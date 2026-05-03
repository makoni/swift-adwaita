// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// =============================================================================
// Xcode entry point for the swift-adwaita demo gallery on macOS.
// =============================================================================
//
// This file is intentionally tiny. The whole 78-example gallery — sidebar,
// search, "Show Code", every individual widget demo — lives in the
// `DemoAppLib` *library* product of the parent `swift-adwaita` Swift package
// (see `Sources/DemoAppLib/`). Both `swift run DemoApp` on Linux and Cmd+R
// from this Xcode project end up calling the exact same function:
//
//     DemoAppLib.runDemoApp(arguments:)
//
// What this file adds on top is the macOS-specific glue Xcode and Launch
// Services need:
//
//   1.  Filter Xcode's debug-only argv. When Xcode launches a debug build
//       it passes `-NSDocumentRevisionsDebugMode YES`,
//       `-ApplePersistenceIgnoreState YES`, and a few other Cocoa-specific
//       flags. GApplication aborts on the first unknown CLI option with
//       "Unknown option …", which from the user's chair looks like the app
//       launched and immediately disappeared. We hand only `argv[0]` to the
//       gallery.
//
//   2.  Run the gallery. `XDG_DATA_DIRS=/opt/homebrew/share` is supplied
//       through the shared scheme's "Run > Environment Variables" for
//       Cmd+R, and through Info.plist's `LSEnvironment` for `open .app` /
//       double-click — and `runDemoApp` itself prepends the Homebrew
//       prefix programmatically as a final safety net (see
//       `ensureHomebrewSchemasOnPath` in `DemoAppRunner.swift`).
//
// To swap this example for *your own* swift-adwaita app, replace the call
// to `DemoAppLib.runDemoApp(arguments:)` with your own `Adwaita.Application`
// setup (and drop the `import DemoAppLib`).
// =============================================================================

import DemoAppLib

// (1) Strip Xcode-only flags from argv before handing them to GApplication.
let executableName = CommandLine.arguments.first ?? "DemoApp"
let cleanArguments = [executableName]

// (2) Hand off to the library — same function `swift run DemoApp` calls.
DemoAppLib.runDemoApp(arguments: cleanArguments)
