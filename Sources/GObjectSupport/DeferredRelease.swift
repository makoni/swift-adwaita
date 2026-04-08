import CAdwaita

/// Schedules the release of a retained closure box on the next GLib main loop iteration.
///
/// This **must** use `g_idle_add` rather than `Task { @MainActor }` because
/// GTK applications run GLib's event loop, not Swift's dispatch main queue.
/// A `Task { @MainActor }` would schedule work on `DispatchQueue.main` which
/// is never drained inside `g_application_run`, causing the release to never
/// execute and the closure box to leak.
public func scheduleDeferredBoxRelease(_ userData: UnsafeMutableRawPointer?) {
    guard let userData else { return }
    g_idle_add_full(
        G_PRIORITY_DEFAULT_IDLE,
        { pointer -> gboolean in
            guard let pointer else { return 0 }
            Unmanaged<AnyObject>.fromOpaque(pointer).release()
            return 0
        },
        userData,
        nil
    )
}

public func deferredBoxDestroyNotify(_ userData: UnsafeMutableRawPointer?, _: UnsafeMutableRawPointer?) {
    scheduleDeferredBoxRelease(userData)
}
