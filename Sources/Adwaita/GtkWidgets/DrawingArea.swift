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

    override internal init(raw pointer: UnsafeMutableRawPointer) {
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
    /// The closure receives a Cairo context pointer, the width, and the height.
    /// Use Cairo C functions (`cairo_set_source_rgb`, `cairo_rectangle`, etc.)
    /// to draw.
    ///
    /// - Parameter drawFunc: `(cairoContext, width, height) -> Void`
    public func setDrawFunc(_ drawFunc: @escaping @MainActor (OpaquePointer, Int, Int) -> Void) {
        let box = Unmanaged.passRetained(PublicClosureBox(drawFunc)).toOpaque()
        gtk_drawing_area_set_draw_func(
            drawingAreaPointer,
            { _, cr, width, height, userData in
                guard let userData, let cr else { return }
                let box = Unmanaged<PublicClosureBox<@MainActor (OpaquePointer, Int, Int) -> Void>>
                    .fromOpaque(userData).takeUnretainedValue()
                MainActor.assumeIsolated {
                    box.closure(cr, Int(width), Int(height))
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
