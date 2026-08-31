// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#pragma once

#include <adwaita.h>
#include <gdk-pixbuf/gdk-pixbuf.h>

// ---------------------------------------------------------------------------
// GTK compatibility helpers.
// ---------------------------------------------------------------------------

// gtk_widget_get_allocation is deprecated in GTK 4.12 in favour of
// gtk_widget_compute_bounds, but compute_bounds traverses the widget
// hierarchy (including viewport clip regions) and can trigger
// Gtk-CRITICAL assertions in partially-initialised scrolled-window
// trees. The allocation cache that get_allocation reads is safe and
// accurate for scroll-into-view queries. Suppress the deprecation here
// so the call in Widget+Allocation.swift compiles cleanly.
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
static inline void swiftadw_widget_get_allocation(GtkWidget *widget, GtkAllocation *alloc) {
    gtk_widget_get_allocation(widget, alloc);
}
#pragma GCC diagnostic pop

static inline void swiftadw_gtk_calendar_set_date_compat(GtkCalendar *calendar, GDateTime *date) {
#if GTK_CHECK_VERSION(4, 20, 0)
    gtk_calendar_set_date(calendar, date);
#else
    gtk_calendar_select_day(calendar, date);
#endif
}

// ---------------------------------------------------------------------------
// Helper to emit a GObject signal by name with no arguments.
// g_signal_emit_by_name is variadic and cannot be called directly from Swift.
// ---------------------------------------------------------------------------
static inline void g_signal_emit_by_name_no_args(gpointer instance, const gchar *signal_name) {
    g_signal_emit_by_name(instance, signal_name);
}

static inline void swiftadw_gesture_click_emit_released(
    GtkGestureClick *gesture,
    int n_press,
    double x,
    double y
) {
    g_signal_emit_by_name(gesture, "released", n_press, x, y);
}

// ---------------------------------------------------------------------------
// GdkPixbufAnimation shims (gdk-pixbuf >= 2.44).
//
// gdk-pixbuf 2.44 (February 2026, Ubuntu 26.04) soft-deprecated the whole
// animation API with `GDK_PIXBUF_DEPRECATED_IN_2_44` macros, without shipping
// a direct replacement: the deprecation notice literally says "Use a different
// image loading library for animatable assets". The replacement path GNOME is
// converging on is `libglycin`, but:
//
//   * Ubuntu 26.04 currently ships `glycin 2.1~beta+ds-0ubuntu3`, which has
//     observable stability issues (SIGSEGV in background sandbox cleanup).
//   * Upstream stable `glycin 2.1.1` landed in GNOME 50.1 on 2026-04-11; the
//     distro packages should catch up within the 50.x cycle.
//   * `libglycin 2.x` supports the forthcoming `glycin 3.x`, which is the
//     stabilisation target we want before migrating. Likely shipped with
//     GNOME 51 on 2026-09-16.
//
// Until then we keep using GdkPixbufAnimation — it still works, the symbols
// aren't going away soon, and the current code in AnimatedImagePlayer.swift
// matches the frame-by-frame extraction model better than GtkMediaFile
// (which is a video player with a GStreamer/ffmpeg backend dependency and
// doesn't handle animated GIF/WebP gracefully — see
// https://discourse.gnome.org/t/help-rendering-paintable-animations-gif-
// through-mediafile-picture-in-gtk4/7092).
//
// See also: Sources/Adwaita/GtkWidgets/AnimatedImagePlayer.swift
//           notes/1ac7cccb-11d2-4805-8b27-ba595616ec8a
// ---------------------------------------------------------------------------

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

static inline GdkPixbufAnimation *swiftadw_pixbuf_animation_new_from_file(
    const char *filename,
    GError **error
) {
    return gdk_pixbuf_animation_new_from_file(filename, error);
}

static inline gboolean swiftadw_pixbuf_animation_is_static_image(GdkPixbufAnimation *animation) {
    return gdk_pixbuf_animation_is_static_image(animation);
}

static inline GdkPixbufAnimationIter *swiftadw_pixbuf_animation_get_iter(
    GdkPixbufAnimation *animation,
    const GTimeVal *start_time
) {
    return gdk_pixbuf_animation_get_iter(animation, start_time);
}

static inline int swiftadw_pixbuf_animation_get_width(GdkPixbufAnimation *animation) {
    return gdk_pixbuf_animation_get_width(animation);
}

static inline int swiftadw_pixbuf_animation_get_height(GdkPixbufAnimation *animation) {
    return gdk_pixbuf_animation_get_height(animation);
}

static inline GdkPixbuf *swiftadw_pixbuf_animation_iter_get_pixbuf(GdkPixbufAnimationIter *iter) {
    return gdk_pixbuf_animation_iter_get_pixbuf(iter);
}

static inline int swiftadw_pixbuf_animation_iter_get_delay_time(GdkPixbufAnimationIter *iter) {
    return gdk_pixbuf_animation_iter_get_delay_time(iter);
}

static inline gboolean swiftadw_pixbuf_animation_iter_advance(
    GdkPixbufAnimationIter *iter,
    const GTimeVal *current_time
) {
    return gdk_pixbuf_animation_iter_advance(iter, current_time);
}

#pragma GCC diagnostic pop

// ---------------------------------------------------------------------------
// Compile-time stubs for libadwaita 1.6+ / 1.7+ / 1.8+ symbols.
//
// When building against older headers (e.g. libadwaita 1.5 on Ubuntu 24.04),
// these forward-declared types and stub functions ensure compilation succeeds.
// Stubs return NULL/0; runtime checks (AdwaitaVersion.isAtLeast) in Swift
// prevent calling on systems where the real implementation is missing.
// ---------------------------------------------------------------------------

