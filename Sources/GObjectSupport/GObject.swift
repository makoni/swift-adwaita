// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

public extension GBindingFlags {
    static let bidirectional = Self(rawValue: 1 << 0)
    static let syncCreate = Self(rawValue: 1 << 1)
}

private final class GObjectLifetimeObserver: @unchecked Sendable {
    private var state: Int32 = 1

    var isAlive: Bool {
        g_atomic_int_get(&state) != 0
    }

    func markFinalized() {
        g_atomic_int_set(&state, 0)
    }

    func consumeAliveFlag() -> Bool {
        g_atomic_int_compare_and_exchange(&state, 1, 0) != 0
    }
}

/// Toggle-reference state of the one wrapper that represents a GObject.
///
/// The wrapper holds a toggle reference instead of a normal one. While anything
/// else also references the object (a parent widget, a list model, GTK's
/// toplevel list…) GLib reports "not the last reference" and the wrapper keeps
/// itself alive; once the toggle reference is the only one left it lets go, so
/// the wrapper — and with it the object — lives only as long as Swift needs it.
private final class GObjectToggleState: @unchecked Sendable {
    unowned(unsafe) let wrapper: GObjectRef
    private var isStrong: Int32 = 0

    init(wrapper: GObjectRef) {
        self.wrapper = wrapper
    }

    /// Retains (`true`) or releases (`false`) the wrapper, at most once per
    /// transition. Toggle notifications can arrive on any thread.
    func setStrong(_ strong: Bool) {
        if strong {
            if g_atomic_int_compare_and_exchange(&isStrong, 0, 1) != 0 {
                _ = Unmanaged.passUnretained(wrapper).retain()
            }
        } else if g_atomic_int_compare_and_exchange(&isStrong, 1, 0) != 0 {
            Unmanaged.passUnretained(wrapper).release()
        }
    }
}

/// qdata key marking that a GObject already has its toggle-ref wrapper.
private let toggleWrapperQuark = g_quark_from_static_string("swift-adwaita-toggle-wrapper")

/// Base class for all GObject-derived Swift wrappers.
///
/// Manages the GObject reference count via Swift's ARC. When a ``GObjectRef``
/// is created it sinks any floating reference (for `GInitiallyUnowned`
/// subclasses such as all GTK widgets) and takes ownership. When the Swift
/// object is deallocated the GObject reference is released.
///
/// The first wrapper created for a GObject also stays alive for as long as
/// anything else references the object — e.g. a widget's parent. So a widget
/// built in a local scope and added to a container keeps its wrapper (and any
/// Swift state on it), and `[weak widget]` captures in signal handlers remain
/// valid while the widget is on screen. Capture widgets weakly in handlers
/// that the widget itself (or one of its descendants) owns; a strong capture
/// there is a reference cycle that keeps the whole subtree alive forever.
///
/// ```swift
/// // All widget classes inherit from GObjectRef.
/// // Typically you use concrete subclasses like Button, Label, etc.
/// let button = Button(label: "OK")
///
/// // Bind a source property to a target property
/// sourceObject.bind(.active, to: targetObject, property: .sensitive)
///
/// // Access the underlying pointer for C interop
/// let raw: UnsafeMutablePointer<GtkButton> = button.castedPointer()
/// ```
@MainActor
open class GObjectRef {
    /// Raw pointer to the underlying GObject.
    /// Marked `nonisolated(unsafe)` because `g_object_ref`/`g_object_unref`
    /// are thread-safe (atomic ref counting), and we need access from `deinit`.
    public nonisolated(unsafe) let pointer: UnsafeMutableRawPointer
    private let lifetimeObserver: GObjectLifetimeObserver
    private let lifetimeObserverToken: UnsafeMutableRawPointer
    /// Set when this wrapper holds the object's toggle reference.
    private nonisolated(unsafe) var toggleState: Unmanaged<GObjectToggleState>?

