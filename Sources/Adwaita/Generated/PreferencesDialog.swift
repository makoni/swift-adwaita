// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A dialog window for presenting application preferences organized by pages.
///
/// Wraps `AdwPreferencesDialog`. Displays one or more ``PreferencesPage``
/// instances in a dialog with optional search and subpage navigation.
/// Present it over a parent window using the inherited `present(_:)` method.
///
/// ```swift
/// let dialog = PreferencesDialog()
/// dialog.searchEnabled = true
///
/// let generalPage = PreferencesPage()
/// generalPage.title = "General"
/// generalPage.iconName = "preferences-system-symbolic"
///
/// let group = PreferencesGroup()
/// group.title = "Appearance"
/// generalPage.add(group)
///
/// dialog.add(generalPage)
/// dialog.present(parentWindow)
/// ```
///
/// - Key properties:
///   - ``searchEnabled``: Whether the search bar is available.
///   - ``visiblePageName``: The name of the currently visible page.
/// - Key methods:
///   - ``add(_:)``: Adds a ``PreferencesPage`` to the dialog.
///   - ``remove(_:)``: Removes a ``PreferencesPage`` from the dialog.
///   - ``pushSubpage(_:)``: Pushes a ``NavigationPage`` as a subpage.
///   - ``popSubpage()``: Pops the current subpage from the navigation stack.
///   - ``addToast(_:)``: Displays a ``Toast`` notification in the dialog.
/// - Since: libadwaita 1.5
@MainActor
public class PreferencesDialog: Dialog {
    override public class var gtkType: GType {
        adw_preferences_dialog_get_type()
    }

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `PreferencesDialog`.
    override public init() {
        let ptr = adw_preferences_dialog_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Whether the search bar is available for filtering preferences.
    /// - Since: libadwaita 1.5
    public var searchEnabled: Bool {
        get {
            adw_preferences_dialog_get_search_enabled(castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>) !=
                0
        }
        set { adw_preferences_dialog_set_search_enabled(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>,
            newValue ? 1 : 0
        ) }
    }

    /// The name of the currently visible preferences page, used for programmatic navigation.
    /// - Since: libadwaita 1.5
    public var visiblePageName: String? {
        get {
            adw_preferences_dialog_get_visible_page_name(castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>)
                .map { String(cString: $0) }
        }
        set { adw_preferences_dialog_set_visible_page_name(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>,
            newValue
        ) }
    }

    /// Adds a preferences page to the dialog.
    public func add(_ page: PreferencesPage) {
        adw_preferences_dialog_add(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>,
            page.castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>
        )
    }

    /// Removes a preferences page from the dialog.
    public func remove(_ page: PreferencesPage) {
        adw_preferences_dialog_remove(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>,
            page.castedPointer() as UnsafeMutablePointer<AdwPreferencesPage>
        )
    }

    /// Pushes a subpage onto the navigation stack.
    public func pushSubpage(_ page: NavigationPage) {
        adw_preferences_dialog_push_subpage(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>,
            page.castedPointer() as UnsafeMutablePointer<AdwNavigationPage>
        )
    }

    /// Displays a toast notification (transfer-full: adds a ref before passing).
    public func addToast(_ toast: Toast) {
        g_object_ref(toast.pointer)
        adw_preferences_dialog_add_toast(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>,
            toast.opaquePointer
        )
    }

    /// Pops the current subpage from the navigation stack, returning to the previous view.
    ///
    /// - Returns: `true` if a subpage was popped, `false` if there was no subpage to pop.
    public func popSubpage() -> Bool {
        adw_preferences_dialog_pop_subpage(castedPointer() as UnsafeMutablePointer<AdwPreferencesDialog>) != 0
    }
}
