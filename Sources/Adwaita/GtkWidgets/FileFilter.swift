import CAdwaita
import GObjectSupport

/// A filter for selecting a subset of files.
///
/// Wraps `GtkFileFilter`. Used with `FileDialog` to restrict which files are shown.
///
/// ```swift
/// let imageFilter = FileFilter(name: "Images", mimeTypes: ["image/png", "image/jpeg"])
/// let swiftFilter = FileFilter(name: "Swift files", suffixes: ["swift"])
/// let allFilter   = FileFilter(name: "All files", patterns: ["*"])
///
/// // Use with a FileDialog
/// let dialog = FileDialog()
/// dialog.filters = [imageFilter, swiftFilter, allFilter]
/// ```
@MainActor
public final class FileFilter: GObjectRef {
    /// Creates a new empty file filter.
    public init() {
        let ptr = gtk_file_filter_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a file filter with a name and suffix patterns.
    ///
    /// Example: `FileFilter(name: "Swift files", suffixes: ["swift"])`
    public convenience init(name: String, suffixes: [String]) {
        self.init()
        self.name = name
        for suffix in suffixes {
            addSuffix(suffix)
        }
    }

    /// Creates a file filter with a name and MIME types.
    ///
    /// Example: `FileFilter(name: "Images", mimeTypes: ["image/png", "image/jpeg"])`
    public convenience init(name: String, mimeTypes: [String]) {
        self.init()
        self.name = name
        for mime in mimeTypes {
            addMimeType(mime)
        }
    }

    /// Creates a file filter with a name and glob patterns.
    ///
    /// Example: `FileFilter(name: "All files", patterns: ["*"])`
    public convenience init(name: String, patterns: [String]) {
        self.init()
        self.name = name
        for pattern in patterns {
            addPattern(pattern)
        }
    }

    /// The human-readable name of the filter.
    public var name: String? {
        get { gtk_file_filter_get_name(opaquePointer).map { String(cString: $0) } }
        set { gtk_file_filter_set_name(opaquePointer, newValue) }
    }

    /// Adds a file extension suffix to match (e.g. "swift", "txt").
    public func addSuffix(_ suffix: String) {
        gtk_file_filter_add_suffix(opaquePointer, suffix)
    }

    /// Adds a MIME type to match (e.g. "image/png").
    public func addMimeType(_ mimeType: String) {
        gtk_file_filter_add_mime_type(opaquePointer, mimeType)
    }

    /// Adds a shell-style glob pattern (e.g. "*.swift").
    public func addPattern(_ pattern: String) {
        gtk_file_filter_add_pattern(opaquePointer, pattern)
    }
}
