import CAdwaita
import GObjectSupport

/// Represents a physical monitor connected to the system.
///
/// Wraps `GdkMonitor`. Obtain instances via ``Display/monitors``.
@MainActor
public final class Monitor: GObjectRef {

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The geometry of the monitor in logical coordinates.
    public var geometry: (x: Int, y: Int, width: Int, height: Int) {
        var rect = GdkRectangle()
        gdk_monitor_get_geometry(opaquePointer, &rect)
        return (Int(rect.x), Int(rect.y), Int(rect.width), Int(rect.height))
    }

    /// The physical width of the monitor in millimeters.
    public var widthMM: Int {
        Int(gdk_monitor_get_width_mm(opaquePointer))
    }

    /// The physical height of the monitor in millimeters.
    public var heightMM: Int {
        Int(gdk_monitor_get_height_mm(opaquePointer))
    }

    /// The integer scale factor of the monitor.
    public var scaleFactor: Int {
        Int(gdk_monitor_get_scale_factor(opaquePointer))
    }

    /// The refresh rate of the monitor in millihertz (e.g. 60000 = 60 Hz).
    public var refreshRate: Int {
        Int(gdk_monitor_get_refresh_rate(opaquePointer))
    }

    /// The manufacturer name, if available.
    public var manufacturer: String? {
        gdk_monitor_get_manufacturer(opaquePointer).map { String(cString: $0) }
    }

    /// The model name, if available.
    public var model: String? {
        gdk_monitor_get_model(opaquePointer).map { String(cString: $0) }
    }

    /// The connector name (e.g. "HDMI-1"), if available.
    public var connector: String? {
        gdk_monitor_get_connector(opaquePointer).map { String(cString: $0) }
    }

    /// Whether the monitor is still valid (connected).
    public var isValid: Bool {
        gdk_monitor_is_valid(opaquePointer) != 0
    }

    /// Connects to the `invalidate` signal — emitted when the monitor
    /// is disconnected or its properties change.
    @discardableResult
    public func onInvalidate(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: "invalidate", handler: handler)
    }
}
