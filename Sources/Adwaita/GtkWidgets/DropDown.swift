// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A widget that lets the user choose an item from a list.
///
/// Wraps `GtkDropDown`. Can be used with a `StringList` model for simple
/// string-based drop-downs.
///
/// ```swift
/// let dropdown = DropDown(strings: ["Small", "Medium", "Large"])
/// dropdown.selected = 1  // selects "Medium"
/// dropdown.enableSearch = true
///
/// dropdown.onSelectedChanged {
///     print("Selected index: \(dropdown.selected)")
/// }
/// ```
@MainActor
public final class DropDown: Widget {
    /// Creates a new drop-down from a string list.
    ///
    /// - Parameter strings: The strings to populate the drop-down with.
    public init(strings: [String]) {
        let cArray: [UnsafePointer<CChar>?] = strings.map { $0.withCString { UnsafePointer(strdup($0)) } }
        var terminated = cArray
        terminated.append(nil)
        let ptr = terminated.withUnsafeBufferPointer { buf in
            gtk_drop_down_new_from_strings(buf.baseAddress)!
        }
        for s in cArray {
            free(UnsafeMutablePointer(mutating: s))
        }
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// Creates an empty drop-down.
    public init() {
        let ptr = gtk_drop_down_new(nil, nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    /// The index of the selected item.
    public var selected: Int {
        get { Int(gtk_drop_down_get_selected(opaquePointer)) }
        set { gtk_drop_down_set_selected(opaquePointer, UInt32(newValue)) }
    }

    /// Whether to show a search entry in the popup.
    public var enableSearch: Bool {
        get { gtk_drop_down_get_enable_search(opaquePointer) != 0 }
        set { gtk_drop_down_set_enable_search(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether to show an arrow indicator.
    public var showArrow: Bool {
        get { gtk_drop_down_get_show_arrow(opaquePointer) != 0 }
        set { gtk_drop_down_set_show_arrow(opaquePointer, newValue ? 1 : 0) }
    }

    /// Emitted when the selection changes.
    ///
    /// - Parameter handler: Called when the selected item changes.
    /// - Returns: A `SignalConnection` that can be used to disconnect the handler.
    @discardableResult
    public func onSelectedChanged(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.onNotify(self, property: .selected, handler: handler)
    }
}
