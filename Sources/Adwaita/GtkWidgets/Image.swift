import CAdwaita
import GObjectSupport

/// A widget displaying an image.
///
/// Wraps `GtkImage`. Displays icons by name, file, or resource.
@MainActor
public final class Image: Widget {
    /// Creates an empty image.
    public init() {
        let ptr = gtk_image_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates an image from an icon name.
    public init(iconName: String) {
        let ptr = gtk_image_new_from_icon_name(iconName)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates an image from a file path.
    public init(filename: String) {
        let ptr = gtk_image_new_from_file(filename)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Sets the image from an icon name.
    public var iconName: String? {
        get {
            guard let cStr = gtk_image_get_icon_name(opaquePointer) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_image_set_from_icon_name(opaquePointer, newValue) }
    }

    /// The pixel size for icon display.
    public var pixelSize: Int32 {
        get { gtk_image_get_pixel_size(opaquePointer) }
        set { gtk_image_set_pixel_size(opaquePointer, newValue) }
    }
}
