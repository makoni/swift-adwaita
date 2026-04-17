import CAdwaita
import Foundation
import GObjectSupport

/// Plays back an animated raster image (GIF, animated WebP, etc.) by driving a
/// ``Picture`` with frames sourced from a `GdkPixbufAnimation` iterator.
///
/// The player owns the animation and its iterator for its lifetime and
/// releases them on deinit (isolated to the main actor).
///
/// ```swift
/// let picture = Picture()
/// if let player = try AnimatedImagePlayer(contentsOf: gifURL, displayedBy: picture) {
///     player.start()
/// }
/// ```
@MainActor
public final class AnimatedImagePlayer {

    /// Intrinsic pixel dimensions reported by the animation.
    public struct Metadata: Sendable, Equatable {
        public let width: Int
        public let height: Int

        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
    }

    /// Intrinsic pixel dimensions of the animation.
    public let metadata: Metadata

    /// Whether ``start()`` has been called and ``stop()`` has not yet run.
    public private(set) var isPlaying: Bool = false

    private let picture: Picture
    private var animation: OpaquePointer?
    private var iterator: OpaquePointer?
    private var timerSourceID: UInt32?

    /// Creates a player for the animated image at `fileURL`, rendering frames
    /// into `picture`.
    ///
    /// The first frame is pushed into the picture eagerly so the UI has
    /// something to display before ``start()`` is called.
    ///
    /// - Parameters:
    ///   - fileURL: A file URL pointing to an animated raster image.
    ///   - picture: The ``Picture`` whose paintable will be updated on each frame.
    /// - Throws: ``ImageDecodingError/decodeFailed(_:)`` if the file cannot be
    ///   opened, or ``ImageDecodingError/invalidData`` if an iterator cannot
    ///   be created from the animation.
    /// - Returns: `nil` if the file decodes but contains only a single static
    ///   frame (e.g. a non-animated GIF). The caller should fall back to a
    ///   static loader in that case.
    public init?(contentsOf fileURL: URL, displayedBy picture: Picture) throws {
        var error: UnsafeMutablePointer<GError>?
        guard let animation = gdk_pixbuf_animation_new_from_file(fileURL.path, &error) else {
            let message = error.map { String(cString: $0.pointee.message) }
                ?? "gdk_pixbuf_animation_new_from_file returned NULL"
            if let error { g_error_free(error) }
            throw ImageDecodingError.decodeFailed(message)
        }
        guard gdk_pixbuf_animation_is_static_image(animation) == 0 else {
            g_object_unref(UnsafeMutableRawPointer(animation))
            return nil
        }
        guard let iterator = gdk_pixbuf_animation_get_iter(animation, nil) else {
            g_object_unref(UnsafeMutableRawPointer(animation))
            throw ImageDecodingError.invalidData
        }

        self.picture = picture
        self.animation = animation
        self.iterator = iterator
        self.metadata = Metadata(
            width: Int(gdk_pixbuf_animation_get_width(animation)),
            height: Int(gdk_pixbuf_animation_get_height(animation))
        )

        renderCurrentFrame()
    }

    /// Begins auto-advancing frames on the main-loop timer.
    public func start() {
        guard !isPlaying, iterator != nil else { return }
        isPlaying = true
        scheduleNext()
    }

    /// Stops auto-advancing frames. The currently displayed frame remains on screen.
    public func stop() {
        isPlaying = false
        if let timerSourceID {
            MainContext.cancel(sourceId: timerSourceID)
            self.timerSourceID = nil
        }
    }

    /// Advances the animation by one frame and updates the displayed paintable.
    ///
    /// Useful for manual frame control (e.g. headless rendering or tests). Has no
    /// effect if the player has already been stopped and its iterator released.
    public func advanceFrame() {
        advanceFrame(reschedule: false)
    }

    isolated deinit {
        stop()
        if let iterator {
            g_object_unref(UnsafeMutableRawPointer(iterator))
        }
        if let animation {
            g_object_unref(UnsafeMutableRawPointer(animation))
        }
    }
}

private extension AnimatedImagePlayer {
    func renderCurrentFrame() {
        guard let iterator,
              let pixbuf = gdk_pixbuf_animation_iter_get_pixbuf(iterator),
              let pixels = try? PixbufPixelDecoder.rgbaPixels(from: pixbuf) else {
            return
        }
        let texture = Texture(rgbaData: pixels.rgba, width: pixels.width, height: pixels.height)
        picture.setPaintable(texture)
    }

    func scheduleNext() {
        guard let iterator, isPlaying else { return }
        let delay = gdk_pixbuf_animation_iter_get_delay_time(iterator)
        let intervalMs = UInt32(delay > 0 ? delay : 100)
        timerSourceID = MainContext.timeout(intervalMs: intervalMs) { [weak self] in
            guard let self, self.isPlaying else { return false }
            self.advanceFrame(reschedule: true)
            return false
        }
    }

    func advanceFrame(reschedule: Bool) {
        guard let iterator else { return }
        _ = gdk_pixbuf_animation_iter_advance(iterator, nil)
        renderCurrentFrame()
        if reschedule {
            scheduleNext()
        }
    }
}
