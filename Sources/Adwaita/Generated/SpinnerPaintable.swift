// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A `GdkPaintable`-based loading spinner for use outside of widgets.
///
/// Wraps `AdwSpinnerPaintable`. Unlike ``Spinner``, which is a full
/// widget, `SpinnerPaintable` implements the `GdkPaintable` interface
/// so it can be used anywhere a paintable is accepted (e.g. as an
/// image source). Attach it to a widget so the animation frames are
/// driven by that widget's frame clock.
///
/// ```swift
/// let paintable = SpinnerPaintable(widget: myImage)
/// // Use `paintable` wherever a GdkPaintable is expected,
/// // for example as the paintable of a GtkImage.
/// ```
///
/// - Since: libadwaita 1.6
@MainActor
public final class SpinnerPaintable: GObjectRef {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `SpinnerPaintable`.
    ///
    /// - Note: Requires libadwaita 1.6+. Returns `nil` on older versions.
    public init?(widget: Widget?) {
        guard AdwaitaVersion.isAtLeast(1, 6) else { return nil }
        let ptr = adw_spinner_paintable_new(widget?.widgetPointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The widget whose frame clock drives the spinner animation.
    /// - Since: libadwaita 1.6
    public var widget: Widget? {
        get { (adw_spinner_paintable_get_widget(opaquePointer)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_spinner_paintable_set_widget(opaquePointer, newValue?.widgetPointer) }
    }
}
