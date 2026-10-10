// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Testing
import Adwaita
@testable import DemoAppLib

/// Every `*-symbolic` icon name the demo references (in widgets and in the
/// `sourceCode` snippets) must resolve in the stock Adwaita icon theme —
/// libadwaita's default — or in the demo's own bundled icons. A name that only
/// exists in a distro theme (Yaru ships `emblem-ok-symbolic`, Adwaita doesn't)
/// renders as the red "missing image" square everywhere else.
///
/// The theme is built with an explicit search path made of the system data
/// dirs only, so a stray `~/.local/share/icons/hicolor/index.theme` on the
/// developer's machine can't change the result.
@Suite(.serialized)
struct DemoIconTests {
    static let demoSources = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Sources/DemoAppLib", isDirectory: true)

    static let systemIconDirs: [String] = {
        let dataDirs = ProcessInfo.processInfo.environment["XDG_DATA_DIRS"] ?? ""
        let dirs = dataDirs.split(separator: ":").map(String.init) + ["/usr/local/share", "/usr/share"]
        var seen = Set<String>()
        return dirs.map { URL(fileURLWithPath: $0).appendingPathComponent("icons").path }
            .filter { seen.insert($0).inserted }
    }()

    static var adwaitaThemeInstalled: Bool {
        systemIconDirs.contains { FileManager.default.fileExists(atPath: "\($0)/Adwaita/index.theme") }
    }

    /// Every distinct `"…-symbolic"` string literal in the demo sources.
    static func referencedIconNames() throws -> Set<String> {
        let regex = try Regex(#""([a-z0-9][a-z0-9._-]*-symbolic(?:-rtl)?)""#)
        var names = Set<String>()
        let enumerator = FileManager.default.enumerator(at: demoSources, includingPropertiesForKeys: nil)
        while let url = enumerator?.nextObject() as? URL {
            guard url.pathExtension == "swift" else { continue }
            let text = try String(contentsOf: url, encoding: .utf8)
            for match in text.matches(of: regex) {
                if let name = match.output[1].substring {
                    names.insert(String(name))
                }
            }
        }
        return names
    }

    @Test(.enabled(if: adwaitaThemeInstalled, "the Adwaita icon theme is not installed"))
    @MainActor
    func everyReferencedIconExistsInAdwaita() throws {
        ensureDemoAdwInit()

        let names = try Self.referencedIconNames()
        #expect(names.count > 20, "the source scan found suspiciously few icon names: \(names.count)")

        let theme = gtk_icon_theme_new()!
        defer { g_object_unref(UnsafeMutableRawPointer(theme)) }
        gtk_icon_theme_set_theme_name(theme, "Adwaita")

        let searchPath =
            Self.systemIconDirs
            + [Self.demoSources.appendingPathComponent("Resources/icons").path]
        let cPaths = searchPath.map { UnsafePointer(strdup($0)) } + [nil]
        defer { cPaths.forEach { free(UnsafeMutableRawPointer(mutating: $0)) } }
        cPaths.withUnsafeBufferPointer { gtk_icon_theme_set_search_path(theme, $0.baseAddress) }

        // Keep GTK's and libadwaita's bundled resource icons, as a real app has.
        let display = gdk_display_get_default()!
        let displayResources = gtk_icon_theme_get_resource_path(gtk_icon_theme_get_for_display(display))!
        defer { g_strfreev(displayResources) }
        displayResources.withMemoryRebound(to: UnsafePointer<CChar>?.self, capacity: 1) {
            gtk_icon_theme_set_resource_path(theme, $0)
        }

        let missing = names.filter { gtk_icon_theme_has_icon(theme, $0) == 0 }.sorted()
        #expect(missing.isEmpty, "icons missing from the Adwaita theme: \(missing)")
    }
}
#endif
