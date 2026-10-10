// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Foundation
import Testing
import Adwaita
@testable import DemoAppLib

/// Every widget an example builds must be freed once its window is destroyed.
/// A widget that survives is kept alive by a reference cycle — typically a
/// signal handler that strongly captures its own widget or an ancestor.
@Suite(.serialized)
struct DemoLeakTests {
    /// GWeakRefs to every widget in `root`'s tree, walked through the C API so
    /// the walk itself creates no Swift wrappers (and no extra references).
    @MainActor
    static func weakRefs(to root: UnsafeMutablePointer<GtkWidget>) -> [UnsafeMutablePointer<GWeakRef>] {
        var refs: [UnsafeMutablePointer<GWeakRef>] = []
        var stack = [root]
        while let widget = stack.popLast() {
            // GTK keeps tooltip windows for the display's lifetime; they are
            // not the example's widgets.
            if g_type_check_instance_is_a(
                UnsafeMutableRawPointer(widget).assumingMemoryBound(to: GTypeInstance.self),
                g_type_from_name("GtkTooltipWindow")) != 0
            {
                continue
            }
            let ref = UnsafeMutablePointer<GWeakRef>.allocate(capacity: 1)
            ref.initialize(to: GWeakRef())
            g_weak_ref_init(ref, UnsafeMutableRawPointer(widget))
            refs.append(ref)
            var child = gtk_widget_get_first_child(widget)
            while let current = child {
                stack.append(current)
                child = gtk_widget_get_next_sibling(current)
            }
        }
        return refs
    }

    /// Type names of the widgets still alive behind `refs`; clears the refs.
    @MainActor
    static func survivors(_ refs: [UnsafeMutablePointer<GWeakRef>]) -> [String] {
        var names: [String] = []
        for ref in refs {
            if let object = g_weak_ref_get(ref) {
                let name = g_type_name_from_instance(object.assumingMemoryBound(to: GTypeInstance.self))
                names.append(name.map { String(cString: $0) } ?? "?")
                g_object_unref(object)
            }
            g_weak_ref_clear(ref)
            ref.deallocate()
        }
        return names
    }

    /// Builds `example` in a window, destroys it, and returns what survived.
    @MainActor
    static func leakedWidgets(_ example: any DemoExample) -> [String] {
        var refs: [UnsafeMutablePointer<GWeakRef>] = []
        do {
            let window = Window()
            window.setDefaultSize(width: 900, height: 700)
            window.content = example.buildWidget()
            window.present()
            drainMainLoop()
            refs = weakRefs(to: window.widgetPointer)
            window.destroy()
        }
        drainMainLoop(8)
        return survivors(refs)
    }

    /// Examples whose leftovers come from upstream bugs, reproduced in plain C
    /// without any Swift code involved.
    static let knownUpstreamLeaks: [String: String] = [
        // libadwaita 1.9: AdwInlineViewSwitcher never frees its per-page
        // button contents (AdwBin, AdwIndicatorBin, labels).
        "inlineviewswitcher": "libadwaita AdwInlineViewSwitcher",
        // GtkSourceView 5.18: with line numbers on, the gutter caches a
        // GtkSourceGutterLines that references the view until the next
        // snapshot, so view ↔ gutter ↔ lines never break.
        "sourceview": "GtkSourceView gutter lines cache",
    ]

    @Test @MainActor
    func everyExampleFreesItsWidgetsWhenTheWindowCloses() {
        ensureDemoAdwInit()
        // DEMO_LEAK_EXAMPLES=id1,id2 narrows the run to those example ids.
        let only = ProcessInfo.processInfo.environment["DEMO_LEAK_EXAMPLES"]
            .map { Set($0.split(separator: ",").map(String.init)) }
        var report: [String] = []
        for example in allExamples
        where !example.opensInWindow && Self.knownUpstreamLeaks[example.id] == nil
            && only?.contains(example.id) ?? true
        {
            let leaked = Self.leakedWidgets(example)
            if !leaked.isEmpty {
                let counts = Dictionary(grouping: leaked, by: { $0 }).mapValues(\.count)
                let summary = counts.sorted { $0.key < $1.key }.map { "\($0.key)×\($0.value)" }
                report.append("\(example.id): \(leaked.count) [\(summary.joined(separator: ", "))]")
            }
        }
        #expect(report.isEmpty, "leaked widgets:\n\(report.joined(separator: "\n"))")
    }
}
#endif