#if !ADW_CHECK_VERSION(1, 6, 0)

typedef struct _AdwBottomSheet AdwBottomSheet;
typedef struct _AdwButtonRow AdwButtonRow;
typedef struct _AdwSpinnerPaintable AdwSpinnerPaintable;
typedef unsigned int AdwAccentColor;

// BottomSheet (1.6+)
static inline GtkWidget *adw_bottom_sheet_new(void) { return NULL; }
static inline float adw_bottom_sheet_get_align(AdwBottomSheet *s) { (void)s; return 0.0f; }
static inline void adw_bottom_sheet_set_align(AdwBottomSheet *s, float a) { (void)s; (void)a; }
static inline GtkWidget *adw_bottom_sheet_get_bottom_bar(AdwBottomSheet *s) { (void)s; return NULL; }
static inline void adw_bottom_sheet_set_bottom_bar(AdwBottomSheet *s, GtkWidget *w) { (void)s; (void)w; }
static inline int adw_bottom_sheet_get_bottom_bar_height(AdwBottomSheet *s) { (void)s; return 0; }
static inline gboolean adw_bottom_sheet_get_can_close(AdwBottomSheet *s) { (void)s; return 0; }
static inline void adw_bottom_sheet_set_can_close(AdwBottomSheet *s, gboolean v) { (void)s; (void)v; }
static inline gboolean adw_bottom_sheet_get_can_open(AdwBottomSheet *s) { (void)s; return 0; }
static inline void adw_bottom_sheet_set_can_open(AdwBottomSheet *s, gboolean v) { (void)s; (void)v; }
static inline GtkWidget *adw_bottom_sheet_get_content(AdwBottomSheet *s) { (void)s; return NULL; }
static inline void adw_bottom_sheet_set_content(AdwBottomSheet *s, GtkWidget *w) { (void)s; (void)w; }
static inline gboolean adw_bottom_sheet_get_full_width(AdwBottomSheet *s) { (void)s; return 0; }
static inline void adw_bottom_sheet_set_full_width(AdwBottomSheet *s, gboolean v) { (void)s; (void)v; }
static inline gboolean adw_bottom_sheet_get_modal(AdwBottomSheet *s) { (void)s; return 0; }
static inline void adw_bottom_sheet_set_modal(AdwBottomSheet *s, gboolean v) { (void)s; (void)v; }
static inline gboolean adw_bottom_sheet_get_open(AdwBottomSheet *s) { (void)s; return 0; }
static inline void adw_bottom_sheet_set_open(AdwBottomSheet *s, gboolean v) { (void)s; (void)v; }
static inline GtkWidget *adw_bottom_sheet_get_sheet(AdwBottomSheet *s) { (void)s; return NULL; }
static inline void adw_bottom_sheet_set_sheet(AdwBottomSheet *s, GtkWidget *w) { (void)s; (void)w; }
static inline int adw_bottom_sheet_get_sheet_height(AdwBottomSheet *s) { (void)s; return 0; }
static inline gboolean adw_bottom_sheet_get_show_drag_handle(AdwBottomSheet *s) { (void)s; return 0; }
static inline void adw_bottom_sheet_set_show_drag_handle(AdwBottomSheet *s, gboolean v) { (void)s; (void)v; }

// ButtonRow (1.6+)
static inline GtkWidget *adw_button_row_new(void) { return NULL; }
static inline const char *adw_button_row_get_end_icon_name(AdwButtonRow *s) { (void)s; return NULL; }
static inline void adw_button_row_set_end_icon_name(AdwButtonRow *s, const char *n) { (void)s; (void)n; }
static inline const char *adw_button_row_get_start_icon_name(AdwButtonRow *s) { (void)s; return NULL; }
static inline void adw_button_row_set_start_icon_name(AdwButtonRow *s, const char *n) { (void)s; (void)n; }

// Spinner (1.6+)
static inline GtkWidget *adw_spinner_new(void) { return NULL; }

// SpinnerPaintable (1.6+)
static inline AdwSpinnerPaintable *adw_spinner_paintable_new(GtkWidget *w) { (void)w; return NULL; }
static inline GtkWidget *adw_spinner_paintable_get_widget(AdwSpinnerPaintable *s) { (void)s; return NULL; }
static inline void adw_spinner_paintable_set_widget(AdwSpinnerPaintable *s, GtkWidget *w) { (void)s; (void)w; }

// AlertDialog.preferWideLayout (1.6+)
static inline gboolean adw_alert_dialog_get_prefer_wide_layout(AdwAlertDialog *s) { (void)s; return 0; }
static inline void adw_alert_dialog_set_prefer_wide_layout(AdwAlertDialog *s, gboolean v) { (void)s; (void)v; }

// PreferencesGroup (1.6+)
static inline gboolean adw_preferences_group_get_separate_rows(AdwPreferencesGroup *s) { (void)s; return 0; }
static inline void adw_preferences_group_set_separate_rows(AdwPreferencesGroup *s, gboolean v) { (void)s; (void)v; }

// PreferencesPage (1.6+)
static inline gboolean adw_preferences_page_get_description_centered(AdwPreferencesPage *s) { (void)s; return 0; }
static inline void adw_preferences_page_set_description_centered(AdwPreferencesPage *s, gboolean v) { (void)s; (void)v; }

// StyleManager (1.6+)
static inline AdwAccentColor adw_style_manager_get_accent_color(AdwStyleManager *s) { (void)s; return (AdwAccentColor)0; }
static inline gboolean adw_style_manager_get_system_supports_accent_colors(AdwStyleManager *s) { (void)s; return 0; }

#endif /* !ADW_CHECK_VERSION(1, 6, 0) */

#if !ADW_CHECK_VERSION(1, 7, 0)

