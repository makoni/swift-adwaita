// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

private let dialogBackdropDismissHelperKey = "swift-adwaita-dialog-backdrop-dismiss-helper"

@MainActor
private final class DialogBackdropDismissHelper {
    private let dialogPointer: UnsafeMutablePointer<AdwDialog>
    private var installedBackdrop: Widget?
    private var maxRetries: Int
    private var remainingRetries: Int
    private var isEnabled = false
    private var installedController: GestureClick?
    private var retryScheduled = false
    private var pendingRetrySourceID: SourceID?
    private var presentationEpoch = 0
    private var didReportRetryExhaustion = false

    init(dialog: Dialog, maxRetries: Int) {
        dialogPointer = dialog.castedPointer()
        self.maxRetries = maxRetries
        remainingRetries = maxRetries
    }

    var isInstalled: Bool {
        installedController != nil
    }

    #if DEBUG
    var debugState: (remainingRetries: Int, retryScheduled: Bool, isEnabled: Bool) {
        (remainingRetries, retryScheduled, isEnabled)
    }

    var debugHasPendingRetrySource: Bool {
        pendingRetrySourceID != nil
    }
    #endif

    func start() {
        let dialog = Dialog(borrowing: UnsafeMutableRawPointer(dialogPointer))
        dialog.onMap { [weak self] in
            self?.beginPresentationIfNeeded()
        }

        dialog.onUnmap { [weak self] in
            self?.endPresentation()
        }
    }

    func simulateBackdropClick() {
        guard let installedController else { return }
        swiftadw_gesture_click_emit_released(
            installedController.opaquePointer,
            1,
            0,
            0
        )
    }

    func arm(maxRetries: Int) {
        self.maxRetries = maxRetries
        isEnabled = true
        resetForNewPresentation()

        guard
            gtk_widget_get_root(dialogWidgetPointer) != nil,
            gtk_widget_get_mapped(dialogWidgetPointer) != 0 else {
            return
        }

        attemptInstall(for: presentationEpoch)
    }

    private func beginPresentationIfNeeded() {
        guard isEnabled else { return }
        resetForNewPresentation()
        attemptInstall(for: presentationEpoch)
    }

    private func endPresentation() {
        guard isEnabled else { return }
        resetForNewPresentation()
    }

    private func resetForNewPresentation() {
        presentationEpoch += 1
        remainingRetries = maxRetries
        retryScheduled = false
        didReportRetryExhaustion = false
        // Cancel any retry idle that was scheduled for the previous
        // presentation. Without this, the epoch-guarded no-op callback still
        // runs and counts as "pending work" inside g_main_context, which
        // leaks into subsequent tests' MainContext.drainPending() measurements
        // and breaks suite isolation.
        if let pendingRetrySourceID {
            MainContext.cancel(sourceId: pendingRetrySourceID)
            self.pendingRetrySourceID = nil
        }
        removeInstalledGesture()
    }

    private func attemptInstall(for epoch: Int) {
        guard
            epoch == presentationEpoch,
            installedController == nil,
            gtk_widget_get_mapped(dialogWidgetPointer) != 0 else {
            return
        }

        let dialog = Widget(borrowing: UnsafeMutableRawPointer(dialogWidgetPointer))
        if let backdrop = dialog.root.flatMap(findBackdrop(in:)) {
            installDismissGesture(on: backdrop)
            return
        }

        guard !retryScheduled else { return }
        guard remainingRetries > 0 else {
            reportRetryExhaustionIfNeeded()
            return
        }
        retryScheduled = true
        remainingRetries -= 1
        pendingRetrySourceID = MainContext.idle { [weak self] in
            guard let self else { return }
            pendingRetrySourceID = nil
            guard epoch == presentationEpoch else { return }
            retryScheduled = false
            attemptInstall(for: epoch)
        }
    }

    private var dialogWidgetPointer: UnsafeMutablePointer<GtkWidget> {
        UnsafeMutableRawPointer(dialogPointer).assumingMemoryBound(to: GtkWidget.self)
    }

    private func installDismissGesture(on backdrop: Widget) {
        removeInstalledGesture()

        let click = GestureClick()
        click.button = 1
        click.onReleased { [weak self] _, _, _ in
            self?.dismissDialog()
        }
        backdrop.addController(click)
        installedBackdrop = backdrop
        installedController = click
    }

    private func dismissDialog() {
        let dialogObject = UnsafeMutableRawPointer(dialogPointer).assumingMemoryBound(to: GObject.self)
        g_object_ref(dialogObject)
        MainContext.idle { [dialogPointer, dialogObject] in
            defer { g_object_unref(dialogObject) }
            _ = adw_dialog_close(dialogPointer)
        }
    }

    private func removeInstalledGesture() {
        guard let installedBackdrop, let installedController else { return }
        installedBackdrop.removeController(installedController)
        self.installedBackdrop = nil
        self.installedController = nil
    }

