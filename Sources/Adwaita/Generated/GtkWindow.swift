// Auto-generated intermediate GTK class wrapper
import CAdwaita
import GObjectSupport

/// Minimal wrapper for GtkWindow.
@MainActor
open class GtkWindow: Widget {

    /// Connects to the `close-request` signal.
    /// Return `true` from the handler to prevent the window from closing.
    @discardableResult
    public func onCloseRequest(_ handler: @escaping @MainActor () -> Bool) -> SignalConnection {
        SignalHelper.connectReturnBool(self, signal: "close-request", handler: handler)
    }
}
