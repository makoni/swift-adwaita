import CAdwaita

// MARK: - GTK Enums

extension GtkOrientation {
    /// Vertical orientation.
    public static let vertical = GTK_ORIENTATION_VERTICAL
    /// Horizontal orientation.
    public static let horizontal = GTK_ORIENTATION_HORIZONTAL
}

extension GtkAlign {
    /// Fill the available space.
    public static let fill = GTK_ALIGN_FILL
    /// Align to the start.
    public static let start = GTK_ALIGN_START
    /// Align to the end.
    public static let end = GTK_ALIGN_END
    /// Align to the center.
    public static let center = GTK_ALIGN_CENTER
    /// Use baseline alignment.
    public static let baseline = GTK_ALIGN_BASELINE_CENTER
}

extension GtkSelectionMode {
    /// No selection allowed.
    public static let none = GTK_SELECTION_NONE
    /// Single selection.
    public static let single = GTK_SELECTION_SINGLE
    /// Allow browsing selection.
    public static let browse = GTK_SELECTION_BROWSE
    /// Allow multiple selection.
    public static let multiple = GTK_SELECTION_MULTIPLE
}

extension GtkStackTransitionType {
    /// No transition.
    public static let none = GTK_STACK_TRANSITION_TYPE_NONE
    /// Crossfade transition.
    public static let crossfade = GTK_STACK_TRANSITION_TYPE_CROSSFADE
    /// Slide right transition.
    public static let slideRight = GTK_STACK_TRANSITION_TYPE_SLIDE_RIGHT
    /// Slide left transition.
    public static let slideLeft = GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT
    /// Slide up transition.
    public static let slideUp = GTK_STACK_TRANSITION_TYPE_SLIDE_UP
    /// Slide down transition.
    public static let slideDown = GTK_STACK_TRANSITION_TYPE_SLIDE_DOWN
    /// Slide left-right transition.
    public static let slideLeftRight = GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT
    /// Slide up-down transition.
    public static let slideUpDown = GTK_STACK_TRANSITION_TYPE_SLIDE_UP_DOWN
    /// Rotate left transition.
    public static let rotateLeft = GTK_STACK_TRANSITION_TYPE_ROTATE_LEFT
    /// Rotate right transition.
    public static let rotateRight = GTK_STACK_TRANSITION_TYPE_ROTATE_RIGHT
}

extension GtkRevealerTransitionType {
    /// No transition.
    public static let none = GTK_REVEALER_TRANSITION_TYPE_NONE
    /// Crossfade transition.
    public static let crossfade = GTK_REVEALER_TRANSITION_TYPE_CROSSFADE
    /// Slide right transition.
    public static let slideRight = GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT
    /// Slide left transition.
    public static let slideLeft = GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT
    /// Slide up transition.
    public static let slideUp = GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP
    /// Slide down transition.
    public static let slideDown = GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN
    /// Swing right transition.
    public static let swingRight = GTK_REVEALER_TRANSITION_TYPE_SWING_RIGHT
    /// Swing left transition.
    public static let swingLeft = GTK_REVEALER_TRANSITION_TYPE_SWING_LEFT
    /// Swing up transition.
    public static let swingUp = GTK_REVEALER_TRANSITION_TYPE_SWING_UP
    /// Swing down transition.
    public static let swingDown = GTK_REVEALER_TRANSITION_TYPE_SWING_DOWN
}

extension GtkPolicyType {
    /// Always show scrollbar.
    public static let always = GTK_POLICY_ALWAYS
    /// Show scrollbar automatically.
    public static let automatic = GTK_POLICY_AUTOMATIC
    /// Never show scrollbar.
    public static let never = GTK_POLICY_NEVER
    /// Show scrollbar as an external overlay.
    public static let external = GTK_POLICY_EXTERNAL
}

extension GtkWrapMode {
    /// No wrapping.
    public static let none = GTK_WRAP_NONE
    /// Wrap at character boundaries.
    public static let char = GTK_WRAP_CHAR
    /// Wrap at word boundaries.
    public static let word = GTK_WRAP_WORD
    /// Wrap at word boundaries, but fall back to char.
    public static let wordChar = GTK_WRAP_WORD_CHAR
}

extension GtkPositionType {
    /// Left position.
    public static let left = GTK_POS_LEFT
    /// Right position.
    public static let right = GTK_POS_RIGHT
    /// Top position.
    public static let top = GTK_POS_TOP
    /// Bottom position.
    public static let bottom = GTK_POS_BOTTOM
}

extension GtkContentFit {
    /// Fill the entire allocation, ignoring aspect ratio.
    public static let fill = GTK_CONTENT_FIT_FILL
    /// Scale to fit the allocation, preserving aspect ratio.
    public static let contain = GTK_CONTENT_FIT_CONTAIN
    /// Cover the entire allocation, preserving aspect ratio.
    public static let cover = GTK_CONTENT_FIT_COVER
    /// Scale down to fit, but never scale up.
    public static let scaleDown = GTK_CONTENT_FIT_SCALE_DOWN
}