typedef struct _AdwToggle AdwToggle;
typedef struct _AdwToggleGroup AdwToggleGroup;
typedef struct _AdwWrapBox AdwWrapBox;
typedef struct _AdwWrapLayout AdwWrapLayout;
typedef unsigned int AdwJustifyMode;
#define ADW_JUSTIFY_NONE ((AdwJustifyMode)0)
#define ADW_JUSTIFY_FILL ((AdwJustifyMode)1)
typedef unsigned int AdwPackDirection;
typedef unsigned int AdwWrapPolicy;
typedef unsigned int AdwBannerButtonStyle;

// Toggle (1.7+)
static inline AdwToggle *adw_toggle_new(void) { return NULL; }
static inline GtkWidget *adw_toggle_get_child(AdwToggle *s) { (void)s; return NULL; }
static inline void adw_toggle_set_child(AdwToggle *s, GtkWidget *c) { (void)s; (void)c; }
static inline gboolean adw_toggle_get_enabled(AdwToggle *s) { (void)s; return 0; }
static inline void adw_toggle_set_enabled(AdwToggle *s, gboolean v) { (void)s; (void)v; }
static inline const char *adw_toggle_get_icon_name(AdwToggle *s) { (void)s; return NULL; }
static inline void adw_toggle_set_icon_name(AdwToggle *s, const char *n) { (void)s; (void)n; }
static inline const char *adw_toggle_get_label(AdwToggle *s) { (void)s; return NULL; }
static inline void adw_toggle_set_label(AdwToggle *s, const char *l) { (void)s; (void)l; }
static inline const char *adw_toggle_get_name(AdwToggle *s) { (void)s; return NULL; }
static inline void adw_toggle_set_name(AdwToggle *s, const char *n) { (void)s; (void)n; }
static inline const char *adw_toggle_get_tooltip(AdwToggle *s) { (void)s; return NULL; }
static inline void adw_toggle_set_tooltip(AdwToggle *s, const char *t) { (void)s; (void)t; }
static inline gboolean adw_toggle_get_use_underline(AdwToggle *s) { (void)s; return 0; }
static inline void adw_toggle_set_use_underline(AdwToggle *s, gboolean v) { (void)s; (void)v; }
static inline int adw_toggle_get_index(AdwToggle *s) { (void)s; return -1; }

// ToggleGroup (1.7+)
static inline GtkWidget *adw_toggle_group_new(void) { return NULL; }
static inline guint adw_toggle_group_get_active(AdwToggleGroup *s) { (void)s; return 0; }
static inline void adw_toggle_group_set_active(AdwToggleGroup *s, guint v) { (void)s; (void)v; }
static inline const char *adw_toggle_group_get_active_name(AdwToggleGroup *s) { (void)s; return NULL; }
static inline void adw_toggle_group_set_active_name(AdwToggleGroup *s, const char *n) { (void)s; (void)n; }
static inline gboolean adw_toggle_group_get_can_shrink(AdwToggleGroup *s) { (void)s; return 0; }
static inline void adw_toggle_group_set_can_shrink(AdwToggleGroup *s, gboolean v) { (void)s; (void)v; }
static inline gboolean adw_toggle_group_get_homogeneous(AdwToggleGroup *s) { (void)s; return 0; }
static inline void adw_toggle_group_set_homogeneous(AdwToggleGroup *s, gboolean v) { (void)s; (void)v; }
static inline guint adw_toggle_group_get_n_toggles(AdwToggleGroup *s) { (void)s; return 0; }
static inline void adw_toggle_group_add(AdwToggleGroup *s, AdwToggle *t) { (void)s; (void)t; }
static inline AdwToggle *adw_toggle_group_get_toggle(AdwToggleGroup *s, guint i) { (void)s; (void)i; return NULL; }
static inline AdwToggle *adw_toggle_group_get_toggle_by_name(AdwToggleGroup *s, const char *n) { (void)s; (void)n; return NULL; }
static inline void adw_toggle_group_remove(AdwToggleGroup *s, AdwToggle *t) { (void)s; (void)t; }
static inline void adw_toggle_group_remove_all(AdwToggleGroup *s) { (void)s; }

