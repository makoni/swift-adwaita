// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import CAdwaita
import GObjectSupport

/// A model that contains only the selected items from a selection model,
/// backed by `GtkSelectionFilterModel`.
///
/// Wraps `GtkSelectionFilterModel` and presents only those items from the
/// underlying selection model that are currently selected. The result itself
/// conforms to `GListModel`, so it can be passed to other list model wrappers
/// or used directly.
///
/// ```swift
/// let store = ListStore()
/// let selection = SingleSelection(model: store)
/// let selectedOnly = SelectionFilterModel(model: selection)
/// ```
@MainActor
public final class SelectionFilterModel: GObjectRef, ListModelConvertible {

    /// Creates a selection filter model wrapping a ``SingleSelection``.
    ///
    /// - Parameter model: The ``SingleSelection`` model to filter.
    public init(model: SingleSelection) {
        let ptr = gtk_selection_filter_model_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_selection_filter_model_set_model(opaquePointer, model.selectionModelPointer)
    }

    /// Creates a selection filter model wrapping a ``MultiSelection``.
    ///
    /// - Parameter model: The ``MultiSelection`` model to filter.
    public init(model: MultiSelection) {
        let ptr = gtk_selection_filter_model_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_selection_filter_model_set_model(opaquePointer, model.selectionModelPointer)
    }

    /// Creates a selection filter model from a raw `GtkSelectionModel` pointer.
    ///
    /// - Parameter selectionModel: A raw `GtkSelectionModel` pointer.
    public init(selectionModel: OpaquePointer) {
        let ptr = gtk_selection_filter_model_new(nil)!
        super.init(raw: UnsafeMutableRawPointer(ptr))
        gtk_selection_filter_model_set_model(opaquePointer, selectionModel)
    }

    required init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    // MARK: - Query

    /// The number of currently selected items.
    public var count: Int {
        Int(g_list_model_get_n_items(opaquePointer))
    }

}
