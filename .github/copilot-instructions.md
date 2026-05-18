# Copilot Instructions for `swift-adwaita`

## Build, test, and documentation commands

- Install system dependencies first:
  - Ubuntu/Debian: `sudo apt install libadwaita-1-dev libgtksourceview-5-dev xvfb`
  - Fedora: `sudo dnf install libadwaita-devel gtksourceview5-devel xorg-x11-server-Xvfb`
- Build the package: `swift build`
- Run the full test suite in a virtual display: `xvfb-run swift test` (CI uses `--no-parallel` because tests share GTK/libadwaita state)
- Run one Swift Testing test by suite and test name: `xvfb-run swift test --filter 'WidgetBaseTests/widgetTooltipText'`
- Run the demo gallery: `swift run DemoApp`
- Lint formatting the same way CI does: `swiftformat --lint Sources/ Tests/`
- Generate API docs for the library target: `swift package generate-documentation --target Adwaita --disable-indexing`
- Generate the repository HTML and Markdown docs bundle: `./buildDocs.sh`

## High-level architecture

This package is organized as a layered stack:

- `Sources/CAdwaita` is the system-library bridge to `libadwaita-1`. It contains `shim.h`, which provides compatibility stubs for APIs that may be missing on older libadwaita versions.
- `Sources/CGtkSource` is the system-library bridge to `gtksourceview-5`, used by `GtkWidgets/SourceView.swift` for the syntax-highlighted source editor wrapper.
- `Sources/GObjectSupport` is the runtime layer shared by all wrappers. `GObjectRef` owns and sinks floating GObject references so Swift ARC manages GTK/libadwaita objects correctly, while `SignalHelper` provides typed signal connections and delays closure release until the next main-loop iteration to avoid dispose-time crashes.
- `Sources/Adwaita` is the public wrapper layer (depends on `GObjectSupport` and `CGtkSource`). `Widget` is the base for visual types, `Widget+FluentSetters.swift` adds method-chaining helpers, `Generated/` contains generated libadwaita wrappers, and `GtkWidgets/` contains hand-written GTK wrappers and higher-level convenience APIs.

The executable demo app in `Sources/DemoApp` is more than a sample: it is the integration map for the library. `DemoExample` defines the protocol for examples, `allExamples` is the manual registry, and `main.swift` builds the searchable gallery by splitting examples into composite layouts and individual widgets.

The test suite in `Tests/AdwaitaTests` uses Swift Testing rather than XCTest. Most widget tests call `ensureAdwInit()` before creating widgets, and suites are serialized because they exercise GTK/libadwaita on the main actor.

## Key conventions

- Keep the API imperative. This repository explicitly avoids SwiftUI-style DSLs and result builders; widgets are created and configured directly.
- Mark GTK/libadwaita-facing types and callbacks with `@MainActor`. Core wrappers like `GObjectRef`, `Widget`, widget classes, and test entry points follow that rule.
- Prefer type-safe wrappers over raw strings. Use `SignalName`, `PropertyName`, `CSSClass`, and `IconName` instead of embedding GTK/libadwaita string constants when an enum exists.
- Wrapper types usually subclass `Widget` for visual elements or `GObjectRef` for non-widget GObjects, and most public concrete wrappers are `final`.
- Fluent configuration methods should return `Self` and usually live in extension-style helpers, matching patterns like `.halign(...)`, `.cssClass(...)`, and `.margins(...)`.
- Signals should be exposed through typed convenience methods such as `onClicked` that delegate to `SignalHelper`, returning `SignalConnection` when the caller may need to disconnect later.
- For libadwaita features introduced after the minimum supported version, gate usage with `AdwaitaVersion.isAtLeast(...)`. Newer generated wrappers may use failable initializers or `isAvailable` to preserve runtime compatibility, and matching C shims belong in `Sources/CAdwaita/shim.h`.
- When adding a demo example, implement `DemoExample` in `Sources/DemoApp/Examples/...` and register it in the `allExamples` array; the demo UI is driven from that central registry.
- Tests use Swift Testing syntax: `@Suite(.serialized)`, `@Test`, and `#expect(...)`, not XCTest assertions.
- Formatting in CI is enforced with the repository’s `.swiftformat` settings: 4-space indentation, 120-column width, and alphabetized import grouping without auto-sorting imports semantically.
- The package targets `swift-tools-version: 6.2` and CI runs the build/test matrix on Swift 6.2 and 6.3 (the local toolchain pinned in `.swift-version` is 6.3.2); keep changes compatible with both.