    /// Takes ownership of a newly-created or transferred GObject.
    ///
    /// If the object has a floating reference (common for widgets created with
    /// `_new()` functions), it is sunk so this wrapper owns exactly one strong
    /// reference.
    public required init(raw pointer: UnsafeMutableRawPointer) {
        self.pointer = pointer
        let observer = GObjectLifetimeObserver()
        lifetimeObserver = observer
        lifetimeObserverToken = Unmanaged.passRetained(observer).toOpaque()
        // Sink floating reference if present (GInitiallyUnowned subclasses)
        if g_object_is_floating(pointer) != 0 {
            g_object_ref_sink(pointer)
        }
        let object = pointer.assumingMemoryBound(to: GObject.self)
        g_object_weak_ref(object, gobjectFinalizeTrampoline, lifetimeObserverToken)

        // The first wrapper of an object trades its reference for a toggle
        // reference; any later wrappers keep a plain one (GLib only reports
        // toggles while there is exactly one toggle reference).
        guard g_object_get_qdata(object, toggleWrapperQuark) == nil else { return }
        let state = Unmanaged.passRetained(GObjectToggleState(wrapper: self))
        toggleState = state
        g_object_set_qdata(object, toggleWrapperQuark, Unmanaged.passUnretained(self).toOpaque())
        g_object_add_toggle_ref(object, gobjectToggleNotify, state.toOpaque())
        // Assume someone else references the object too; if our own reference
        // was the only other one, dropping it below reports "last reference"
        // and the wrapper goes back to being owned by Swift alone.
        state.takeUnretainedValue().setStrong(true)
        g_object_unref(pointer)
    }

    /// Borrows a reference to an existing GObject by adding a new strong ref.
    ///
    /// This is a convenience initializer so all subclasses inherit it
    /// automatically — enabling `Widget.cast(_:)` to create typed wrappers.
    public convenience init(borrowing pointer: UnsafeMutableRawPointer) {
        g_object_ref(pointer)
        self.init(raw: pointer)
    }

    isolated deinit {
        guard lifetimeObserver.consumeAliveFlag() else {
            toggleState?.release()
            return
        }
        let object = pointer.assumingMemoryBound(to: GObject.self)
        g_object_weak_unref(object, gobjectFinalizeTrampoline, lifetimeObserverToken)
        Unmanaged<GObjectLifetimeObserver>.fromOpaque(lifetimeObserverToken).release()
        if let toggleState {
            g_object_set_qdata(object, toggleWrapperQuark, nil)
            g_object_remove_toggle_ref(object, gobjectToggleNotify, toggleState.toOpaque())
            toggleState.release()
        } else {
            g_object_unref(pointer)
        }
    }

    /// Returns the raw pointer cast to a typed GObject subtype pointer.
    public func castedPointer<T>() -> UnsafeMutablePointer<T> {
        pointer.assumingMemoryBound(to: T.self)
    }

    /// Returns the raw pointer as a `GObject` pointer.
    public var gobjectPointer: UnsafeMutablePointer<GObject> {
        castedPointer()
    }

    /// Returns the raw pointer as an `OpaquePointer`.
    /// Used for GObject final types whose struct is not publicly defined.
    public var opaquePointer: OpaquePointer {
        OpaquePointer(pointer)
    }

    /// Whether two wrappers refer to the same underlying GObject.
    ///
    /// Use this instead of `===` (which compares Swift class identity) when
    /// the same GObject may be referenced through multiple Swift wrappers —
    /// e.g. a widget returned by a parent lookup vs. one held in a property.
    public func isSame(as other: GObjectRef?) -> Bool {
        guard let other else { return false }
        return pointer == other.pointer
    }

    /// Binds a property of this object to a property of another object.
    ///
    /// When the source property changes, the target property is updated automatically.
    ///
    /// - Parameters:
    ///   - sourceProperty: The name of the property on this object.
    ///   - target: The target object.
    ///   - targetProperty: The name of the property on the target object.
    ///   - flags: Binding flags. Defaults to `.syncCreate` (sync on creation + one-way).
    /// - Returns: The binding, which can be used to unbind later.
    @discardableResult
    public func bind(
        _ sourceProperty: PropertyName,
        to target: GObjectRef,
        property targetProperty: PropertyName,
        flags: GBindingFlags = .syncCreate
    ) -> OpaquePointer {
        g_object_bind_property(
            pointer,
            sourceProperty.name,
            target.pointer,
            targetProperty.name,
            flags
        )
    }
}

private let gobjectFinalizeTrampoline:
    @convention(c) (UnsafeMutableRawPointer?, UnsafeMutablePointer<GObject>?) -> Void = { data, _ in
        guard let data else { return }
        let observer = Unmanaged<GObjectLifetimeObserver>.fromOpaque(data).takeRetainedValue()
        observer.markFinalized()
    }

private let gobjectToggleNotify:
    @convention(c) (UnsafeMutableRawPointer?, UnsafeMutablePointer<GObject>?, gboolean) -> Void = {
        data, _, isLastRef in
        guard let data else { return }
        Unmanaged<GObjectToggleState>.fromOpaque(data).takeUnretainedValue().setStrong(isLastRef == 0)
    }
