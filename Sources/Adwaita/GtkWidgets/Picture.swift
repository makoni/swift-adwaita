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

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
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

    /// Sets a `GdkPaintable` as the content of this picture.
    ///
    /// Use this with `Texture` to display dynamically loaded images.
    ///
    /// ```swift
    /// let texture = Texture(filename: "/path/to/photo.jpg")
    /// picture.setPaintable(texture)
    /// ```
    public func setPaintable(_ paintable: Texture?) {
        gtk_picture_set_paintable(opaquePointer, paintable.map { OpaquePointer($0.pointer) })
    }
}

/// A pixel-based image loaded into GPU memory.
///
/// Wraps `GdkTexture`. Use with `Picture.setPaintable()` to display images.
@MainActor
public final class Texture: GObjectRef {
    /// Loads a texture from a file path.
    ///
    /// Returns `nil` if the file cannot be loaded.
    public init?(filename: String) {
        var error: UnsafeMutablePointer<GError>?
        guard let ptr = gdk_texture_new_from_filename(filename, &error) else {
            if let error { g_error_free(error) }
            return nil
        }
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Loads a texture from raw pixel data (RGBA, 8 bits per channel).
    ///
    /// - Parameters:
    ///   - data: Raw RGBA pixel data.
    ///   - width: The width in pixels.
    ///   - height: The height in pixels.
    public init(rgbaData data: [UInt8], width: Int, height: Int) {
        let bytes = g_bytes_new(data, gsize(data.count))!
        let ptr = gdk_memory_texture_new(
            Int32(width), Int32(height),
            GDK_MEMORY_R8G8B8A8,
            bytes,
            gsize(width * 4)
        )!
        g_bytes_unref(bytes)
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The width of the texture in pixels.
    public var width: Int {
        Int(gdk_texture_get_width(OpaquePointer(pointer)))
    }

    /// The height of the texture in pixels.
    public var height: Int {
        Int(gdk_texture_get_height(OpaquePointer(pointer)))
    }
}