extension GtkArrowType {
    /// Up arrow.
    public static let up = GTK_ARROW_UP
    /// Down arrow.
    public static let down = GTK_ARROW_DOWN
    /// Left arrow.
    public static let left = GTK_ARROW_LEFT
    /// Right arrow.
    public static let right = GTK_ARROW_RIGHT
    /// No arrow.
    public static let none = GTK_ARROW_NONE
}

extension GtkLicense {
    /// Unknown license.
    public static let unknown = GTK_LICENSE_UNKNOWN
    /// Custom license.
    public static let custom = GTK_LICENSE_CUSTOM
    /// GPL 2.0.
    public static let gpl20 = GTK_LICENSE_GPL_2_0
    /// GPL 3.0.
    public static let gpl30 = GTK_LICENSE_GPL_3_0
    /// LGPL 2.1.
    public static let lgpl21 = GTK_LICENSE_LGPL_2_1
    /// LGPL 3.0.
    public static let lgpl30 = GTK_LICENSE_LGPL_3_0
    /// MIT license.
    public static let mit = GTK_LICENSE_MIT_X11
    /// Apache 2.0.
    public static let apache20 = GTK_LICENSE_APACHE_2_0
}

// MARK: - Adwaita Enums

extension AdwResponseAppearance {
    /// Default appearance.
    public static let `default` = ADW_RESPONSE_DEFAULT
    /// Suggested action appearance.
    public static let suggested = ADW_RESPONSE_SUGGESTED
    /// Destructive action appearance.
    public static let destructive = ADW_RESPONSE_DESTRUCTIVE
}

extension AdwColorScheme {
    /// Default color scheme.
    public static let `default` = ADW_COLOR_SCHEME_DEFAULT
    /// Force light theme.
    public static let forceLight = ADW_COLOR_SCHEME_FORCE_LIGHT
    /// Prefer light theme.
    public static let preferLight = ADW_COLOR_SCHEME_PREFER_LIGHT
    /// Prefer dark theme.
    public static let preferDark = ADW_COLOR_SCHEME_PREFER_DARK
    /// Force dark theme.
    public static let forceDark = ADW_COLOR_SCHEME_FORCE_DARK
}

extension AdwLengthUnit {
    /// Pixels.
    public static let px = ADW_LENGTH_UNIT_PX
    /// Points.
    public static let pt = ADW_LENGTH_UNIT_PT
    /// Scale-independent pixels.
    public static let sp = ADW_LENGTH_UNIT_SP
}

extension AdwNavigationDirection {
    /// Back direction.
    public static let back = ADW_NAVIGATION_DIRECTION_BACK
    /// Forward direction.
    public static let forward = ADW_NAVIGATION_DIRECTION_FORWARD
}

extension AdwEasing {
    /// Linear easing.
    public static let linear = ADW_LINEAR
    /// Ease-in cubic.
    public static let easeInCubic = ADW_EASE_IN_CUBIC
    /// Ease-out cubic.
    public static let easeOutCubic = ADW_EASE_OUT_CUBIC
    /// Ease-in-out cubic.
    public static let easeInOutCubic = ADW_EASE_IN_OUT_CUBIC
}

extension AdwToastPriority {
    /// Normal priority.
    public static let normal = ADW_TOAST_PRIORITY_NORMAL
    /// High priority.
    public static let high = ADW_TOAST_PRIORITY_HIGH
}

extension AdwViewSwitcherPolicy {
    /// Narrow policy.
    public static let narrow = ADW_VIEW_SWITCHER_POLICY_NARROW
    /// Wide policy.
    public static let wide = ADW_VIEW_SWITCHER_POLICY_WIDE
}

extension GtkPackType {
    /// Start side (left for LTR).
    public static let start = GTK_PACK_START
    /// End side (right for LTR).
    public static let end = GTK_PACK_END
}

extension GtkJustification {
    /// Left justified.
    public static let left = GTK_JUSTIFY_LEFT
    /// Right justified.
    public static let right = GTK_JUSTIFY_RIGHT
    /// Centered.
    public static let center = GTK_JUSTIFY_CENTER
    /// Fill the available width.
    public static let fill = GTK_JUSTIFY_FILL
}

extension AdwAnimationState {
    /// Idle state.
    public static let idle = ADW_ANIMATION_IDLE
    /// Paused state.
    public static let paused = ADW_ANIMATION_PAUSED
    /// Playing state.
    public static let playing = ADW_ANIMATION_PLAYING
    /// Finished state.
    public static let finished = ADW_ANIMATION_FINISHED
}
