import CAdwaita
import Foundation

/// Off-main decoder that lifts a raster image file into a Sendable RGBA buffer.
///
/// Isolated from the main actor so it can run inside `Task.detached`. The pixbuf
/// API itself is thread-safe for loading and inspection; the only constraint is
/// that GTK widget work (creating a ``Texture``) happens back on the main actor,
/// which the callers handle.
enum PixbufPixelDecoder {
    /// Sendable representation of a decoded frame, ready to construct a texture.
    struct DecodedPixels {
        let rgba: [UInt8]
        let width: Int
        let height: Int
    }

    /// Decodes the file at `fileURL` into RGBA pixels.
    ///
    /// Uses `gdk_pixbuf_new_from_file`, which is registered for every format
    /// the host system's GdkPixbuf loaders support (PNG/JPEG/GIF/WebP/TIFF/BMP/etc.).
    static func decode(at fileURL: URL) throws -> DecodedPixels {
        var error: UnsafeMutablePointer<GError>?
        guard let pixbuf = gdk_pixbuf_new_from_file(fileURL.path, &error) else {
            let message = error.map { String(cString: $0.pointee.message) }
                ?? "gdk_pixbuf_new_from_file returned NULL"
            if let error { g_error_free(error) }
            throw ImageDecodingError.decodeFailed(message)
        }
        defer { g_object_unref(UnsafeMutableRawPointer(pixbuf)) }
        return try rgbaPixels(from: pixbuf)
    }

    /// Copies the pixel data from a pixbuf into a freshly allocated RGBA8888 buffer.
    ///
    /// The pixbuf can be released after this call.
    static func rgbaPixels(from pixbuf: OpaquePointer) throws -> DecodedPixels {
        let width = Int(gdk_pixbuf_get_width(pixbuf))
        let height = Int(gdk_pixbuf_get_height(pixbuf))
        let rowStride = Int(gdk_pixbuf_get_rowstride(pixbuf))
        let channels = Int(gdk_pixbuf_get_n_channels(pixbuf))
        let hasAlpha = gdk_pixbuf_get_has_alpha(pixbuf) != 0

        guard width > 0, height > 0, channels >= 3, let pixels = gdk_pixbuf_get_pixels(pixbuf) else {
            throw ImageDecodingError.invalidData
        }

        var rgba = [UInt8](repeating: 0, count: width * height * 4)
        for y in 0 ..< height {
            let row = pixels.advanced(by: y * rowStride)
            for x in 0 ..< width {
                let source = row.advanced(by: x * channels)
                let destinationIndex = (y * width + x) * 4
                rgba[destinationIndex] = source[0]
                rgba[destinationIndex + 1] = source[1]
                rgba[destinationIndex + 2] = source[2]
                rgba[destinationIndex + 3] = (hasAlpha && channels >= 4) ? source[3] : 255
            }
        }
        return DecodedPixels(rgba: rgba, width: width, height: height)
    }
}
