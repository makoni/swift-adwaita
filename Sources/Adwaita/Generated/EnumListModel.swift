// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A [iface@Gio.ListModel] representing values of a given enum.
@MainActor
public final class EnumListModel: GObjectRef {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `EnumListModel`.
    public init(enumType: GType) {
        let ptr = adw_enum_list_model_new(enumType)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `enum-type` property (read-only).
    public var enumType: GType {
        adw_enum_list_model_get_enum_type(opaquePointer)
    }

    /// Calls `adw_enum_list_model_find_position`.
    @discardableResult
    public func findPosition(_ value: Int) -> Int {
        return Int(adw_enum_list_model_find_position(opaquePointer, Int32(value)))
    }
}
