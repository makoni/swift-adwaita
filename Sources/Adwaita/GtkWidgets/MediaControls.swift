import CAdwaita
import GObjectSupport

/// A widget showing playback controls for a media stream.
///
/// Wraps `GtkMediaControls`. Displays play/pause, seek bar, and
/// timestamp for a ``MediaStream``.
///
/// ```swift
/// let stream = MediaStream(filename: "video.mp4")
/// let controls = MediaControls(stream: stream)
///
/// let vbox = Box(orientation: .vertical)
/// vbox.append(videoPicture)
/// vbox.append(controls)
/// ```
@MainActor
public final class MediaControls: Widget {
    /// Creates new media controls, optionally for a media stream.
    public init(stream: MediaStream? = nil) {
        let ptr = gtk_media_controls_new(stream?.streamPointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The media stream being controlled.
    public var mediaStream: MediaStream? {
        get {
            guard let ptr = gtk_media_controls_get_media_stream(opaquePointer) else { return nil }
            return MediaStream(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_media_controls_set_media_stream(opaquePointer, newValue?.streamPointer) }
    }
}
