import CAdwaita
import GObjectSupport

/// An emoji picker popover.
///
/// Wraps `GtkEmojiChooser`. A popover that lets users pick emoji.
/// Typically attached to a `MenuButton`.
///
/// ```swift
/// let chooser = EmojiChooser()
/// chooser.onEmojiPicked { emoji in
///     print("User picked: \(emoji)")
/// }
///
/// let menuButton = MenuButton()
/// menuButton.popover = chooser
/// ```
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

    /// Emitted when an emoji is selected.
    ///
    /// - Parameter handler: Called when an emoji is picked. Receives the emoji as a string.
    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.
    @discardableResult
    public func onEmojiPicked(_ handler: @escaping @MainActor (String) -> Void) -> SignalConnection {
        SignalHelper.connectString(self, signal: .emojiPicked, handler: handler)
    }
}
