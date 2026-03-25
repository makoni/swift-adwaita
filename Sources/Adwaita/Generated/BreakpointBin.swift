// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport
/// A container that applies layout changes based on size breakpoint conditions.
///
/// Wraps `AdwBreakpointBin`. Acts as a container for a single child widget and
/// a set of ``Breakpoint`` objects. Each breakpoint defines a size condition
/// (e.g. minimum width of 600px) and a set of property changes to apply when
/// that condition is met. This is the foundation of responsive layouts in
/// libadwaita -- ``ApplicationWindow`` itself is a subclass of `BreakpointBin`.
///
/// ```swift
/// let bin = BreakpointBin()
/// bin.child = contentBox
///
/// // Create a breakpoint that triggers at 600px width
/// let breakpoint = Breakpoint()
/// breakpoint.addCondition(
///     BreakpointCondition.parse("min-width: 600px")
/// )
///
/// // Add property setters that apply when the condition is met
/// breakpoint.addSetter(splitView, property: "collapsed", value: false)
///
/// bin.addBreakpoint(breakpoint)
///
/// // Query the active breakpoint
/// if let active = bin.currentBreakpoint {
///     print("A breakpoint is currently active")
/// }
/// ```
///
/// Key properties:
/// - ``child``: The content widget inside the bin.
/// - ``currentBreakpoint``: The currently active ``Breakpoint``, if any (read-only).
///
/// Key methods:
/// - ``addBreakpoint(_:)``: Register a breakpoint with the bin.
/// - ``removeBreakpoint(_:)``: Remove a previously added breakpoint.
///
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

    /// The content widget inside the breakpoint bin.
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
