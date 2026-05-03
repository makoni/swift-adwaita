// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class BreakpointButtonXCTests: XCTestCase {

    // MARK: - Clamp

    @MainActor func test_clampCreation() {
        ensureAdwInit()
        let clamp = Clamp()
        _ = clamp
    }

    @MainActor func test_clampChildProperty() {
        ensureAdwInit()
        let clamp = Clamp()
        XCTAssertNil(clamp.child)
        let label = Label("Clamped")
        clamp.child = label
        XCTAssertNotNil(clamp.child)
    }

    @MainActor func test_clampMaximumSizeRoundTrip() {
        ensureAdwInit()
        let clamp = Clamp()
        clamp.maximumSize = 800
        XCTAssertTrue(clamp.maximumSize == 800)
    }

    @MainActor func test_clampTighteningThresholdRoundTrip() {
        ensureAdwInit()
        let clamp = Clamp()
        clamp.tighteningThreshold = 300
        XCTAssertTrue(clamp.tighteningThreshold == 300)
    }

    // MARK: - ClampLayout

    @MainActor func test_clampLayoutCreation() {
        ensureAdwInit()
        let layout = ClampLayout()
        _ = layout
    }

    @MainActor func test_clampLayoutMaximumSize() {
        ensureAdwInit()
        let layout = ClampLayout()
        layout.maximumSize = 1000
        XCTAssertTrue(layout.maximumSize == 1000)
    }

    @MainActor func test_clampLayoutTighteningThreshold() {
        ensureAdwInit()
        let layout = ClampLayout()
        layout.tighteningThreshold = 500
        XCTAssertTrue(layout.tighteningThreshold == 500)
    }

    // MARK: - ClampScrollable

    @MainActor func test_clampScrollableCreation() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        _ = clamp
    }

    @MainActor func test_clampScrollableChildProperty() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        XCTAssertNil(clamp.child)
        let textView = TextView()
        clamp.child = textView
        XCTAssertNotNil(clamp.child)
    }

    @MainActor func test_clampScrollableMaximumSize() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        clamp.maximumSize = 700
        XCTAssertTrue(clamp.maximumSize == 700)
    }

    @MainActor func test_clampScrollableTighteningThreshold() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        clamp.tighteningThreshold = 350
        XCTAssertTrue(clamp.tighteningThreshold == 350)
    }

    // MARK: - Breakpoint

    @MainActor func test_breakpointCreation() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "min-width: 600px")
        let bp = Breakpoint(condition: cond)
        _ = bp
    }

    @MainActor func test_breakpointConditionProperty() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 400sp")
        let bp = Breakpoint(condition: cond)
        XCTAssertNotNil(bp.condition)
        let condStr = bp.condition?.toString()
        XCTAssertNotNil(condStr)
    }

    @MainActor func test_breakpointOnApplySignal() {
        ensureAdwInit()
        let bp = Breakpoint.minWidth(600)
        var applied = false
        let conn = bp.onApply { applied = true }
        XCTAssertTrue(conn is SignalConnection)
        conn.disconnect()
        _ = applied
    }

    @MainActor func test_breakpointOnUnapplySignal() {
        ensureAdwInit()
        let bp = Breakpoint.maxWidth(800)
        var unapplied = false
        let conn = bp.onUnapply { unapplied = true }
        XCTAssertTrue(conn is SignalConnection)
        conn.disconnect()
        _ = unapplied
    }

    // MARK: - BreakpointBin

    @MainActor func test_breakpointBinCreation() {
        ensureAdwInit()
        let bin = BreakpointBin()
        _ = bin
    }

    @MainActor func test_breakpointBinChildProperty() {
        ensureAdwInit()
        let bin = BreakpointBin()
        XCTAssertNil(bin.child)
        let label = Label("Content")
        bin.child = label
        XCTAssertNotNil(bin.child)
    }

    @MainActor func test_breakpointBinAddBreakpoint() {
        ensureAdwInit()
        let bin = BreakpointBin()
        let bp = Breakpoint.minWidth(500)
        bin.addBreakpoint(bp)
        // No breakpoint is active until the bin is sized.
        XCTAssertNil(bin.currentBreakpoint)
    }

    // MARK: - SplitButton

    @MainActor func test_splitButtonCreation() {
        ensureAdwInit()
        let btn = SplitButton()
        _ = btn
    }

    @MainActor func test_splitButtonLabelProperty() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.label = "Save"
        XCTAssertTrue(btn.label == "Save")
    }

    @MainActor func test_splitButtonIconNameProperty() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.iconName = "document-save-symbolic"
        XCTAssertTrue(btn.iconName == "document-save-symbolic")
    }

    @MainActor func test_splitButtonChildProperty() {
        ensureAdwInit()
        let btn = SplitButton()
        XCTAssertNil(btn.child)
        let content = ButtonContent()
        content.label = "Custom"
        btn.child = content
        XCTAssertNotNil(btn.child)
    }

    @MainActor func test_splitButtonDropdownTooltip() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.dropdownTooltip = "More options"
        XCTAssertTrue(btn.dropdownTooltip == "More options")
    }

    @MainActor func test_splitButtonOnClicked() {
        ensureAdwInit()
        let btn = SplitButton()
        var clicked = false
        let conn = btn.onClicked { clicked = true }
        XCTAssertTrue(conn is SignalConnection)
        conn.disconnect()
        _ = clicked
    }

    @MainActor func test_splitButtonCanShrink() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.canShrink = true
        XCTAssertTrue(btn.canShrink == true)
        btn.canShrink = false
        XCTAssertTrue(btn.canShrink == false)
    }

    @MainActor func test_splitButtonUseUnderline() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.useUnderline = true
        XCTAssertTrue(btn.useUnderline == true)
        btn.useUnderline = false
        XCTAssertTrue(btn.useUnderline == false)
    }

    // MARK: - ButtonContent

    @MainActor func test_buttonContentCreation() {
        ensureAdwInit()
        let content = ButtonContent()
        _ = content
    }

    @MainActor func test_buttonContentLabelProperty() {
        ensureAdwInit()
        let content = ButtonContent()
        content.label = "Download"
        XCTAssertTrue(content.label == "Download")
    }

    @MainActor func test_buttonContentIconNameProperty() {
        ensureAdwInit()
        let content = ButtonContent()
        content.iconName = "folder-download-symbolic"
        XCTAssertTrue(content.iconName == "folder-download-symbolic")
    }

    @MainActor func test_buttonContentUseUnderline() {
        ensureAdwInit()
        let content = ButtonContent()
        content.useUnderline = true
        XCTAssertTrue(content.useUnderline == true)
        content.useUnderline = false
        XCTAssertTrue(content.useUnderline == false)
    }

    @MainActor func test_buttonContentCanShrink() {
        ensureAdwInit()
        let content = ButtonContent()
        content.canShrink = true
        XCTAssertTrue(content.canShrink == true)
        content.canShrink = false
        XCTAssertTrue(content.canShrink == false)
    }

    // MARK: - ShortcutLabel

    @MainActor func test_shortcutLabelCreation() {
        ensureAdwInit()
        guard let label = ShortcutLabel(accelerator: "<Control>s") else {
            // libadwaita < 1.8; skip gracefully.
            return
        }
        _ = label
    }

    @MainActor func test_shortcutLabelAccelerator() {
        ensureAdwInit()
        guard let label = ShortcutLabel(accelerator: "<Control>s") else { return }
        XCTAssertTrue(label.accelerator == "<Control>s")
        label.accelerator = "<Alt>F4"
        XCTAssertTrue(label.accelerator == "<Alt>F4")
    }

    @MainActor func test_shortcutLabelDisabledText() {
        ensureAdwInit()
        guard let label = ShortcutLabel(accelerator: "<Control>z") else { return }
        label.disabledText = "Not available"
        XCTAssertTrue(label.disabledText == "Not available")
    }

    // MARK: - ShortcutsDialog

    @MainActor func test_shortcutsDialogCreation() {
        ensureAdwInit()
        let dialog = ShortcutsDialog()
        _ = dialog
    }

    @MainActor func test_shortcutsDialogAddSection() {
        ensureAdwInit()
        guard ShortcutsDialog.isAvailable else { return }
        let dialog = ShortcutsDialog()
        guard let section = ShortcutsSection(title: "General") else { return }
        dialog.add(section)
    }

    // MARK: - ShortcutsItem

    @MainActor func test_shortcutsItemCreation() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Save", accelerator: "<Control>s") else {
            return
        }
        _ = item
    }

    @MainActor func test_shortcutsItemTitleProperty() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Save", accelerator: "<Control>s") else { return }
        XCTAssertTrue(item.title == "Save")
        item.title = "Save As"
        XCTAssertTrue(item.title == "Save As")
    }

    @MainActor func test_shortcutsItemAccelerator() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Undo", accelerator: "<Control>z") else { return }
        XCTAssertTrue(item.accelerator == "<Control>z")
        item.accelerator = "<Control><Shift>z"
        XCTAssertTrue(item.accelerator == "<Control><Shift>z")
    }

    @MainActor func test_shortcutsItemSubtitle() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Find", accelerator: "<Control>f") else { return }
        item.subtitle = "Search in document"
        XCTAssertTrue(item.subtitle == "Search in document")
    }

    @MainActor func test_shortcutsItemActionName() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Quit", accelerator: "<Control>q") else { return }
        item.actionName = "app.quit"
        XCTAssertTrue(item.actionName == "app.quit")
    }

    @MainActor func test_shortcutsItemFromAction() {
        ensureAdwInit()
        guard let item = ShortcutsItem.newFromAction(title: "Quit", actionName: "app.quit") else {
            return
        }
        XCTAssertTrue(item.title == "Quit")
        XCTAssertTrue(item.actionName == "app.quit")
    }

    // MARK: - ShortcutsSection

    @MainActor func test_shortcutsSectionCreation() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: "Editing") else {
            return
        }
        _ = section
    }

    @MainActor func test_shortcutsSectionTitleProperty() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: "Navigation") else { return }
        XCTAssertTrue(section.title == "Navigation")
        section.title = "General"
        XCTAssertTrue(section.title == "General")
    }

    @MainActor func test_shortcutsSectionAddItem() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: "Edit") else { return }
        guard let item = ShortcutsItem(title: "Cut", accelerator: "<Control>x") else { return }
        section.add(item)
    }

    @MainActor func test_shortcutsSectionNilTitle() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: nil) else { return }
        XCTAssertNil(section.title)
        section.title = "Now has a title"
        XCTAssertTrue(section.title == "Now has a title")
    }
}
#endif
