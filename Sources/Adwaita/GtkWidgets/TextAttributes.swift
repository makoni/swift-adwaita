import CAdwaita
import GObjectSupport

/// A list of text attributes for styling entry text.
///
/// Wraps `PangoAttrList`. Use with ``EntryRow`` or ``Entry`` to style
/// the input text (bold, italic, colored, etc.).
///
/// ```swift
/// let attrs = TextAttributes()
/// attrs.addBold()
/// attrs.addForegroundColor(red: 0.8, green: 0.2, blue: 0.2)
/// entryRow.textAttributes = attrs
/// ```
@MainActor
public final class TextAttributes {
    /// The underlying PangoAttrList pointer.
    public nonisolated(unsafe) let pointer: OpaquePointer

    /// Creates an empty attribute list.
    public init() {
        pointer = pango_attr_list_new()
    }

    /// Borrows a reference to an existing PangoAttrList.
    public init(borrowing ptr: OpaquePointer) {
        pointer = pango_attr_list_ref(ptr)
    }

    isolated deinit {
        pango_attr_list_unref(pointer)
    }

    // MARK: - Adding Attributes

    /// Adds a font weight attribute.
    public func addWeight(_ weight: PangoWeight) {
        pango_attr_list_insert(pointer, pango_attr_weight_new(weight))
    }

    /// Adds bold weight.
    public func addBold() {
        addWeight(PANGO_WEIGHT_BOLD)
    }

    /// Adds light weight.
    public func addLight() {
        addWeight(PANGO_WEIGHT_LIGHT)
    }

    /// Adds a font style attribute.
    public func addStyle(_ style: PangoStyle) {
        pango_attr_list_insert(pointer, pango_attr_style_new(style))
    }

    /// Adds italic style.
    public func addItalic() {
        addStyle(PANGO_STYLE_ITALIC)
    }

    /// Adds a font family attribute.
    public func addFamily(_ family: String) {
        pango_attr_list_insert(pointer, pango_attr_family_new(family))
    }

    /// Adds a font size attribute in Pango units (1 point = 1024 Pango units).
    public func addSize(_ pangoUnits: Int) {
        pango_attr_list_insert(pointer, pango_attr_size_new(Int32(pangoUnits)))
    }

    /// Adds a font size attribute in points.
    public func addSizePoints(_ points: Double) {
        addSize(Int(points * 1024))
    }

    /// Adds an absolute font size in device units (pixels).
    public func addSizeAbsolute(_ pixels: Int) {
        pango_attr_list_insert(pointer, pango_attr_size_new_absolute(Int32(pixels * 1024)))
    }

    /// Adds a foreground (text) color.
    ///
    /// Color components are 0.0–1.0.
    public func addForegroundColor(red: Double, green: Double, blue: Double) {
        pango_attr_list_insert(pointer, pango_attr_foreground_new(
            UInt16(red * 65535),
            UInt16(green * 65535),
            UInt16(blue * 65535)
        ))
    }

    /// Adds an underline attribute.
    public func addUnderline(_ style: PangoUnderline = PANGO_UNDERLINE_SINGLE) {
        pango_attr_list_insert(pointer, pango_attr_underline_new(style))
    }

    /// Adds an underline color.
    ///
    /// Color components are 0.0–1.0.
    public func addUnderlineColor(red: Double, green: Double, blue: Double) {
        pango_attr_list_insert(pointer, pango_attr_underline_color_new(
            UInt16(red * 65535),
            UInt16(green * 65535),
            UInt16(blue * 65535)
        ))
    }

    /// Adds a strikethrough attribute.
    public func addStrikethrough(_ enabled: Bool = true) {
        pango_attr_list_insert(pointer, pango_attr_strikethrough_new(enabled ? 1 : 0))
    }

    /// Adds a strikethrough color.
    ///
    /// Color components are 0.0–1.0.
    public func addStrikethroughColor(red: Double, green: Double, blue: Double) {
        pango_attr_list_insert(pointer, pango_attr_strikethrough_color_new(
            UInt16(red * 65535),
            UInt16(green * 65535),
            UInt16(blue * 65535)
        ))
    }
}

// MARK: - Pango Enum Extensions

public extension PangoWeight {
    /// Thin weight (100).
    static let thin = PANGO_WEIGHT_THIN
    /// Ultra-light weight (200).
    static let ultralight = PANGO_WEIGHT_ULTRALIGHT
    /// Light weight (300).
    static let light = PANGO_WEIGHT_LIGHT
    /// Semi-light weight (350).
    static let semilight = PANGO_WEIGHT_SEMILIGHT
    /// Book weight (380).
    static let book = PANGO_WEIGHT_BOOK
    /// Normal weight (400).
    static let normal = PANGO_WEIGHT_NORMAL
    /// Medium weight (500).
    static let medium = PANGO_WEIGHT_MEDIUM
    /// Semi-bold weight (600).
    static let semibold = PANGO_WEIGHT_SEMIBOLD
    /// Bold weight (700).
    static let bold = PANGO_WEIGHT_BOLD
    /// Ultra-bold weight (800).
    static let ultrabold = PANGO_WEIGHT_ULTRABOLD
    /// Heavy weight (900).
    static let heavy = PANGO_WEIGHT_HEAVY
}

public extension PangoStyle {
    /// Normal (upright) style.
    static let normal = PANGO_STYLE_NORMAL
    /// Oblique style.
    static let oblique = PANGO_STYLE_OBLIQUE
    /// Italic style.
    static let italic = PANGO_STYLE_ITALIC
}

public extension PangoUnderline {
    /// No underline.
    static let none = PANGO_UNDERLINE_NONE
    /// Single underline.
    static let single = PANGO_UNDERLINE_SINGLE
    /// Double underline.
    static let double = PANGO_UNDERLINE_DOUBLE
    /// Low underline.
    static let low = PANGO_UNDERLINE_LOW
    /// Error-style underline (wavy).
    static let error = PANGO_UNDERLINE_ERROR
}
