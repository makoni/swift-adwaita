// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

extension Widget {
    /// Wraps this widget in a `Clamp` + `ScrolledWindow` for consistent demo layout.
    @MainActor
    func scrollableClamped(maxWidth: Int = 600) -> Widget {
        let clamp = Clamp()
        clamp.maximumSize = maxWidth
        clamp.child = self
        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
