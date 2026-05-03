// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

// MARK: - Fluent Setters

public extension Widget {

    /// Sets the horizontal alignment and returns self for chaining.
    @discardableResult
    func halign(_ align: GtkAlign) -> Self {
        halign = align
        return self
    }

    /// Sets the vertical alignment and returns self for chaining.
    @discardableResult
    func valign(_ align: GtkAlign) -> Self {
        valign = align
        return self
    }

    /// Sets horizontal expansion and returns self for chaining.
    @discardableResult
    func hexpand(_ expand: Bool = true) -> Self {
        hexpand = expand
        return self
    }

    /// Sets vertical expansion and returns self for chaining.
    @discardableResult
    func vexpand(_ expand: Bool = true) -> Self {
        vexpand = expand
        return self
    }

    /// Sets margin on all sides and returns self for chaining.
    @discardableResult
    func margins(_ margin: Int) -> Self {
        setMargins(margin)
        return self
    }

    /// Sets sensitivity and returns self for chaining.
    @discardableResult
    func sensitive(_ sensitive: Bool) -> Self {
        self.sensitive = sensitive
        return self
    }

    /// Sets tooltip text and returns self for chaining.
    @discardableResult
    func tooltip(_ text: String) -> Self {
        tooltipText = text
        return self
    }

    /// Adds a CSS class and returns self for chaining.
    @discardableResult
    func cssClass(_ cssClass: String) -> Self {
        addCSSClass(cssClass)
        return self
    }

    /// Adds a type-safe CSS class and returns self for chaining.
    @discardableResult
    func cssClass(_ cssClass: CSSClass) -> Self {
        addCSSClass(cssClass)
        return self
    }

    /// Sets the size request and returns self for chaining.
    @discardableResult
    func sizeRequest(width: Int = -1, height: Int = -1) -> Self {
        setSizeRequest(width: width, height: height)
        return self
    }

    /// Sets visibility and returns self for chaining.
    @discardableResult
    func visible(_ visible: Bool) -> Self {
        self.visible = visible
        return self
    }

    /// Sets opacity and returns self for chaining.
    @discardableResult
    func opacity(_ opacity: Double) -> Self {
        self.opacity = opacity
        return self
    }

    /// Sets the start margin and returns self for chaining.
    @discardableResult
    func marginStart(_ margin: Int) -> Self {
        marginStart = margin
        return self
    }

    /// Sets the end margin and returns self for chaining.
    @discardableResult
    func marginEnd(_ margin: Int) -> Self {
        marginEnd = margin
        return self
    }

    /// Sets the top margin and returns self for chaining.
    @discardableResult
    func marginTop(_ margin: Int) -> Self {
        marginTop = margin
        return self
    }

    /// Sets the bottom margin and returns self for chaining.
    @discardableResult
    func marginBottom(_ margin: Int) -> Self {
        marginBottom = margin
        return self
    }
}
