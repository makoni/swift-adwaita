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

/// Base class for all GObject-derived Swift wrappers.
///
/// Manages the GObject reference count via Swift's ARC. When a ``GObjectRef``
/// is created it sinks any floating reference (for `GInitiallyUnowned`
/// subclasses such as all GTK widgets) and takes ownership. When the Swift
/// object is deallocated the GObject reference is released.
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

    /// Takes ownership of a newly-created or transferred GObject.
    ///
    /// If the object has a floating reference (common for widgets created with
    /// `_new()` functions), it is sunk so this wrapper owns exactly one strong
    /// reference.
    public required init(raw pointer: UnsafeMutableRawPointer) {
        self.pointer = pointer
        lifetimeObserver = GObjectLifetimeObserver()
        // Sink floating reference if present (GInitiallyUnowned subclasses)
        if g_object_is_floating(pointer) != 0 {
            g_object_ref_sink(pointer)
        }
        g_object_weak_ref(
            pointer.assumingMemoryBound(to: GObject.self),
            gobjectFinalizeTrampoline,
            Unmanaged.passRetained(lifetimeObserver).toOpaque()
        )
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
        guard lifetimeObserver.consumeAliveFlag() else { return }
        g_object_unref(pointer)
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
