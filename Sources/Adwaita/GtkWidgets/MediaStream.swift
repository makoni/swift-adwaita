// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

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

    /// Releases the stream's media resources, leaving an empty stream behind.
    ///
    /// On Linux a `GtkMediaFile` is backed by GStreamer, which runs a pipeline
    /// on its own thread with its own main loop. Dropping the last Swift
    /// reference schedules that pipeline's teardown, but does not wait for it —
    /// so a short-lived stream can still be disposing on the GStreamer thread
    /// while the program moves on, and a process that exits in that window
    /// aborts inside `g_mutex_clear`. Calling `clear()` while the main loop is
    /// still running makes the teardown happen at a point you choose.
    ///
    /// Worth doing at the end of a test, and whenever a stream outlives the
    /// thing that was playing it. A no-op on a stream that is not a media file.
    public func clear() {
        guard g_type_check_instance_is_a(
            pointer.assumingMemoryBound(to: GTypeInstance.self),
            gtk_media_file_get_type()
        ) != 0 else { return }
        gtk_media_file_clear(pointer.assumingMemoryBound(to: GtkMediaFile.self))
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
