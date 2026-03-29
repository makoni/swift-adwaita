// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// An animation target that directly updates a GObject property.
///
/// Wraps `AdwPropertyAnimationTarget`. Instead of using a callback, this
/// target animates a named property on a GObject instance directly. The
/// property must be writable and accept a `double` value.
///
/// ```swift
/// // Animate the "opacity" property of a GtkWidget directly.
/// // (Typically created via the C API; see CallbackAnimationTarget
/// // for the more common Swift-friendly approach.)
/// ```
///
/// - Since: libadwaita 1.2
@MainActor
public final class PropertyAnimationTarget: AnimationTarget {}
