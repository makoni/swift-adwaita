import CAdwaita
import GObjectSupport

/// A media stream for audio/video playback.
///
/// Wraps `GtkMediaStream`. Use with ``Video`` and ``MediaControls``
/// for playback control, seeking, volume, and querying duration.
///
/// ```swift
/// let stream = MediaStream(filename: "/path/to/video.mp4")
/// video.mediaStream = stream
/// stream.play()
/// ```
@MainActor
public class MediaStream: GObjectRef {
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a media stream from a file path.
    public init(filename: String) {
        let ptr = gtk_media_file_new_for_filename(filename)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a media stream from a resource path.
    public init(resource: String) {
        let ptr = gtk_media_file_new_for_resource(resource)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The underlying `GtkMediaStream` pointer for C interop.
    var streamPointer: UnsafeMutablePointer<GtkMediaStream> {
        pointer.assumingMemoryBound(to: GtkMediaStream.self)
    }

    // MARK: - Playback

    /// Starts playback.
    public func play() {
        gtk_media_stream_play(streamPointer)
    }

    /// Pauses playback.
    public func pause() {
        gtk_media_stream_pause(streamPointer)
    }

    /// Whether the stream is currently playing.
    public var isPlaying: Bool {
        get { gtk_media_stream_get_playing(streamPointer) != 0 }
        set { gtk_media_stream_set_playing(streamPointer, newValue ? 1 : 0) }
    }

    /// Whether the stream has reached the end.
    public var ended: Bool {
        gtk_media_stream_get_ended(streamPointer) != 0
    }

    /// Whether the stream loops after finishing.
    public var loop: Bool {
        get { gtk_media_stream_get_loop(streamPointer) != 0 }
        set { gtk_media_stream_set_loop(streamPointer, newValue ? 1 : 0) }
    }

    // MARK: - Position and Duration

    /// The current playback position in microseconds.
    public var timestamp: Int {
        Int(gtk_media_stream_get_timestamp(streamPointer))
    }

    /// The total duration in microseconds, or 0 if unknown.
    public var duration: Int {
        Int(gtk_media_stream_get_duration(streamPointer))
    }

    /// Whether seeking is supported.
    public var isSeekable: Bool {
        gtk_media_stream_is_seekable(streamPointer) != 0
    }

    /// Whether a seek operation is currently in progress.
    public var isSeeking: Bool {
        gtk_media_stream_is_seeking(streamPointer) != 0
    }

    /// Seeks to the given position in microseconds.
    public func seek(_ timestamp: Int) {
        gtk_media_stream_seek(streamPointer, gint64(timestamp))
    }

    // MARK: - Audio

    /// Whether the stream is muted.
    public var isMuted: Bool {
        get { gtk_media_stream_get_muted(streamPointer) != 0 }
        set { gtk_media_stream_set_muted(streamPointer, newValue ? 1 : 0) }
    }

    /// The playback volume (0.0 to 1.0).
    public var volume: Double {
        get { gtk_media_stream_get_volume(streamPointer) }
        set { gtk_media_stream_set_volume(streamPointer, newValue) }
    }

    // MARK: - Stream Info

    /// Whether the stream is prepared (metadata loaded).
    public var isPrepared: Bool {
        gtk_media_stream_is_prepared(streamPointer) != 0
    }

    /// Whether the stream contains audio.
    public var hasAudio: Bool {
        gtk_media_stream_has_audio(streamPointer) != 0
    }

    /// Whether the stream contains video.
    public var hasVideo: Bool {
        gtk_media_stream_has_video(streamPointer) != 0
    }
}
