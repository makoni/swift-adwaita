// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita

// MARK: - GTK Enums

// Swift-friendly extensions on GTK and Adwaita C enums.
//
// These extensions add static properties so you can use dot-syntax instead
// of C-style constants.
//
// ```swift
// let box = Box(orientation: .vertical, spacing: 6)
// box.halign = .center
// box.valign = .fill
//
// let stack = Stack()
// stack.transitionType = .crossfade
// ```

public extension GtkOrientation {
    /// Vertical orientation.
    static let vertical = GTK_ORIENTATION_VERTICAL
    /// Horizontal orientation.
    static let horizontal = GTK_ORIENTATION_HORIZONTAL
}

public extension GtkAlign {
    /// Fill the available space.
    static let fill = GTK_ALIGN_FILL
    /// Align to the start.
    static let start = GTK_ALIGN_START
    /// Align to the end.
    static let end = GTK_ALIGN_END
    /// Align to the center.
    static let center = GTK_ALIGN_CENTER
    /// Use baseline alignment.
    static let baseline = GTK_ALIGN_BASELINE_CENTER
}

public extension GtkSelectionMode {
    /// No selection allowed.
    static let none = GTK_SELECTION_NONE
    /// Single selection.
    static let single = GTK_SELECTION_SINGLE
    /// Allow browsing selection.
    static let browse = GTK_SELECTION_BROWSE
    /// Allow multiple selection.
    static let multiple = GTK_SELECTION_MULTIPLE
}

public extension GtkStackTransitionType {
    /// No transition.
    static let none = GTK_STACK_TRANSITION_TYPE_NONE
    /// Crossfade transition.
    static let crossfade = GTK_STACK_TRANSITION_TYPE_CROSSFADE
    /// Slide right transition.
    static let slideRight = GTK_STACK_TRANSITION_TYPE_SLIDE_RIGHT
    /// Slide left transition.
    static let slideLeft = GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT
    /// Slide up transition.
    static let slideUp = GTK_STACK_TRANSITION_TYPE_SLIDE_UP
    /// Slide down transition.
    static let slideDown = GTK_STACK_TRANSITION_TYPE_SLIDE_DOWN
    /// Slide left-right transition.
    static let slideLeftRight = GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT
    /// Slide up-down transition.
    static let slideUpDown = GTK_STACK_TRANSITION_TYPE_SLIDE_UP_DOWN
    /// Rotate left transition.
    static let rotateLeft = GTK_STACK_TRANSITION_TYPE_ROTATE_LEFT
    /// Rotate right transition.
    static let rotateRight = GTK_STACK_TRANSITION_TYPE_ROTATE_RIGHT
}

public extension GtkRevealerTransitionType {
    /// No transition.
    static let none = GTK_REVEALER_TRANSITION_TYPE_NONE
    /// Crossfade transition.
    static let crossfade = GTK_REVEALER_TRANSITION_TYPE_CROSSFADE
    /// Slide right transition.
    static let slideRight = GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT
    /// Slide left transition.
    static let slideLeft = GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT
    /// Slide up transition.
    static let slideUp = GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP
    /// Slide down transition.
    static let slideDown = GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN
    /// Swing right transition.
    static let swingRight = GTK_REVEALER_TRANSITION_TYPE_SWING_RIGHT
    /// Swing left transition.
    static let swingLeft = GTK_REVEALER_TRANSITION_TYPE_SWING_LEFT
    /// Swing up transition.
    static let swingUp = GTK_REVEALER_TRANSITION_TYPE_SWING_UP
    /// Swing down transition.
    static let swingDown = GTK_REVEALER_TRANSITION_TYPE_SWING_DOWN
}

public extension GtkPolicyType {
    /// Always show scrollbar.
    static let always = GTK_POLICY_ALWAYS
    /// Show scrollbar automatically.
    static let automatic = GTK_POLICY_AUTOMATIC
    /// Never show scrollbar.
    static let never = GTK_POLICY_NEVER
    /// Show scrollbar as an external overlay.
    static let external = GTK_POLICY_EXTERNAL
}

