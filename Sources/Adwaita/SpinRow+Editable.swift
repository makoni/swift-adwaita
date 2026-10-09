// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// Reads the text of a `GtkEditable` (which `AdwSpinRow` is) from its instance
/// pointer. Kept as a free function so the `input` signal closure can read the
/// entry's text without capturing the `SpinRow` wrapper, which would keep the
/// wrapper alive forever.
func spinRowEditableText(_ ptr: OpaquePointer) -> String {
    String(cString: gtk_editable_get_text(ptr))
}
