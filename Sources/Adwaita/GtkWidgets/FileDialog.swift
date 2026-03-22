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
}
