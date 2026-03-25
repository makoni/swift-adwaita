import Testing
@testable import Adwaita
import CAdwaita

/// Helper to verify subclass relationships at runtime.
@MainActor
func isSubclass<Sub: AnyObject, Super: AnyObject>(_: Sub.Type, of _: Super.Type) -> Bool {
    Sub.self is Super.Type
}

/// One-time GTK/Adw init for tests that instantiate widgets.
@MainActor
func ensureAdwInit() {
    struct Once { nonisolated(unsafe) static var done = false }
    guard !Once.done else { return }
    adw_init()
    Once.done = true
}
