// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget that changes layout based on available size.
/// - Since: libadwaita 1.4
@MainActor
public class BreakpointBin: Widget {

    /// Internal raw-pointer initializer.
    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `BreakpointBin`.
    public init() {
        let ptr = adw_breakpoint_bin_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The `child` property.
    /// - Since: libadwaita 1.4
    public var child: Widget? {
        get { (adw_breakpoint_bin_get_child(castedPointer() as UnsafeMutablePointer<AdwBreakpointBin>)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) } }
        set { adw_breakpoint_bin_set_child(castedPointer() as UnsafeMutablePointer<AdwBreakpointBin>, newValue?.widgetPointer) }
    }

    /// The `current-breakpoint` property (read-only).
    /// - Since: libadwaita 1.4
    public var currentBreakpoint: Breakpoint? {
        (adw_breakpoint_bin_get_current_breakpoint(castedPointer() as UnsafeMutablePointer<AdwBreakpointBin>)).map { Breakpoint(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Adds a breakpoint (transfer-full: adds a ref before passing).
    public func addBreakpoint(_ breakpoint: Breakpoint) {
        g_object_ref(breakpoint.pointer)
        adw_breakpoint_bin_add_breakpoint(castedPointer() as UnsafeMutablePointer<AdwBreakpointBin>, breakpoint.opaquePointer)
    }

    /// Removes a breakpoint.
    public func removeBreakpoint(_ breakpoint: Breakpoint) {
        adw_breakpoint_bin_remove_breakpoint(castedPointer() as UnsafeMutablePointer<AdwBreakpointBin>, breakpoint.opaquePointer)
    }
}
