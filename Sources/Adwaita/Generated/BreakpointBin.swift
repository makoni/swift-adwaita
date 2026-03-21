// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A widget that changes layout based on available size.
/// - Since: libadwaita 1.4
@MainActor
open class BreakpointBin: Widget {

    /// Internal raw-pointer initializer.
    override internal init(raw pointer: UnsafeMutableRawPointer) {
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
    public var currentBreakpoint: OpaquePointer? {
        adw_breakpoint_bin_get_current_breakpoint(castedPointer() as UnsafeMutablePointer<AdwBreakpointBin>)
    }

    /// Calls `adw_breakpoint_bin_add_breakpoint`.
    public func addBreakpoint(_ breakpoint: OpaquePointer) {
        adw_breakpoint_bin_add_breakpoint(castedPointer() as UnsafeMutablePointer<AdwBreakpointBin>, breakpoint)
    }

    /// Calls `adw_breakpoint_bin_remove_breakpoint`.
    public func removeBreakpoint(_ breakpoint: OpaquePointer) {
        adw_breakpoint_bin_remove_breakpoint(castedPointer() as UnsafeMutablePointer<AdwBreakpointBin>, breakpoint)
    }
}
