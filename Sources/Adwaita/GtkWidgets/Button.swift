import CAdwaita
import GObjectSupport

/// A button widget that emits a signal when clicked.
///
/// Wraps `GtkButton`.
@MainActor
public final class Button: Widget {
    /// Creates a new empty button.
    public init() {
        let ptr = gtk_button_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a button with a text label.
    public init(label: String) {
        let ptr = gtk_button_new_with_label(label)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a button from an icon name.
    public init(iconName: String) {
        let ptr = gtk_button_new_from_icon_name(iconName)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a button with a label and a click handler.
    public convenience init(label: String, onClicked handler: @escaping @MainActor () -> Void) {
        self.init(label: label)
        self.onClicked(handler)
    }

    /// Creates a button with an icon and a click handler.
    public convenience init(iconName: String, onClicked handler: @escaping @MainActor () -> Void) {
        self.init(iconName: iconName)
        self.onClicked(handler)
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The button label.
    public var label: String? {
        get {
            guard let cStr = gtk_button_get_label(castedPointer()) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_button_set_label(castedPointer(), newValue) }
    }

    /// The icon name.
    public var iconName: String? {
        get {
            guard let cStr = gtk_button_get_icon_name(castedPointer()) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_button_set_icon_name(castedPointer(), newValue) }
    }

    /// The child widget.
    public var child: Widget? {
        get {
            guard let ptr = gtk_button_get_child(castedPointer()) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_button_set_child(castedPointer(), newValue?.widgetPointer) }
    }

    /// Whether the button has a frame.
    public var hasFrame: Bool {
        get { gtk_button_get_has_frame(castedPointer()) != 0 }
        set { gtk_button_set_has_frame(castedPointer(), newValue ? 1 : 0) }
    }

    /// Connects to the `clicked` signal.
    @discardableResult
    public func onClicked(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .clicked, handler: handler)
    }
}
