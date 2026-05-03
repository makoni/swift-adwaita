// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import Foundation
import XCTest
@testable import Adwaita
import CAdwaita

final class AsyncWidgetXCTests: XCTestCase {

    @MainActor func test_dialogAsyncDismissedDomainMatchesGtk() {
        let domain = DialogAsyncSupport.dismissedDialogErrorDomain
        XCTAssertTrue(domain != 0)
        XCTAssertTrue(domain == g_quark_from_string("gtk-dialog-error-quark"))
    }

    // MARK: - FileDialog

    @MainActor func test_fileDialogModal() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.modal = true
        XCTAssertTrue(dialog.modal == true)
        dialog.modal = false
        XCTAssertTrue(dialog.modal == false)
    }

    @MainActor func test_fileDialogInitialName() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.initialName = "document.txt"
        XCTAssertTrue(dialog.initialName == "document.txt")
    }

    @MainActor func test_fileDialogAcceptLabel() {
        ensureAdwInit()
        let dialog = FileDialog()
        dialog.acceptLabel = "Select"
        XCTAssertTrue(dialog.acceptLabel == "Select")
    }

    @MainActor func test_fileDialogFilters() {
        ensureAdwInit()
        let dialog = FileDialog()
        let imageFilter = FileFilter(name: "Images", suffixes: ["png", "jpg", "gif"])
        let textFilter = FileFilter(name: "Text", suffixes: ["txt", "md"])
        dialog.setFilters([imageFilter, textFilter])
        dialog.setDefaultFilter(imageFilter)
        // Should not crash
    }

    @MainActor func test_fileFilterPatterns() {
        ensureAdwInit()
        let filter = FileFilter(name: "All", patterns: ["*"])
        XCTAssertTrue(filter.name == "All")
    }

    @MainActor func test_fileFilterMimeTypes() {
        ensureAdwInit()
        let filter = FileFilter(name: "Images", mimeTypes: ["image/png", "image/jpeg"])
        XCTAssertTrue(filter.name == "Images")
    }

    /// Verify the callback-based APIs exist without actually invoking them.
    /// Actually opening a dialog / launching a URI / reading the clipboard
    /// under xvfb would either hang for user input or pop up system UI,
    /// so these tests just pin the API shape via unbound method references.
    @MainActor func test_colorDialogExposesCallbackAPI() {
        let ref: (ColorDialog) -> (Widget?, RGBA?, @escaping @MainActor (Result<RGBA?, GLibError>) -> Void) -> Void =
            ColorDialog.chooseRGBA(parent:initialColor:completion:)
        _ = ref
    }

    @MainActor func test_fontDialogExposesCallbackAPI() {
        let ref: (FontDialog) -> (Widget?, String?, @escaping @MainActor (Result<String?, GLibError>) -> Void) -> Void =
            FontDialog.chooseFont(parent:initialFont:completion:)
        _ = ref
    }

    @MainActor func test_clipboardExposesCallbackReadAPIs() {
        let textRef: (Clipboard) -> (@escaping @MainActor (String?) -> Void) -> Void =
            Clipboard.readText(completion:)
        let textureRef: (Clipboard) -> (@escaping @MainActor (Texture?) -> Void) -> Void =
            Clipboard.readTexture(completion:)
        _ = textRef
        _ = textureRef
    }

    @MainActor func test_uriLauncherExposesCallbackAPI() {
        let ref: (UriLauncher) -> (Widget?, @escaping @MainActor (Bool) -> Void) -> Void =
            UriLauncher.launch(parent:completion:)
        _ = ref
    }

    @MainActor func test_textureLoadExposesCallbackAPI() {
        let ref: (URL, @escaping @MainActor (Result<Texture, ImageDecodingError>) -> Void) -> Void =
            Texture.load(from:completion:)
        _ = ref
    }

    @MainActor func test_fileDialogExposesCallbackAPI() {
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

    @MainActor func test_colorDialogButtonWithDialog() {
        ensureAdwInit()
        let dialog = ColorDialog()
        dialog.withAlpha = true
        let btn = ColorDialogButton(dialog: dialog)
        // Should not crash
        _ = btn
    }

    @MainActor func test_colorDialogButtonOnColorChanged() {
        ensureAdwInit()
        var changed = false
        let btn = ColorDialogButton()
        btn.onColorChanged { changed = true }
        btn.rgba = RGBA(red: 0.5, green: 0.5, blue: 0.5)
        XCTAssertTrue(changed, "onColorChanged should fire when rgba is set")
    }

    @MainActor func test_dialogAsyncDismissedDetectionMatchesExpectedError() throws {
        let domain = DialogAsyncSupport.dismissedDialogErrorDomain
        let message = try XCTUnwrap(g_strdup("dismissed"))
        defer { g_free(gpointer(message)) }

        let error = try XCTUnwrap(g_error_new_literal(domain, DialogAsyncSupport.dismissedDialogErrorCode, message))
        defer { g_error_free(error) }

        XCTAssertTrue(DialogAsyncSupport.isDismissed(error))
    }

    @MainActor func test_dialogAsyncDismissedDetectionRejectsOtherErrors() throws {
        let domain = DialogAsyncSupport.dismissedDialogErrorDomain
        let message = try XCTUnwrap(g_strdup("other"))
        defer { g_free(gpointer(message)) }

        let error = try XCTUnwrap(g_error_new_literal(domain, 99, message))
        defer { g_error_free(error) }

        XCTAssertFalse(DialogAsyncSupport.isDismissed(error))
    }

    // MARK: - RGBA

    @MainActor func test_rgbaCreation() {
        ensureAdwInit()
        let color = RGBA(red: 0.2, green: 0.4, blue: 0.6, alpha: 0.8)
        XCTAssertTrue(abs(color.red - 0.2) < 0.01)
        XCTAssertTrue(abs(color.green - 0.4) < 0.01)
        XCTAssertTrue(abs(color.blue - 0.6) < 0.01)
        XCTAssertTrue(abs(color.alpha - 0.8) < 0.01)
    }

    @MainActor func test_rgbaDefaultAlpha() {
        ensureAdwInit()
        let color = RGBA(red: 1.0, green: 0.0, blue: 0.0)
        XCTAssertTrue(abs(color.alpha - 1.0) < 0.01, "Default alpha should be 1.0")
    }

    // MARK: - Clipboard

    @MainActor func test_clipboardSetText() {
        ensureAdwInit()
        let label = Label("Test")
        let clipboard = label.clipboard
        clipboard.setText("Hello, Clipboard!")
        // setText should not crash; we can't read back without a display
    }

    @MainActor func test_clipboardOnChanged() {
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

    @MainActor func test_gestureSwipeSignal() {
        ensureAdwInit()
        let gesture = GestureSwipe()
        var swiped = false
        gesture.onSwipe { _, _ in swiped = true }
        let label = Label("Target")
        label.addController(gesture)
        XCTAssertFalse(swiped)
    }

    @MainActor func test_gestureClickSignal() {
        ensureAdwInit()
        let gesture = GestureClick()
        gesture.button = 1
        var clicked = false
        gesture.onPressed { _, _, _ in clicked = true }
        gesture.onReleased { _, _, _ in }
        let label = Label("Target")
        label.addController(gesture)
        XCTAssertFalse(clicked)
    }
}
#endif