public extension GtkWrapMode {
    /// No wrapping.
    static let none = GTK_WRAP_NONE
    /// Wrap at character boundaries.
    static let char = GTK_WRAP_CHAR
    /// Wrap at word boundaries.
    static let word = GTK_WRAP_WORD
    /// Wrap at word boundaries, but fall back to char.
    static let wordChar = GTK_WRAP_WORD_CHAR
}

public extension GtkPositionType {
    /// Left position.
    static let left = GTK_POS_LEFT
    /// Right position.
    static let right = GTK_POS_RIGHT
    /// Top position.
    static let top = GTK_POS_TOP
    /// Bottom position.
    static let bottom = GTK_POS_BOTTOM
}

public extension GtkContentFit {
    /// Fill the entire allocation, ignoring aspect ratio.
    static let fill = GTK_CONTENT_FIT_FILL
    /// Scale to fit the allocation, preserving aspect ratio.
    static let contain = GTK_CONTENT_FIT_CONTAIN
    /// Cover the entire allocation, preserving aspect ratio.
    static let cover = GTK_CONTENT_FIT_COVER
    /// Scale down to fit, but never scale up.
    static let scaleDown = GTK_CONTENT_FIT_SCALE_DOWN
}

public extension GtkArrowType {
    /// Up arrow.
    static let up = GTK_ARROW_UP
    /// Down arrow.
    static let down = GTK_ARROW_DOWN
    /// Left arrow.
    static let left = GTK_ARROW_LEFT
    /// Right arrow.
    static let right = GTK_ARROW_RIGHT
    /// No arrow.
    static let none = GTK_ARROW_NONE
}

public extension GtkLicense {
    /// Unknown license.
    static let unknown = GTK_LICENSE_UNKNOWN
    /// Custom license.
    static let custom = GTK_LICENSE_CUSTOM
    /// GPL 2.0.
    static let gpl20 = GTK_LICENSE_GPL_2_0
    /// GPL 3.0.
    static let gpl30 = GTK_LICENSE_GPL_3_0
    /// LGPL 2.1.
    static let lgpl21 = GTK_LICENSE_LGPL_2_1
    /// LGPL 3.0.
    static let lgpl30 = GTK_LICENSE_LGPL_3_0
    /// MIT license.
    static let mit = GTK_LICENSE_MIT_X11
    /// Apache 2.0.
    static let apache20 = GTK_LICENSE_APACHE_2_0
}

// MARK: - Adwaita Enums

public extension AdwResponseAppearance {
    /// Default appearance.
    static let `default` = ADW_RESPONSE_DEFAULT
    /// Suggested action appearance.
    static let suggested = ADW_RESPONSE_SUGGESTED
    /// Destructive action appearance.
    static let destructive = ADW_RESPONSE_DESTRUCTIVE
}

public extension AdwColorScheme {
    /// Default color scheme.
    static let `default` = ADW_COLOR_SCHEME_DEFAULT
    /// Force light theme.
    static let forceLight = ADW_COLOR_SCHEME_FORCE_LIGHT
    /// Prefer light theme.
    static let preferLight = ADW_COLOR_SCHEME_PREFER_LIGHT
    /// Prefer dark theme.
    static let preferDark = ADW_COLOR_SCHEME_PREFER_DARK
    /// Force dark theme.
    static let forceDark = ADW_COLOR_SCHEME_FORCE_DARK
}

public extension AdwLengthUnit {
    /// Pixels.
    static let px = ADW_LENGTH_UNIT_PX
    /// Points.
    static let pt = ADW_LENGTH_UNIT_PT
    /// Scale-independent pixels.
    static let sp = ADW_LENGTH_UNIT_SP
}

public extension AdwNavigationDirection {
    /// Back direction.
    static let back = ADW_NAVIGATION_DIRECTION_BACK
    /// Forward direction.
    static let forward = ADW_NAVIGATION_DIRECTION_FORWARD
}

