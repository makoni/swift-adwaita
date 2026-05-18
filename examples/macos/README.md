# swift-adwaita on macOS — Xcode example

An Xcode project that packages the swift-adwaita demo gallery as a regular
macOS `.app` bundle. Open `DemoApp/DemoApp.xcodeproj` in Xcode (26.4+
recommended), hit **⌘R**, and you should get the same 78-example gallery
that `swift run DemoApp` produces on Linux — search box, sidebar, "Show
Code" button and all.

This is a **developer starter** — it depends on Homebrew at runtime. Shipping
a self-contained bundle to other machines requires extra steps; see
"Distributing the bundle" below.

## Prerequisites

```bash
brew install libadwaita gtksourceview5 adwaita-icon-theme pkgconf
```

That pulls in `gtk4`, `glib`, `cairo`, `pango`, `gdk-pixbuf`, `harfbuzz`,
`librsvg`, and ~30 transitive deps (~1.5–2 GB on disk).

`adwaita-icon-theme` is required — Homebrew does not pull it in
transitively, and without it HeaderBar buttons, Banner, dialog buttons,
and most widget icons render empty.

Apple Silicon assumed. For Intel, replace `/opt/homebrew` with `/usr/local`
in `Project.xcconfig` and `Info.plist`.

## Layout

```
examples/macos/DemoApp/
├── DemoApp.xcodeproj/
├── DemoApp/
│   ├── main.swift          ← 5-line shim that calls DemoAppLib.runDemoApp()
│   └── Assets.xcassets/    ← icon catalog (left empty by default)
├── Info.plist              ← bundle metadata + LSEnvironment
└── Project.xcconfig        ← Homebrew header / library paths
```

Files dropped into `DemoApp/` are picked up automatically by Xcode's
"file-system synchronised group" (`objectVersion = 77` / Xcode 16+ format).

## How it hangs together

1. **`Project.xcconfig`** lists Homebrew's header / library / link flags
   that Xcode's build system needs (it has no native `pkg-config`). Both
   the project- and target-level `XCBuildConfiguration` set
   `baseConfigurationReference` to this file.

2. **`DemoAppLib.runDemoApp()` is the single entry point.** All gallery
   setup lives in the `DemoAppLib` library product of swift-adwaita. The
   Xcode app and `Sources/DemoApp/main.swift` both call into it, so the
   `swift run DemoApp` executable on Linux and Cmd+R from Xcode share one
   code path. The library also prepends `/opt/homebrew/share` (or
   `/usr/local/share` on Intel) to `XDG_DATA_DIRS` programmatically before
   `gtk_init`, which fixes a launch issue where Launch Services skips
   Info.plist's `LSEnvironment` if the parent shell already exported
   `XDG_DATA_DIRS` (Ghostty / iTerm / a customised shell rc do this).

3. **`Info.plist` `LSEnvironment`** *also* sets `XDG_DATA_DIRS` for the
   `open DemoApp.app` path on a clean shell environment. Belt-and-braces
   with the programmatic prepend in `runDemoApp()`.

4. **`main.swift` runs `Adwaita.Application.run()` directly** instead of
   `NSApplicationMain` / `@main`. GTK4's Quartz backend installs its own
   `NSApplication` and runs GLib's main loop; a second Cocoa runloop
   driving `DispatchQueue.main` would conflict with it. See
   `Sources/GObjectSupport/MainContext.swift` in the parent package for
   the explanation. The Xcode `main.swift` also strips the
   `-NSDocumentRevisionsDebugMode` / `-ApplePersistenceIgnoreState` flags
   that Xcode injects under a debug session — GApplication aborts on the
   first unknown CLI option.

5. **swift-adwaita is added as a Local Swift Package** at relative path
   `../../..` (the project root) with two product dependencies: `Adwaita`
   (the wrapper library) and `DemoAppLib` (the gallery). Modify the
   `XCLocalSwiftPackageReference` in `project.pbxproj` if you copy this
   example out of the repo — point it at a checkout or a remote URL.

6. **App Sandbox + Hardened Runtime are disabled** in `Project.xcconfig`.
   The brew dylibs live at `/opt/homebrew/lib`, which neither the sandbox
   nor library validation will allow without explicit entitlements. Re-
   enable both for App Store / notarized distribution and add:
   - `com.apple.security.cs.disable-library-validation` (Hardened Runtime)
   - file-system entitlements for any user data the app touches (Sandbox)

## Running

In Xcode: open `DemoApp.xcodeproj`, select the `DemoApp` scheme, ⌘R.

From the command line:

```bash
cd examples/macos/DemoApp
xcodebuild -project DemoApp.xcodeproj -scheme DemoApp -configuration Debug build
open ~/Library/Developer/Xcode/DerivedData/DemoApp-*/Build/Products/Debug/DemoApp.app
```

(`xcodebuild` plus `open` mirrors what ⌘R does — the latter goes through
Launch Services, which is what applies `LSEnvironment`.)

## A note on distribution

This example deliberately stops at "Cmd+R works." Turning a brew-linked
GTK app into a notarized, redistributable `.app` is the consumer's job
and lives outside the scope of a library example — it depends on **your**
Developer ID, **your** Apple ID, **your** bundle identifier, and **your**
release flow. The library doesn't prescribe a specific approach.

For reference, every GTK-on-macOS app does roughly the same shape of
work: vendor the brew dylibs via `dylibbundler` into
`Contents/Frameworks/`, copy GSettings schemas + icon themes + GdkPixbuf
loaders into `Contents/Resources/`, point env vars at bundle-relative
paths, then code-sign with Developer ID, submit to `xcrun notarytool`,
and wrap in a DMG with `hdiutil create`. A fully-vendored bundle weighs
≈80–100 MB (GTK 4 alone is 78 MB). The `swifty-notes-gtk` repo has a
working end-to-end script at `scripts/bundle-macos-app.sh` if you want
a concrete reference implementation to adapt.

## Visual caveats

This app uses GTK4's Quartz backend, **not** native Cocoa. Window chrome,
HeaderBar, Toast, and dialog styling will look like libadwaita on macOS,
not like AppKit / SwiftUI. If you need a native Mac look, swift-adwaita
is not the right toolkit for that target.
