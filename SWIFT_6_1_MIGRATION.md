# Swift 6.1 Migration Plan

Upgrade path for `swift-adwaita` from Swift 6.0 to 6.1 tools version, plus a punch list of code that will benefit from features stabilised in 6.1.

**Status: complete.** All tiers below are done. Tier 1 shipped with the 6.1 bump (commit `1782a66` + `59e52f4`); Tier 2.3 and Tier 2.4 shipped together in a follow-up since the only downstream consumer (`swifty-notes-gtk`) was migrated in lockstep.

## 1. Baseline bump ✅

- `Package.swift` header: `// swift-tools-version: 6.1` — done.
- `swift-language-mode: 6` — unchanged, already in force.
- Minimum toolchain: **Swift 6.1.0** (shipped March 2025).

Downstream consumer (`swifty-notes-gtk`) runs on Swift 6.3, so no action needed there.

## 2. Modernisation — completed work

### Tier 1 — Done with the 6.1 bump

#### 2.1 Isolated `deinit` (SE-0371) ✅

Classes annotated `@MainActor` whose `deinit` previously relied on GObject/GLib being ref-count-safe from any thread. Marking deinits as `isolated` makes the contract explicit and permits touching main-thread-only state (timers, signal IDs) without `assumeIsolated` gymnastics.

Shipped in commit `59e52f4`:

- `Sources/GObjectSupport/GObject.swift:78` — `GObjectRef.deinit` (`g_object_unref`).
- `Sources/GObjectSupport/GVariant.swift:43` — `GVariant.deinit` (`g_variant_unref`).
- `Sources/Adwaita/BoxedTypes.swift:45, 155` — `SpringParams`, `BreakpointCondition`.
- `Sources/Adwaita/GtkWidgets/TextAttributes.swift:30` — `pango_attr_destroy`.

`nonisolated(unsafe) let pointer` declarations remain in place — that is still the correct shape for the pointer field, since the pointer value itself is address-stable and read-only after init.

#### 2.2 `AnimatedImagePlayer` ships with `isolated deinit` from day one ✅

Shipped alongside the 6.1 bump in commit `1782a66`. Lifecycle (stopping timers, releasing pixbuf animation + iterator) runs on MainActor with no workarounds.

### Tier 2 — Done in follow-up pass

#### 2.3 Typed throws on dialog APIs (SE-0413) ✅

All throwing dialog methods now declare `throws(GLibError)` instead of untyped `throws`.

Migrated:

- `FileDialog.openThrowing / saveThrowing / selectFolderThrowing`
- `ColorDialog.chooseRGBAThrowing`
- `FontDialog.chooseFontThrowing`

**Swift 6.3 stdlib caveat.** `withCheckedThrowingContinuation` in Swift 6.3 still only bridges to `any Error`, not typed throws — the `async throws(E)` overload landed in the proposal but not yet in the shipping stdlib. We bridge across this gap with a per-class `retype<T>(_ operation:) async throws(GLibError) -> T` wrapper that catches `any Error`, downcasts to `GLibError`, and `preconditionFailure`s on any other error type (which is unreachable in practice because the underlying continuations only ever resume with `GLibError` or success). When the stdlib ships the typed overload, the wrapper can be deleted and the calls inlined.

```swift
// pattern used in FileDialog/ColorDialog/FontDialog
private static func retype<T>(_ op: () async throws -> T) async throws(GLibError) -> T {
    do { return try await op() }
    catch let error as GLibError { throw error }
    catch { preconditionFailure("continuation threw non-GLibError: \(error)") }
}
```

#### 2.4 Callback-based dialog/clipboard APIs collapsed into `async` ✅

Callback variants were removed outright — no deprecation shim — since the only downstream consumer (`swifty-notes-gtk`) was migrated in lockstep and the library has not yet had a stable release.

Removed entirely:

- `Clipboard.readText(completion:) / readTexture(completion:)` — now `async -> String? / Texture?` only.
- `FileDialog.open(parent:completion:) / save(...) / selectFolder(...)` and their throwing variants — now async-only.
- `ColorDialog.chooseRGBA(parent:completion:)` and throwing variant — async-only.
- `FontDialog.chooseFont(parent:completion:)` and throwing variant — async-only.

Shared async plumbing moved to `DialogAsyncSupport.retainBox` / `takeBox`; the class-private `ClipboardAsyncBox` helper was deleted.

DemoApp examples (`FileDialogExample`, `ClipboardExample`, `PictureExample`, `VideoExample`) updated to wrap calls in `Task { @MainActor in await ... }`.

### Tier 3 — Skipped intentionally ✅

These patterns show up in the codebase but do **not** need changes after the 6.1 bump:

#### 2.5 `nonisolated(unsafe)` on pointer fields — canonical

`GObjectSupport/GObject.swift:47`, `GVariant.swift:26`, `BoxedTypes.swift:22, 94` — correct as-is; no better alternative in 6.1.

#### 2.6 `MainContext` vs `DispatchQueue.main` — deliberate

`Sources/GObjectSupport/MainContext.swift:10` intentionally uses `g_idle_add`/`g_timeout_add` for GLib main-loop integration. Unchanged.

#### 2.7 `@unchecked Sendable` trampoline boxes — kept

`SignalTrampolines.swift:7-8`, `GObject.swift:8` (`GObjectLifetimeObserver`), `Signal.swift:16, 39`, `Clipboard.swift:5`, `DialogAsyncSupport.swift:4` — wrap C-callback context. Region-based isolation (SE-0414) could in theory make some checked-Sendable, but the resulting code is less readable and invariants are clearer with explicit `@unchecked`. Kept.

## 3. Execution record

1. ✅ **Tools-version bump + Tier 1** — commits `1782a66` (6.1 bump + AnimatedImagePlayer) and `59e52f4` (isolated deinit on existing types).
2. ✅ **Tier 2.3 + 2.4** — combined follow-up. Typed throws and callback-collapse landed together since the only consumer (`swifty-notes-gtk`) was migrated in the same pass, making the deprecation-shim step unnecessary.

## 4. Non-goals — honoured

- `swift-language-mode` unchanged (still 6).
- No new dependencies beyond existing `swift-docc-plugin`.
- `swifty-notes-gtk` call-sites were migrated in lockstep; no shipped API break for external consumers.
