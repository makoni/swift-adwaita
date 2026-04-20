import CAdwaita
import GObjectSupport

public extension SplitButton {
    /// Programmatically emits the `clicked` signal as if the user clicked
    /// the primary button area.
    func emitClicked() {
        g_signal_emit_by_name_no_args(UnsafeMutableRawPointer(opaquePointer), "clicked")
    }
}
