// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A list model whose items are the values of a GLib-registered enum.
///
/// Wraps `AdwEnumListModel`. Each item is an ``EnumListItem`` exposing
/// the enum value's name, nick, and numeric value. Useful for populating
/// a `ComboRow` or `DropDown` from a C enum type.
///
/// ```swift
/// let model = EnumListModel(enumType: adw_color_scheme_get_type())
/// let position = model.findPosition(1)
/// print("Enum type: \(model.enumType)")
/// ```
///
@MainActor
public final class EnumListModel: GObjectRef {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `EnumListModel`.
    public init(enumType: GType) {
        let ptr = adw_enum_list_model_new(enumType)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The GLib type of the enum this model represents.
    public var enumType: GType {
        adw_enum_list_model_get_enum_type(opaquePointer)
    }

    /// Finds the position of the item with the given enum value in the model.
    ///
    /// - Parameter value: The numeric enum value to search for.
    /// - Returns: The zero-based index of the matching item, or `GTK_INVALID_LIST_POSITION` if not found.
    @discardableResult
    public func findPosition(_ value: Int) -> Int {
        Int(adw_enum_list_model_find_position(opaquePointer, Int32(value)))
    }
}
