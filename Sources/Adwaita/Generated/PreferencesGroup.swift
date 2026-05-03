// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// Auto-generated from Adw-1.gir — do not edit
import CAdwaita
import GObjectSupport

/// A group of preference rows.
@MainActor
public class PreferencesGroup: Widget {

    /// Internal raw-pointer initializer.
    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates a new `PreferencesGroup`.
    public init() {
        let ptr = adw_preferences_group_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// Creates a `PreferencesGroup` with a title.
    public convenience init(title: String) {
        self.init()
        self.title = title
    }

    /// Creates a `PreferencesGroup` with a title and description.
    public convenience init(title: String, description: String) {
        self.init()
        self.title = title
        self.description = description
    }

    /// The descriptive text displayed below the group title.
    public var description: String? {
        get {
            adw_preferences_group_get_description(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>)
                .map { String(cString: $0) }
        }
        set { adw_preferences_group_set_description(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>,
            newValue
        ) }
    }

    /// A widget placed at the end of the group's header row, next to the title.
    /// - Since: libadwaita 1.1
    public var headerSuffix: Widget? {
        get {
            adw_preferences_group_get_header_suffix(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>)
                .map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
        }
        set { adw_preferences_group_set_header_suffix(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>,
            newValue?.widgetPointer
        ) }
    }

    /// Whether each row in the group is visually separated with individual frames.
    /// - Since: libadwaita 1.6
    public var separateRows: Bool {
        get {
            adw_preferences_group_get_separate_rows(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>) != 0
        }
        set { adw_preferences_group_set_separate_rows(
            castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>,
            newValue ? 1 : 0
        ) }
    }

    /// The title displayed at the top of the preferences group.
    public var title: String {
        get {
            String(
                cString: adw_preferences_group_get_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>)
            )
        }
        set { adw_preferences_group_set_title(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, newValue) }
    }

    /// Adds a child widget (typically a preference row) to the group.
    ///
    /// - Parameter child: The widget to add to this group.
    public func add(_ child: Widget) {
        adw_preferences_group_add(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, child.widgetPointer)
    }

    /// Returns the preference row at the given index within this group.
    ///
    /// - Parameter index: The zero-based index of the row to retrieve.
    /// - Returns: The widget at the specified index, or `nil` if the index is out of bounds.
    @discardableResult
    public func getRow(_ index: Int) -> Widget? {
        adw_preferences_group_get_row(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, UInt32(index))
            .map { Widget(borrowing: UnsafeMutableRawPointer($0)) }
    }

    /// Removes a child widget from the group.
    ///
    /// - Parameter child: The widget to remove from this group.
    public func remove(_ child: Widget) {
        adw_preferences_group_remove(castedPointer() as UnsafeMutablePointer<AdwPreferencesGroup>, child.widgetPointer)
    }
}
