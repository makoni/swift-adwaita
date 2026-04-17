# Contributing to swift-adwaita

Thank you for your interest in contributing! This guide covers how to set up the project, run tests, and submit changes.

## Getting Started

### Prerequisites

- **Swift 6.2+** ([swiftly](https://swift-server.github.io/swiftly/) recommended for installing)
- **libadwaita 1.5+** development headers
- **Linux** (Ubuntu, Fedora, or other GTK4-supported distro)

```bash
# Ubuntu/Debian
sudo apt install libadwaita-1-dev xvfb

# Fedora
sudo dnf install libadwaita-devel xorg-x11-server-Xvfb
```

### Building

```bash
swift build
```

### Running Tests

Tests require a virtual display since they instantiate GTK widgets:

```bash
xvfb-run swift test --no-parallel
```

### Running the Demo App

```bash
swift run DemoApp
```

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
- Linux distribution and version
- Minimal reproduction code

### Adding a Widget Wrapper

1. Create a new file in `Sources/Adwaita/GtkWidgets/` (hand-written) or `Sources/Adwaita/Generated/` (if auto-generated)
2. Subclass `Widget` (for GTK/Adw widgets) or `GObjectRef` (for non-widget GObjects)
3. Add `@MainActor` and `public final class`
4. Expose properties as Swift get/set computed properties
5. Add signals using `SignalHelper.connect()` methods
6. Add tests in `Tests/AdwaitaTests/`
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
3. Make your changes with tests
4. Ensure `xvfb-run swift test --no-parallel` passes
5. Submit a pull request

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
