// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// An auxiliary class used by [class@ViewStack].
/// - Since: libadwaita 1.4
@MainActor
public final class ViewStackPages: GObjectRef {

    /// The `selected-page` property.
    /// - Since: libadwaita 1.4
    public var selectedPage: OpaquePointer? {
        get { adw_view_stack_pages_get_selected_page(opaquePointer) }
        set { adw_view_stack_pages_set_selected_page(opaquePointer, newValue) }
    }
}
