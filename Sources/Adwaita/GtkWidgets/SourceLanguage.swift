import CAdwaita
import CGtkSource
import GObjectSupport

/// A language definition used by ``SourceBuffer`` for syntax highlighting.
///
/// Wraps `GtkSourceLanguage`.
@MainActor
public final class SourceLanguage: GObjectRef {
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The stable language identifier, such as `"markdown"` or `"swift"`.
    public var id: String? {
        gtk_source_language_get_id(opaquePointer).map { String(cString: $0) }
    }

    /// The stable language identifier as a typed value.
    public var identifier: SourceLanguageID? {
        id.map(SourceLanguageID.init(rawValue:))
    }

    /// The user-visible language name.
    public var name: String? {
        gtk_source_language_get_name(opaquePointer).map { String(cString: $0) }
    }

    /// The user-visible language section/category.
    public var section: String? {
        gtk_source_language_get_section(opaquePointer).map { String(cString: $0) }
    }

    /// Whether the language definition is hidden from generic pickers.
    public var hidden: Bool {
        gtk_source_language_get_hidden(opaquePointer) != 0
    }
}