public extension AdwEasing {
    /// Linear easing.
    static let linear = ADW_LINEAR
    /// Ease-in quad.
    static let easeInQuad = ADW_EASE_IN_QUAD
    /// Ease-out quad.
    static let easeOutQuad = ADW_EASE_OUT_QUAD
    /// Ease-in-out quad.
    static let easeInOutQuad = ADW_EASE_IN_OUT_QUAD
    /// Ease-in cubic.
    static let easeInCubic = ADW_EASE_IN_CUBIC
    /// Ease-out cubic.
    static let easeOutCubic = ADW_EASE_OUT_CUBIC
    /// Ease-in-out cubic.
    static let easeInOutCubic = ADW_EASE_IN_OUT_CUBIC
    /// Ease-in quart.
    static let easeInQuart = ADW_EASE_IN_QUART
    /// Ease-out quart.
    static let easeOutQuart = ADW_EASE_OUT_QUART
    /// Ease-in-out quart.
    static let easeInOutQuart = ADW_EASE_IN_OUT_QUART
    /// Ease-in quint.
    static let easeInQuint = ADW_EASE_IN_QUINT
    /// Ease-out quint.
    static let easeOutQuint = ADW_EASE_OUT_QUINT
    /// Ease-in-out quint.
    static let easeInOutQuint = ADW_EASE_IN_OUT_QUINT
    /// Ease-in bounce.
    static let easeInBounce = ADW_EASE_IN_BOUNCE
    /// Ease-out bounce.
    static let easeOutBounce = ADW_EASE_OUT_BOUNCE
    /// Ease-in-out bounce.
    static let easeInOutBounce = ADW_EASE_IN_OUT_BOUNCE
}

public extension GtkOverflow {
    /// Visible — no clipping.
    static let visible = GTK_OVERFLOW_VISIBLE
    /// Hidden — clip to allocation.
    static let hidden = GTK_OVERFLOW_HIDDEN
}

public extension AdwToastPriority {
    /// Normal priority.
    static let normal = ADW_TOAST_PRIORITY_NORMAL
    /// High priority.
    static let high = ADW_TOAST_PRIORITY_HIGH
}

public extension AdwViewSwitcherPolicy {
    /// Narrow policy.
    static let narrow = ADW_VIEW_SWITCHER_POLICY_NARROW
    /// Wide policy.
    static let wide = ADW_VIEW_SWITCHER_POLICY_WIDE
}

public extension GtkPackType {
    /// Start side (left for LTR).
    static let start = GTK_PACK_START
    /// End side (right for LTR).
    static let end = GTK_PACK_END
}

public extension GtkJustification {
    /// Left justified.
    static let left = GTK_JUSTIFY_LEFT
    /// Right justified.
    static let right = GTK_JUSTIFY_RIGHT
    /// Centered.
    static let center = GTK_JUSTIFY_CENTER
    /// Fill the available width.
    static let fill = GTK_JUSTIFY_FILL
}

public extension GtkInputPurpose {
    /// Free-form text.
    static let freeForm = GTK_INPUT_PURPOSE_FREE_FORM
    /// Digits only.
    static let digits = GTK_INPUT_PURPOSE_DIGITS
    /// A number (may include decimals/signs).
    static let number = GTK_INPUT_PURPOSE_NUMBER
    /// A phone number.
    static let phone = GTK_INPUT_PURPOSE_PHONE
    /// A URL.
    static let url = GTK_INPUT_PURPOSE_URL
    /// An email address.
    static let email = GTK_INPUT_PURPOSE_EMAIL
    /// A name.
    static let name = GTK_INPUT_PURPOSE_NAME
    /// A password.
    static let password = GTK_INPUT_PURPOSE_PASSWORD
    /// A PIN.
    static let pin = GTK_INPUT_PURPOSE_PIN
    /// Terminal input.
    static let terminal = GTK_INPUT_PURPOSE_TERMINAL
}

public extension GtkEntryIconPosition {
    /// The primary icon (start of entry).
    static let primary = GTK_ENTRY_ICON_PRIMARY
    /// The secondary icon (end of entry).
    static let secondary = GTK_ENTRY_ICON_SECONDARY
}

public extension GtkNaturalWrapMode {
    /// Inherit from parent.
    static let inherit = GTK_NATURAL_WRAP_INHERIT
    /// No natural wrap.
    static let none = GTK_NATURAL_WRAP_NONE
    /// Wrap at word boundaries.
    static let word = GTK_NATURAL_WRAP_WORD
}

public extension PangoWrapMode {
    /// Wrap at word boundaries.
    static let word = PANGO_WRAP_WORD
    /// Wrap at any character.
    static let char = PANGO_WRAP_CHAR
    /// Wrap at word boundaries, falling back to character when a word
    /// doesn't fit.
    static let wordChar = PANGO_WRAP_WORD_CHAR
}

