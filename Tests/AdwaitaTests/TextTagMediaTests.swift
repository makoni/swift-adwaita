#if swift(>=6.3)
import Testing
@testable import Adwaita
import CAdwaita

extension SerializedLifecycleSuites {
@Suite(.serialized)
struct TextTagMediaTests {

    // MARK: - TextTag

    @Test @MainActor func textTagStyle() {
        ensureAdwInit()
        let tag = TextTag(name: "style-test")
        tag.style = .italic
        #expect(tag.style == .italic)
        tag.style = .normal
        #expect(tag.style == .normal)
    }

    @Test @MainActor func textTagUnderline() {
        ensureAdwInit()
        let tag = TextTag()
        tag.underline = .single
        #expect(tag.underline == .single)
        tag.underline = .double
        #expect(tag.underline == .double)
    }

    @Test @MainActor func textTagSizeAndSizePoints() {
        ensureAdwInit()
        let tag = TextTag()
        tag.sizePoints = 14.0
        #expect(abs(tag.sizePoints - 14.0) < 0.01)
        tag.size = 12288 // 12 * 1024
        #expect(tag.size == 12288)
    }

    @Test @MainActor func textTagForegroundAndBackground() {
        ensureAdwInit()
        let tag = TextTag()
        // foreground and background are write-only, getter returns nil
        tag.foreground = "#ff0000"
        #expect(tag.foreground == nil)
        tag.background = "#0000ff"
        #expect(tag.background == nil)
    }

    @Test @MainActor func textTagFamily() {
        ensureAdwInit()
        let tag = TextTag()
        tag.family = "monospace"
        // family is write-only, getter returns nil
        #expect(tag.family == nil)
    }

    @Test @MainActor func textTagStylePresets() {
        ensureAdwInit()
        let bold = TextTag.bold()
        #expect(bold.weight == 700)
        let italic = TextTag.italic()
        #expect(italic.style == .italic)
        let mono = TextTag.monospace()
        // monospace sets family which is write-only, just verify no crash
        _ = mono
        let red = TextTag.colored("red")
        // colored sets foreground which is write-only
        _ = red
    }

    // MARK: - TextAttributes

    @Test @MainActor func textAttributesBoldAndItalic() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addBold()
        attrs.addItalic()
        // No crash means attributes were inserted successfully
        #expect(attrs.pointer != OpaquePointer(bitPattern: 0))
    }

    @Test @MainActor func textAttributesStrikethroughAndUnderline() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addStrikethrough()
        attrs.addUnderline(.single)
        attrs.addUnderlineColor(red: 0.0, green: 0.0, blue: 1.0)
        attrs.addStrikethroughColor(red: 1.0, green: 0.0, blue: 0.0)
        #expect(attrs.pointer != OpaquePointer(bitPattern: 0))
    }

    @Test @MainActor func textAttributesFamilyAndSize() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addFamily("monospace")
        attrs.addSizePoints(14.0)
        attrs.addSizeAbsolute(20)
        #expect(attrs.pointer != OpaquePointer(bitPattern: 0))
    }

    // MARK: - Picture

    @Test @MainActor func pictureContentFit() {
        ensureAdwInit()
        let pic = Picture()
        pic.contentFit = .contain
        #expect(pic.contentFit == .contain)
        pic.contentFit = .cover
        #expect(pic.contentFit == .cover)
        pic.contentFit = .fill
        #expect(pic.contentFit == .fill)
        pic.contentFit = .scaleDown
        #expect(pic.contentFit == .scaleDown)
    }

    @Test @MainActor func pictureSizeRequest() {
        ensureAdwInit()
        let pic = Picture()
        pic.setSizeRequest(width: 200, height: 150)
        // setSizeRequest is fire-and-forget, just verify no crash
    }

    @Test @MainActor func pictureSetFilename() {
        ensureAdwInit()
        let pic = Picture()
        pic.setFilename("/nonexistent/path.png")
        // Setting a nonexistent file should not crash
        pic.setFilename(nil)
    }

    // MARK: - Video

    @Test @MainActor func videoAutoplay() {
        ensureAdwInit()
        let video = Video()
        video.autoplay = true
        #expect(video.autoplay == true)
        video.autoplay = false
        #expect(video.autoplay == false)
    }

    @Test @MainActor func videoLoop() {
        ensureAdwInit()
        let video = Video()
        video.loop = true
        #expect(video.loop == true)
        video.loop = false
        #expect(video.loop == false)
    }

    @Test @MainActor func videoSetFilename() {
        ensureAdwInit()
        let video = Video()
        video.setFilename("/nonexistent/video.mp4")
        // Should not crash even with a nonexistent file
        video.setFilename(nil)
    }

    // MARK: - Separator

    @Test @MainActor func separatorHorizontal() {
        ensureAdwInit()
        let sep = Separator()
        // Default is horizontal, should not crash
        _ = sep
    }

    @Test @MainActor func separatorVertical() {
        ensureAdwInit()
        let sep = Separator(orientation: GTK_ORIENTATION_VERTICAL)
        _ = sep
    }

}
}
#endif
