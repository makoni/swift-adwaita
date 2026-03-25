/// Re-exports the low-level modules so consumers of `Adwaita` get
/// `GObjectSupport` and `CAdwaita` symbols automatically.
///
/// ```swift
/// // In your app, just import Adwaita — no need to import
/// // GObjectSupport or CAdwaita separately.
/// import Adwaita
/// ```
@_exported import GObjectSupport
@_exported import CAdwaita
