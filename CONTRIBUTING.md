# Contributing to swift-adwaita

Thank you for your interest in contributing! This guide covers how to set up the project, run tests, and submit changes.

## Getting Started

### Prerequisites

- **Swift 6.2+** ([swiftly](https://swift-server.github.io/swiftly/) recommended for installing)
- **libadwaita 1.5+** development headers
- **Linux** (Ubuntu, Fedora, …) **or macOS 13+** (Apple Silicon recommended)

```bash
# Ubuntu/Debian
sudo apt install libadwaita-1-dev libgtksourceview-5-dev xvfb

# Fedora
sudo dnf install libadwaita-devel gtksourceview5-devel xorg-x11-server-Xvfb

# macOS (Homebrew)
brew install libadwaita gtksourceview5 pkgconf
```

### Building

```bash
swift build
```

### Running Tests

**Linux** — tests require a virtual display since they instantiate GTK widgets:

```bash
xvfb-run swift test --no-parallel
```

**macOS** — tests need the Homebrew GSettings schemas exposed via `XDG_DATA_DIRS`
(otherwise libadwaita aborts with `No GSettings schemas are installed`):

```bash
XDG_DATA_DIRS=/opt/homebrew/share swift test --no-parallel
```

(Intel Macs: `/usr/local/share`.)

### Running the Demo App

Linux: `swift run DemoApp`. macOS: `XDG_DATA_DIRS=/opt/homebrew/share swift run DemoApp`.

### Why two test harnesses

On Linux the suite runs under **swift-testing** (`@Test` / `#expect`).
On macOS the same coverage runs under **XCTest** mirrors in
`Tests/AdwaitaTests/macOS/`. swift-testing's per-test autorelease pool
transitions on Apple platforms corrupt memory after `gtk_init` registers
Cocoa CFRunLoop callbacks, so the swift-testing files are gated
`#if !os(macOS)` and the XCTest mirrors are gated `#if os(macOS)`.

When you add a new test, write it as a swift-testing case under
`Tests/AdwaitaTests/<Name>Tests.swift` first (the Linux path is
canonical), then add a one-to-one XCTest mirror under
`Tests/AdwaitaTests/macOS/<Name>XCTests.swift`. The conventions:

- `@Suite struct FooTests` ↔ `final class FooXCTests: XCTestCase`
- `@Test @MainActor func name()` ↔ `@MainActor func test_name()`
- `#expect(expr)` ↔ `XCTAssertTrue(expr)` (and `XCTAssertNil`/`XCTAssertNotNil` for nil checks)
- `try #require(x)` ↔ `try XCTUnwrap(x)`
- `#expect(throws:)` ↔ `XCTAssertThrowsError` (sync) or `do/catch` + `XCTFail` (async)
- `XCTestCase` shadows `NSObject.isSubclass(of:)`, so use the `isAdwSubclass` helper from `TestHelpers.swift` for type hierarchy checks.
- Tests that iterate the GLib main loop (`MainContext.task` / `pump` / `drainPending` / `spinMainLoop`) cannot run on macOS — they interleave with Cocoa CFRunLoop pool management and corrupt the pool. Keep them in the swift-testing file only and skip them in the XCTest mirror.

A working CI config for both is in `.github/workflows/ci.yml`.

## Project Structure

```
Sources/
  CAdwaita/          System library bridge (shim.h with version stubs)
  GObjectSupport/    GObject lifecycle, signals, GVariant, GValue
  Adwaita/
    Generated/       74 auto-generated Adwaita widget wrappers
    GtkWidgets/      Hand-written GTK widget wrappers
    Documentation.docc/  DocC tutorials and guides
  DemoApp/           Interactive demo gallery (76 examples)
Tests/
  AdwaitaTests/      Test suite (750+ tests)
```

## How to Contribute

### Bug Reports

Open an issue with:
- Swift version (`swift --version`)
- libadwaita version (`pkg-config --modversion libadwaita-1`)
- Operating system and version (Linux distribution / macOS release)
- Minimal reproduction code

### Adding a Widget Wrapper

1. Create a new file in `Sources/Adwaita/GtkWidgets/` (hand-written) or `Sources/Adwaita/Generated/` (if auto-generated)
2. Subclass `Widget` (for GTK/Adw widgets) or `GObjectRef` (for non-widget GObjects)
3. Add `@MainActor` and `public final class`
4. Expose properties as Swift get/set computed properties
5. Add signals using `SignalHelper.connect()` methods
6. Add a swift-testing test in `Tests/AdwaitaTests/<Name>Tests.swift` **and** an XCTest mirror in `Tests/AdwaitaTests/macOS/<Name>XCTests.swift` (see "Why two test harnesses" above)
7. Optionally add a demo example in `Sources/DemoApp/Examples/`

### Adding a Demo Example

1. Create a struct conforming to `DemoExample` in `Sources/DemoApp/Examples/Widgets/` or `Composite/`
2. Implement `name`, `id`, `category`, `sourceCode`, and `buildWidget()`
3. Register it in `allExamples` array in `Sources/DemoApp/DemoExample.swift`

### Version Compatibility

When wrapping APIs from newer libadwaita versions:

- **1.6+**: Use failable `init?()` with `guard AdwaitaVersion.isAtLeast(1, 6)`
- **1.7+/1.8+**: Same pattern with appropriate version
- Add C stubs in `Sources/CAdwaita/shim.h` under the appropriate `#if !ADW_CHECK_VERSION()` block
- For classes that override a non-failable parent init, use a fallback pattern with `static var isAvailable: Bool`

## Code Style

- **Imperative API** — no result builders, no declarative DSL, no SwiftUI patterns
- **@MainActor** on all widget classes
- **Fluent setters** return `Self` for chaining
- **Type-safe enums** (`CSSClass`, `IconName`, `SignalName`, `PropertyName`) over raw strings
- No docstrings on trivial property wrappers; document non-obvious behavior
- Tests use Swift Testing framework (`@Test`, `#expect`)

## Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests (both swift-testing and XCTest mirror, see above)
4. Ensure tests pass on at least one platform locally:
   - Linux: `xvfb-run swift test --no-parallel`
   - macOS: `XDG_DATA_DIRS=/opt/homebrew/share swift test --no-parallel`
5. Submit a pull request — CI will run the suite on Linux automatically.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
