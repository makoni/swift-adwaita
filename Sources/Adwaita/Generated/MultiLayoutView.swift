// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget for switching between different layouts.
/// - Since: libadwaita 1.6
@MainActor
public final class MultiLayoutView: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `MultiLayoutView`.
    public init() {
        let ptr = adw_multi_layout_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `layout` property.
    /// - Since: libadwaita 1.6
    public var layout: OpaquePointer? {
        get { adw_multi_layout_view_get_layout(opaquePointer) }
        set { adw_multi_layout_view_set_layout(opaquePointer, newValue) }
    }

    /// The `layout-name` property.
    /// - Since: libadwaita 1.6
    public var layoutName: String? {
        get { (adw_multi_layout_view_get_layout_name(opaquePointer)).map { String(cString: $0) } }
        set { adw_multi_layout_view_set_layout_name(opaquePointer, newValue) }
    }

    /// Adds a layout (transfer-full: adds a ref before passing).
    public func addLayout(_ layout: Layout) {
        g_object_ref(layout.pointer)
        adw_multi_layout_view_add_layout(opaquePointer, layout.opaquePointer)
    }

    /// Calls `adw_multi_layout_view_get_child`.
    @discardableResult
    public func getChild(_ id: String) -> Widget? {
        return (adw_multi_layout_view_get_child(opaquePointer, id)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Calls `adw_multi_layout_view_get_layout_by_name`.
    @discardableResult
    public func getLayoutByName(_ name: String) -> OpaquePointer? {
        return adw_multi_layout_view_get_layout_by_name(opaquePointer, name)
    }

    /// Calls `adw_multi_layout_view_remove_layout`.
    public func removeLayout(_ layout: OpaquePointer) {
        adw_multi_layout_view_remove_layout(opaquePointer, layout)
    }

    /// Calls `adw_multi_layout_view_set_child`.
    public func setChild(_ id: String, child: Widget) {
        adw_multi_layout_view_set_child(opaquePointer, id, child.widgetPointer)
    }
}
