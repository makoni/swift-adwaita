// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CWebKit
import CAdwaita
import GObjectSupport
import Adwaita

/// A web view backed by WebKitGTK 6.0.
///
/// Wraps `WebKitWebView` (the GTK 4 / `webkitgtk-6.0` flavour). Useful
/// for in-app preview panes, embedded help, or any HTML rendering that a
/// `Label` with markup can't carry.
///
/// ```swift
/// let preview = WebView()
/// preview.loadURI("https://example.com")
///
/// // …or render an HTML string with a base URI for relative links.
/// preview.loadHTML("<h1>Hello</h1>", baseURI: nil)
/// ```
///
/// The wrapper exposes the most common operations (load, reload, back /
/// forward, stop). For features that aren't surfaced here, reach for the
/// raw pointer via `castedPointer()` and the upstream WebKitGTK API.
@MainActor
public final class WebView: Widget {
    override public class var gtkType: GType {
        webkit_web_view_get_type()
    }

    /// Creates a new web view with the default web context.
    public init() {
        let ptr = webkit_web_view_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    private var webViewPointer: UnsafeMutablePointer<WebKitWebView> {
        castedPointer()
    }

    /// Begins loading the given URI. Pass an absolute URL (e.g.
    /// `https://example.com` or `file:///path`).
    public func loadURI(_ uri: String) {
        webkit_web_view_load_uri(webViewPointer, uri)
    }

    /// Renders an HTML string. `baseURI` is used to resolve relative
    /// references inside the document (CSS, images, links); pass `nil`
    /// for a fully self-contained snippet.
    public func loadHTML(_ html: String, baseURI: String? = nil) {
        webkit_web_view_load_html(webViewPointer, html, baseURI)
    }

    /// Reloads the current page from the network (or cache if no
    /// network connectivity is available).
    public func reload() {
        webkit_web_view_reload(webViewPointer)
    }

    /// Reloads the current page bypassing the local cache.
    public func reloadBypassCache() {
        webkit_web_view_reload_bypass_cache(webViewPointer)
    }

    /// Stops the in-progress load (no-op if nothing is loading).
    public func stopLoading() {
        webkit_web_view_stop_loading(webViewPointer)
    }

    /// Navigates one entry back in the session history (if possible).
    public func goBack() {
        webkit_web_view_go_back(webViewPointer)
    }

    /// Navigates one entry forward in the session history (if possible).
    public func goForward() {
        webkit_web_view_go_forward(webViewPointer)
    }

    /// Whether the session history can go back from the current page.
    public var canGoBack: Bool {
        webkit_web_view_can_go_back(webViewPointer) != 0
    }

    /// Whether the session history can advance forward.
    public var canGoForward: Bool {
        webkit_web_view_can_go_forward(webViewPointer) != 0
    }

    /// The currently-displayed URI, or `nil` if nothing has been loaded
    /// yet.
    public var uri: String? {
        guard let raw = webkit_web_view_get_uri(webViewPointer) else { return nil }
        return String(cString: raw)
    }

    /// The page title reported by `<title>`. May be `nil` for blank
    /// pages or HTML strings without a title element.
    public var title: String? {
        guard let raw = webkit_web_view_get_title(webViewPointer) else { return nil }
        return String(cString: raw)
    }

    /// Whether the view is currently fetching / rendering a page.
    public var isLoading: Bool {
        webkit_web_view_is_loading(webViewPointer) != 0
    }

    /// Fraction (0…1) of the current load that has completed.
    public var estimatedLoadProgress: Double {
        webkit_web_view_get_estimated_load_progress(webViewPointer)
    }

    /// Phases of a WebKit page load. Mirrors `WebKitLoadEvent` from
    /// `webkit/webkit.h`.
    public enum LoadEvent: UInt32, Sendable {
        case started = 0
        case redirected = 1
        case committed = 2
        case finished = 3
    }

    /// Observer fired when the load state changes (`started`,
    /// `redirected`, `committed`, `finished`). For most apps the
    /// `finished` and `started` cases are the ones worth handling.
    @discardableResult
    public func onLoadChanged(_ handler: @escaping @MainActor (LoadEvent) -> Void) -> SignalConnection {
        SignalHelper.connectUInt(self, signal: .loadChanged) { value in
            handler(LoadEvent(rawValue: value) ?? .started)
        }
    }
}
