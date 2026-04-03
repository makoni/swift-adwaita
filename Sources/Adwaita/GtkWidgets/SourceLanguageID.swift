import Foundation

/// A typed identifier for a GtkSource language definition.
///
/// `GtkSourceView` language IDs come from runtime-installed language specs, so
/// the full set can vary by system and package version. Use
/// ``SourceLanguageManager/languages`` to inspect all IDs available on the
/// current machine, and use the static convenience values below for common
/// languages.
public struct SourceLanguageID: RawRepresentable, Hashable, Codable, Sendable, ExpressibleByStringLiteral,
    CustomStringConvertible {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        rawValue = value
    }

    public var description: String {
        rawValue
    }
}

public extension SourceLanguageID {
    static let markdown: Self = "markdown"
    static let swift: Self = "swift"
    static let python: Self = "python"
    static let javascript: Self = "js"
    static let typescript: Self = "typescript"
    static let json: Self = "json"
    static let yaml: Self = "yaml"
    static let xml: Self = "xml"
    static let html: Self = "html"
    static let css: Self = "css"
    static let shell: Self = "sh"
    static let c: Self = "c"
    static let cpp: Self = "cpp"
    static let csharp: Self = "csharp"
    static let go: Self = "go"
    static let java: Self = "java"
    static let kotlin: Self = "kotlin"
    static let rust: Self = "rust"
    static let ruby: Self = "ruby"
    static let php: Self = "php"
    static let sql: Self = "sql"
    static let toml: Self = "toml"
}
