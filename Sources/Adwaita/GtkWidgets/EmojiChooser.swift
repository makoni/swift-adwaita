import CAdwaita
import GObjectSupport

/// An emoji picker popover.
///
/// Wraps `GtkEmojiChooser`. A popover that lets users pick emoji.
/// Typically attached to a `MenuButton`.
@MainActor
public final class EmojiChooser: Widget {
    /// Creates a new emoji chooser.
    public init() {
        let ptr = gtk_emoji_chooser_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Connects to the `emoji-picked` signal.
    /// The handler receives the picked emoji as a string.
    @discardableResult
    public func onEmojiPicked(_ handler: @escaping @MainActor (String) -> Void) -> SignalConnection {
        SignalHelper.connectString(self, signal: "emoji-picked", handler: handler)
    }
}
