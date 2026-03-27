// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// An individual layout configuration used by ``MultiLayoutView``.
///
/// Wraps `AdwLayout`. Pairs a content widget tree with an optional name
/// so that a ``MultiLayoutView`` can switch between alternative
/// arrangements of the same child widgets.
///
/// - Note: Requires libadwaita 1.6+. The initializer returns `nil` at runtime
///   if the installed version is too old.
///
/// - Since: libadwaita 1.6
@MainActor
public final class Layout: GObjectRef {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Layout`. Returns `nil` if libadwaita < 1.6.
    public init?(content: Widget) {
        guard AdwaitaVersion.isAtLeast(1, 6) else { return nil }
        let ptr = cadw_layout_new(content.widgetPointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The widget tree that defines this layout's visual arrangement (read-only).
    /// - Since: libadwaita 1.6
    public var content: Widget {
        Widget(borrowing: UnsafeMutableRawPointer(cadw_layout_get_content(pointer)!))
    }

    /// An optional identifier for this layout, used to switch between layouts in a ``MultiLayoutView``.
    /// - Since: libadwaita 1.6
    public var name: String? {
        get { (cadw_layout_get_name(pointer)).map { String(cString: $0) } }
        set { cadw_layout_set_name(pointer, newValue) }
    }
}
