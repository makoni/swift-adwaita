// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// An item representing a single value in an ``EnumListModel``.
///
/// Wraps `AdwEnumListItem`. Provides read-only access to the C enum
/// value's numeric value, registered name, and human-readable nick.
///
/// ```swift
/// let model = EnumListModel(enumType: adw_color_scheme_get_type())
/// // Retrieve the item at position 0
/// if let item = model.getItem(0) as? EnumListItem {
///     print(item.name)   // e.g. "ADW_COLOR_SCHEME_DEFAULT"
///     print(item.nick)   // e.g. "default"
///     print(item.value)  // e.g. 0
/// }
/// ```
///
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
