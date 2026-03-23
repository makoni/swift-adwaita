import CAdwaita
import GObjectSupport

/// A widget for displaying video.
///
/// Wraps `GtkVideo`. Can play video files with optional controls.
@MainActor
public final class Video: Widget {
    /// Creates a new empty video widget.
    public init() {
        let ptr = gtk_video_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new video widget for a file path.
    public init(filename: String) {
        let ptr = gtk_video_new_for_filename(filename)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a new video widget for a resource path.
    public init(resource: String) {
        let ptr = gtk_video_new_for_resource(resource)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Whether the video should automatically start playing.
    public var autoplay: Bool {
        get { gtk_video_get_autoplay(opaquePointer) != 0 }
        set { gtk_video_set_autoplay(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the video loops after finishing.
    public var loop: Bool {
        get { gtk_video_get_loop(opaquePointer) != 0 }
        set { gtk_video_set_loop(opaquePointer, newValue ? 1 : 0) }
    }

    /// Sets the video from a file path.
    public func setFilename(_ filename: String?) {
        gtk_video_set_filename(opaquePointer, filename)
    }

    /// Sets the video from a resource path.
    public func setResource(_ resource: String?) {
        gtk_video_set_resource(opaquePointer, resource)
    }

    /// The underlying media stream, or `nil` if none is set.
    ///
    /// Use the media stream for fine-grained playback control such as
    /// seeking, volume, and querying duration.
    public var mediaStream: UnsafeMutablePointer<GtkMediaStream>? {
        get { gtk_video_get_media_stream(opaquePointer) }
        set { gtk_video_set_media_stream(opaquePointer, newValue) }
    }

    // MARK: - Media Stream Convenience

    /// Whether the video is currently playing.
    ///
    /// Requires a media stream to be set (e.g., by setting a filename).
    public var isPlaying: Bool {
        get {
            guard let stream = mediaStream else { return false }
            return gtk_media_stream_get_playing(stream) != 0
        }
        set {
            guard let stream = mediaStream else { return }
            gtk_media_stream_set_playing(stream, newValue ? 1 : 0)
        }
    }

    /// Starts playback via the media stream.
    public func play() {
        guard let stream = mediaStream else { return }
        gtk_media_stream_play(stream)
    }

    /// Pauses playback via the media stream.
    public func pause() {
        guard let stream = mediaStream else { return }
        gtk_media_stream_pause(stream)
    }

    /// Whether the media stream has reached the end of content.
    public var ended: Bool {
        guard let stream = mediaStream else { return false }
        return gtk_media_stream_get_ended(stream) != 0
    }

    /// The current playback position in microseconds.
    public var timestamp: Int {
        guard let stream = mediaStream else { return 0 }
        return gtk_media_stream_get_timestamp(stream)
    }

    /// The total duration in microseconds, or 0 if unknown.
    public var duration: Int {
        guard let stream = mediaStream else { return 0 }
        return gtk_media_stream_get_duration(stream)
    }

    /// Whether the media stream is muted.
    public var isMuted: Bool {
        get {
            guard let stream = mediaStream else { return false }
            return gtk_media_stream_get_muted(stream) != 0
        }
        set {
            guard let stream = mediaStream else { return }
            gtk_media_stream_set_muted(stream, newValue ? 1 : 0)
        }
    }

    /// The playback volume (0.0 to 1.0).
    public var volume: Double {
        get {
            guard let stream = mediaStream else { return 0.0 }
            return gtk_media_stream_get_volume(stream)
        }
        set {
            guard let stream = mediaStream else { return }
            gtk_media_stream_set_volume(stream, newValue)
        }
    }
}
