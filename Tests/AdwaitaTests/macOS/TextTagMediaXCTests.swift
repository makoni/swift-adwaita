// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class TextTagMediaXCTests: XCTestCase {

    // MARK: - TextTag

    @MainActor func test_textTagStyle() {
        ensureAdwInit()
        let tag = TextTag(name: "style-test")
        tag.style = .italic
        XCTAssertTrue(tag.style == .italic)
        tag.style = .normal
        XCTAssertTrue(tag.style == .normal)
    }

    @MainActor func test_textTagUnderline() {
        ensureAdwInit()
        let tag = TextTag()
        tag.underline = .single
        XCTAssertTrue(tag.underline == .single)
        tag.underline = .double
        XCTAssertTrue(tag.underline == .double)
    }

    @MainActor func test_textTagSizeAndSizePoints() {
        ensureAdwInit()
        let tag = TextTag()
        tag.sizePoints = 14.0
        XCTAssertTrue(abs(tag.sizePoints - 14.0) < 0.01)
        tag.size = 12288 // 12 * 1024
        XCTAssertTrue(tag.size == 12288)
    }

    @MainActor func test_textTagForegroundAndBackground() {
        ensureAdwInit()
        let tag = TextTag()
        // foreground and background are write-only, getter returns nil
        tag.foreground = "#ff0000"
        XCTAssertNil(tag.foreground)
        tag.background = "#0000ff"
        XCTAssertNil(tag.background)
    }

    @MainActor func test_textTagFamily() {
        ensureAdwInit()
        let tag = TextTag()
        tag.family = "monospace"
        // family is write-only, getter returns nil
        XCTAssertNil(tag.family)
    }

    @MainActor func test_textTagStylePresets() {
        ensureAdwInit()
        let bold = TextTag.bold()
        XCTAssertTrue(bold.weight == 700)
        let italic = TextTag.italic()
        XCTAssertTrue(italic.style == .italic)
        let mono = TextTag.monospace()
        // monospace sets family which is write-only, just verify no crash
        _ = mono
        let red = TextTag.colored("red")
        // colored sets foreground which is write-only
        _ = red
    }

    // MARK: - TextAttributes

    @MainActor func test_textAttributesBoldAndItalic() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addBold()
        attrs.addItalic()
        // No crash means attributes were inserted successfully
        XCTAssertTrue(attrs.pointer != OpaquePointer(bitPattern: 0))
    }

    @MainActor func test_textAttributesStrikethroughAndUnderline() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addStrikethrough()
        attrs.addUnderline(.single)
        attrs.addUnderlineColor(red: 0.0, green: 0.0, blue: 1.0)
        attrs.addStrikethroughColor(red: 1.0, green: 0.0, blue: 0.0)
        XCTAssertTrue(attrs.pointer != OpaquePointer(bitPattern: 0))
    }

    @MainActor func test_textAttributesFamilyAndSize() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addFamily("monospace")
        attrs.addSizePoints(14.0)
        attrs.addSizeAbsolute(20)
        XCTAssertTrue(attrs.pointer != OpaquePointer(bitPattern: 0))
    }

    // MARK: - Picture

    @MainActor func test_pictureContentFit() {
        ensureAdwInit()
        let pic = Adwaita.Picture()
        pic.contentFit = .contain
        XCTAssertTrue(pic.contentFit == .contain)
        pic.contentFit = .cover
        XCTAssertTrue(pic.contentFit == .cover)
        pic.contentFit = .fill
        XCTAssertTrue(pic.contentFit == .fill)
        pic.contentFit = .scaleDown
        XCTAssertTrue(pic.contentFit == .scaleDown)
    }

    @MainActor func test_pictureSizeRequest() {
        ensureAdwInit()
        let pic = Adwaita.Picture()
        pic.setSizeRequest(width: 200, height: 150)
        // setSizeRequest is fire-and-forget, just verify no crash
    }

    @MainActor func test_pictureSetFilename() {
        ensureAdwInit()
        let pic = Adwaita.Picture()
        pic.setFilename("/nonexistent/path.png")
        // Setting a nonexistent file should not crash
        pic.setFilename(nil)
    }

    // MARK: - Video

    @MainActor func test_videoAutoplay() {
        ensureAdwInit()
        let video = Video()
        video.autoplay = true
        XCTAssertTrue(video.autoplay == true)
        video.autoplay = false
        XCTAssertTrue(video.autoplay == false)
    }

    @MainActor func test_videoLoop() {
        ensureAdwInit()
        let video = Video()
        video.loop = true
        XCTAssertTrue(video.loop == true)
        video.loop = false
        XCTAssertTrue(video.loop == false)
    }

    @MainActor func test_videoSetFilename() {
        ensureAdwInit()
        let video = Video()
        video.setFilename("/nonexistent/video.mp4")
        // Should not crash even with a nonexistent file
        video.setFilename(nil)
    }

    // MARK: - Separator

    @MainActor func test_separatorHorizontal() {
        ensureAdwInit()
        let sep = Separator()
        // Default is horizontal, should not crash
        _ = sep
    }

    @MainActor func test_separatorVertical() {
        ensureAdwInit()
        let sep = Separator(orientation: GTK_ORIENTATION_VERTICAL)
        _ = sep
    }

}
#endif
