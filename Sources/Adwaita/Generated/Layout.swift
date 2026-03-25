// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An individual layout configuration used by ``MultiLayoutView``.
///
/// Wraps `AdwLayout`. Pairs a content widget tree with an optional name
/// so that a ``MultiLayoutView`` can switch between alternative
/// arrangements of the same child widgets.
///
/// ```swift
/// let wideBox = Box()
/// wideBox.orientation = GTK_ORIENTATION_HORIZONTAL
///
/// let wideLayout = Layout(content: wideBox)
/// wideLayout.name = "wide"
///
/// let multiView = MultiLayoutView()
/// multiView.addLayout(wideLayout)
/// ```
///
/// - Since: libadwaita 1.6
@MainActor
public final class Layout: GObjectRef {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `Layout`.
    public init(content: Widget) {
        let ptr = adw_layout_new(content.widgetPointer)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The widget tree that defines this layout's visual arrangement (read-only).
    /// - Since: libadwaita 1.6
    public var content: Widget {
        Widget(borrowing: UnsafeMutableRawPointer(adw_layout_get_content(opaquePointer)))
    }

    /// An optional identifier for this layout, used to switch between layouts in a ``MultiLayoutView``.
    /// - Since: libadwaita 1.6
    public var name: String? {
        get { (adw_layout_get_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_layout_set_name(opaquePointer, newValue) }
    }
}
