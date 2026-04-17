import CAdwaita
import GObjectSupport

/// A file chooser dialog for opening and saving files.
///
/// Wraps `GtkFileDialog` (GTK 4.10+). All dialog methods are async
/// and resume on the main actor when the user makes a selection or
/// dismisses the dialog. User cancellation returns `nil`; other
/// failures throw a `GLibError`.
@MainActor
public final class FileDialog: GObjectRef {
    /// Creates a new file dialog.
    public init() {
        let ptr = gtk_file_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The title of the dialog.
    public var title: String? {
        get { gtk_file_dialog_get_title(opaquePointer).map { String(cString: $0) } }
        set { gtk_file_dialog_set_title(opaquePointer, newValue) }
    }

    /// Whether the dialog is modal.
    public var modal: Bool {
        get { gtk_file_dialog_get_modal(opaquePointer) != 0 }
        set { gtk_file_dialog_set_modal(opaquePointer, newValue ? 1 : 0) }
    }

    /// The initial file name suggestion (for save dialogs).
    public var initialName: String? {
        get { gtk_file_dialog_get_initial_name(opaquePointer).map { String(cString: $0) } }
        set { gtk_file_dialog_set_initial_name(opaquePointer, newValue) }
    }

    /// The accept button label.
    public var acceptLabel: String? {
        get { gtk_file_dialog_get_accept_label(opaquePointer).map { String(cString: $0) } }
        set { gtk_file_dialog_set_accept_label(opaquePointer, newValue) }
    }

    /// Sets the file filters for this dialog.
    ///
    /// Example:
    /// ```swift
    /// dialog.setFilters([
    ///     FileFilter(name: "Swift files", suffixes: ["swift"]),
    ///     FileFilter(name: "All files", patterns: ["*"]),
    /// ])
    /// ```
    public func setFilters(_ filters: [FileFilter]) {
        let store = g_list_store_new(gtk_file_filter_get_type())!
        for filter in filters {
            g_list_store_append(store, gpointer(filter.pointer))
        }
        gtk_file_dialog_set_filters(opaquePointer, store)
        g_object_unref(gpointer(store))
    }

    /// Sets the default (initially selected) filter.
    public func setDefaultFilter(_ filter: FileFilter) {
        gtk_file_dialog_set_default_filter(opaquePointer, OpaquePointer(filter.pointer))
    }

    /// Opens the file dialog for selecting a file.
    ///
    /// Returns the selected file path, or `nil` if the user cancelled.
    /// Throws a `GLibError` if the underlying GTK call fails.
    ///
    /// ```swift
    /// let path = try await dialog.open(parent: window)
    /// if let path { print("Selected: \(path)") }
    /// ```
    public func open(parent: Widget?) async throws(GLibError) -> String? {
        try await FileDialog.retype {
            try await withCheckedThrowingContinuation { continuation in
                let box = DialogAsyncSupport.retainBox(continuation)
                gtk_file_dialog_open(
                    self.opaquePointer,
                    parent.map { cadw_cast_window($0.pointer) },
                    nil,
                    { source, result, userData in
                        FileDialog.finishPath(
                            userData: userData,
                            source: source,
                            result: result,
                            context: #function
                        ) { src, res, err in
                            gtk_file_dialog_open_finish(src, res, &err)
                        }
                    },
                    box
                )
            }
        }
    }

    /// Opens the file dialog for saving a file.
    ///
    /// Returns the selected save path, or `nil` if the user cancelled.
    /// Throws a `GLibError` on failure.
    public func save(parent: Widget?) async throws(GLibError) -> String? {
        try await FileDialog.retype {
            try await withCheckedThrowingContinuation { continuation in
                let box = DialogAsyncSupport.retainBox(continuation)
                gtk_file_dialog_save(
                    self.opaquePointer,
                    parent.map { cadw_cast_window($0.pointer) },
                    nil,
                    { source, result, userData in
                        FileDialog.finishPath(
                            userData: userData,
                            source: source,
                            result: result,
                            context: #function
                        ) { src, res, err in
                            gtk_file_dialog_save_finish(src, res, &err)
                        }
                    },
                    box
                )
            }
        }
    }

    /// Opens the file dialog for selecting a folder.
    ///
    /// Returns the selected folder path, or `nil` if the user cancelled.
    /// Throws a `GLibError` on failure.
    public func selectFolder(parent: Widget?) async throws(GLibError) -> String? {
        try await FileDialog.retype {
            try await withCheckedThrowingContinuation { continuation in
                let box = DialogAsyncSupport.retainBox(continuation)
                gtk_file_dialog_select_folder(
                    self.opaquePointer,
                    parent.map { cadw_cast_window($0.pointer) },
                    nil,
                    { source, result, userData in
                        FileDialog.finishPath(
                            userData: userData,
                            source: source,
                            result: result,
                            context: #function
                        ) { src, res, err in
                            gtk_file_dialog_select_folder_finish(src, res, &err)
                        }
                    },
                    box
                )
            }
        }
    }
}

private extension FileDialog {
    static func retype<T>(_ operation: () async throws -> T) async throws(GLibError) -> T {
        do {
            return try await operation()
        } catch let error as GLibError {
            throw error
        } catch {
            preconditionFailure("FileDialog continuation threw non-GLibError: \(error)")
        }
    }

    static func finishPath(
        userData: UnsafeMutableRawPointer?,
        source: UnsafeMutablePointer<GObject>?,
        result: OpaquePointer?,
        context: StaticString,
        finish: (OpaquePointer, OpaquePointer, inout UnsafeMutablePointer<GError>?) -> OpaquePointer?
    ) {
        let continuation = DialogAsyncSupport.takeBox(
            userData,
            as: CheckedContinuation<String?, any Error>.self,
            context: context
        ).closure
        guard let source, let result else {
            continuation.resume(returning: nil)
            return
        }
        var error: UnsafeMutablePointer<GError>?
        let file = finish(OpaquePointer(source), result, &error)
        if let file {
            let cPath = g_file_get_path(file)
            let path = cPath.map { String(cString: $0) }
            if let cPath { g_free(gpointer(mutating: cPath)) }
            g_object_unref(gpointer(file))
            continuation.resume(returning: path)
        } else if let error {
            if DialogAsyncSupport.isDismissed(error) {
                g_error_free(error)
                continuation.resume(returning: nil)
            } else {
                continuation.resume(throwing: GLibError(consuming: error))
            }
        } else {
            continuation.resume(returning: nil)
        }
    }
}