    private func reportRetryExhaustionIfNeeded() {
        guard !didReportRetryExhaustion else { return }
        didReportRetryExhaustion = true
        #if DEBUG
        let message = "swift-adwaita: Dialog.enableBackdropClickDismiss() exhausted retries without finding the internal floating backdrop widget"
        "MESSAGE".withCString { key in
            message.withCString { value in
                var field = GLogField(key: key, value: UnsafeRawPointer(value), length: -1)
                g_log_structured_array(GLogLevelFlags(rawValue: 1 << 4), &field, 1)
            }
        }
        #endif
    }

    private func findBackdrop(in root: Widget) -> Widget? {
        if isBackdrop(root) {
            return root
        }
        for child in root.children() {
            if let backdrop = findBackdrop(in: child) {
                return backdrop
            }
        }
        return nil
    }

    private func isBackdrop(_ widget: Widget) -> Bool {
        widget.cssName == "dimming" && typeName(of: widget) == "GtkWindowHandle"
    }

    private func typeName(of widget: Widget) -> String {
        g_type_name_from_instance(UnsafeMutableRawPointer(widget.widgetPointer)
            .assumingMemoryBound(to: GTypeInstance.self))
            .map { String(cString: $0) } ?? "GtkWidget"
    }
}

public extension Dialog {
    /// Enables dismissing this dialog by clicking its dimmed backdrop.
    ///
    /// `AdwDialog` does not currently route backdrop clicks through
    /// `close()` for floating presentations. This helper installs an
    /// explicit click handler on the internal backdrop widget after the
    /// dialog enters the widget tree.
    ///
    /// Call this after `present(_:)`. If the backdrop is not immediately
    /// available, the helper retries on the GLib main loop up to
    /// `maxRetries` times and then gives up silently.
    ///
    /// - Parameter maxRetries: Maximum number of idle-turn retries while
    ///   waiting for the internal backdrop widget to appear. Must be
    ///   non-negative. Defaults to 5.
    func enableBackdropClickDismiss(maxRetries: Int = 5) {
        precondition(maxRetries >= 0, "maxRetries must be non-negative")
        guard AdwaitaVersion.isAtLeast(1, 5) else { return }
        let helper: DialogBackdropDismissHelper

        if let pointer = g_object_get_data(gobjectPointer, dialogBackdropDismissHelperKey) {
            helper = Unmanaged<DialogBackdropDismissHelper>.fromOpaque(pointer).takeUnretainedValue()
        } else {
            helper = DialogBackdropDismissHelper(dialog: self, maxRetries: maxRetries)
            let helperPointer = Unmanaged.passRetained(helper).toOpaque()
            // Tie the helper to the underlying AdwDialog GObject so it survives
            // Swift wrapper churn and releases when the C dialog is finalized.
            g_object_set_data_full(gobjectPointer, dialogBackdropDismissHelperKey, helperPointer) { data in
                guard let data else { return }
                Unmanaged<DialogBackdropDismissHelper>.fromOpaque(data).release()
            }
            helper.start()
        }

        helper.arm(maxRetries: maxRetries)
    }
}

#if DEBUG
public extension Dialog {
    var debugHasBackdropClickDismissHook: Bool {
        guard let pointer = g_object_get_data(gobjectPointer, dialogBackdropDismissHelperKey) else { return false }
        let helper = Unmanaged<DialogBackdropDismissHelper>.fromOpaque(pointer).takeUnretainedValue()
        return helper.isInstalled
    }

    var debugBackdropClickDismissState: (
        isInstalled: Bool,
        remainingRetries: Int,
        retryScheduled: Bool,
        isEnabled: Bool
    )? {
        guard let pointer = g_object_get_data(gobjectPointer, dialogBackdropDismissHelperKey) else { return nil }
        let helper = Unmanaged<DialogBackdropDismissHelper>.fromOpaque(pointer).takeUnretainedValue()
        let state = helper.debugState
        return (helper.isInstalled, state.remainingRetries, state.retryScheduled, state.isEnabled)
    }

    func debugEmitBackdropClickDismiss() {
        guard let pointer = g_object_get_data(gobjectPointer, dialogBackdropDismissHelperKey) else { return }
        let helper = Unmanaged<DialogBackdropDismissHelper>.fromOpaque(pointer).takeUnretainedValue()
        helper.simulateBackdropClick()
    }

    var debugBackdropClickDismissHasPendingRetrySource: Bool {
        guard let pointer = g_object_get_data(gobjectPointer, dialogBackdropDismissHelperKey) else { return false }
        let helper = Unmanaged<DialogBackdropDismissHelper>.fromOpaque(pointer).takeUnretainedValue()
        return helper.debugHasPendingRetrySource
    }
}
#endif
