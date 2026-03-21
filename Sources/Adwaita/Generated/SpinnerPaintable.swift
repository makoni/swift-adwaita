// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A paintable showing a loading spinner.
/// - Since: libadwaita 1.6
@MainActor
public final class SpinnerPaintable: GObjectRef {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SpinnerPaintable`.
    public init(widget: Widget?) {
        let ptr = adw_spinner_paintable_new(widget?.widgetPointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `widget` property.
    /// - Since: libadwaita 1.6
    public var widget: Widget? {
        get { (adw_spinner_paintable_get_widget(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_spinner_paintable_set_widget(opaquePointer, newValue?.widgetPointer) }
    }
}
