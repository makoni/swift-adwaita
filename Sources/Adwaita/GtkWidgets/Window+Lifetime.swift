// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

public extension GtkWindow {
    /// Tears the window down immediately, without asking it to close.
    ///
    /// ``close()`` is a *request*: it is what a title-bar ✕ does, it can be
    /// vetoed by a `close-request` handler, and on a window that was never
    /// presented it may do nothing at all. ``destroy()`` is the real teardown —
    /// it unparents the content, drops the window's own reference, and removes
    /// it from the list GTK keeps of live toplevels.
    ///
    /// That last part is why this exists. GTK walks its toplevel list whenever
    /// something process-wide changes — the reading direction
    /// (``defaultTextDirection``), the theme, the inspector. A window released
    /// by dropping its Swift wrapper is not guaranteed to have left that list
    /// by the time it is finalized, and a stale entry turns the next such walk
    /// into a crash. Destroying a window you are done with keeps the list
    /// honest.
    ///
    /// ```swift
    /// let window = ApplicationWindow(application: app)
    /// // ... use it
    /// window.destroy()
    /// ```
    ///
    /// Use ``close()`` for anything a user initiates, so `close-request`
    /// handlers still get their say.
    func destroy() {
        gtk_window_destroy(castedPointer())
    }
}
