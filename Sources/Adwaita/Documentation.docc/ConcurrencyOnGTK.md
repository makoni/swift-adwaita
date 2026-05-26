# Concurrency on GTK

GTK apps run on GLib's main loop, not `DispatchQueue.main`.

## The important rule

Do **not** schedule GTK work with `Task { @MainActor in ... }` inside a running
GTK application. Swift's default main-actor executor uses the dispatch main
queue, which GLib does not drain.

Use ``MainContext`` instead.

## One-shot UI work

```swift
MainContext.task {
    statusLabel.text = "Saved"
}
```

## Delayed work

```swift
MainContext.task(after: .seconds(1)) {
    banner.revealed = false
}
```

## Async code that needs a main-loop hop

```swift
let width = await MainContext.run {
    content.measure(orientation: .horizontal, forSize: -1).natural
}
```

## Repeating work

```swift
MainContext.task(every: .milliseconds(250)) {
    spinner.spinning
}
```

Return `true` to keep the task scheduled, `false` to stop it.

## Dialogs and async APIs

Many wrappers expose both callback-based and `async` APIs. In GTK apps, run
`async` dialog calls from ``MainContext/task(priority:operation:)`` so resumptions
stay on the GLib-driven main loop.

See <doc:WorkingWithDialogs> for concrete file-dialog patterns.
