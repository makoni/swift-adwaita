import CAdwaita
import GObjectSupport

/// A widget for custom drawing.
///
/// Wraps `GtkDrawingArea`. Uses a Cairo context for rendering.
@MainActor
public final class DrawingArea: Widget {
    /// Creates a new drawing area.
    public init() {
        let ptr = gtk_drawing_area_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    private var drawingAreaPointer: UnsafeMutablePointer<GtkDrawingArea> { castedPointer() }

    /// The content width the drawing area requests.
    public var contentWidth: Int {
        get { Int(gtk_drawing_area_get_content_width(drawingAreaPointer)) }
        set { gtk_drawing_area_set_content_width(drawingAreaPointer, Int32(newValue)) }
    }

    /// The content height the drawing area requests.
    public var contentHeight: Int {
        get { Int(gtk_drawing_area_get_content_height(drawingAreaPointer)) }
        set { gtk_drawing_area_set_content_height(drawingAreaPointer, Int32(newValue)) }
    }

    /// Sets the draw function that is called to render the contents.
    ///
    /// The closure receives a ``CairoContext``, the width, and the height.
    ///
    /// ```swift
    /// drawingArea.setDrawFunc { cr, width, height in
    ///     cr.setSourceRGB(0.2, 0.6, 1.0)
    ///     cr.rectangle(x: 0, y: 0, width: Double(width), height: Double(height))
    ///     cr.fill()
    /// }
    /// ```
    ///
    /// - Parameter drawFunc: `(cairoContext, width, height) -> Void`
    public func setDrawFunc(_ drawFunc: @escaping @MainActor (CairoContext, Int, Int) -> Void) {
        let box = Unmanaged.passRetained(PublicClosureBox(drawFunc)).toOpaque()
        gtk_drawing_area_set_draw_func(
            drawingAreaPointer,
            { _, cr, width, height, userData in
                guard let userData, let cr else { return }
                let box = Unmanaged<PublicClosureBox<@MainActor (CairoContext, Int, Int) -> Void>>
                    .fromOpaque(userData).takeUnretainedValue()
                MainActor.assumeIsolated {
                    box.closure(CairoContext(cr), Int(width), Int(height))
                }
            },
            box,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
    }

    /// Queues a redraw of the drawing area.
    public func queueDraw() {
        gtk_widget_queue_draw(widgetPointer)
    }
}
