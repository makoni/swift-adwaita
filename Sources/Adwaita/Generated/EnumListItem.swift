// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// `EnumListItem` is the type of items in a [class@EnumListModel].
@MainActor
public final class EnumListItem: GObjectRef {

    /// The `name` property (read-only).
    public var name: String {
        String(cString: adw_enum_list_item_get_name(opaquePointer))
    }

    /// The `nick` property (read-only).
    public var nick: String {
        String(cString: adw_enum_list_item_get_nick(opaquePointer))
    }

    /// The `value` property (read-only).
    public var value: Int {
        Int(adw_enum_list_item_get_value(opaquePointer))
    }
}