// WrapBox (1.7+)
static inline GtkWidget *adw_wrap_box_new(void) { return NULL; }
static inline float adw_wrap_box_get_align(AdwWrapBox *s) { (void)s; return 0.0f; }
static inline void adw_wrap_box_set_align(AdwWrapBox *s, float a) { (void)s; (void)a; }
static inline int adw_wrap_box_get_child_spacing(AdwWrapBox *s) { (void)s; return 0; }
static inline void adw_wrap_box_set_child_spacing(AdwWrapBox *s, int v) { (void)s; (void)v; }
static inline AdwLengthUnit adw_wrap_box_get_child_spacing_unit(AdwWrapBox *s) { (void)s; return (AdwLengthUnit)0; }
static inline void adw_wrap_box_set_child_spacing_unit(AdwWrapBox *s, AdwLengthUnit u) { (void)s; (void)u; }
static inline AdwJustifyMode adw_wrap_box_get_justify(AdwWrapBox *s) { (void)s; return (AdwJustifyMode)0; }
static inline void adw_wrap_box_set_justify(AdwWrapBox *s, AdwJustifyMode j) { (void)s; (void)j; }
static inline gboolean adw_wrap_box_get_justify_last_line(AdwWrapBox *s) { (void)s; return 0; }
static inline void adw_wrap_box_set_justify_last_line(AdwWrapBox *s, gboolean v) { (void)s; (void)v; }
static inline gboolean adw_wrap_box_get_line_homogeneous(AdwWrapBox *s) { (void)s; return 0; }
static inline void adw_wrap_box_set_line_homogeneous(AdwWrapBox *s, gboolean v) { (void)s; (void)v; }
static inline int adw_wrap_box_get_line_spacing(AdwWrapBox *s) { (void)s; return 0; }
static inline void adw_wrap_box_set_line_spacing(AdwWrapBox *s, int v) { (void)s; (void)v; }
static inline AdwLengthUnit adw_wrap_box_get_line_spacing_unit(AdwWrapBox *s) { (void)s; return (AdwLengthUnit)0; }
static inline void adw_wrap_box_set_line_spacing_unit(AdwWrapBox *s, AdwLengthUnit u) { (void)s; (void)u; }
static inline int adw_wrap_box_get_natural_line_length(AdwWrapBox *s) { (void)s; return 0; }
static inline void adw_wrap_box_set_natural_line_length(AdwWrapBox *s, int v) { (void)s; (void)v; }
static inline AdwLengthUnit adw_wrap_box_get_natural_line_length_unit(AdwWrapBox *s) { (void)s; return (AdwLengthUnit)0; }
static inline void adw_wrap_box_set_natural_line_length_unit(AdwWrapBox *s, AdwLengthUnit u) { (void)s; (void)u; }
static inline AdwPackDirection adw_wrap_box_get_pack_direction(AdwWrapBox *s) { (void)s; return (AdwPackDirection)0; }
static inline void adw_wrap_box_set_pack_direction(AdwWrapBox *s, AdwPackDirection d) { (void)s; (void)d; }
static inline AdwWrapPolicy adw_wrap_box_get_wrap_policy(AdwWrapBox *s) { (void)s; return (AdwWrapPolicy)0; }
static inline void adw_wrap_box_set_wrap_policy(AdwWrapBox *s, AdwWrapPolicy p) { (void)s; (void)p; }
static inline gboolean adw_wrap_box_get_wrap_reverse(AdwWrapBox *s) { (void)s; return 0; }
static inline void adw_wrap_box_set_wrap_reverse(AdwWrapBox *s, gboolean v) { (void)s; (void)v; }
static inline void adw_wrap_box_append(AdwWrapBox *s, GtkWidget *c) { (void)s; (void)c; }
static inline void adw_wrap_box_insert_child_after(AdwWrapBox *s, GtkWidget *c, GtkWidget *b) { (void)s; (void)c; (void)b; }
static inline void adw_wrap_box_prepend(AdwWrapBox *s, GtkWidget *c) { (void)s; (void)c; }
static inline void adw_wrap_box_remove(AdwWrapBox *s, GtkWidget *c) { (void)s; (void)c; }
static inline void adw_wrap_box_reorder_child_after(AdwWrapBox *s, GtkWidget *c, GtkWidget *b) { (void)s; (void)c; (void)b; }

// WrapLayout (1.7+)
static inline GtkLayoutManager *adw_wrap_layout_new(void) { return NULL; }
static inline float adw_wrap_layout_get_align(AdwWrapLayout *s) { (void)s; return 0.0f; }
static inline void adw_wrap_layout_set_align(AdwWrapLayout *s, float a) { (void)s; (void)a; }
static inline int adw_wrap_layout_get_child_spacing(AdwWrapLayout *s) { (void)s; return 0; }
static inline void adw_wrap_layout_set_child_spacing(AdwWrapLayout *s, int v) { (void)s; (void)v; }
static inline AdwLengthUnit adw_wrap_layout_get_child_spacing_unit(AdwWrapLayout *s) { (void)s; return (AdwLengthUnit)0; }
static inline void adw_wrap_layout_set_child_spacing_unit(AdwWrapLayout *s, AdwLengthUnit u) { (void)s; (void)u; }
static inline AdwJustifyMode adw_wrap_layout_get_justify(AdwWrapLayout *s) { (void)s; return (AdwJustifyMode)0; }
static inline void adw_wrap_layout_set_justify(AdwWrapLayout *s, AdwJustifyMode j) { (void)s; (void)j; }
static inline gboolean adw_wrap_layout_get_justify_last_line(AdwWrapLayout *s) { (void)s; return 0; }
static inline void adw_wrap_layout_set_justify_last_line(AdwWrapLayout *s, gboolean v) { (void)s; (void)v; }
static inline gboolean adw_wrap_layout_get_line_homogeneous(AdwWrapLayout *s) { (void)s; return 0; }
static inline void adw_wrap_layout_set_line_homogeneous(AdwWrapLayout *s, gboolean v) { (void)s; (void)v; }
static inline int adw_wrap_layout_get_line_spacing(AdwWrapLayout *s) { (void)s; return 0; }
static inline void adw_wrap_layout_set_line_spacing(AdwWrapLayout *s, int v) { (void)s; (void)v; }
static inline AdwLengthUnit adw_wrap_layout_get_line_spacing_unit(AdwWrapLayout *s) { (void)s; return (AdwLengthUnit)0; }
static inline void adw_wrap_layout_set_line_spacing_unit(AdwWrapLayout *s, AdwLengthUnit u) { (void)s; (void)u; }
static inline int adw_wrap_layout_get_natural_line_length(AdwWrapLayout *s) { (void)s; return 0; }
static inline void adw_wrap_layout_set_natural_line_length(AdwWrapLayout *s, int v) { (void)s; (void)v; }
static inline AdwLengthUnit adw_wrap_layout_get_natural_line_length_unit(AdwWrapLayout *s) { (void)s; return (AdwLengthUnit)0; }
static inline void adw_wrap_layout_set_natural_line_length_unit(AdwWrapLayout *s, AdwLengthUnit u) { (void)s; (void)u; }
static inline AdwPackDirection adw_wrap_layout_get_pack_direction(AdwWrapLayout *s) { (void)s; return (AdwPackDirection)0; }
static inline void adw_wrap_layout_set_pack_direction(AdwWrapLayout *s, AdwPackDirection d) { (void)s; (void)d; }
static inline AdwWrapPolicy adw_wrap_layout_get_wrap_policy(AdwWrapLayout *s) { (void)s; return (AdwWrapPolicy)0; }
static inline void adw_wrap_layout_set_wrap_policy(AdwWrapLayout *s, AdwWrapPolicy p) { (void)s; (void)p; }
static inline gboolean adw_wrap_layout_get_wrap_reverse(AdwWrapLayout *s) { (void)s; return 0; }
static inline void adw_wrap_layout_set_wrap_reverse(AdwWrapLayout *s, gboolean v) { (void)s; (void)v; }

