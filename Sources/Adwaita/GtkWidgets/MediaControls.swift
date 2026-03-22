import CAdwaita
import GObjectSupport

/// A widget showing playback controls for a media stream.
///
/// Wraps `GtkMediaControls`.
@MainActor
public final class MediaControls: Widget {
    /// Creates new media controls, optionally for a media stream.
    public init(stream: UnsafeMutablePointer<GtkMediaStream>? = nil) {
        let ptr = gtk_media_controls_new(stream)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The media stream being controlled.
    public var mediaStream: UnsafeMutablePointer<GtkMediaStream>? {
        get { gtk_media_controls_get_media_stream(opaquePointer) }
        set { gtk_media_controls_set_media_stream(opaquePointer, newValue) }
    }
}
