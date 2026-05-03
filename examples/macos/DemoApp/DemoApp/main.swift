import DemoAppLib
import Foundation

// Entry point for the Xcode-built macOS .app bundle.
//
// All gallery setup lives in `DemoAppLib` so the same code drives
// `swift run DemoApp` on Linux and Cmd+R from this Xcode project. We only
// massage the args here:
//
//   * Xcode's debug-launch passes `-NSDocumentRevisionsDebugMode YES`,
//     `-ApplePersistenceIgnoreState YES`, and similar Cocoa-specific flags
//     that GApplication does not recognise. GApplication aborts with
//     "Unknown option …" on the first one, which on screen looks like the
//     app launched and immediately disappeared. Pass argv[0] only.
//   * `XDG_DATA_DIRS=/opt/homebrew/share` is exported via the shared
//     scheme's Run > Environment Variables (and via Info.plist's
//     LSEnvironment for `open .app` / Launch Services launches), so we
//     don't have to re-export it from here.

let executableName = CommandLine.arguments.first ?? "DemoApp"
runDemoApp(arguments: [executableName])