// BottomSheet.revealBottomBar (1.7+)
static inline gboolean adw_bottom_sheet_get_reveal_bottom_bar(AdwBottomSheet *s) { (void)s; return 0; }
static inline void adw_bottom_sheet_set_reveal_bottom_bar(AdwBottomSheet *s, gboolean v) { (void)s; (void)v; }

// Banner.buttonStyle (1.7+)
static inline AdwBannerButtonStyle adw_banner_get_button_style(AdwBanner *s) { (void)s; return (AdwBannerButtonStyle)0; }
static inline void adw_banner_set_button_style(AdwBanner *s, AdwBannerButtonStyle v) { (void)s; (void)v; }

// NavigationView (1.7+)
static inline gboolean adw_navigation_view_get_hhomogeneous(AdwNavigationView *s) { (void)s; return 0; }
static inline void adw_navigation_view_set_hhomogeneous(AdwNavigationView *s, gboolean v) { (void)s; (void)v; }
static inline gboolean adw_navigation_view_get_vhomogeneous(AdwNavigationView *s) { (void)s; return 0; }
static inline void adw_navigation_view_set_vhomogeneous(AdwNavigationView *s, gboolean v) { (void)s; (void)v; }
static inline const char *adw_navigation_view_get_visible_page_tag(AdwNavigationView *s) { (void)s; return NULL; }

// ViewStack transitions (1.7+)
static inline gboolean adw_view_stack_get_enable_transitions(AdwViewStack *s) { (void)s; return 0; }
static inline void adw_view_stack_set_enable_transitions(AdwViewStack *s, gboolean v) { (void)s; (void)v; }
static inline guint adw_view_stack_get_transition_duration(AdwViewStack *s) { (void)s; return 0; }
static inline void adw_view_stack_set_transition_duration(AdwViewStack *s, guint v) { (void)s; (void)v; }
static inline gboolean adw_view_stack_get_transition_running(AdwViewStack *s) { (void)s; return 0; }

// StyleManager fonts (1.7+)
static inline const char *adw_style_manager_get_document_font_name(AdwStyleManager *s) { (void)s; return ""; }
static inline const char *adw_style_manager_get_monospace_font_name(AdwStyleManager *s) { (void)s; return ""; }

// PreferencesPage.banner (1.7+)
static inline AdwBanner *adw_preferences_page_get_banner(AdwPreferencesPage *s) { (void)s; return NULL; }
static inline void adw_preferences_page_set_banner(AdwPreferencesPage *s, AdwBanner *b) { (void)s; (void)b; }

// Window.adaptivePreview (1.7+)
static inline gboolean adw_window_get_adaptive_preview(AdwWindow *s) { (void)s; return 0; }
static inline void adw_window_set_adaptive_preview(AdwWindow *s, gboolean v) { (void)s; (void)v; }

// AboutDialog.addOtherApp (1.7+)
static inline void adw_about_dialog_add_other_app(AdwAboutDialog *s, const char *id, const char *name, const char *summary) { (void)s; (void)id; (void)name; (void)summary; }

// ToastOverlay.dismissAll (1.7+)
static inline void adw_toast_overlay_dismiss_all(AdwToastOverlay *s) { (void)s; }

#endif /* !ADW_CHECK_VERSION(1, 7, 0) */

#if !ADW_CHECK_VERSION(1, 8, 0)

typedef struct _AdwShortcutLabel AdwShortcutLabel;
typedef struct _AdwShortcutsDialog AdwShortcutsDialog;
typedef struct _AdwShortcutsSection AdwShortcutsSection;
typedef struct _AdwShortcutsItem AdwShortcutsItem;

// PreferencesGroup.getRow (1.8+)
static inline GtkWidget *adw_preferences_group_get_row(AdwPreferencesGroup *s, guint i) { (void)s; (void)i; return NULL; }

// PreferencesPage.getGroup (1.8+)
static inline AdwPreferencesGroup *adw_preferences_page_get_group(AdwPreferencesPage *s, guint i) { (void)s; (void)i; return NULL; }

// WrapBox.removeAll (1.8+)
static inline void adw_wrap_box_remove_all(AdwWrapBox *s) { (void)s; }

// ShortcutLabel (1.8+)
static inline GtkWidget *adw_shortcut_label_new(const char *a) { (void)a; return NULL; }
static inline const char *adw_shortcut_label_get_accelerator(AdwShortcutLabel *s) { (void)s; return ""; }
static inline void adw_shortcut_label_set_accelerator(AdwShortcutLabel *s, const char *a) { (void)s; (void)a; }
static inline const char *adw_shortcut_label_get_disabled_text(AdwShortcutLabel *s) { (void)s; return ""; }
static inline void adw_shortcut_label_set_disabled_text(AdwShortcutLabel *s, const char *t) { (void)s; (void)t; }

