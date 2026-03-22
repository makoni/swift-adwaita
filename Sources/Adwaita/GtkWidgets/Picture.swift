import CAdwaita
import GObjectSupport

/// A widget that displays an image at its natural size or scaled.
///
/// Wraps `GtkPicture`. Unlike `GtkImage`, `GtkPicture` can scale and
/// is intended for displaying user content rather than icons.
@MainActor
public final class Picture: Widget {
    /// Creates a new empty picture.
    public init() {
        let ptr = gtk_picture_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a picture that displays the given file.
    public init(filename: String) {
        let ptr = gtk_picture_new_for_filename(filename)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a picture from a named resource.
    public init(resourcePath: String) {
        let ptr = gtk_picture_new_for_resource(resourcePath)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Sets the file to display by filename.
    public func setFilename(_ filename: String?) {
        gtk_picture_set_filename(opaquePointer, filename)
    }

    /// Sets the resource to display.
    public func setResource(_ resourcePath: String?) {
        gtk_picture_set_resource(opaquePointer, resourcePath)
    }

    /// Whether the picture can be made smaller than its natural size.
    public var canShrink: Bool {
        get { gtk_picture_get_can_shrink(opaquePointer) != 0 }
        set { gtk_picture_set_can_shrink(opaquePointer, newValue ? 1 : 0) }
    }

    /// The content fit mode (how the picture is sized within its allocation).
    public var contentFit: GtkContentFit {
        get { gtk_picture_get_content_fit(opaquePointer) }
        set { gtk_picture_set_content_fit(opaquePointer, newValue) }
    }

    /// Alternative text for accessibility.
    public var alternativeText: String? {
        get { gtk_picture_get_alternative_text(opaquePointer).map { String(cString: $0) } }
        set { gtk_picture_set_alternative_text(opaquePointer, newValue) }
    }
}
