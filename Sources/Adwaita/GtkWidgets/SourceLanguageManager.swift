import CAdwaita
import CGtkSource
import GObjectSupport

/// Access to GtkSource language definitions.
///
/// Wraps `GtkSourceLanguageManager`.
@MainActor
public final class SourceLanguageManager: GObjectRef {
    /// The process-wide default manager.
    public static var `default`: SourceLanguageManager {
        let ptr = gtk_source_language_manager_get_default()!
        return SourceLanguageManager(borrowing: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// All known language identifiers.
    public var languageIDs: [String] {
        guard let ids = gtk_source_language_manager_get_language_ids(opaquePointer) else { return [] }
        var result: [String] = []
        var index = 0
        while let current = ids[index] {
            result.append(String(cString: current))
            index += 1
        }
        return result
    }

    /// All known language identifiers as typed values.
    public var languages: [SourceLanguageID] {
        languageIDs.map(SourceLanguageID.init(rawValue:))
    }

    /// Looks up a language definition by identifier.
    public func language(id: String) -> SourceLanguage? {
        guard let ptr = gtk_source_language_manager_get_language(opaquePointer, id) else { return nil }
        return SourceLanguage(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Looks up a language definition by typed identifier.
    public func language(id: SourceLanguageID) -> SourceLanguage? {
        language(id: id.rawValue)
    }
}
