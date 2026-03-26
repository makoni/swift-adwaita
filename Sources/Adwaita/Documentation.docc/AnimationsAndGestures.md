# Animations and Gestures

Animate widget properties and respond to touch and pointer gestures.

## Overview

swift-adwaita provides ``TimedAnimation`` for fixed-duration animations,
``SpringAnimation`` for physics-based spring motion, and a set of gesture
controllers for clicks, drags, swipes, and more.

### Timed animation

``TimedAnimation`` interpolates a value from a start to an end over a
fixed duration. Attach a ``CallbackAnimationTarget`` to receive
each frame's value.

```swift
let box = Box(orientation: .vertical, spacing: 0)

let target = CallbackAnimationTarget { value in
    // value goes from 0.0 to 1.0
    box.opacity = value
}

let animation = TimedAnimation(
    widget: box,
    from: 0,
    to: 1,
    duration: 500,
    target: target
)

// Play the animation
animation.play()
```

Control playback:

```swift
animation.play()
animation.pause()
animation.reset()
animation.skip()    // Jump to end
animation.reverse = true  // Play backwards
```

### Animate a widget property directly

``PropertyAnimationTarget`` animates a GObject property without a callback:

```swift
let target = PropertyAnimationTarget(
    object: widget,
    property: .opacity
)

let animation = TimedAnimation(
    widget: widget,
    from: 0,
    to: 1,
    duration: 300,
    target: target
)
animation.play()
```

### Spring animation

``SpringAnimation`` uses a physics-based spring model. The animation
settles naturally without a fixed duration.

```swift
let springParams = SpringParams(
    damping: 0.8,
    mass: 1.0,
    stiffness: 100.0
)

let target = CallbackAnimationTarget { value in
    widget.setMargins(Int(value))
}

let spring = SpringAnimation(
    widget: widget,
    from: 0,
    to: 24,
    springParams: springParams,
    target: target
)
spring.play()
```

Tune the spring behavior:

```swift
spring.clamp = true     // Don't overshoot the target
spring.epsilon = 0.001  // Precision threshold for settling
spring.initialVelocity = 50  // Starting velocity
```

### Animation lifecycle

Listen for animation state changes:

```swift
animation.onDone {
    print("Animation finished!")
}
```

### Click gestures

``GestureClick`` handles tap/click events with press, release, and
multi-click support:

```swift
let click = GestureClick()
click.onPressed { nPress, x, y in
    if nPress == 2 {
        print("Double-clicked at (\(x), \(y))")
    }
}
click.onReleased { nPress, x, y in
    print("Released")
}
widget.addController(click)
```

### Drag gestures

``GestureDrag`` tracks pointer drag movements:

```swift
let drag = GestureDrag()
drag.onDragBegin { startX, startY in
    print("Drag started at (\(startX), \(startY))")
}
drag.onDragUpdate { offsetX, offsetY in
    print("Dragged by (\(offsetX), \(offsetY))")
}
drag.onDragEnd { offsetX, offsetY in
    print("Drag ended at (\(offsetX), \(offsetY))")
}
widget.addController(drag)
```

### Long press

``GestureLongPress`` fires after holding for a threshold duration:

```swift
let longPress = GestureLongPress()
longPress.onPressed { x, y in
    print("Long press at (\(x), \(y))")
}
widget.addController(longPress)
```

### Drag and drop

Use ``DragSource`` and ``DropTarget`` to implement drag-and-drop:

```swift
// Source widget
let source = DragSource()
source.actions = .copy
source.onPrepare { x, y in
    // Return data to drag (as GValue)
    return ContentProvider.forValue("Hello")
}
sourceWidget.addController(source)

// Target widget
let drop = DropTarget(type: G_TYPE_STRING, actions: .copy)
drop.onDrop { value, x, y in
    print("Dropped: \(value)")
    return true  // Accept the drop
}
targetWidget.addController(drop)
```

### Keyboard events

``EventControllerKey`` captures keyboard input on a widget:

```swift
let keyController = EventControllerKey()
keyController.onKeyPressed { keyval, keycode, modifiers in
    print("Key pressed: \(keyval)")
    return false  // Let the event propagate
}
widget.addController(keyController)
```

### Scroll events

``EventControllerScroll`` handles scroll wheel and touchpad scrolling:

```swift
let scroll = EventControllerScroll(flags: .vertical)
scroll.onScroll { dx, dy in
    print("Scrolled vertically by \(dy)")
    return true
}
widget.addController(scroll)
```

### Pointer motion

``EventControllerMotion`` tracks the pointer entering, leaving, and
moving over a widget:

```swift
let motion = EventControllerMotion()
motion.onEnter { x, y in
    widget.addCSSClass("hover")
}
motion.onLeave {
    widget.removeCSSClass("hover")
}
widget.addController(motion)
```
