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

    override internal init(raw pointer: UnsafeMutableRawPointer) {
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
}
