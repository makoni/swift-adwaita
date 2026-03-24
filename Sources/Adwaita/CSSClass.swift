/// Type-safe CSS class names for standard Adwaita/GNOME styles.
///
/// Use these with ``Widget/addCSSClass(_:)-enum``,
/// ``Widget/removeCSSClass(_:)-enum``, and ``Widget/hasCSSClass(_:)-enum``
/// instead of raw strings. For custom classes not listed here, use the
/// string-based overloads.
public enum CSSClass: String, Sendable, Equatable {

    // MARK: - Button Styles

    /// Suggested action (accent color).
    case suggestedAction = "suggested-action"
    /// Destructive action (red).
    case destructiveAction = "destructive-action"
    /// Flat button (no background).
    case flat
    /// Pill-shaped button (rounded corners).
    case pill
    /// Circular button.
    case circular
    /// Raised button (adds shadow).
    case raised

    // MARK: - Typography

    /// Title 1 (largest heading).
    case title1 = "title-1"
    /// Title 2.
    case title2 = "title-2"
    /// Title 3.
    case title3 = "title-3"
    /// Title 4 (smallest heading).
    case title4 = "title-4"
    /// Large heading.
    case heading
    /// Body text.
    case body
    /// Caption text (small).
    case caption
    /// Caption heading (small, bold).
    case captionHeading = "caption-heading"
    /// Monospace text.
    case monospace
    /// Numeric/tabular text (fixed-width digits).
    case numeric

    // MARK: - Colors & Backgrounds

    /// Accent color.
    case accent
    /// Success color (green).
    case success
    /// Warning color (yellow).
    case warning
    /// Error color (red).
    case error
    /// Dim label (reduced opacity).
    case dimLabel = "dim-label"

    // MARK: - Containers & Layout

    /// Card style (rounded, elevated).
    case card
    /// Toolbar style.
    case toolbar
    /// On-screen display style.
    case osd
    /// Boxed list style for ListBox.
    case boxedList = "boxed-list"
    /// Rich list style for ListBox.
    case richList = "rich-list"
    /// Navigation sidebar style for ListBox.
    case navigationSidebar = "navigation-sidebar"
    /// Frame border.
    case frame
    /// View background (white/dark base).
    case view
    /// Background style.
    case background

    // MARK: - Spacing & Size

    /// Compact spacing.
    case compact
    /// Spacious layout.
    case spacious

    // MARK: - Misc

    /// Linked group (joins adjacent widgets).
    case linked
    /// Opaque style.
    case opaque
    /// Selection mode.
    case selectionMode = "selection-mode"
}