public extension AdwAnimationState {
    /// Idle state.
    static let idle = ADW_ANIMATION_IDLE
    /// Paused state.
    static let paused = ADW_ANIMATION_PAUSED
    /// Playing state.
    static let playing = ADW_ANIMATION_PLAYING
    /// Finished state.
    static let finished = ADW_ANIMATION_FINISHED
}

public extension GtkTextDirection {
    /// No direction set; use the default locale direction.
    static let none = GTK_TEXT_DIR_NONE
    /// Left-to-right text direction.
    static let ltr = GTK_TEXT_DIR_LTR
    /// Right-to-left text direction.
    static let rtl = GTK_TEXT_DIR_RTL
}

public extension GtkLevelBarMode {
    /// Show a continuous bar proportional to the value.
    static let continuous = GTK_LEVEL_BAR_MODE_CONTINUOUS
    /// Show discrete blocks, one per integer step.
    static let discrete = GTK_LEVEL_BAR_MODE_DISCRETE
}

public extension GtkShortcutScope {
    /// Shortcut is handled by the widget itself.
    static let local = GTK_SHORTCUT_SCOPE_LOCAL
    /// Shortcut is handled by the first ancestor that is a `GtkShortcutManager`.
    static let managed = GTK_SHORTCUT_SCOPE_MANAGED
    /// Shortcut is handled by the root widget.
    static let global = GTK_SHORTCUT_SCOPE_GLOBAL
}

public extension GtkSpinButtonUpdatePolicy {
    /// Update value on every change.
    static let always = GTK_UPDATE_ALWAYS
    /// Update only when the entered value is valid.
    static let ifValid = GTK_UPDATE_IF_VALID
}

public extension GtkStringFilterMatchMode {
    /// Match only when the whole string is equal.
    static let exact = GTK_STRING_FILTER_MATCH_MODE_EXACT
    /// Match when the needle appears anywhere.
    static let substring = GTK_STRING_FILTER_MATCH_MODE_SUBSTRING
    /// Match when the string starts with the needle.
    static let prefix = GTK_STRING_FILTER_MATCH_MODE_PREFIX
}

public extension PangoEllipsizeMode {
    /// Don't ellipsize.
    static let none = PANGO_ELLIPSIZE_NONE
    /// Ellipsize at the start (`…foo`).
    static let start = PANGO_ELLIPSIZE_START
    /// Ellipsize in the middle (`fo…ar`).
    static let middle = PANGO_ELLIPSIZE_MIDDLE
    /// Ellipsize at the end (`foo…`).
    static let end = PANGO_ELLIPSIZE_END
}

public extension AdwCenteringPolicy {
    /// Centering may slide off-axis under pressure.
    static let loose = ADW_CENTERING_POLICY_LOOSE
    /// Centering stays centered at all costs.
    static let strict = ADW_CENTERING_POLICY_STRICT
}

public extension AdwDialogPresentationMode {
    /// Choose based on window size.
    static let auto = ADW_DIALOG_AUTO
    /// Present as a floating dialog.
    static let floating = ADW_DIALOG_FLOATING
    /// Present as a bottom sheet.
    static let bottomSheet = ADW_DIALOG_BOTTOM_SHEET
}

public extension AdwJustifyMode {
    /// No justification.
    static let none = ADW_JUSTIFY_NONE
    /// Fill the available space evenly.
    static let fill = ADW_JUSTIFY_FILL
}

public extension AdwToolbarStyle {
    /// Flat style — no background tint.
    static let flat = ADW_TOOLBAR_FLAT
    /// Raised style — lifted surface.
    static let raised = ADW_TOOLBAR_RAISED
    /// Raised with a separator border.
    static let raisedBorder = ADW_TOOLBAR_RAISED_BORDER
}