// ShortcutsDialog (1.8+)
static inline GtkWidget *adw_shortcuts_dialog_new(void) { return NULL; }
static inline void adw_shortcuts_dialog_add(AdwShortcutsDialog *s, AdwShortcutsSection *sec) { (void)s; (void)sec; }

// ShortcutsSection (1.8+)
static inline AdwShortcutsSection *adw_shortcuts_section_new(const char *t) { (void)t; return NULL; }
static inline const char *adw_shortcuts_section_get_title(AdwShortcutsSection *s) { (void)s; return NULL; }
static inline void adw_shortcuts_section_set_title(AdwShortcutsSection *s, const char *t) { (void)s; (void)t; }
static inline void adw_shortcuts_section_add(AdwShortcutsSection *s, AdwShortcutsItem *i) { (void)s; (void)i; }

// ShortcutsItem (1.8+)
static inline AdwShortcutsItem *adw_shortcuts_item_new(const char *t, const char *a) { (void)t; (void)a; return NULL; }
static inline AdwShortcutsItem *adw_shortcuts_item_new_from_action(const char *t, const char *a) { (void)t; (void)a; return NULL; }
static inline const char *adw_shortcuts_item_get_accelerator(AdwShortcutsItem *s) { (void)s; return ""; }
static inline void adw_shortcuts_item_set_accelerator(AdwShortcutsItem *s, const char *a) { (void)s; (void)a; }
static inline const char *adw_shortcuts_item_get_action_name(AdwShortcutsItem *s) { (void)s; return ""; }
static inline void adw_shortcuts_item_set_action_name(AdwShortcutsItem *s, const char *a) { (void)s; (void)a; }
static inline GtkTextDirection adw_shortcuts_item_get_direction(AdwShortcutsItem *s) { (void)s; return (GtkTextDirection)0; }
static inline void adw_shortcuts_item_set_direction(AdwShortcutsItem *s, GtkTextDirection d) { (void)s; (void)d; }
static inline const char *adw_shortcuts_item_get_subtitle(AdwShortcutsItem *s) { (void)s; return ""; }
static inline void adw_shortcuts_item_set_subtitle(AdwShortcutsItem *s, const char *t) { (void)s; (void)t; }
static inline const char *adw_shortcuts_item_get_title(AdwShortcutsItem *s) { (void)s; return ""; }
static inline void adw_shortcuts_item_set_title(AdwShortcutsItem *s, const char *t) { (void)s; (void)t; }

#endif /* !ADW_CHECK_VERSION(1, 8, 0) */

// g_signal_connect is a macro that Swift cannot import.
// Provide inline wrappers around g_signal_connect_data.

static inline gulong
cadw_signal_connect(gpointer instance, const gchar *detailed_signal,
                    GCallback c_handler, gpointer data)
{
    return g_signal_connect_data(instance, detailed_signal, c_handler, data,
                                NULL, (GConnectFlags)0);
}

static inline gulong
cadw_signal_connect_with_destroy(gpointer instance, const gchar *detailed_signal,
                                 GCallback c_handler, gpointer data,
                                 GClosureNotify destroy_data,
                                 GConnectFlags connect_flags)
{
    return g_signal_connect_data(instance, detailed_signal, c_handler, data,
                                 destroy_data, connect_flags);
}

static inline gulong
cadw_signal_connect_after(gpointer instance, const gchar *detailed_signal,
                          GCallback c_handler, gpointer data)
{
    return g_signal_connect_data(instance, detailed_signal, c_handler, data,
                                NULL, G_CONNECT_AFTER);
}

static inline gulong
cadw_signal_connect_swapped(gpointer instance, const gchar *detailed_signal,
                            GCallback c_handler, gpointer data)
{
    return g_signal_connect_data(instance, detailed_signal, c_handler, data,
                                NULL, G_CONNECT_SWAPPED);
}

// GObject casting macros are not importable in Swift.
// Provide typed cast helpers.

static inline GObject *
cadw_cast_gobject(gpointer obj)
{
    return G_OBJECT(obj);
}

static inline GtkWidget *
cadw_cast_widget(gpointer obj)
{
    return GTK_WIDGET(obj);
}

static inline GtkWindow *
cadw_cast_window(gpointer obj)
{
    return GTK_WINDOW(obj);
}

static inline GtkApplication *
cadw_cast_application(gpointer obj)
{
    return GTK_APPLICATION(obj);
}

static inline AdwApplication *
cadw_cast_adw_application(gpointer obj)
{
    return ADW_APPLICATION(obj);
}

static inline AdwApplicationWindow *
cadw_cast_adw_application_window(gpointer obj)
{
    return ADW_APPLICATION_WINDOW(obj);
}

// GType fundamental type macros are not importable in Swift.

static inline GType cadw_type_boolean(void) { return G_TYPE_BOOLEAN; }
static inline GType cadw_type_int(void)     { return G_TYPE_INT; }
static inline GType cadw_type_uint(void)    { return G_TYPE_UINT; }
static inline GType cadw_type_int64(void)   { return G_TYPE_INT64; }
static inline GType cadw_type_uint64(void)  { return G_TYPE_UINT64; }
static inline GType cadw_type_float(void)   { return G_TYPE_FLOAT; }
static inline GType cadw_type_double(void)  { return G_TYPE_DOUBLE; }
static inline GType cadw_type_string(void)  { return G_TYPE_STRING; }
static inline GType cadw_type_object(void)  { return G_TYPE_OBJECT; }

// g_object_new is variadic and not importable in Swift.

static inline gpointer cadw_object_new(GType type) {
    return g_object_new_with_properties(type, 0, NULL, NULL);
}

// G_VALUE_HOLDS_* macros

static inline gboolean cadw_value_holds_string(const GValue *value) {
    return G_VALUE_HOLDS_STRING(value);
}

