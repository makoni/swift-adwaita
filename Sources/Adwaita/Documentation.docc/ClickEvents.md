# Click Events

Use the highest-level click API that matches the interaction you need.

## Buttons

For button activation, use the typed convenience:

```swift
button.onClicked {
    saveDocument()
}
```

## Arbitrary widgets

For click handling on non-button widgets, add a ``GestureClick`` controller:

```swift
let click = GestureClick()
click.onPressed { _, x, y in
    print("Pressed at \(x), \(y)")
}
widget.addController(click)
```

## Long-press, drag, and motion

Use the dedicated controllers instead of overloading one gesture with many
behaviors:

- ``GestureLongPress``
- ``GestureDrag``
- ``GestureSwipe``
- ``EventControllerMotion``

This keeps interactions predictable and maps more closely to GTK's event model.