public extension GtkAccessibleRole {
    /// A button that triggers an action when activated.
    static let button = GTK_ACCESSIBLE_ROLE_BUTTON
    /// A checkbox the user can toggle on or off.
    static let checkbox = GTK_ACCESSIBLE_ROLE_CHECKBOX
    /// A plain static label.
    static let label = GTK_ACCESSIBLE_ROLE_LABEL
    /// A link.
    static let link = GTK_ACCESSIBLE_ROLE_LINK
    /// A list of items.
    static let list = GTK_ACCESSIBLE_ROLE_LIST
    /// An item within a list.
    static let listItem = GTK_ACCESSIBLE_ROLE_LIST_ITEM
    /// A container grouping related widgets.
    static let group = GTK_ACCESSIBLE_ROLE_GROUP
    /// Generic container without specific role.
    static let generic = GTK_ACCESSIBLE_ROLE_GENERIC
    /// A search input.
    static let searchBox = GTK_ACCESSIBLE_ROLE_SEARCH_BOX
    /// A text entry.
    static let textBox = GTK_ACCESSIBLE_ROLE_TEXT_BOX
    /// A toolbar.
    static let toolbar = GTK_ACCESSIBLE_ROLE_TOOLBAR
    /// A tab within a tab list.
    static let tab = GTK_ACCESSIBLE_ROLE_TAB
    /// A tab list (row of tabs).
    static let tabList = GTK_ACCESSIBLE_ROLE_TAB_LIST
    /// A dialog / modal.
    static let dialog = GTK_ACCESSIBLE_ROLE_DIALOG
    /// An alert dialog.
    static let alertDialog = GTK_ACCESSIBLE_ROLE_ALERT_DIALOG
    /// Generic image role.
    static let img = GTK_ACCESSIBLE_ROLE_IMG
    /// Default / unspecified role.
    static let none = GTK_ACCESSIBLE_ROLE_NONE
}

// MARK: - Bitflag-style C enums

public extension GdkModifierType {
    /// Shift modifier.
    static let shift = GDK_SHIFT_MASK
    /// Lock modifier (Caps Lock).
    static let lock = GDK_LOCK_MASK
    /// Control modifier.
    static let control = GDK_CONTROL_MASK
    /// Alt modifier.
    static let alt = GDK_ALT_MASK
    /// Meta modifier.
    static let meta = GDK_META_MASK
    /// Super modifier (usually the platform / "windows" key).
    static let `super` = GDK_SUPER_MASK
    /// Hyper modifier.
    static let hyper = GDK_HYPER_MASK
    /// Primary mouse button pressed.
    static let button1 = GDK_BUTTON1_MASK
    /// Secondary mouse button pressed.
    static let button2 = GDK_BUTTON2_MASK
    /// Middle mouse button pressed.
    static let button3 = GDK_BUTTON3_MASK
    /// Fourth mouse button pressed.
    static let button4 = GDK_BUTTON4_MASK
    /// Fifth mouse button pressed.
    static let button5 = GDK_BUTTON5_MASK
}

public extension GdkDragAction {
    /// Copy the source data.
    static let copy = GDK_ACTION_COPY
    /// Move the source data (remove from origin).
    static let move = GDK_ACTION_MOVE
    /// Create a link to the source data.
    static let link = GDK_ACTION_LINK
    /// Ask the user which action to take.
    static let ask = GDK_ACTION_ASK
}

public extension GtkEventControllerScrollFlags {
    /// Don't emit scroll events for any axis.
    static let none = GTK_EVENT_CONTROLLER_SCROLL_NONE
    /// Emit scroll events for the vertical axis.
    static let vertical = GTK_EVENT_CONTROLLER_SCROLL_VERTICAL
    /// Emit scroll events for the horizontal axis.
    static let horizontal = GTK_EVENT_CONTROLLER_SCROLL_HORIZONTAL
    /// Emit discrete (mouse-wheel-style) scroll events.
    static let discrete = GTK_EVENT_CONTROLLER_SCROLL_DISCRETE
    /// Emit kinetic scroll-decelerate events.
    static let kinetic = GTK_EVENT_CONTROLLER_SCROLL_KINETIC
    /// Emit scroll events for both axes.
    static let bothAxes = GTK_EVENT_CONTROLLER_SCROLL_BOTH_AXES
}

