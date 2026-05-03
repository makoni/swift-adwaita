// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated intermediate GTK class wrapper
import CAdwaita
import GObjectSupport

/// Base class for layout managers that control how a widget arranges its children.
///
/// Wraps `GtkLayoutManager`. Subclasses such as ``ClampLayout`` and
/// ``WrapLayout`` implement specific layout strategies. You do not
/// typically instantiate this class directly.
///
/// ```swift
/// // Use a concrete subclass instead:
/// let wrap = WrapLayout()
/// wrap.childSpacing = 8
/// wrap.lineSpacing = 8
///
/// let clamp = ClampLayout()
/// clamp.maximumSize = 600
/// ```
///
@MainActor
public class LayoutManager: GObjectRef {}
