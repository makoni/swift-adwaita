import CAdwaita
import CGtkSource
import GObjectSupport

/// Access to GtkSource style schemes.
///
/// Wraps `GtkSourceStyleSchemeManager`.
@MainActor
public final class SourceStyleSchemeManager: GObjectRef {
    /// The process-wide default manager.
    public static var `default`: SourceStyleSchemeManager {
        let ptr = gtk_source_style_scheme_manager_get_default()!
        return SourceStyleSchemeManager(borrowing: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// All known style-scheme identifiers.
    public var schemeIDs: [String] {
        guard let ids = gtk_source_style_scheme_manager_get_scheme_ids(opaquePointer) else { return [] }
        var result: [String] = []
        var index = 0
        while let current = ids[index] {
            result.append(String(cString: current))
            index += 1
        }
        return result
    }

    /// All known style-scheme identifiers as typed values.
    public var schemes: [SourceStyleSchemeID] {
        schemeIDs.map { SourceStyleSchemeID(rawValue: $0) }
    }

    /// Looks up a style scheme by identifier.
    public func scheme(id: String) -> SourceStyleScheme? {
        guard let ptr = gtk_source_style_scheme_manager_get_scheme(opaquePointer, id) else { return nil }
        return SourceStyleScheme(borrowing: UnsafeMutableRawPointer(ptr))
    }

    /// Looks up a style scheme by typed identifier.
    public func scheme(id: SourceStyleSchemeID) -> SourceStyleScheme? {
        scheme(id: id.rawValue)
    }
}