public extension GtkInputHints {
    /// No hints.
    static let none = GTK_INPUT_HINT_NONE
    /// Suggest spelling corrections.
    static let spellcheck = GTK_INPUT_HINT_SPELLCHECK
    /// Do not suggest spelling corrections.
    static let noSpellcheck = GTK_INPUT_HINT_NO_SPELLCHECK
    /// Suggest word completions.
    static let wordCompletion = GTK_INPUT_HINT_WORD_COMPLETION
    /// Force lowercase input.
    static let lowercase = GTK_INPUT_HINT_LOWERCASE
    /// Force uppercase characters.
    static let uppercaseChars = GTK_INPUT_HINT_UPPERCASE_CHARS
    /// Capitalise the first letter of each word.
    static let uppercaseWords = GTK_INPUT_HINT_UPPERCASE_WORDS
    /// Capitalise the first letter of each sentence.
    static let uppercaseSentences = GTK_INPUT_HINT_UPPERCASE_SENTENCES
    /// Request the on-screen keyboard to stay hidden.
    static let inhibitOSK = GTK_INPUT_HINT_INHIBIT_OSK
    /// Input is vertical.
    static let verticalWriting = GTK_INPUT_HINT_VERTICAL_WRITING
    /// Show emoji keyboard.
    static let emoji = GTK_INPUT_HINT_EMOJI
    /// Hide emoji keyboard.
    static let noEmoji = GTK_INPUT_HINT_NO_EMOJI
    /// Treat content as private (suppress logging, autofill, etc.).
    static let `private` = GTK_INPUT_HINT_PRIVATE
}

public extension AdwTabViewShortcuts {
    /// No shortcuts.
    static let none = ADW_TAB_VIEW_SHORTCUT_NONE
    /// Ctrl+Tab — switch to next tab.
    static let controlTab = ADW_TAB_VIEW_SHORTCUT_CONTROL_TAB
    /// Ctrl+Shift+Tab — switch to previous tab.
    static let controlShiftTab = ADW_TAB_VIEW_SHORTCUT_CONTROL_SHIFT_TAB
    /// Ctrl+PageUp — switch to previous tab.
    static let controlPageUp = ADW_TAB_VIEW_SHORTCUT_CONTROL_PAGE_UP
    /// Ctrl+PageDown — switch to next tab.
    static let controlPageDown = ADW_TAB_VIEW_SHORTCUT_CONTROL_PAGE_DOWN
    /// Ctrl+Home — switch to first tab.
    static let controlHome = ADW_TAB_VIEW_SHORTCUT_CONTROL_HOME
    /// Ctrl+End — switch to last tab.
    static let controlEnd = ADW_TAB_VIEW_SHORTCUT_CONTROL_END
    /// Ctrl+Shift+PageUp — move tab left.
    static let controlShiftPageUp = ADW_TAB_VIEW_SHORTCUT_CONTROL_SHIFT_PAGE_UP
    /// Ctrl+Shift+PageDown — move tab right.
    static let controlShiftPageDown = ADW_TAB_VIEW_SHORTCUT_CONTROL_SHIFT_PAGE_DOWN
    /// Ctrl+Shift+Home — move tab to first.
    static let controlShiftHome = ADW_TAB_VIEW_SHORTCUT_CONTROL_SHIFT_HOME
    /// Ctrl+Shift+End — move tab to last.
    static let controlShiftEnd = ADW_TAB_VIEW_SHORTCUT_CONTROL_SHIFT_END
    /// Alt+1 through Alt+9 — switch to tabs 1–9.
    static let altDigits = ADW_TAB_VIEW_SHORTCUT_ALT_DIGITS
    /// Alt+0 — switch to tab 10.
    static let altZero = ADW_TAB_VIEW_SHORTCUT_ALT_ZERO
    /// All shortcuts enabled.
    static let allShortcuts = ADW_TAB_VIEW_SHORTCUT_ALL_SHORTCUTS
}

/// Swift-friendly option set for `GtkListScrollFlags`.
///
/// Controls behavior when programmatically scrolling list widgets
/// (`ListView`, `GridView`, `ColumnView`).
public struct ListScrollFlags: OptionSet, Sendable {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    /// Don't do anything extra — just scroll.
    public static let none = ListScrollFlags(rawValue: GTK_LIST_SCROLL_NONE.rawValue)
    /// Focus the target item after scrolling.
    public static let focus = ListScrollFlags(rawValue: GTK_LIST_SCROLL_FOCUS.rawValue)
    /// Select the target item and deselect all others.
    public static let select = ListScrollFlags(rawValue: GTK_LIST_SCROLL_SELECT.rawValue)
}
