import CAdwaita
import GObjectSupport

/// A helper for the async callback pattern.
private final class AsyncBox<T>: @unchecked Sendable {
    let closure: T
    init(_ closure: T) { self.closure = closure }
}

/// A file chooser dialog for opening and saving files.
///
/// Wraps `GtkFileDialog` (GTK 4.10+). Uses async callbacks — results
/// are delivered to the completion handler on the main thread.
@MainActor
public final class FileDialog: GObjectRef {
    /// Creates a new file dialog.
    public init() {
        let ptr = gtk_file_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
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
    ///
    /// ```swift
    /// let path = await dialog.open(parent: window)
    /// if let path { print("Selected: \(path)") }
    /// ```
    public func open(parent: Widget?) async -> String? {
        await withCheckedContinuation { continuation in
            open(parent: parent) { path in
                continuation.resume(returning: path)
            }
        }
    }

    /// Opens the file dialog for selecting a file (throwing version).
    ///
    /// Throws a ``GLibError`` if the dialog fails for a reason other than
    /// the user cancelling. Cancellation returns `nil`.
    ///
    /// ```swift
    /// let path = try await dialog.openThrowing(parent: window)
    /// ```
    public func openThrowing(parent: Widget?) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            openThrowing(parent: parent) { result in
                continuation.resume(with: result)
            }
        }
    }

    /// Opens the file dialog for selecting a file.
    ///
    /// - Parameters:
    ///   - parent: The parent window, or nil.
    ///   - completion: Called with the selected file path, or nil if cancelled.
    public func open(parent: Widget?, completion: @escaping @MainActor (String?) -> Void) {
        let box = Unmanaged.passRetained(AsyncBox(completion)).toOpaque()
        gtk_file_dialog_open(
            opaquePointer,
            parent.map { cadw_cast_window($0.pointer) },
            nil,
            { source, result, userData in
                guard let userData, let source, let result else { return }
                var error: UnsafeMutablePointer<GError>?
                let file = gtk_file_dialog_open_finish(OpaquePointer(source), result, &error)
                let path: String?
                if let file {
                    let cPath = g_file_get_path(file)
                    path = cPath.map { String(cString: $0) }
                    if let cPath { g_free(gpointer(mutating: cPath)) }
                    g_object_unref(gpointer(file))
                } else {
                    path = nil
                }
                if let error { g_error_free(error) }
                let box = Unmanaged<AsyncBox<@MainActor (String?) -> Void>>.fromOpaque(userData).takeRetainedValue()
                MainActor.assumeIsolated { box.closure(path) }
            },
            box
        )
    }

    /// Opens the file dialog for selecting a file (throwing version).
    ///
    /// The completion handler receives a `Result` — `.success(nil)` on cancel,
    /// `.success(path)` on selection, or `.failure(GLibError)` on error.
    public func openThrowing(
        parent: Widget?,
        completion: @escaping @MainActor (Result<String?, GLibError>) -> Void
    ) {
        let box = Unmanaged.passRetained(AsyncBox(completion)).toOpaque()
        gtk_file_dialog_open(
            opaquePointer,
            parent.map { cadw_cast_window($0.pointer) },
            nil,
            { source, result, userData in
                guard let userData, let source, let result else { return }
                var error: UnsafeMutablePointer<GError>?
                let file = gtk_file_dialog_open_finish(OpaquePointer(source), result, &error)
                let callResult: Result<String?, GLibError>
                if let file {
                    let cPath = g_file_get_path(file)
                    let path = cPath.map { String(cString: $0) }
                    if let cPath { g_free(gpointer(mutating: cPath)) }
                    g_object_unref(gpointer(file))
                    callResult = .success(path)
                } else if let error {
                    // Check if it's a cancellation (GTK_DIALOG_ERROR_DISMISSED)
                    let dismissed = g_quark_try_string("gtk-dialog-error-quark")
                    if error.pointee.domain == dismissed && error.pointee.code == 2 {
                        g_error_free(error)
                        callResult = .success(nil)
                    } else {
                        callResult = .failure(GLibError(consuming: error))
                    }
                } else {
                    callResult = .success(nil)
                }
                let box = Unmanaged<AsyncBox<@MainActor (Result<String?, GLibError>) -> Void>>
                    .fromOpaque(userData).takeRetainedValue()
                MainActor.assumeIsolated { box.closure(callResult) }
            },
            box
        )
    }

    /// Opens the file dialog for saving a file.
    ///
    /// Returns the selected save path, or `nil` if the user cancelled.
    public func save(parent: Widget?) async -> String? {
        await withCheckedContinuation { continuation in
            save(parent: parent) { path in
                continuation.resume(returning: path)
            }
        }
    }

    /// Opens the file dialog for saving a file (throwing version).
    ///
    /// Throws a ``GLibError`` on failure. Cancellation returns `nil`.
    public func saveThrowing(parent: Widget?) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            saveThrowing(parent: parent) { result in
                continuation.resume(with: result)
            }
        }
    }

    /// Opens the file dialog for saving a file.
    ///
    /// - Parameters:
    ///   - parent: The parent window, or nil.
    ///   - completion: Called with the selected save path, or nil if cancelled.
    public func save(parent: Widget?, completion: @escaping @MainActor (String?) -> Void) {
        let box = Unmanaged.passRetained(AsyncBox(completion)).toOpaque()
        gtk_file_dialog_save(
            opaquePointer,
            parent.map { cadw_cast_window($0.pointer) },
            nil,
            { source, result, userData in
                guard let userData, let source, let result else { return }
                var error: UnsafeMutablePointer<GError>?
                let file = gtk_file_dialog_save_finish(OpaquePointer(source), result, &error)
                let path: String?
                if let file {
                    let cPath = g_file_get_path(file)
                    path = cPath.map { String(cString: $0) }
                    if let cPath { g_free(gpointer(mutating: cPath)) }
                    g_object_unref(gpointer(file))
                } else {
                    path = nil
                }
                if let error { g_error_free(error) }
                let box = Unmanaged<AsyncBox<@MainActor (String?) -> Void>>.fromOpaque(userData).takeRetainedValue()
                MainActor.assumeIsolated { box.closure(path) }
            },
            box
        )
    }

    /// Opens the file dialog for saving a file (throwing version).
    public func saveThrowing(
        parent: Widget?,
        completion: @escaping @MainActor (Result<String?, GLibError>) -> Void
    ) {
        let box = Unmanaged.passRetained(AsyncBox(completion)).toOpaque()
        gtk_file_dialog_save(
            opaquePointer,
            parent.map { cadw_cast_window($0.pointer) },
            nil,
            { source, result, userData in
                guard let userData, let source, let result else { return }
                var error: UnsafeMutablePointer<GError>?
                let file = gtk_file_dialog_save_finish(OpaquePointer(source), result, &error)
                let callResult: Result<String?, GLibError>
                if let file {
                    let cPath = g_file_get_path(file)
                    let path = cPath.map { String(cString: $0) }
                    if let cPath { g_free(gpointer(mutating: cPath)) }
                    g_object_unref(gpointer(file))
                    callResult = .success(path)
                } else if let error {
                    let dismissed = g_quark_try_string("gtk-dialog-error-quark")
                    if error.pointee.domain == dismissed && error.pointee.code == 2 {
                        g_error_free(error)
                        callResult = .success(nil)
                    } else {
                        callResult = .failure(GLibError(consuming: error))
                    }
                } else {
                    callResult = .success(nil)
                }
                let box = Unmanaged<AsyncBox<@MainActor (Result<String?, GLibError>) -> Void>>
                    .fromOpaque(userData).takeRetainedValue()
                MainActor.assumeIsolated { box.closure(callResult) }
            },
            box
        )
    }

    /// Opens the file dialog for selecting a folder.
    ///
    /// Returns the selected folder path, or `nil` if the user cancelled.
    public func selectFolder(parent: Widget?) async -> String? {
        await withCheckedContinuation { continuation in
            selectFolder(parent: parent) { path in
                continuation.resume(returning: path)
            }
        }
    }

    /// Opens the file dialog for selecting a folder (throwing version).
    ///
    /// Throws a ``GLibError`` on failure. Cancellation returns `nil`.
    public func selectFolderThrowing(parent: Widget?) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            selectFolderThrowing(parent: parent) { result in
                continuation.resume(with: result)
            }
        }
    }

    /// Opens the file dialog for selecting a folder.
    ///
    /// - Parameters:
    ///   - parent: The parent window, or nil.
    ///   - completion: Called with the selected folder path, or nil if cancelled.
    public func selectFolder(parent: Widget?, completion: @escaping @MainActor (String?) -> Void) {
        let box = Unmanaged.passRetained(AsyncBox(completion)).toOpaque()
        gtk_file_dialog_select_folder(
            opaquePointer,
            parent.map { cadw_cast_window($0.pointer) },
            nil,
            { source, result, userData in
                guard let userData, let source, let result else { return }
                var error: UnsafeMutablePointer<GError>?
                let file = gtk_file_dialog_select_folder_finish(OpaquePointer(source), result, &error)
                let path: String?
                if let file {
                    let cPath = g_file_get_path(file)
                    path = cPath.map { String(cString: $0) }
                    if let cPath { g_free(gpointer(mutating: cPath)) }
                    g_object_unref(gpointer(file))
                } else {
                    path = nil
                }
                if let error { g_error_free(error) }
                let box = Unmanaged<AsyncBox<@MainActor (String?) -> Void>>.fromOpaque(userData).takeRetainedValue()
                MainActor.assumeIsolated { box.closure(path) }
            },
            box
        )
    }

    /// Opens the file dialog for selecting a folder (throwing version).
    public func selectFolderThrowing(
        parent: Widget?,
        completion: @escaping @MainActor (Result<String?, GLibError>) -> Void
    ) {
        let box = Unmanaged.passRetained(AsyncBox(completion)).toOpaque()
        gtk_file_dialog_select_folder(
            opaquePointer,
            parent.map { cadw_cast_window($0.pointer) },
            nil,
            { source, result, userData in
                guard let userData, let source, let result else { return }
                var error: UnsafeMutablePointer<GError>?
                let file = gtk_file_dialog_select_folder_finish(OpaquePointer(source), result, &error)
                let callResult: Result<String?, GLibError>
                if let file {
                    let cPath = g_file_get_path(file)
                    let path = cPath.map { String(cString: $0) }
                    if let cPath { g_free(gpointer(mutating: cPath)) }
                    g_object_unref(gpointer(file))
                    callResult = .success(path)
                } else if let error {
                    let dismissed = g_quark_try_string("gtk-dialog-error-quark")
                    if error.pointee.domain == dismissed && error.pointee.code == 2 {
                        g_error_free(error)
                        callResult = .success(nil)
                    } else {
                        callResult = .failure(GLibError(consuming: error))
                    }
                } else {
                    callResult = .success(nil)
                }
                let box = Unmanaged<AsyncBox<@MainActor (Result<String?, GLibError>) -> Void>>
                    .fromOpaque(userData).takeRetainedValue()
                MainActor.assumeIsolated { box.closure(callResult) }
            },
            box
        )
    }
}
