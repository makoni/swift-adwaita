// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A list of text attributes for styling entry text.
///
/// Wraps `PangoAttrList`. Use with ``EntryRow`` or ``Entry`` to style
/// the input text (bold, italic, colored, etc.), or with ``Label/attributes``
/// to overlay styling on top of plain text without switching to markup.
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
    public let pointer: OpaquePointer

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

    /// Adds a font weight attribute for a specific substring.
    public func addWeight(_ weight: PangoWeight, range: Range<String.Index>, in text: String) {
        insert(pango_attr_weight_new(weight), range: range, in: text)
    }

    /// Adds bold weight.
    public func addBold() {
        addWeight(PANGO_WEIGHT_BOLD)
    }

    /// Adds bold weight for a specific substring.
    public func addBold(range: Range<String.Index>, in text: String) {
        addWeight(PANGO_WEIGHT_BOLD, range: range, in: text)
    }

    /// Adds light weight.
    public func addLight() {
        addWeight(PANGO_WEIGHT_LIGHT)
    }

    /// Adds light weight for a specific substring.
    public func addLight(range: Range<String.Index>, in text: String) {
        addWeight(PANGO_WEIGHT_LIGHT, range: range, in: text)
    }

    /// Adds a font style attribute.
    public func addStyle(_ style: PangoStyle) {
        pango_attr_list_insert(pointer, pango_attr_style_new(style))
    }

    /// Adds a font style attribute for a specific substring.
    public func addStyle(_ style: PangoStyle, range: Range<String.Index>, in text: String) {
        insert(pango_attr_style_new(style), range: range, in: text)
    }

    /// Adds italic style.
    public func addItalic() {
        addStyle(PANGO_STYLE_ITALIC)
    }

    /// Adds italic style for a specific substring.
    public func addItalic(range: Range<String.Index>, in text: String) {
        addStyle(PANGO_STYLE_ITALIC, range: range, in: text)
    }

    /// Adds a font family attribute.
    public func addFamily(_ family: String) {
        pango_attr_list_insert(pointer, pango_attr_family_new(family))
    }

    /// Adds a font family attribute for a specific substring.
    public func addFamily(_ family: String, range: Range<String.Index>, in text: String) {
        insert(pango_attr_family_new(family), range: range, in: text)
    }

    /// Adds a font size attribute in Pango units (1 point = 1024 Pango units).
    public func addSize(_ pangoUnits: Int) {
        pango_attr_list_insert(pointer, pango_attr_size_new(Int32(pangoUnits)))
    }

    /// Adds a font size attribute in Pango units for a specific substring.
    public func addSize(_ pangoUnits: Int, range: Range<String.Index>, in text: String) {
        insert(pango_attr_size_new(Int32(pangoUnits)), range: range, in: text)
    }

    /// Adds a font size attribute in points.
    public func addSizePoints(_ points: Double) {
        addSize(Int(points * 1024))
    }

    /// Adds a font size attribute in points for a specific substring.
    public func addSizePoints(_ points: Double, range: Range<String.Index>, in text: String) {
        addSize(Int(points * 1024), range: range, in: text)
    }

    /// Adds an absolute font size in device units (pixels).
    public func addSizeAbsolute(_ pixels: Int) {
        pango_attr_list_insert(pointer, pango_attr_size_new_absolute(Int32(pixels * 1024)))
    }

    /// Adds an absolute font size in device units for a specific substring.
    public func addSizeAbsolute(_ pixels: Int, range: Range<String.Index>, in text: String) {
        insert(pango_attr_size_new_absolute(Int32(pixels * 1024)), range: range, in: text)
    }

    /// Adds a foreground (text) color.
    ///
    /// Color components are 0.0–1.0.
    public func addForegroundColor(red: Double, green: Double, blue: Double) {
        pango_attr_list_insert(
            pointer,
            pango_attr_foreground_new(colorComponent(red), colorComponent(green), colorComponent(blue))
        )
    }

    /// Adds a foreground color.
    public func addForegroundColor(_ rgba: RGBA) {
        addForegroundColor(red: rgba.red, green: rgba.green, blue: rgba.blue)
    }

    /// Adds a foreground color for a specific substring.
    public func addForegroundColor(_ rgba: RGBA, range: Range<String.Index>, in text: String) {
        insert(
            pango_attr_foreground_new(
                colorComponent(rgba.red),
                colorComponent(rgba.green),
                colorComponent(rgba.blue)
            ),
            range: range,
            in: text
        )
    }

    /// Adds a background color.
    ///
    /// Color components are 0.0–1.0.
    public func addBackgroundColor(red: Double, green: Double, blue: Double) {
        pango_attr_list_insert(
            pointer,
            pango_attr_background_new(colorComponent(red), colorComponent(green), colorComponent(blue))
        )
    }

    /// Adds a background color.
    public func addBackgroundColor(_ rgba: RGBA) {
        addBackgroundColor(red: rgba.red, green: rgba.green, blue: rgba.blue)
    }

    /// Adds a background color for a specific substring.
    public func addBackgroundColor(_ rgba: RGBA, range: Range<String.Index>, in text: String) {
        insert(
            pango_attr_background_new(
                colorComponent(rgba.red),
                colorComponent(rgba.green),
                colorComponent(rgba.blue)
            ),
            range: range,
            in: text
        )
    }

    /// Adds an underline attribute.
    public func addUnderline(_ style: PangoUnderline = PANGO_UNDERLINE_SINGLE) {
        pango_attr_list_insert(pointer, pango_attr_underline_new(style))
    }

    /// Adds an underline attribute for a specific substring.
    public func addUnderline(
        _ style: PangoUnderline = PANGO_UNDERLINE_SINGLE,
        range: Range<String.Index>,
        in text: String
    ) {
        insert(pango_attr_underline_new(style), range: range, in: text)
    }

    /// Adds an underline color.
    ///
    /// Color components are 0.0–1.0.
    public func addUnderlineColor(red: Double, green: Double, blue: Double) {
        pango_attr_list_insert(
            pointer,
            pango_attr_underline_color_new(colorComponent(red), colorComponent(green), colorComponent(blue))
        )
    }

    /// Adds an underline color.
    public func addUnderlineColor(_ rgba: RGBA) {
        addUnderlineColor(red: rgba.red, green: rgba.green, blue: rgba.blue)
    }

    /// Adds an underline color for a specific substring.
    public func addUnderlineColor(_ rgba: RGBA, range: Range<String.Index>, in text: String) {
        insert(
            pango_attr_underline_color_new(
                colorComponent(rgba.red),
                colorComponent(rgba.green),
                colorComponent(rgba.blue)
            ),
            range: range,
            in: text
        )
    }

    /// Adds a strikethrough attribute.
    public func addStrikethrough(_ enabled: Bool = true) {
        pango_attr_list_insert(pointer, pango_attr_strikethrough_new(enabled ? 1 : 0))
    }

    /// Adds a strikethrough attribute for a specific substring.
    public func addStrikethrough(_ enabled: Bool = true, range: Range<String.Index>, in text: String) {
        insert(pango_attr_strikethrough_new(enabled ? 1 : 0), range: range, in: text)
    }

    /// Adds a strikethrough color.
    ///
    /// Color components are 0.0–1.0.
    public func addStrikethroughColor(red: Double, green: Double, blue: Double) {
        pango_attr_list_insert(
            pointer,
            pango_attr_strikethrough_color_new(colorComponent(red), colorComponent(green), colorComponent(blue))
        )
    }

    /// Adds a strikethrough color.
    public func addStrikethroughColor(_ rgba: RGBA) {
        addStrikethroughColor(red: rgba.red, green: rgba.green, blue: rgba.blue)
    }

    /// Adds a strikethrough color for a specific substring.
    public func addStrikethroughColor(_ rgba: RGBA, range: Range<String.Index>, in text: String) {
        insert(
            pango_attr_strikethrough_color_new(
                colorComponent(rgba.red),
                colorComponent(rgba.green),
                colorComponent(rgba.blue)
            ),
            range: range,
            in: text
        )
    }

    /// Removes every attribute from the list in place.
    public func removeAll() {
        let removed = pango_attr_list_filter(pointer, { _, _ in 1 }, nil)
        if let removed {
            pango_attr_list_unref(removed)
        }
    }

    private func insert(
        _ attribute: UnsafeMutablePointer<PangoAttribute>,
        range: Range<String.Index>,
        in text: String
    ) {
        let byteRange = clampedPangoByteRange(for: text.pangoByteRange(for: range), in: text)
        attribute.pointee.start_index = UInt32(byteRange.lowerBound)
        attribute.pointee.end_index = UInt32(byteRange.upperBound)
        pango_attr_list_insert(pointer, attribute)
    }

    func clampedPangoByteRange(for range: Range<Int>, in text: String) -> Range<Int> {
        let utf8Count = text.utf8.count
        let lower = min(max(range.lowerBound, 0), utf8Count)
        let upper = min(max(range.upperBound, lower), utf8Count)

        precondition(
            !isMidCodepointBoundary(lower, in: text),
            "TextAttributes range started in the middle of a UTF-8 code point"
        )
        precondition(
            !isMidCodepointBoundary(upper, in: text),
            "TextAttributes range ended in the middle of a UTF-8 code point"
        )
        return lower ..< upper
    }

    func isMidCodepointBoundary(_ offset: Int, in text: String) -> Bool {
        let utf8View = text.utf8
        let utf8Count = utf8View.count
        guard offset > 0, offset < utf8Count else { return false }
        if let isMid = utf8View.withContiguousStorageIfAvailable({
            ($0[offset] & 0b1100_0000) == 0b1000_0000
        }) {
            return isMid
        }
        let boundaryIndex = utf8View.index(utf8View.startIndex, offsetBy: offset)
        return (utf8View[boundaryIndex] & 0b1100_0000) == 0b1000_0000
    }

    private func colorComponent(_ value: Double) -> UInt16 {
        UInt16(min(max(value, 0), 1) * 65535)
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
