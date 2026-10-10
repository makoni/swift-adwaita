# Lifetime and Ownership

Understand how GTK ownership maps onto Swift ARC in `swift-adwaita`.

## Overview

`swift-adwaita` wrappers are reference types. The runtime layer retains GTK and
libadwaita objects so Swift ARC manages their lifetime naturally, but GTK still
has its own ownership rules:

- widgets are usually owned by their parent container
- dialogs and transient popovers often outlive the local variable that created them
- signal closures run later, so captured objects must still be alive when the
  callback fires

Most of the time you should create a widget, attach it to a parent, and let the
parent own it.

## Keep transient widgets alive when GTK shows them later

If a widget is presented asynchronously and you do not store it anywhere else,
retain it until GTK closes it:

```swift
let dialog = Dialog()
dialog.title = "Details"
dialog.child = Label("Loaded lazily")
dialog.retainUntilClose()
dialog.present(parentWidget)
```

`GtkWindow.present()` already does this for top-level windows, so you usually do
not need to call ``Widget/retainUntilClose()`` manually there.

## Parenting transfers UI ownership

Appending a widget to a container or setting a `child` property transfers the
UI lifetime to GTK:

```swift
let box = Box(orientation: .vertical, spacing: 12)
let status = Label("Ready")
box.append(status)
```

You can still keep Swift references around, but you do not need to.

## Closing a window is a request; destroying it is not

``GtkWindow/close()`` asks GTK to close the window. A `close-request` handler
can veto it, it completes asynchronously, and on a window that was never
presented it does nothing at all. That is the right behaviour for anything the
user initiates — a Cancel button, a keyboard shortcut — because handlers that
prompt to save unsaved work still get their say.

``GtkWindow/destroy()`` tears the window down instead, with no veto and no
wait:

```swift
let window = ApplicationWindow(application: app)
// ... use it
window.destroy()
```

Use it when the code, not the user, is done with a window — most often at the
end of a test.

The reason the distinction is worth knowing is what destroying also does: it
unregisters the window from the list GTK keeps of live toplevels. GTK walks
that list whenever something process-wide changes — the reading direction
(``defaultTextDirection``), the theme, the inspector. A window released only by
dropping its Swift wrapper is not guaranteed to have left the list by the time
it is finalized, and a stale entry turns the next such walk into a read of
freed memory. In a long-lived process that is a rare crash; in a shared test
process, where windows accumulate from every earlier suite, it is a reliable
one.

## A widget's wrapper lives as long as the widget

The first Swift wrapper created for a GTK object holds a *toggle reference*:
while anything else references the object — its parent, a list model, the
widget a controller is attached to — the wrapper keeps itself alive. Once only
Swift references the object, the wrapper is owned by Swift alone again and both
go away with the last Swift reference.

So a widget built in a local scope and attached to a parent keeps its wrapper
(and any Swift state stored on a subclass) for as long as it is on screen:

```swift
func makeRow() -> Widget {
    let toggle = Switch()
    toggle.onActiveChanged { [weak toggle] in
        // Still valid long after makeRow() returned.
        print(toggle?.active ?? false)
    }
    return toggle
}
```

Wrappers obtained by re-wrapping an existing object — ``Widget/parent``,
``Widget/firstChild``, ``Widget/cast(_:)`` and similar — are extra wrappers when
the object already has one. They hold a plain reference and live only as long
as Swift references them.

## Signal closures should capture intentionally

A handler is owned by the object that emits the signal. If the handler
strongly captures that object, or one of its ancestors, the object owns a
closure that owns the object: a reference cycle that keeps the whole subtree
alive after its window closes. Capture those weakly:

```swift
let button = Button(label: "Increment")
let label = Label("0")
var count = 0

button.onClicked { [weak button, label] in
    count += 1
    label.text = "\(count)"
    button?.sensitive = count < 10
}
```

`label` can be captured strongly here: it does not own `button`, so no cycle
forms. As a rule of thumb, capture weakly the handler's own widget, any widget
that contains it, and any widget whose own handlers capture this one back.
Implicit captures — using an outer widget variable in the closure body without
a capture list — are strong captures too.

Handlers connected to long-lived objects such as ``StyleManager/default`` live
as long as those objects do. Capture widgets weakly there as well, or
disconnect the returned ``SignalConnection`` when the widget is destroyed.

Avoid hidden global registries or "keep alive everything forever" patterns.
They make ownership bugs harder to see and can leak windows, dialogs, or
controllers.

## Troubleshooting

- dialog disappears immediately: keep a Swift reference or call
  ``Widget/retainUntilClose()``
- callback never fires after the widget closes: the signal owner may already be
  destroyed
- a window's widgets are never freed after it closes: a handler strongly
  captures its own widget or an ancestor — switch that capture to `[weak …]`
- ``GtkWindow/close()`` appears to do nothing: the window was never presented,
  or a `close-request` handler vetoed it. ``GtkWindow/destroy()`` is
  unconditional
- a crash when the theme or the reading direction changes: a window was
  released without being destroyed, leaving a stale entry in GTK's toplevel
  list
- widget tree looks wrong: inspect ``Widget/debugDescription`` and confirm the
  parent-child chain you expected actually exists
