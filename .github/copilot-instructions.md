# Copilot Instructions for `swift-adwaita`

## Build, test, and documentation commands

- Install system dependencies first:
  - Ubuntu/Debian: `sudo apt install libadwaita-1-dev libgtksourceview-5-dev xvfb`
  - Fedora: `sudo dnf install libadwaita-devel gtksourceview5-devel xorg-x11-server-Xvfb`
- Build the package: `swift build`
- Run the full test suite in a virtual display: `xvfb-run swift test` (CI uses `--no-parallel` because tests share GTK/libadwaita state)
- Run one Swift Testing test by suite and test name: `xvfb-run swift test --filter 'WidgetBaseTests/widgetTooltipText'`
- Run the demo gallery: `swift run DemoApp`
- Lint formatting the same way CI does: `swift format lint --strict -r Sources/ Tests/`; to format in place, run `swift format format -i -r Sources/ Tests/`
- Generate API docs for the library target: `swift package generate-documentation --target Adwaita --disable-indexing`
- Generate the repository HTML and Markdown docs bundle: `./buildDocs.sh`

## High-level architecture

This package is organized as a layered stack:

- `Sources/CAdwaita` is the system-library bridge to `libadwaita-1`. It contains `shim.h`, which provides compatibility stubs for APIs that may be missing on older libadwaita versions.
- `Sources/CGtkSource` is the system-library bridge to `gtksourceview-5`, used by `GtkWidgets/SourceView.swift` for the syntax-highlighted source editor wrapper.
- `Sources/GObjectSupport` is the runtime layer shared by all wrappers. `GObjectRef` owns and sinks floating GObject references so Swift ARC manages GTK/libadwaita objects correctly, while `SignalHelper` provides typed signal connections and delays closure release until the next main-loop iteration to avoid dispose-time crashes.
- `Sources/Adwaita` is the public wrapper layer (depends on `GObjectSupport` and `CGtkSource`). `Widget` is the base for visual types, `Widget+FluentSetters.swift` adds method-chaining helpers, `Generated/` contains generated libadwaita wrappers, and `GtkWidgets/` contains hand-written GTK wrappers and higher-level convenience APIs.

The demo gallery is more than a sample: it is the integration map for the library, and it lives in the `DemoAppLib` library (`Sources/DemoAppLib`) — the `Sources/DemoApp/main.swift` executable is just a thin wrapper that calls `runDemoApp()`. The examples live in `Sources/DemoAppLib/Examples/`; the `DemoExample` protocol and the `allExamples` registry are defined in `Sources/DemoAppLib/DemoExample.swift`, and the searchable gallery is built by splitting that registry into composite layouts and individual widgets.

The test suite in `Tests/AdwaitaTests` covers the library: on Linux it runs under Swift Testing (the swift-testing files are gated `#if !os(macOS)`), and on macOS the same coverage runs as one-to-one XCTest mirrors in `Tests/AdwaitaTests/macOS/` (tests that spin the GLib main loop are Linux-only — see CONTRIBUTING.md). A second target, `Tests/DemoAppLibTests`, smoke-tests every example in `allExamples` plus interaction tests. Most widget tests call `ensureAdwInit()` before creating widgets, and suites are serialized because they exercise GTK/libadwaita on the main actor.

## Key conventions

- Keep the API imperative. This repository explicitly avoids SwiftUI-style DSLs and result builders; widgets are created and configured directly.
- Mark GTK/libadwaita-facing types and callbacks with `@MainActor`. Core wrappers like `GObjectRef`, `Widget`, widget classes, and test entry points follow that rule.
- Prefer type-safe wrappers over raw strings. Use `SignalName`, `PropertyName`, `CSSClass`, and `IconName` instead of embedding GTK/libadwaita string constants when an enum exists.
- Wrapper types usually subclass `Widget` for visual elements or `GObjectRef` for non-widget GObjects, and most public concrete wrappers are `final`.
- Fluent configuration methods should return `Self` and usually live in extension-style helpers, matching patterns like `.halign(...)`, `.cssClass(...)`, and `.margins(...)`.
- Signals are exposed through typed convenience methods such as `onClicked` that delegate to `SignalHelper`; every `onXxx` method is marked `@discardableResult` and returns a `SignalConnection` so the caller can disconnect later.
- For libadwaita features introduced after the minimum supported version, gate usage with `AdwaitaVersion.isAtLeast(...)`. Newer generated wrappers may use failable initializers or `isAvailable` to preserve runtime compatibility, and matching C shims belong in `Sources/CAdwaita/shim.h`.
- When adding a demo example, implement `DemoExample` in `Sources/DemoAppLib/Examples/...` and register it in the `allExamples` array (in `Sources/DemoAppLib/DemoExample.swift`); the demo UI is driven from that central registry.
- Linux tests use Swift Testing syntax (`@Suite(.serialized)`, `@Test`, `#expect(...)`), gated `#if !os(macOS)`; the macOS path is a one-to-one XCTest mirror in `Tests/AdwaitaTests/macOS/` (see CONTRIBUTING.md for the mapping and the GLib main-loop exceptions).
- Formatting in CI is enforced with the repository’s `.swift-format` configuration (the Swift toolchain’s `swift-format`): 4-space indentation, 120-column width, and alphabetized import grouping.
- The package targets `swift-tools-version: 6.3` and CI runs the build/test matrix on Swift 6.3 and 6.4 (the local toolchain pinned in `.swift-version` is 6.4.0); keep changes compatible with both.
