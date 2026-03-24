import CAdwaita
import GObjectSupport

/// A tag that can be applied to text in a `TextBuffer` for styling.
///
/// Wraps `GtkTextTag`. Properties are set via GObject property system.
@MainActor
public final class TextTag: GObjectRef {
    /// Creates a new text tag with an optional name.
    public init(name: String? = nil) {
        let ptr = gtk_text_tag_new(name)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Common Properties

    /// The foreground color as a string (e.g. "red", "#ff0000").
    public var foreground: String? {
        get { nil } // write-only in GTK
        set {
            if let newValue {
                g_object_set_string(pointer, "foreground", newValue)
            }
        }
    }

    /// The background color as a string (e.g. "blue", "#0000ff").
    public var background: String? {
        get { nil } // write-only in GTK
        set {
            if let newValue {
                g_object_set_string(pointer, "background", newValue)
            }
        }
    }

    /// The font weight (e.g. 700 for bold, 400 for normal).
    public var weight: Int {
        get { Int(g_object_get_int(pointer, "weight")) }
        set { g_object_set_int(pointer, "weight", Int32(newValue)) }
    }

    /// The font style (e.g. PANGO_STYLE_ITALIC).
    public var style: PangoStyle {
        get { PangoStyle(rawValue: UInt32(g_object_get_int(pointer, "style"))) }
        set { g_object_set_int(pointer, "style", Int32(newValue.rawValue)) }
    }

    /// Whether to use strikethrough.
    public var strikethrough: Bool {
        get { g_object_get_bool(pointer, "strikethrough") }
        set { g_object_set_bool(pointer, "strikethrough", newValue) }
    }

    /// The underline style.
    public var underline: PangoUnderline {
        get { PangoUnderline(rawValue: UInt32(g_object_get_int(pointer, "underline"))) }
        set { g_object_set_int(pointer, "underline", Int32(newValue.rawValue)) }
    }

    /// The font size in Pango units (multiply points by PANGO_SCALE = 1024).
    public var size: Int {
        get { Int(g_object_get_int(pointer, "size")) }
        set { g_object_set_int(pointer, "size", Int32(newValue)) }
    }

    /// The font size in points.
    public var sizePoints: Double {
        get { g_object_get_double(pointer, "size-points") }
        set { g_object_set_double(pointer, "size-points", newValue) }
    }

    /// The font family name.
    public var family: String? {
        get { nil } // write-only convenience
        set {
            if let newValue {
                g_object_set_string(pointer, "family", newValue)
            }
        }
    }

    /// The scale factor relative to the default font size (e.g. 1.5 for 150%).
    public var scale: Double {
        get { g_object_get_double(pointer, "scale") }
        set { g_object_set_double(pointer, "scale", newValue) }
    }

    // MARK: - Style Presets

    /// Creates a bold text tag.
    public static func bold(name: String? = "bold") -> TextTag {
        let tag = TextTag(name: name)
        tag.weight = 700
        return tag
    }

    /// Creates an italic text tag.
    public static func italic(name: String? = "italic") -> TextTag {
        let tag = TextTag(name: name)
        tag.style = .italic
        return tag
    }

    /// Creates a monospace text tag.
    public static func monospace(name: String? = "monospace") -> TextTag {
        let tag = TextTag(name: name)
        tag.family = "monospace"
        return tag
    }

    /// Creates a colored text tag.
    public static func colored(_ color: String, name: String? = nil) -> TextTag {
        let tag = TextTag(name: name)
        tag.foreground = color
        return tag
    }
}

// MARK: - GObject property helpers

private func g_object_set_string(_ obj: UnsafeMutableRawPointer, _ prop: String, _ value: String) {
    var gval = GValue()
    g_value_init(&gval, cadw_type_string())
    g_value_set_string(&gval, value)
    g_object_set_property(obj.assumingMemoryBound(to: GObject.self), prop, &gval)
    g_value_unset(&gval)
}

private func g_object_set_int(_ obj: UnsafeMutableRawPointer, _ prop: String, _ value: Int32) {
    var gval = GValue()
    g_value_init(&gval, cadw_type_int())
    g_value_set_int(&gval, value)
    g_object_set_property(obj.assumingMemoryBound(to: GObject.self), prop, &gval)
    g_value_unset(&gval)
}

private func g_object_get_int(_ obj: UnsafeMutableRawPointer, _ prop: String) -> Int32 {
    var gval = GValue()
    g_value_init(&gval, cadw_type_int())
    g_object_get_property(obj.assumingMemoryBound(to: GObject.self), prop, &gval)
    let result = g_value_get_int(&gval)
    g_value_unset(&gval)
    return result
}

private func g_object_set_bool(_ obj: UnsafeMutableRawPointer, _ prop: String, _ value: Bool) {
    var gval = GValue()
    g_value_init(&gval, cadw_type_boolean())
    g_value_set_boolean(&gval, value ? 1 : 0)
    g_object_set_property(obj.assumingMemoryBound(to: GObject.self), prop, &gval)
    g_value_unset(&gval)
}

private func g_object_get_bool(_ obj: UnsafeMutableRawPointer, _ prop: String) -> Bool {
    var gval = GValue()
    g_value_init(&gval, cadw_type_boolean())
    g_object_get_property(obj.assumingMemoryBound(to: GObject.self), prop, &gval)
    let result = g_value_get_boolean(&gval) != 0
    g_value_unset(&gval)
    return result
}

private func g_object_set_double(_ obj: UnsafeMutableRawPointer, _ prop: String, _ value: Double) {
    var gval = GValue()
    g_value_init(&gval, cadw_type_double())
    g_value_set_double(&gval, value)
    g_object_set_property(obj.assumingMemoryBound(to: GObject.self), prop, &gval)
    g_value_unset(&gval)
}

private func g_object_get_double(_ obj: UnsafeMutableRawPointer, _ prop: String) -> Double {
    var gval = GValue()
    g_value_init(&gval, cadw_type_double())
    g_object_get_property(obj.assumingMemoryBound(to: GObject.self), prop, &gval)
    let result = g_value_get_double(&gval)
    g_value_unset(&gval)
    return result
}
