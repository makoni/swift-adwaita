import CAdwaita

/// Base class for all GObject-derived Swift wrappers.
///
/// Manages the GObject reference count via Swift's ARC. When a ``GObjectRef``
/// is created it sinks any floating reference (for `GInitiallyUnowned`
/// subclasses such as all GTK widgets) and takes ownership. When the Swift
/// object is deallocated the GObject reference is released.
@MainActor
open class GObjectRef {
    /// Raw pointer to the underlying GObject.
    /// Marked `nonisolated(unsafe)` because `g_object_ref`/`g_object_unref`
    /// are thread-safe (atomic ref counting), and we need access from `deinit`.
    public nonisolated(unsafe) let pointer: UnsafeMutableRawPointer

    /// Takes ownership of a newly-created or transferred GObject.
    ///
    /// If the object has a floating reference (common for widgets created with
    /// `_new()` functions), it is sunk so this wrapper owns exactly one strong
    /// reference.
    public init(raw pointer: UnsafeMutableRawPointer) {
        self.pointer = pointer
        // Sink floating reference if present (GInitiallyUnowned subclasses)
        if g_object_is_floating(pointer) != 0 {
            g_object_ref_sink(pointer)
        }
    }

    /// Borrows a reference to an existing GObject by adding a new strong ref.
    public init(borrowing pointer: UnsafeMutableRawPointer) {
        self.pointer = pointer
        g_object_ref(pointer)
    }

    deinit {
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
        _ sourceProperty: String,
        to target: GObjectRef,
        property targetProperty: String,
        flags: GBindingFlags = G_BINDING_SYNC_CREATE
    ) -> OpaquePointer {
        g_object_bind_property(
            pointer,
            sourceProperty,
            target.pointer,
            targetProperty,
            flags
        )
    }
}
