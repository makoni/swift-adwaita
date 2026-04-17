# Changelog

All notable changes to swift-adwaita are documented here. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.2.0] - 2026-04-18

First release on Swift 6.2+. Contains breaking API changes in the dialog and clipboard layers — see **Removed** below for the call-site migration you will need.

### Added

- **Async image loading.** `Texture.load(from:)` decodes any raster format the host's GdkPixbuf loaders support (PNG, JPEG, GIF, WebP, TIFF, BMP, …) off the main actor, a superset of what `gdk_texture_new_from_filename` handles natively. Paired with a new `ImageDecodingError` type.
- **Animated image playback.** `AnimatedImagePlayer` drives a `Picture` widget with frames from a `GdkPixbufAnimation` iterator and exposes `start` / `stop` / `advanceFrame`. Timers and the underlying animation/iterator are released on the main actor via an isolated deinit.
- **`Picture.intrinsicSize`** — reads the current paintable's natural pixel dimensions without exposing `GdkPaintable`.
- **`Application.onOpen`** — Swift handler for the `GApplication::open` signal, receiving `[URL]` + optional open hint. Enables file-open activation for apps registered with `G_APPLICATION_HANDLES_OPEN`.
- **`Application.run(arguments:)`** — `CommandLine.arguments` are now forwarded to `g_application_run` by default, so GApplication can process file-open requests and other activation data. The previous zero-argument call site continues to work unchanged.
- GdkPixbuf wired into the `CAdwaita` umbrella module so pixbuf symbols are available without a separate shim target.

### Changed

- **Minimum Swift toolchain raised to 6.2.** `Package.swift` declares `// swift-tools-version: 6.2` and the CI matrix drops Swift 6.1 (isolated deinit is experimental in 6.1 and the release toolchain refuses to enable experimental features, so 6.1 support was not viable).
- **Isolated deinits on @MainActor reference wrappers.** `GObjectRef`, `GVariant`, `SpringParams`, `BreakpointCondition`, and `TextAttributes` now declare `isolated deinit`, making main-actor teardown explicit instead of relying on whichever thread drops the last reference.
- **Typed throws on dialog APIs.** `FileDialog.open` / `save` / `selectFolder`, `ColorDialog.chooseRGBA`, and `FontDialog.chooseFont` declare `async throws(GLibError) -> …?`. User cancellation returns `nil`; only underlying GTK failures throw. The previous non-throwing overloads have been removed — callers must now use `try` (or `try?` to collapse both outcomes to `nil`).

### Removed — Breaking

The callback-based overloads of the async dialogs have been removed outright. The async variants are now the only API, and the previous non-throwing async overloads have been collapsed into the throwing ones (dropping the `Throwing` suffix that `throws` in the signature already communicates).

Migration:

```swift
// before (callback)
dialog.open(parent: window) { path in
    if let path { handle(path) }
}

// before (non-throwing async — removed)
if let path = await dialog.open(parent: window) {
    handle(path)
}

// after
Task { @MainActor in
    do {
        if let path = try await dialog.open(parent: window) {
            handle(path)
        }
    } catch {
        presentError((error as? GLibError)?.message ?? error.localizedDescription)
    }
}

// or, if you don't care about distinguishing cancellation from failure:
if let path = try? await dialog.open(parent: window) {
    handle(path)
}
```

Specifically removed:

- Callback overloads: `FileDialog.open(parent:completion:)`, `save(parent:completion:)`, `selectFolder(parent:completion:)`, `ColorDialog.chooseRGBA(parent:completion:)`, `FontDialog.chooseFont(parent:completion:)`, and their `Throwing`-suffixed callback siblings.
- Non-throwing async overloads: the `open` / `save` / `selectFolder` / `chooseRGBA` / `chooseFont` variants that swallowed errors and returned `nil`. The (renamed) throwing variants are now the only call site — use `try?` if you want the old behavior.
- `Clipboard.readText(completion:)` and `Clipboard.readTexture(completion:)`.

The shared async plumbing moved to `DialogAsyncSupport.retainBox` / `takeBox`; the class-private `ClipboardAsyncBox` helper was deleted.

### Notes

- Swift 6.3's `withCheckedThrowingContinuation` still bridges to `any Error`, not typed throws. Each dialog type internally uses a small `retype<T>` wrapper that catches `any Error`, re-throws as `GLibError`, and `preconditionFailure`s on any other error type (unreachable in practice). When the stdlib ships the typed-throws overload, the wrapper can be inlined away.

### Housekeeping

- New README sections listing apps built with swift-adwaita and the bundled demo app.
- `FUNDING.yml` points at a custom sponsorship URL.

[1.2.0]: https://github.com/makoni/swift-adwaita/compare/1.1.0...1.2.0