static inline gboolean cadw_value_holds_int(const GValue *value) {
    return G_VALUE_HOLDS_INT(value);
}

static inline gboolean cadw_value_holds_boolean(const GValue *value) {
    return G_VALUE_HOLDS_BOOLEAN(value);
}

static inline gboolean cadw_value_holds_double(const GValue *value) {
    return G_VALUE_HOLDS_DOUBLE(value);
}

static inline gboolean cadw_value_holds_file_list(const GValue *value) {
    return G_VALUE_HOLDS(value, GDK_TYPE_FILE_LIST);
}

static inline GdkFileList *cadw_value_get_file_list(const GValue *value) {
    if (!cadw_value_holds_file_list(value)) {
        return NULL;
    }
    return (GdkFileList *)g_value_get_boxed(value);
}

// Runtime version checking — always uses the loaded library's version.
static inline guint cadw_adw_major_version(void) { return adw_get_major_version(); }
static inline guint cadw_adw_minor_version(void) { return adw_get_minor_version(); }
static inline guint cadw_adw_micro_version(void) { return adw_get_micro_version(); }

// Runtime version checks (NOT compile-time — these check the loaded .so).
static inline int cadw_has_adw_1_6(void) {
    guint maj = adw_get_major_version(), min = adw_get_minor_version();
    return maj > 1 || (maj == 1 && min >= 6);
}
static inline int cadw_has_adw_1_7(void) {
    guint maj = adw_get_major_version(), min = adw_get_minor_version();
    return maj > 1 || (maj == 1 && min >= 7);
}

// --------------------------------------------------------------------------
// libadwaita 1.6+ / 1.7+ API wrappers using dlsym.
//
// All functions are always defined regardless of header version. They resolve
// the real symbol at runtime via dlsym. If the symbol is not found (older
// libadwaita at runtime), pointer-returning functions return NULL, int-returning
// functions return 0, and void functions do nothing.
//
// This ensures:
//  • Code always compiles (even on Ubuntu 24.04 with libadwaita 1.5 headers)
//  • Binaries compiled on newer systems won't crash on older systems
//    (dlsym returns NULL, Swift checks prevent calling)
// --------------------------------------------------------------------------

#include <dlfcn.h>

// --- Layout (libadwaita 1.6+) ---

