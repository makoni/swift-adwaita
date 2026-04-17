# Swift 6.1 Migration Plan

Upgrade path for `swift-adwaita` from Swift 6.0 to 6.1 tools version, plus a punch list of code that will benefit from features stabilised in 6.1.

## 1. Baseline bump

- `Package.swift` header: `// swift-tools-version: 6.1`
- Keep `swift-language-mode: 6` (no change — Swift 6 language mode already in force).
- Minimum toolchain: **Swift 6.1.0** (shipped March 2025 — now supported by Apple's own SDKs as the floor; Swift 6.0 is being dropped in new projects).

After the bump, consumers of the library must also be on 6.1+. The immediate downstream consumer (`swifty-notes-gtk`) is already on Swift 6.3, so no action needed there.

## 2. Modernisation opportunities (ranked by ROI)

### Tier 1 — Do during the 6.1 bump

#### 2.1 Isolated `deinit` (SE-0371) — remove implicit thread-safety assumptions

Classes annotated `@MainActor` whose `deinit` currently relies on GObject/GLib being ref-count-safe from any thread. Marking deinits as `isolated` makes the contract explicit and lets us also touch main-thread-only state (timers, signal IDs) without `assumeIsolated` gymnastics.

Candidates:

- `Sources/GObjectSupport/GObject.swift:78-81` — `GObjectRef.deinit` calls `g_object_unref`.
- `Sources/GObjectSupport/GVariant.swift:43-45` — `GVariant.deinit` calls `g_variant_unref`.
- `Sources/Adwaita/BoxedTypes.swift:45-46, 155-156` — `SpringParams`, `BreakpointCondition`.
- `Sources/Adwaita/GtkWidgets/TextAttributes.swift:30` — `pango_attr_destroy`.

After migration, the `nonisolated(unsafe) let pointer` declarations (e.g. `GObject.swift:47`, `GVariant.swift:26`, `BoxedTypes.swift:22, 94`) stay — they are correct. But any *method* that does GTK work during teardown can drop defensive `assumeIsolated` / `Task { @MainActor }` and just run in the isolated deinit.

**Effort:** Medium · **Wins:** Medium (clearer invariants, fewer footguns).

#### 2.2 New `AnimatedImagePlayer` will ship with `isolated deinit` from day one

Lifecycle (stopping timers, releasing pixbuf animation + iterator) runs on MainActor without workarounds. This is a design input for the new API being added alongside the migration, not rework of existing code.

**Effort:** Already baked into the new API.

### Tier 2 — Worth doing in a follow-up pass

#### 2.3 Typed throws on dialog APIs (SE-0413, stable in 6.1)

All "throwing" dialog methods currently bounce through `Result<T, GLibError>` or `throws -> T` but in reality only ever throw `GLibError`. Typed throws makes the contract explicit without breaking source compatibility for callers that use `catch` without pattern-matching.

Candidates:

- `Sources/Adwaita/GtkWidgets/FileDialog.swift:91-96, 142-144, 250, 356` — `open/save/selectFolderThrowing`
- `Sources/Adwaita/GtkWidgets/ColorDialog.swift:140` — `chooseRGBAThrowing`
- `Sources/Adwaita/GtkWidgets/FontDialog.swift:117` — `chooseFontDescThrowing`

Change pattern:

```swift
// before
public func openThrowing() async throws -> String? { ... }

// after
public func openThrowing() async throws(GLibError) -> String? { ... }
```

**Effort:** Easy (≈15 lines changed) · **Wins:** Small (API clarity, better auto-completion in catch blocks).

#### 2.4 Callback-based APIs → pure `async throws`

Several async wrappers today: `callback → continuation → async`. With 6.1 isolation inference we can collapse the callback layer entirely in most dialogs. Scope is larger — do in a dedicated PR.

Candidates:

- `Sources/Adwaita/GtkWidgets/Clipboard.swift:26, 65, 92-109` — `readText`, `readTexture`.
- `Sources/Adwaita/GtkWidgets/FileDialog.swift:104, 213, 319` — `open`, `save`, `selectFolder`.
- `Sources/Adwaita/GtkWidgets/ColorDialog.swift:77, 140` — `chooseRGBA`.
- `Sources/Adwaita/GtkWidgets/FontDialog.swift:56, 117` — `chooseFontDesc`.
- `Sources/Adwaita/GtkWidgets/UriLauncher.swift:55, 64` — `launch`.

Preserve the callback variants as `@available(*, deprecated, renamed:)` shims for one release before removal.

**Effort:** Medium · **Wins:** Large (surface area shrinks, retained `*AsyncBox<T>` helpers become internal implementation details or are deleted).

### Tier 3 — Skip / already optimal

These patterns show up in the codebase but do **not** need changes after the 6.1 bump:

#### 2.5 `nonisolated(unsafe)` on pointer fields — already canonical

`GObjectSupport/GObject.swift:47`, `GVariant.swift:26`, `BoxedTypes.swift:22, 94` are correctly using `nonisolated(unsafe) let pointer` — no better alternative in 6.1.

#### 2.6 `MainContext` vs `DispatchQueue.main` — deliberate

`Sources/GObjectSupport/MainContext.swift:10` has a comment explaining why the library intentionally uses `g_idle_add`/`g_timeout_add` instead of `DispatchQueue.main`. This is correct for GLib main-loop integration. Leave alone.

#### 2.7 `@unchecked Sendable` trampoline boxes — leave

`SignalTrampolines.swift:7-8`, `GObject.swift:8` (`GObjectLifetimeObserver`), `Signal.swift:16, 39`, `Clipboard.swift:5`, `DialogAsyncSupport.swift:4`. These wrap C-callback context. Region-based isolation (SE-0414) *could* in theory make some of them checked-Sendable, but the resulting code is less readable and the invariants are clearer with the explicit `@unchecked`. Keep.

## 3. Execution order

1. **Tools-version bump + Tier 1 (isolated deinit)** — single PR, together with the new image-loading API that depends on it.
2. **Tier 2.3 (typed throws)** — small follow-up PR, source-compatible for most call sites.
3. **Tier 2.4 (callback → async)** — dedicated PR, marks old signatures deprecated first.

## 4. Non-goals

- No change to `swift-language-mode` (already 6).
- No new dependencies beyond the existing `swift-docc-plugin`.
- No API break for existing consumers during the 6.1 bump itself.
