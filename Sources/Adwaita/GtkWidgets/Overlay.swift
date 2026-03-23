import CAdwaita
import GObjectSupport

/// A container that stacks children on top of each other.
///
/// Wraps `GtkOverlay`. One child is the main content; additional
/// children are overlaid on top using alignment properties.
@MainActor
public final class Overlay: Widget {
    /// Creates a new overlay.
    public init() {
        let ptr = gtk_overlay_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The main child widget.
    public var child: Widget? {
        get {
            guard let ptr = gtk_overlay_get_child(opaquePointer) else { return nil }
            return Widget(borrowing: UnsafeMutableRawPointer(ptr))
        }
        set { gtk_overlay_set_child(opaquePointer, newValue?.widgetPointer) }
    }

    /// Adds an overlay widget.
    public func addOverlay(_ widget: Widget) {
        gtk_overlay_add_overlay(opaquePointer, widget.widgetPointer)
    }

    /// Removes an overlay widget.
    public func removeOverlay(_ widget: Widget) {
        gtk_overlay_remove_overlay(opaquePointer, widget.widgetPointer)
    }

    /// Sets whether an overlay widget should be clipped to the main child's allocation.
    public func setClipOverlay(_ widget: Widget, clip: Bool) {
        gtk_overlay_set_clip_overlay(opaquePointer, widget.widgetPointer, clip ? 1 : 0)
    }

    /// Returns whether an overlay widget is clipped.
    public func getClipOverlay(_ widget: Widget) -> Bool {
        gtk_overlay_get_clip_overlay(opaquePointer, widget.widgetPointer) != 0
    }

    /// Sets whether an overlay widget is included in the measurement of the main child.
    public func setMeasureOverlay(_ widget: Widget, measure: Bool) {
        gtk_overlay_set_measure_overlay(opaquePointer, widget.widgetPointer, measure ? 1 : 0)
    }

    /// Returns whether an overlay widget is measured.
    public func getMeasureOverlay(_ widget: Widget) -> Bool {
        gtk_overlay_get_measure_overlay(opaquePointer, widget.widgetPointer) != 0
    }
}
