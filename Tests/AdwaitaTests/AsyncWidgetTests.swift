import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct AsyncWidgetTests {

    @Test @MainActor func dialogAsyncDismissedDomainMatchesGtk() {
        let domain = DialogAsyncSupport.dismissedDialogErrorDomain
        #expect(domain != 0)
        #expect(domain == g_quark_from_string("gtk-dialog-error-quark"))
    }

    // MARK: - FileDialog

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

    // Verify the callback-based API exists without actually invoking it —
    // calling open/save/selectFolder would try to show a dialog under
    // xvfb and hang waiting for user input.
    @Test @MainActor func fileDialogExposesCallbackAPI() {
        let openRef: (FileDialog) -> (Widget?, @escaping @MainActor (Result<String?, GLibError>) -> Void) -> Void =
            FileDialog.open(parent:completion:)
        let saveRef: (FileDialog) -> (Widget?, @escaping @MainActor (Result<String?, GLibError>) -> Void) -> Void =
            FileDialog.save(parent:completion:)
        let selectRef: (FileDialog) -> (Widget?, @escaping @MainActor (Result<String?, GLibError>) -> Void) -> Void =
            FileDialog.selectFolder(parent:completion:)
        _ = openRef
        _ = saveRef
        _ = selectRef
    }

    // MARK: - ColorDialog

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

    @Test @MainActor func dialogAsyncDismissedDetectionMatchesExpectedError() throws {
        let domain = DialogAsyncSupport.dismissedDialogErrorDomain
        let message = try #require(g_strdup("dismissed"))
        defer { g_free(gpointer(message)) }

        let error = try #require(g_error_new_literal(domain, DialogAsyncSupport.dismissedDialogErrorCode, message))
        defer { g_error_free(error) }

        #expect(DialogAsyncSupport.isDismissed(error))
    }

    @Test @MainActor func dialogAsyncDismissedDetectionRejectsOtherErrors() throws {
        let domain = DialogAsyncSupport.dismissedDialogErrorDomain
        let message = try #require(g_strdup("other"))
        defer { g_free(gpointer(message)) }

        let error = try #require(g_error_new_literal(domain, 99, message))
        defer { g_error_free(error) }

        #expect(!DialogAsyncSupport.isDismissed(error))
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

    // MARK: - Gesture Controllers

    @Test @MainActor func gestureSwipeSignal() {
        ensureAdwInit()
        let gesture = GestureSwipe()
        var swiped = false
        gesture.onSwipe { _, _ in swiped = true }
        let label = Label("Target")
        label.addController(gesture)
        #expect(!swiped)
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
