// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

/// Type-safe GObject property names for `bind()`, `addSetter()`, and `onNotify()`.
///
/// Use `.custom(String)` for properties not covered by the predefined cases.
///
/// ```swift
/// // Use predefined property names
/// sourceObject.bind(.active, to: targetObject, property: .sensitive)
///
/// // Observe when a property changes
/// SignalHelper.onNotify(label, property: .label) {
///     print("Label text changed")
/// }
///
/// // Use a custom property name
/// SignalHelper.onNotify(widget, property: .custom("my-property")) {
///     print("Custom property changed")
/// }
/// ```
public enum PropertyName: Sendable, Equatable {

    // MARK: - Common widget properties

    case active
    case child
    case content
    case cssClasses
    case decorated
    case defaultHeight
    case defaultWidth
    case fontDesc
    case halign
    case heightRequest
    case hexpand
    case homogeneous
    case iconName
    case label
    case margin
    case modal
    case opacity
    case orientation
    case resizable
    case rgba
    case selected
    case sensitive
    case spacing
    case subtitle
    case text
    case title
    case tooltip
    case valign
    case value
    case vexpand
    case visible
    case width
    case widthRequest
    case wrap

    // MARK: - Custom

    /// A property name not covered by the predefined cases.
    case custom(String)

    /// The GObject property name string.
    public var name: String {
        switch self {
        case .active: "active"
        case .child: "child"
        case .content: "content"
        case .cssClasses: "css-classes"
        case .decorated: "decorated"
        case .defaultHeight: "default-height"
        case .defaultWidth: "default-width"
        case .fontDesc: "font-desc"
        case .halign: "halign"
        case .heightRequest: "height-request"
        case .hexpand: "hexpand"
        case .homogeneous: "homogeneous"
        case .iconName: "icon-name"
        case .label: "label"
        case .margin: "margin"
        case .modal: "modal"
        case .opacity: "opacity"
        case .orientation: "orientation"
        case .resizable: "resizable"
        case .rgba: "rgba"
        case .selected: "selected"
        case .sensitive: "sensitive"
        case .spacing: "spacing"
        case .subtitle: "subtitle"
        case .text: "text"
        case .title: "title"
        case .tooltip: "tooltip"
        case .valign: "valign"
        case .value: "value"
        case .vexpand: "vexpand"
        case .visible: "visible"
        case .width: "width"
        case .widthRequest: "width-request"
        case .wrap: "wrap"
        case let .custom(name): name
        }
    }
}
