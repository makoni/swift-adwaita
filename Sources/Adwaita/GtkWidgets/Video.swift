import CAdwaita
import GObjectSupport

/// A widget for displaying and playing video files.
///
/// Wraps `GtkVideo`. Supports autoplay, looping, and media stream
/// controls for volume, seeking, and playback state.
///
/// ```swift
/// let video = Video(filename: "/path/to/clip.mp4")
/// video.autoplay = true
/// video.loop = true
///
/// // Control playback
/// video.play()
/// video.volume = 0.8
/// print("Duration: \(video.duration) microseconds")
///
/// // Or start with an empty video and set the file later
/// let player = Video()
/// player.setFilename("/path/to/another.webm")
/// ```
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

    required init(raw pointer: UnsafeMutableRawPointer) {
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
    public var mediaStream: MediaStream? {
        get {
            guard let ptr = gtk_video_get_media_stream(opaquePointer) else { return nil }
            return MediaStream(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set {
            gtk_video_set_media_stream(opaquePointer, newValue?.streamPointer)
        }
    }

    // MARK: - Media Stream Convenience

    /// Whether the video is currently playing.
    ///
    /// Requires a media stream to be set (e.g., by setting a filename).
    public var isPlaying: Bool {
        get { mediaStream?.isPlaying ?? false }
        set { mediaStream?.isPlaying = newValue }
    }

    /// Starts playback via the media stream.
    public func play() {
        mediaStream?.play()
    }

    /// Pauses playback via the media stream.
    public func pause() {
        mediaStream?.pause()
    }

    /// Whether the media stream has reached the end of content.
    public var ended: Bool {
        mediaStream?.ended ?? false
    }

    /// The current playback position in microseconds.
    public var timestamp: Int {
        mediaStream?.timestamp ?? 0
    }

    /// The total duration in microseconds, or 0 if unknown.
    public var duration: Int {
        mediaStream?.duration ?? 0
    }

    /// Whether the media stream is muted.
    public var isMuted: Bool {
        get { mediaStream?.isMuted ?? false }
        set { mediaStream?.isMuted = newValue }
    }

    /// The playback volume (0.0 to 1.0).
    public var volume: Double {
        get { mediaStream?.volume ?? 0.0 }
        set { mediaStream?.volume = newValue }
    }
}
