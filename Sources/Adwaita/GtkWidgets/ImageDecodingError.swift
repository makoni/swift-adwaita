import Foundation

/// Errors that can surface when decoding raster images through ``Texture/load(from:)``
/// or ``AnimatedImagePlayer``.
public enum ImageDecodingError: Error, Sendable, Equatable {
    /// The underlying decoder rejected the file. The associated string is the
    /// message reported by GdkPixbuf (or a synthesised description).
    case decodeFailed(String)

    /// The file was decoded but could not be interpreted — for example, an
    /// animation iterator could not be created from an otherwise-valid file.
    case invalidData
}
