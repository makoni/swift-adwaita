import CAdwaita
import GObjectSupport

/// A widget displaying an image from an icon name, file path, or resource.
///
/// Wraps `GtkImage`. Most commonly used to display symbolic icons from the
/// system icon theme. Use ``pixelSize`` to control the rendered size.
///
/// ```swift
/// // Display a symbolic icon
/// let icon = Image(iconName: "document-open-symbolic")
/// icon.pixelSize = 48
///
/// // Display from a file on disk
/// let photo = Image(filename: "/path/to/photo.png")
///
/// // Change icon at runtime
/// icon.iconName = "document-save-symbolic"
/// ```
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

    /// Creates an image from a type-safe icon name.
    public convenience init(icon: IconName) {
        self.init(iconName: icon.name)
    }

    /// Creates an image from a file path.
    public init(filename: String) {
        let ptr = gtk_image_new_from_file(filename)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates an image from a resource path.
    public init(resourcePath: String) {
        let ptr = gtk_image_new_from_resource(resourcePath)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
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

    /// Sets the image from a resource path.
    public func setFromResource(_ resourcePath: String?) {
        gtk_image_set_from_resource(opaquePointer, resourcePath)
    }

    /// Clears the image, making it empty.
    public func clear() {
        gtk_image_clear(opaquePointer)
    }

    /// The pixel size for icon display.
    public var pixelSize: Int {
        get { Int(gtk_image_get_pixel_size(opaquePointer)) }
        set { gtk_image_set_pixel_size(opaquePointer, Int32(newValue)) }
    }
}