static inline GtkWidget *cadw_layout_new(GtkWidget *content) {
    typedef GtkWidget* (*Fn)(GtkWidget*);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_layout_new");
    return fn ? fn(content) : NULL;
}
static inline GtkWidget *cadw_layout_get_content(gpointer self) {
    typedef GtkWidget* (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_layout_get_content");
    return fn ? fn(self) : NULL;
}
static inline const char *cadw_layout_get_name(gpointer self) {
    typedef const char* (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_layout_get_name");
    return fn ? fn(self) : NULL;
}
static inline void cadw_layout_set_name(gpointer self, const char *name) {
    typedef void (*Fn)(gpointer, const char*);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_layout_set_name");
    if (fn) fn(self, name);
}

// --- LayoutSlot (libadwaita 1.6+) ---

static inline GtkWidget *cadw_layout_slot_new(const char *id) {
    typedef GtkWidget* (*Fn)(const char*);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_layout_slot_new");
    return fn ? fn(id) : NULL;
}
static inline const char *cadw_layout_slot_get_slot_id(gpointer self) {
    typedef const char* (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_layout_slot_get_slot_id");
    return fn ? fn(self) : NULL;
}

// --- MultiLayoutView (libadwaita 1.6+) ---

static inline GtkWidget *cadw_multi_layout_view_new(void) {
    typedef GtkWidget* (*Fn)(void);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_multi_layout_view_new");
    return fn ? fn() : NULL;
}
static inline gpointer cadw_multi_layout_view_get_layout(gpointer self) {
    typedef gpointer (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_multi_layout_view_get_layout");
    return fn ? fn(self) : NULL;
}
static inline void cadw_multi_layout_view_set_layout(gpointer self, gpointer layout) {
    typedef void (*Fn)(gpointer, gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_multi_layout_view_set_layout");
    if (fn) fn(self, layout);
}
static inline const char *cadw_multi_layout_view_get_layout_name(gpointer self) {
    typedef const char* (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_multi_layout_view_get_layout_name");
    return fn ? fn(self) : NULL;
}
static inline void cadw_multi_layout_view_set_layout_name(gpointer self, const char *name) {
    typedef void (*Fn)(gpointer, const char*);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_multi_layout_view_set_layout_name");
    if (fn) fn(self, name);
}
static inline void cadw_multi_layout_view_add_layout(gpointer self, gpointer layout) {
    typedef void (*Fn)(gpointer, gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_multi_layout_view_add_layout");
    if (fn) fn(self, layout);
}
static inline gpointer cadw_multi_layout_view_get_child(gpointer self, const char *id) {
    typedef gpointer (*Fn)(gpointer, const char*);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_multi_layout_view_get_child");
    return fn ? fn(self, id) : NULL;
}
static inline gpointer cadw_multi_layout_view_get_layout_by_name(gpointer self, const char *name) {
    typedef gpointer (*Fn)(gpointer, const char*);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_multi_layout_view_get_layout_by_name");
    return fn ? fn(self, name) : NULL;
}
static inline void cadw_multi_layout_view_remove_layout(gpointer self, gpointer layout) {
    typedef void (*Fn)(gpointer, gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_multi_layout_view_remove_layout");
    if (fn) fn(self, layout);
}
static inline void cadw_multi_layout_view_set_child(gpointer self, const char *id, GtkWidget *child) {
    typedef void (*Fn)(gpointer, const char*, GtkWidget*);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_multi_layout_view_set_child");
    if (fn) fn(self, id, child);
}

// --- ComboRow.searchMatchMode (libadwaita 1.6+) ---

static inline GtkStringFilterMatchMode cadw_combo_row_get_search_match_mode(gpointer self) {
    typedef GtkStringFilterMatchMode (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_combo_row_get_search_match_mode");
    return fn ? fn(self) : (GtkStringFilterMatchMode)0;
}
static inline void cadw_combo_row_set_search_match_mode(gpointer self, GtkStringFilterMatchMode mode) {
    typedef void (*Fn)(gpointer, GtkStringFilterMatchMode);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_combo_row_set_search_match_mode");
    if (fn) fn(self, mode);
}

// --- EntryRow.maxLength (libadwaita 1.6+) ---

static inline int cadw_entry_row_get_max_length(gpointer self) {
    typedef int (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_entry_row_get_max_length");
    return fn ? fn(self) : 0;
}
static inline void cadw_entry_row_set_max_length(gpointer self, int length) {
    typedef void (*Fn)(gpointer, int);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_entry_row_set_max_length");
    if (fn) fn(self, length);
}

// --- NavigationSplitView.sidebarPosition (libadwaita 1.7+) ---

static inline GtkPackType cadw_navigation_split_view_get_sidebar_position(gpointer self) {
    typedef GtkPackType (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_navigation_split_view_get_sidebar_position");
    return fn ? fn(self) : (GtkPackType)0;
}
static inline void cadw_navigation_split_view_set_sidebar_position(gpointer self, GtkPackType position) {
    typedef void (*Fn)(gpointer, GtkPackType);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_navigation_split_view_set_sidebar_position");
    if (fn) fn(self, position);
}

// --- InlineViewSwitcher (libadwaita 1.7+) ---
// The AdwInlineViewSwitcherDisplayMode enum only exists in 1.7+ headers.
// We use int as the portable type; Swift sees it as Int32.

static inline GtkWidget *cadw_inline_view_switcher_new(void) {
    typedef GtkWidget* (*Fn)(void);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_inline_view_switcher_new");
    return fn ? fn() : NULL;
}
static inline int cadw_inline_view_switcher_get_can_shrink(gpointer self) {
    typedef int (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_inline_view_switcher_get_can_shrink");
    return fn ? fn(self) : 0;
}
static inline void cadw_inline_view_switcher_set_can_shrink(gpointer self, int val) {
    typedef void (*Fn)(gpointer, int);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_inline_view_switcher_set_can_shrink");
    if (fn) fn(self, val);
}
static inline int cadw_inline_view_switcher_get_display_mode(gpointer self) {
    typedef int (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_inline_view_switcher_get_display_mode");
    return fn ? fn(self) : 0;
}
static inline void cadw_inline_view_switcher_set_display_mode(gpointer self, int mode) {
    typedef void (*Fn)(gpointer, int);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_inline_view_switcher_set_display_mode");
    if (fn) fn(self, mode);
}
static inline int cadw_inline_view_switcher_get_homogeneous(gpointer self) {
    typedef int (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_inline_view_switcher_get_homogeneous");
    return fn ? fn(self) : 0;
}
static inline void cadw_inline_view_switcher_set_homogeneous(gpointer self, int val) {
    typedef void (*Fn)(gpointer, int);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_inline_view_switcher_set_homogeneous");
    if (fn) fn(self, val);
}
static inline gpointer cadw_inline_view_switcher_get_stack(gpointer self) {
    typedef gpointer (*Fn)(gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_inline_view_switcher_get_stack");
    return fn ? fn(self) : NULL;
}
static inline void cadw_inline_view_switcher_set_stack(gpointer self, gpointer stack) {
    typedef void (*Fn)(gpointer, gpointer);
    Fn fn = (Fn)dlsym(RTLD_DEFAULT, "adw_inline_view_switcher_set_stack");
    if (fn) fn(self, stack);
}

// ---------------------------------------------------------------------------
// Localization: gettext setup and runtime language changes.
// ---------------------------------------------------------------------------
//
// `<libintl.h>` is not part of the Glibc/Darwin module, so bindtextdomain and
// friends are unreachable from Swift without this include. Every app using
// `localized(_:)` needs them — the domain has to be bound to a directory
// before a lookup can find anything — so they belong here rather than in each
// app's own C shim.

#include <libintl.h>
#include <locale.h>

// glibc and GNU libintl resolve a domain's catalogue once and cache it, so
// assigning LANGUAGE mid-process changes nothing until this counter moves.
// Bumping it is the mechanism the GNU gettext manual documents for changing
// the language at runtime; glibc has exported it since 2.2.
//
// Declared weak so a libintl without the symbol still links — the capability
// probe then reports false and the app keeps the language it started with.
extern int _nl_msg_cat_cntr __attribute__((weak));

static inline int cadw_can_change_language_at_runtime(void) {
    return (&_nl_msg_cat_cntr) != NULL;
}

static inline void cadw_invalidate_translation_cache(void) {
    if (&_nl_msg_cat_cntr) {
        ++_nl_msg_cat_cntr;
    }
}

// gettext ignores LANGUAGE entirely while LC_MESSAGES names the C or POSIX
// locale — and "C.UTF-8" counts as C. Escaping that needs any *generated*
// locale, not the one belonging to the language being requested, which is why
// the caller passes candidates and keeps whichever this returns non-NULL for.
static inline const char *cadw_set_messages_locale(const char *locale) {
    return setlocale(LC_MESSAGES, locale);
}

static inline const char *cadw_current_messages_locale(void) {
    return setlocale(LC_MESSAGES, NULL);
}

static inline const char *cadw_activate_locale_from_environment(void) {
    return setlocale(LC_ALL, "");
}
