import CAdwaita
import GObjectSupport

/// A controller that manages keyboard shortcuts.
///
/// Wraps `GtkShortcutController`. Allows adding multiple shortcuts to a single
/// controller and controlling the propagation scope.
///
/// For simple one-off shortcuts, see `Widget.addKeyboardShortcut(_:handler:)`.
/// Use `ShortcutController` when you need to manage a group of shortcuts together
/// or set the scope.
@MainActor
public final class ShortcutController: GObjectRef {
    /// Creates a new shortcut controller.
    public init() {
        let ptr = gtk_shortcut_controller_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The scope in which shortcuts are activated.
    ///
    /// - `GTK_SHORTCUT_SCOPE_LOCAL`: Only the widget (default).
    /// - `GTK_SHORTCUT_SCOPE_MANAGED`: The first managed ancestor (typically the window).
    /// - `GTK_SHORTCUT_SCOPE_GLOBAL`: The entire application.
    public var scope: GtkShortcutScope {
        get { gtk_shortcut_controller_get_scope(OpaquePointer(pointer)) }
        set { gtk_shortcut_controller_set_scope(OpaquePointer(pointer), newValue) }
    }

    /// Adds a keyboard shortcut with an accelerator string.
    ///
    /// - Parameters:
    ///   - accelerator: The accelerator string (e.g. "\<Control\>s", "\<Alt\>F4").
    ///   - handler: Called when the shortcut is triggered. Return `true` to stop propagation.
    public func addShortcut(_ accelerator: String, handler: @escaping @MainActor () -> Bool) {
        guard let trigger = gtk_shortcut_trigger_parse_string(accelerator) else { return }
        let box = Unmanaged.passRetained(PublicClosureBox(handler)).toOpaque()
        let action = gtk_callback_action_new(
            { _, _, userData in
                guard let userData else { return 0 }
                let box = Unmanaged<PublicClosureBox<@MainActor () -> Bool>>.fromOpaque(userData)
                    .takeUnretainedValue()
                return MainActor.assumeIsolated {
                    box.closure() ? 1 : 0
                }
            },
            box,
            { userData in
                guard let userData else { return }
                Unmanaged<AnyObject>.fromOpaque(userData).release()
            }
        )
        let shortcut = gtk_shortcut_new(trigger, action)
        gtk_shortcut_controller_add_shortcut(OpaquePointer(pointer), shortcut)
    }

    /// Adds a keyboard shortcut with a key and modifiers.
    ///
    /// - Parameters:
    ///   - key: The key to listen for.
    ///   - modifiers: Modifier keys (e.g. `.control`, `[.control, .shift]`).
    ///   - handler: Called when the shortcut is triggered. Return `true` to stop propagation.
    public func addShortcut(key: Key, modifiers: KeyModifiers = [], handler: @escaping @MainActor () -> Bool) {
        addShortcut(acceleratorString(key: key, modifiers: modifiers), handler: handler)
    }

    /// Adds a shortcut that triggers a named action on the widget.
    ///
    /// - Parameters:
    ///   - accelerator: The accelerator string (e.g. "\<Control\>s").
    ///   - actionName: The action name (e.g. "window.close").
    public func addShortcut(_ accelerator: String, action actionName: String) {
        guard let trigger = gtk_shortcut_trigger_parse_string(accelerator) else { return }
        let action = gtk_named_action_new(actionName)
        let shortcut = gtk_shortcut_new(trigger, action)
        gtk_shortcut_controller_add_shortcut(OpaquePointer(pointer), shortcut)
    }

    /// Adds a shortcut that triggers a named action, using key and modifiers.
    ///
    /// - Parameters:
    ///   - key: The key to listen for.
    ///   - modifiers: Modifier keys.
    ///   - actionName: The action name (e.g. "window.close").
    public func addShortcut(key: Key, modifiers: KeyModifiers = [], action actionName: String) {
        addShortcut(acceleratorString(key: key, modifiers: modifiers), action: actionName)
    }
}
