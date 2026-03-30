#if swift(>=6.3)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct BreakpointButtonTests {

    // MARK: - Clamp

    @Test @MainActor func clampCreation() {
        ensureAdwInit()
        let clamp = Clamp()
        _ = clamp
    }

    @Test @MainActor func clampChildProperty() {
        ensureAdwInit()
        let clamp = Clamp()
        #expect(clamp.child == nil)
        let label = Label("Clamped")
        clamp.child = label
        #expect(clamp.child != nil)
    }

    @Test @MainActor func clampMaximumSizeRoundTrip() {
        ensureAdwInit()
        let clamp = Clamp()
        clamp.maximumSize = 800
        #expect(clamp.maximumSize == 800)
    }

    @Test @MainActor func clampTighteningThresholdRoundTrip() {
        ensureAdwInit()
        let clamp = Clamp()
        clamp.tighteningThreshold = 300
        #expect(clamp.tighteningThreshold == 300)
    }

    // MARK: - ClampLayout

    @Test @MainActor func clampLayoutCreation() {
        ensureAdwInit()
        let layout = ClampLayout()
        _ = layout
    }

    @Test @MainActor func clampLayoutMaximumSize() {
        ensureAdwInit()
        let layout = ClampLayout()
        layout.maximumSize = 1000
        #expect(layout.maximumSize == 1000)
    }

    @Test @MainActor func clampLayoutTighteningThreshold() {
        ensureAdwInit()
        let layout = ClampLayout()
        layout.tighteningThreshold = 500
        #expect(layout.tighteningThreshold == 500)
    }

    // MARK: - ClampScrollable

    @Test @MainActor func clampScrollableCreation() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        _ = clamp
    }

    @Test @MainActor func clampScrollableChildProperty() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        #expect(clamp.child == nil)
        let label = Label("Scrollable content")
        clamp.child = label
        #expect(clamp.child != nil)
    }

    @Test @MainActor func clampScrollableMaximumSize() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        clamp.maximumSize = 700
        #expect(clamp.maximumSize == 700)
    }

    @Test @MainActor func clampScrollableTighteningThreshold() {
        ensureAdwInit()
        let clamp = ClampScrollable()
        clamp.tighteningThreshold = 350
        #expect(clamp.tighteningThreshold == 350)
    }

    // MARK: - Breakpoint

    @Test @MainActor func breakpointCreation() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "min-width: 600px")
        let bp = Breakpoint(condition: cond)
        _ = bp
    }

    @Test @MainActor func breakpointConditionProperty() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 400sp")
        let bp = Breakpoint(condition: cond)
        #expect(bp.condition != nil)
        let condStr = bp.condition?.toString()
        #expect(condStr != nil)
    }

    @Test @MainActor func breakpointOnApplySignal() {
        ensureAdwInit()
        let bp = Breakpoint.minWidth(600)
        var applied = false
        let conn = bp.onApply { applied = true }
        #expect(conn is SignalConnection)
        conn.disconnect()
        _ = applied
    }

    @Test @MainActor func breakpointOnUnapplySignal() {
        ensureAdwInit()
        let bp = Breakpoint.maxWidth(800)
        var unapplied = false
        let conn = bp.onUnapply { unapplied = true }
        #expect(conn is SignalConnection)
        conn.disconnect()
        _ = unapplied
    }

    // MARK: - BreakpointBin

    @Test @MainActor func breakpointBinCreation() {
        ensureAdwInit()
        let bin = BreakpointBin()
        _ = bin
    }

    @Test @MainActor func breakpointBinChildProperty() {
        ensureAdwInit()
        let bin = BreakpointBin()
        #expect(bin.child == nil)
        let label = Label("Content")
        bin.child = label
        #expect(bin.child != nil)
    }

    @Test @MainActor func breakpointBinAddBreakpoint() {
        ensureAdwInit()
        let bin = BreakpointBin()
        let bp = Breakpoint.minWidth(500)
        bin.addBreakpoint(bp)
        // No breakpoint is active until the bin is sized.
        #expect(bin.currentBreakpoint == nil)
    }

    // MARK: - SplitButton

    @Test @MainActor func splitButtonCreation() {
        ensureAdwInit()
        let btn = SplitButton()
        _ = btn
    }

    @Test @MainActor func splitButtonLabelProperty() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.label = "Save"
        #expect(btn.label == "Save")
    }

    @Test @MainActor func splitButtonIconNameProperty() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.iconName = "document-save-symbolic"
        #expect(btn.iconName == "document-save-symbolic")
    }

    @Test @MainActor func splitButtonChildProperty() {
        ensureAdwInit()
        let btn = SplitButton()
        #expect(btn.child == nil)
        let content = ButtonContent()
        content.label = "Custom"
        btn.child = content
        #expect(btn.child != nil)
    }

    @Test @MainActor func splitButtonDropdownTooltip() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.dropdownTooltip = "More options"
        #expect(btn.dropdownTooltip == "More options")
    }

    @Test @MainActor func splitButtonOnClicked() {
        ensureAdwInit()
        let btn = SplitButton()
        var clicked = false
        let conn = btn.onClicked { clicked = true }
        #expect(conn is SignalConnection)
        conn.disconnect()
        _ = clicked
    }

    @Test @MainActor func splitButtonCanShrink() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.canShrink = true
        #expect(btn.canShrink == true)
        btn.canShrink = false
        #expect(btn.canShrink == false)
    }

    @Test @MainActor func splitButtonUseUnderline() {
        ensureAdwInit()
        let btn = SplitButton()
        btn.useUnderline = true
        #expect(btn.useUnderline == true)
        btn.useUnderline = false
        #expect(btn.useUnderline == false)
    }

    // MARK: - ButtonContent

    @Test @MainActor func buttonContentCreation() {
        ensureAdwInit()
        let content = ButtonContent()
        _ = content
    }

    @Test @MainActor func buttonContentLabelProperty() {
        ensureAdwInit()
        let content = ButtonContent()
        content.label = "Download"
        #expect(content.label == "Download")
    }

    @Test @MainActor func buttonContentIconNameProperty() {
        ensureAdwInit()
        let content = ButtonContent()
        content.iconName = "folder-download-symbolic"
        #expect(content.iconName == "folder-download-symbolic")
    }

    @Test @MainActor func buttonContentUseUnderline() {
        ensureAdwInit()
        let content = ButtonContent()
        content.useUnderline = true
        #expect(content.useUnderline == true)
        content.useUnderline = false
        #expect(content.useUnderline == false)
    }

    @Test @MainActor func buttonContentCanShrink() {
        ensureAdwInit()
        let content = ButtonContent()
        content.canShrink = true
        #expect(content.canShrink == true)
        content.canShrink = false
        #expect(content.canShrink == false)
    }

    // MARK: - ShortcutLabel

    @Test @MainActor func shortcutLabelCreation() {
        ensureAdwInit()
        guard let label = ShortcutLabel(accelerator: "<Control>s") else {
            // libadwaita < 1.8; skip gracefully.
            return
        }
        _ = label
    }

    @Test @MainActor func shortcutLabelAccelerator() {
        ensureAdwInit()
        guard let label = ShortcutLabel(accelerator: "<Control>s") else { return }
        #expect(label.accelerator == "<Control>s")
        label.accelerator = "<Alt>F4"
        #expect(label.accelerator == "<Alt>F4")
    }

    @Test @MainActor func shortcutLabelDisabledText() {
        ensureAdwInit()
        guard let label = ShortcutLabel(accelerator: "<Control>z") else { return }
        label.disabledText = "Not available"
        #expect(label.disabledText == "Not available")
    }

    // MARK: - ShortcutsDialog

    @Test @MainActor func shortcutsDialogCreation() {
        ensureAdwInit()
        let dialog = ShortcutsDialog()
        _ = dialog
    }

    @Test @MainActor func shortcutsDialogAddSection() {
        ensureAdwInit()
        guard ShortcutsDialog.isAvailable else { return }
        let dialog = ShortcutsDialog()
        guard let section = ShortcutsSection(title: "General") else { return }
        dialog.add(section)
    }

    // MARK: - ShortcutsItem

    @Test @MainActor func shortcutsItemCreation() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Save", accelerator: "<Control>s") else {
            return
        }
        _ = item
    }

    @Test @MainActor func shortcutsItemTitleProperty() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Save", accelerator: "<Control>s") else { return }
        #expect(item.title == "Save")
        item.title = "Save As"
        #expect(item.title == "Save As")
    }

    @Test @MainActor func shortcutsItemAccelerator() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Undo", accelerator: "<Control>z") else { return }
        #expect(item.accelerator == "<Control>z")
        item.accelerator = "<Control><Shift>z"
        #expect(item.accelerator == "<Control><Shift>z")
    }

    @Test @MainActor func shortcutsItemSubtitle() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Find", accelerator: "<Control>f") else { return }
        item.subtitle = "Search in document"
        #expect(item.subtitle == "Search in document")
    }

    @Test @MainActor func shortcutsItemActionName() {
        ensureAdwInit()
        guard let item = ShortcutsItem(title: "Quit", accelerator: "<Control>q") else { return }
        item.actionName = "app.quit"
        #expect(item.actionName == "app.quit")
    }

    @Test @MainActor func shortcutsItemFromAction() {
        ensureAdwInit()
        guard let item = ShortcutsItem.newFromAction(title: "Quit", actionName: "app.quit") else {
            return
        }
        #expect(item.title == "Quit")
        #expect(item.actionName == "app.quit")
    }

    // MARK: - ShortcutsSection

    @Test @MainActor func shortcutsSectionCreation() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: "Editing") else {
            return
        }
        _ = section
    }

    @Test @MainActor func shortcutsSectionTitleProperty() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: "Navigation") else { return }
        #expect(section.title == "Navigation")
        section.title = "General"
        #expect(section.title == "General")
    }

    @Test @MainActor func shortcutsSectionAddItem() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: "Edit") else { return }
        guard let item = ShortcutsItem(title: "Cut", accelerator: "<Control>x") else { return }
        section.add(item)
    }

    @Test @MainActor func shortcutsSectionNilTitle() {
        ensureAdwInit()
        guard let section = ShortcutsSection(title: nil) else { return }
        #expect(section.title == nil)
        section.title = "Now has a title"
        #expect(section.title == "Now has a title")
    }
}
#endif
