import CAdwaita
import GObjectSupport

/// A push button widget that emits a signal when clicked.
///
/// `Button` is the most common interactive widget in GTK. It can display
/// a text label, an icon, or a custom child widget. Connect to the
/// `clicked` signal to respond to user interaction.
///
/// Wraps [GtkButton](https://docs.gtk.org/gtk4/class.Button.html).
///
/// ## Examples
///
/// A labeled button with a click handler:
/// ```swift
/// let button = Button(label: "Save") {
///     print("File saved!")
/// }
/// ```
///
/// An icon button without a frame (toolbar style):
/// ```swift
/// let iconButton = Button(icon: .editDelete)
/// iconButton.hasFrame = false
/// iconButton.onClicked {
///     print("Delete pressed")
/// }
/// ```
///
/// A button with a custom child widget:
/// ```swift
/// let button = Button()
/// let box = Box(orientation: .horizontal, spacing: 6)
/// box.append(Image(icon: .documentOpen))
/// box.append(Label("Open File"))
/// button.child = box
/// ```
@MainActor
public final class Button: Widget {
    override public class var gtkType: GType {
        gtk_button_get_type()
    }

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

    /// Creates a button from a type-safe icon name.
    public convenience init(icon: IconName) {
        self.init(iconName: icon.name)
    }

    /// Creates a button with a label and a click handler.
    public convenience init(label: String, onClicked handler: @escaping @MainActor () -> Void) {
        self.init(label: label)
        onClicked(handler)
    }

    /// Creates a button with an icon and a click handler.
    public convenience init(iconName: String, onClicked handler: @escaping @MainActor () -> Void) {
        self.init(iconName: iconName)
        onClicked(handler)
    }

    /// Creates a button with a type-safe icon and a click handler.
    public convenience init(icon: IconName, onClicked handler: @escaping @MainActor () -> Void) {
        self.init(iconName: icon.name)
        onClicked(handler)
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The button's text label, or `nil` if the button has no label.
    ///
    /// Setting this replaces any existing child widget with a text label.
    public var label: String? {
        get {
            guard let cStr = gtk_button_get_label(castedPointer()) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_button_set_label(castedPointer(), newValue) }
    }

    /// The icon name displayed by the button, or `nil` if no icon is set.
    ///
    /// Setting this replaces any existing child widget with an icon.
    /// Use standard icon names from the
    /// [Icon Naming Specification](https://specifications.freedesktop.org/icon-naming-spec/latest/).
    public var iconName: String? {
        get {
            guard let cStr = gtk_button_get_icon_name(castedPointer()) else { return nil }
            return String(cString: cStr)
        }
        set { gtk_button_set_icon_name(castedPointer(), newValue) }
    }

    /// The child widget displayed inside the button.
    ///
    /// Set a custom widget (e.g., a `Box` containing an icon and label)
    /// to create buttons with complex content. Setting `label` or `iconName`
    /// replaces this child.
    public var child: Widget? {
        get {
            guard let ptr = gtk_button_get_child(castedPointer()) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_button_set_child(castedPointer(), newValue?.widgetPointer) }
    }

    /// Whether the button has a visible frame/border.
    ///
    /// Set to `false` for flat, frameless buttons typically used in toolbars
    /// or as icon-only actions. Add the `.flat` CSS class for the same effect.
    public var hasFrame: Bool {
        get { gtk_button_get_has_frame(castedPointer()) != 0 }
        set { gtk_button_set_has_frame(castedPointer(), newValue ? 1 : 0) }
    }

    /// Connects a handler to the `clicked` signal, fired when the user
    /// clicks the button or activates it via keyboard.
    ///
    /// - Parameter handler: The closure to run when the button is clicked.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onClicked(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .clicked, handler: handler)
    }

    /// Programmatically emits the `clicked` signal as if the user clicked the button.
    ///
    /// Useful for driving UI from keyboard shortcuts, debug helpers, or tests.
    public func emitClicked() {
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(opaquePointer), "clicked")
    }
}
