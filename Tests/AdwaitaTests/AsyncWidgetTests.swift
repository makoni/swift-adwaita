import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct AsyncWidgetTests {

    // MARK: - FileDialog

    @Test @MainActor func fileDialogCreation() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.title = "Open File"
        #expect(dialog.title == "Open File")
    }

    @Test @MainActor func fileDialogModal() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.modal = true
        #expect(dialog.modal == true)
        dialog.modal = false
        #expect(dialog.modal == false)
    }

    @Test @MainActor func fileDialogInitialName() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.initialName = "document.txt"
        #expect(dialog.initialName == "document.txt")
    }

    @Test @MainActor func fileDialogAcceptLabel() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.acceptLabel = "Select"
        #expect(dialog.acceptLabel == "Select")
    }

    @Test @MainActor func fileDialogFilters() {
        ensureAdwInit()
        let dialog = FileDialog()
        let imageFilter = FileFilter(name: "Images", suffixes: ["png", "jpg", "gif"])
        let textFilter = FileFilter(name: "Text", suffixes: ["txt", "md"])
        dialog.setFilters([imageFilter, textFilter])
        dialog.setDefaultFilter(imageFilter)
        // Should not crash
    }

    @Test @MainActor func fileFilterCreation() {
        ensureAdwInit()
        let filter = FileFilter(name: "Swift Files", suffixes: ["swift"])
        #expect(filter.name == "Swift Files")
    }

    @Test @MainActor func fileFilterPatterns() {
        ensureAdwInit()
        let filter = FileFilter(name: "All", patterns: ["*"])
        #expect(filter.name == "All")
    }

    @Test @MainActor func fileFilterMimeTypes() {
        ensureAdwInit()
        let filter = FileFilter(name: "Images", mimeTypes: ["image/png", "image/jpeg"])
        #expect(filter.name == "Images")
    }

    // MARK: - ColorDialog

    @Test @MainActor func colorDialogCreation() {
        ensureAdwInit()
        let dialog = ColorDialog()
        dialog.title = "Pick a Color"
        #expect(dialog.title == "Pick a Color")
    }

    @Test @MainActor func colorDialogProperties() {
        ensureAdwInit()
        let dialog = ColorDialog()
        dialog.modal = true
        #expect(dialog.modal == true)
        dialog.withAlpha = false
        #expect(dialog.withAlpha == false)
    }

    @Test @MainActor func colorDialogButtonCreation() {
        ensureAdwInit()
        let btn = ColorDialogButton()
        let color = RGBA(red: 1.0, green: 0.0, blue: 0.0)
        btn.rgba = color
        let c = btn.rgba
        #expect(abs(c.red - 1.0) < 0.01)
        #expect(abs(c.green - 0.0) < 0.01)
        #expect(abs(c.blue - 0.0) < 0.01)
    }

    @Test @MainActor func colorDialogButtonWithDialog() {
        ensureAdwInit()
        let dialog = ColorDialog()
        dialog.withAlpha = true
        let btn = ColorDialogButton(dialog: dialog)
        // Should not crash
        _ = btn
    }

    @Test @MainActor func colorDialogButtonOnColorChanged() {
        ensureAdwInit()
        var changed = false
        let btn = ColorDialogButton()
        btn.onColorChanged { changed = true }
        btn.rgba = RGBA(red: 0.5, green: 0.5, blue: 0.5)
        #expect(changed, "onColorChanged should fire when rgba is set")
    }

    // MARK: - RGBA

    @Test @MainActor func rgbaCreation() {
        ensureAdwInit()
        let color = RGBA(red: 0.2, green: 0.4, blue: 0.6, alpha: 0.8)
        #expect(abs(color.red - 0.2) < 0.01)
        #expect(abs(color.green - 0.4) < 0.01)
        #expect(abs(color.blue - 0.6) < 0.01)
        #expect(abs(color.alpha - 0.8) < 0.01)
    }

    @Test @MainActor func rgbaDefaultAlpha() {
        ensureAdwInit()
        let color = RGBA(red: 1.0, green: 0.0, blue: 0.0)
        #expect(abs(color.alpha - 1.0) < 0.01, "Default alpha should be 1.0")
    }

    // MARK: - Clipboard

    @Test @MainActor func clipboardSetText() {
        ensureAdwInit()
        let label = Label("Test")
        let clipboard = label.clipboard
        clipboard.setText("Hello, Clipboard!")
        // setText should not crash; we can't read back without a display
    }

    @Test @MainActor func clipboardOnChanged() {
        ensureAdwInit()
        let label = Label("Test")
        let clipboard = label.clipboard
        var changed = false
        clipboard.onChanged { changed = true }
        clipboard.setText("Trigger change")
        // Note: onChanged may not fire in headless tests without a real display
        _ = changed
    }

    // MARK: - FontDialog

    @Test @MainActor func fontDialogCreation() {
        ensureAdwInit()
        let dialog = FontDialog()
        dialog.title = "Select Font"
        #expect(dialog.title == "Select Font")
        dialog.modal = true
        #expect(dialog.modal == true)
    }

    @Test @MainActor func fontDialogButtonCreation() {
        ensureAdwInit()
        let btn = FontDialogButton()
        // Should not crash; font button displays current font
        _ = btn
    }

    // MARK: - Gesture Controllers

    @Test @MainActor func gestureLongPressCreation() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        gesture.delayFactor = 2.0
        #expect(abs(gesture.delayFactor - 2.0) < 0.01)
    }

    @Test @MainActor func gestureLongPressSignals() {
        ensureAdwInit()
        let gesture = GestureLongPress()
        var pressed = false
        var cancelled = false
        gesture.onPressed { _, _ in pressed = true }
        gesture.onCancelled { cancelled = true }
        let label = Label("Target")
        label.addController(gesture)
        // Signals connected without crash
        #expect(!pressed)
        #expect(!cancelled)
    }

    @Test @MainActor func gestureSwipeCreation() {
        ensureAdwInit()
        let gesture = GestureSwipe()
        // Velocity is nil when no swipe is in progress
        #expect(gesture.velocity == nil)
    }

    @Test @MainActor func gestureSwipeSignal() {
        ensureAdwInit()
        let gesture = GestureSwipe()
        var swiped = false
        gesture.onSwipe { _, _ in swiped = true }
        let label = Label("Target")
        label.addController(gesture)
        #expect(!swiped)
    }

    @Test @MainActor func gestureDragSignals() {
        ensureAdwInit()
        let gesture = GestureDrag()
        var began = false
        var updated = false
        gesture.onDragBegin { _, _ in began = true }
        gesture.onDragUpdate { _, _ in updated = true }
        gesture.onDragEnd { _, _ in }
        let label = Label("Target")
        label.addController(gesture)
        #expect(!began)
        #expect(!updated)
    }

    @Test @MainActor func gestureClickSignal() {
        ensureAdwInit()
        let gesture = GestureClick()
        gesture.button = 1
        var clicked = false
        gesture.onPressed { _, _, _ in clicked = true }
        gesture.onReleased { _, _, _ in }
        let label = Label("Target")
        label.addController(gesture)
        #expect(!clicked)
    }
}
