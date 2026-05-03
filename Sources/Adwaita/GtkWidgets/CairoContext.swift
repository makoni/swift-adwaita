// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

/// A lightweight wrapper around a Cairo drawing context (`cairo_t`).
///
/// Provides Swift-friendly methods for common drawing operations.
/// Obtain an instance in the ``DrawingArea/setDrawFunc(_:)`` callback.
///
/// ```swift
/// drawingArea.setDrawFunc { cr, width, height in
///     cr.setSourceRGB(0.2, 0.6, 1.0)
///     cr.rectangle(x: 0, y: 0, width: Double(width), height: Double(height))
///     cr.fill()
/// }
/// ```
@MainActor
public struct CairoContext {
    /// The raw Cairo context pointer, for use with Cairo C functions.
    public let pointer: OpaquePointer

    init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    // MARK: - Path Operations

    /// Begins a new sub-path.
    public func newSubPath() {
        cairo_new_sub_path(pointer)
    }

    /// Moves the current point to the given coordinates.
    public func moveTo(x: Double, y: Double) {
        cairo_move_to(pointer, x, y)
    }

    /// Draws a line from the current point to the given coordinates.
    public func lineTo(x: Double, y: Double) {
        cairo_line_to(pointer, x, y)
    }

    /// Adds a circular arc to the path.
    public func arc(centerX: Double, centerY: Double, radius: Double, startAngle: Double, endAngle: Double) {
        cairo_arc(pointer, centerX, centerY, radius, startAngle, endAngle)
    }

    /// Adds a rectangle to the path.
    public func rectangle(x: Double, y: Double, width: Double, height: Double) {
        cairo_rectangle(pointer, x, y, width, height)
    }

    /// Closes the current sub-path.
    public func closePath() {
        cairo_close_path(pointer)
    }

    // MARK: - Drawing

    /// Sets the source color (RGB, 0.0–1.0).
    public func setSourceRGB(_ r: Double, _ g: Double, _ b: Double) {
        cairo_set_source_rgb(pointer, r, g, b)
    }

    /// Sets the source color with alpha (RGBA, 0.0–1.0).
    public func setSourceRGBA(_ r: Double, _ g: Double, _ b: Double, _ a: Double) {
        cairo_set_source_rgba(pointer, r, g, b, a)
    }

    /// Fills the current path and clears it.
    public func fill() {
        cairo_fill(pointer)
    }

    /// Fills the current path but preserves it for further operations.
    public func fillPreserve() {
        cairo_fill_preserve(pointer)
    }

    /// Strokes (outlines) the current path and clears it.
    public func stroke() {
        cairo_stroke(pointer)
    }

    /// Strokes the current path but preserves it for further operations.
    public func strokePreserve() {
        cairo_stroke_preserve(pointer)
    }

    /// Paints the entire surface with the current source.
    public func paint() {
        cairo_paint(pointer)
    }

    /// Paints the entire surface with the current source at the given alpha.
    public func paintWithAlpha(_ alpha: Double) {
        cairo_paint_with_alpha(pointer, alpha)
    }

    // MARK: - Line Properties

    /// Sets the line width for stroke operations.
    public func setLineWidth(_ width: Double) {
        cairo_set_line_width(pointer, width)
    }

    /// Sets the line cap style.
    public func setLineCap(_ cap: cairo_line_cap_t) {
        cairo_set_line_cap(pointer, cap)
    }

    /// Sets the line join style.
    public func setLineJoin(_ join: cairo_line_join_t) {
        cairo_set_line_join(pointer, join)
    }

    // MARK: - Transform

    /// Saves the current state (color, transform, etc.) to a stack.
    public func save() {
        cairo_save(pointer)
    }

    /// Restores the most recently saved state.
    public func restore() {
        cairo_restore(pointer)
    }

    /// Translates the coordinate system.
    public func translate(x: Double, y: Double) {
        cairo_translate(pointer, x, y)
    }

    /// Scales the coordinate system.
    public func scale(x: Double, y: Double) {
        cairo_scale(pointer, x, y)
    }

    /// Rotates the coordinate system by the given angle in radians.
    public func rotate(_ angle: Double) {
        cairo_rotate(pointer, angle)
    }

    // MARK: - Convenience: Rounded Rectangle

    /// Draws a rounded rectangle path.
    public func roundedRectangle(x: Double, y: Double, width: Double, height: Double, radius: Double) {
        newSubPath()
        arc(centerX: x + width - radius, centerY: y + radius, radius: radius, startAngle: -.pi / 2, endAngle: 0)
        arc(centerX: x + width - radius, centerY: y + height - radius, radius: radius, startAngle: 0, endAngle: .pi / 2)
        arc(centerX: x + radius, centerY: y + height - radius, radius: radius, startAngle: .pi / 2, endAngle: .pi)
        arc(centerX: x + radius, centerY: y + radius, radius: radius, startAngle: .pi, endAngle: 3 * .pi / 2)
        closePath()
    }
}
