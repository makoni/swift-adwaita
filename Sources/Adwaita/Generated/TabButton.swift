// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A button that displays the current tab count for a ``TabView``.
///
/// Wraps `AdwTabButton`. Typically used in a header bar to show how many tabs
/// are open and to open a ``TabOverview`` when clicked. The button
/// automatically updates its label to reflect ``TabView/nPages``.
///
/// ```swift
/// let tabView = TabView()
/// let tabButton = TabButton()
/// tabButton.view = tabView
///
/// // Open the tab overview when clicked
/// let tabOverview = TabOverview()
/// tabOverview.view = tabView
/// tabButton.onClicked {
///     tabOverview.open = true
/// }
///
/// // Place in a header bar
/// headerBar.packEnd(tabButton)
/// ```
///
/// Key properties:
/// - ``view``: The ``TabView`` whose page count is displayed.
///
/// Key signals:
/// - ``onClicked(_:)``: Emitted when the button is clicked.
/// - ``onActivate(_:)``: Emitted on keyboard activation.
///
/// - Since: libadwaita 1.3
@MainActor
public final class TabButton: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `TabButton`.
    public init() {
        let ptr = adw_tab_button_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The ``TabView`` whose open tab count is displayed on this button.
    /// - Since: libadwaita 1.3
    public var view: TabView? {
        get { (adw_tab_button_get_view(opaquePointer)).map { TabView(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_tab_button_set_view(opaquePointer, newValue?.opaquePointer) }
    }

    /// Connects to the `activate` signal.
    @discardableResult
    public func onActivate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .activate, handler: handler)
    }

    /// Connects to the `clicked` signal.
    @discardableResult
    public func onClicked(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .clicked, handler: handler)
    }
}
