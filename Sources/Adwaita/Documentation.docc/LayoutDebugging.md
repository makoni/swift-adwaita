# Layout Debugging

When a GTK layout looks wrong, inspect structure before guessing.

## Dump the widget tree

Every widget exposes a debug-oriented tree description:

```swift
print(container.debugDescription)
```

This prints widget types, size, focusability, visibility, and CSS classes
without leaking user text content.

## Measure widgets directly

```swift
let size = label.measure(orientation: .horizontal, forSize: -1)
print(size.minimum, size.natural)
```

Use this when a widget appears collapsed or requests more space than expected.

## Scroll the broken area into view

```swift
scrolledWindow.scrollChildIntoView(problemRow, animate: true)
```

This is useful for validation UIs, search results, and forms that need to jump
to the first invalid control.

## Check CSS classes

```swift
print(widget.cssClasses)
```

Missing or extra classes often explain spacing, typography, or state styling
issues.
