import CAdwaita
import Foundation
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

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    override public class var gtkType: GType {
        gtk_picture_get_type()
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

    /// The filesystem `URL` the picture is currently displaying, if any.
    ///
    /// Reflects the `GFile` previously installed via ``setFilename(_:)`` (or
    /// any other path that goes through `gtk_picture_get_file`). Returns `nil`
    /// when the picture is empty, when it was seeded from a non-file source
    /// (a `GdkTexture` via ``setPaintable(_:)`` or a `GResource`), or when the
    /// `GFile` has no local path.
    public var fileURL: URL? {
        guard let file = gtk_picture_get_file(opaquePointer) else { return nil }
        guard let cPath = g_file_get_path(file) else { return nil }
        defer { g_free(gpointer(cPath)) }
        return URL(fileURLWithPath: String(cString: cPath))
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

    /// Whether the picture currently has a `GdkPaintable` content attached.
    ///
    /// Flips to `true` after ``setPaintable(_:)`` with a non-nil texture, and
    /// back to `false` when the paintable is cleared. Note that seeding the
    /// picture via ``setFilename(_:)`` does not set a paintable immediately —
    /// GTK loads it lazily on the next draw, so `hasPaintable` can read
    /// `false` right after `setFilename` even though the image will render.
    public var hasPaintable: Bool {
        gtk_picture_get_paintable(opaquePointer) != nil
    }

    /// Raw pointer to the picture's current `GdkPaintable`, or `nil` if none.
    ///
    /// The only intended use is identity comparison — detecting whether the
    /// paintable has been swapped for a different instance (for example, when
    /// animating frame by frame). Do not dereference or retain the pointer.
    ///
    /// Prefer ``paintableIdentity`` or ``paintableIsSame(as:)`` in new code;
    /// this accessor leaks a raw pointer and is kept only for callers that
    /// need interop with low-level GTK APIs.
    public var paintablePointer: UnsafeMutableRawPointer? {
        guard let paintable = gtk_picture_get_paintable(opaquePointer) else { return nil }
        return UnsafeMutableRawPointer(paintable)
    }

    /// An opaque identity token for the picture's current paintable.
    ///
    /// Use this to detect when the paintable has been swapped out — for
    /// example, after ``setPaintable(_:)`` or when an ``AnimatedImagePlayer``
    /// advances a frame. Two reads return equal values as long as the same
    /// underlying `GdkPaintable` is installed.
    ///
    /// Equatable and Sendable, but the contained pointer must not be
    /// dereferenced. Returns `nil` when no paintable is installed.
    public struct PaintableIdentity: Equatable, Sendable {
        fileprivate let raw: UInt
    }

    /// The current paintable's identity, or `nil` if none is installed.
    public var paintableIdentity: PaintableIdentity? {
        guard let paintable = gtk_picture_get_paintable(opaquePointer) else { return nil }
        return PaintableIdentity(raw: UInt(bitPattern: Int(bitPattern: paintable)))
    }

    /// Whether the picture's current paintable is the given texture.
    ///
    /// Clean replacement for reading ``paintablePointer`` and comparing raw
    /// pointers. Returns `false` when the picture has no paintable, or when
    /// the installed paintable is a different object — including a different
    /// ``Texture`` that happens to hold the same pixels.
    public func paintableIsSame(as texture: Texture) -> Bool {
        guard let paintable = gtk_picture_get_paintable(opaquePointer) else { return false }
        return UnsafeMutableRawPointer(paintable) == texture.pointer
    }

    /// The intrinsic pixel size of the currently displayed paintable, if any.
    ///
    /// Returns `nil` when the picture has no paintable or the paintable does
    /// not report usable dimensions (for example, before an async load has
    /// populated the content).
    public struct IntrinsicSize: Sendable, Equatable {
        public let width: Int
        public let height: Int

        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
    }

    /// Reads the current paintable's natural pixel dimensions.
    ///
    /// Useful for aspect-ratio calculations after loading an image into a
    /// picture whose container size is dictated by the layout.
    public var intrinsicSize: IntrinsicSize? {
        guard let paintable = gtk_picture_get_paintable(opaquePointer) else {
            return nil
        }
        let width = Int(gdk_paintable_get_intrinsic_width(paintable))
        let height = Int(gdk_paintable_get_intrinsic_height(paintable))
        guard width > 0, height > 0 else { return nil }
        return IntrinsicSize(width: width, height: height)
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

    required init(raw pointer: UnsafeMutableRawPointer) {
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

    /// Encodes the texture as PNG and returns the resulting bytes.
    ///
    /// Wraps `gdk_texture_save_to_png_bytes`. Useful for piping a
    /// texture obtained from the clipboard, drag-and-drop, or any
    /// other in-memory source through any PNG-aware sink (file write,
    /// network upload, content-import pipelines).
    ///
    /// - Returns: PNG-encoded data, or `nil` if the encode fails.
    public func encodedPNGData() -> Data? {
        guard let bytesPtr = gdk_texture_save_to_png_bytes(OpaquePointer(pointer)) else {
            return nil
        }
        defer { g_bytes_unref(bytesPtr) }
        var size: gsize = 0
        guard let raw = g_bytes_get_data(bytesPtr, &size), size > 0 else {
            return nil
        }
        return Data(bytes: raw, count: Int(size))
    }

    /// Synchronously decodes a raster image on the calling thread and
    /// returns a GPU-resident texture.
    ///
    /// Same format coverage as ``load(from:)`` (anything GdkPixbuf handles
    /// on the host), but blocks the caller until the decode finishes. Use
    /// from the main actor when loading small bundled assets where the
    /// blocking cost is negligible; for user-supplied images prefer the
    /// async or callback overloads so the UI stays responsive.
    ///
    /// - Parameter fileURL: A file URL pointing to a readable image.
    /// - Throws: ``ImageDecodingError`` if the file cannot be opened or decoded.
    /// - Returns: A texture that mirrors the file's pixel data.
    public static func loadSynchronously(from fileURL: URL) throws -> Texture {
        let pixels = try PixbufPixelDecoder.decode(at: fileURL)
        return Texture(rgbaData: pixels.rgba, width: pixels.width, height: pixels.height)
    }

    /// Asynchronously decodes a raster image (PNG, JPEG, GIF, WebP, TIFF, BMP — anything
    /// registered with GdkPixbuf on the host system) and returns a GPU-resident texture.
    ///
    /// The file is decoded off the main actor; the resulting ``Texture`` is constructed
    /// on the main actor. Supports a wider set of formats than ``Texture/init(filename:)``
    /// (which uses `gdk_texture_new_from_filename` and only natively handles PNG and JPEG
    /// on most GTK builds).
    ///
    /// > Warning: Inside a GTK application use ``load(from:completion:)``.
    /// > The outer `Task { @MainActor in let texture = try await
    /// > Texture.load(...) }` never runs under the GLib main loop — Swift's
    /// > default main actor executor is `DispatchQueue.main`, which GLib
    /// > does not drain. The `async` form is intended for tests and non-GTK
    /// > contexts.
    ///
    /// - Parameter fileURL: A file URL pointing to a readable image.
    /// - Throws: ``ImageDecodingError`` if the file cannot be opened or decoded.
    /// - Returns: A texture that mirrors the file's pixel data.
    public static func load(from fileURL: URL) async throws -> Texture {
        let pixels = try await Task.detached(priority: .userInitiated) {
            try PixbufPixelDecoder.decode(at: fileURL)
        }.value
        return Texture(rgbaData: pixels.rgba, width: pixels.width, height: pixels.height)
    }

    /// Decodes a raster image off the main thread and reports the result
    /// through a completion handler on the GLib main loop.
    ///
    /// Callback-based counterpart to ``load(from:)``. Prefer this form
    /// inside GTK applications: Swift's default main actor executor is
    /// `DispatchQueue.main`, which the GLib main loop does not drain, so
    /// `Task { @MainActor in let texture = try await Texture.load(...)
    /// }` bodies never execute. The decode still runs on a cooperative
    /// background thread via `Task.detached`; the completion hop back to
    /// the main actor goes through `MainContext.idle(_:)`, which the GLib
    /// main loop does drain.
    ///
    /// - Parameters:
    ///   - fileURL: A file URL pointing to a readable image.
    ///   - completion: Called on the main actor with either the resulting
    ///     ``Texture`` or an ``ImageDecodingError`` if the file could not
    ///     be decoded.
    public nonisolated static func load(
        from fileURL: URL,
        completion: @escaping @MainActor (Result<Texture, ImageDecodingError>) -> Void
    ) {
        Task.detached(priority: .userInitiated) {
            let decode: Result<PixbufPixelDecoder.DecodedPixels, ImageDecodingError>
            do {
                decode = try .success(PixbufPixelDecoder.decode(at: fileURL))
            } catch let error as ImageDecodingError {
                decode = .failure(error)
            } catch {
                decode = .failure(.decodeFailed(String(describing: error)))
            }
            MainContext.idle {
                switch decode {
                case let .success(pixels):
                    let texture = Texture(rgbaData: pixels.rgba, width: pixels.width, height: pixels.height)
                    completion(.success(texture))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
