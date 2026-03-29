import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct TextTagMediaTests {

    // MARK: - TextTag

    @Test @MainActor func textTagCreation() {
        ensureAdwInit()
        let tag = TextTag(name: "myTag")
        // Tag should be created without crashing
        _ = tag
    }

    @Test @MainActor func textTagWeight() {
        ensureAdwInit()
        let tag = TextTag(name: "bold-test")
        tag.weight = 700
        #expect(tag.weight == 700)
        tag.weight = 400
        #expect(tag.weight == 400)
    }

    @Test @MainActor func textTagStyle() {
        ensureAdwInit()
        let tag = TextTag(name: "style-test")
        tag.style = .italic
        #expect(tag.style == .italic)
        tag.style = .normal
        #expect(tag.style == .normal)
    }

    @Test @MainActor func textTagScale() {
        ensureAdwInit()
        let tag = TextTag()
        tag.scale = 1.5
        #expect(abs(tag.scale - 1.5) < 0.01)
    }

    @Test @MainActor func textTagUnderline() {
        ensureAdwInit()
        let tag = TextTag()
        tag.underline = .single
        #expect(tag.underline == .single)
        tag.underline = .double
        #expect(tag.underline == .double)
    }

    @Test @MainActor func textTagStrikethrough() {
        ensureAdwInit()
        let tag = TextTag()
        tag.strikethrough = true
        #expect(tag.strikethrough == true)
        tag.strikethrough = false
        #expect(tag.strikethrough == false)
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

    @Test @MainActor func textAttributesCreation() {
        ensureAdwInit()
        let attrs = TextAttributes()
        // Should create without crashing
        #expect(attrs.pointer != nil)
    }

    @Test @MainActor func textAttributesBoldAndItalic() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addBold()
        attrs.addItalic()
        // No crash means attributes were inserted successfully
        #expect(attrs.pointer != nil)
    }

    @Test @MainActor func textAttributesForegroundColor() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addForegroundColor(red: 1.0, green: 0.0, blue: 0.0)
        #expect(attrs.pointer != nil)
    }

    @Test @MainActor func textAttributesStrikethroughAndUnderline() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addStrikethrough()
        attrs.addUnderline(.single)
        attrs.addUnderlineColor(red: 0.0, green: 0.0, blue: 1.0)
        attrs.addStrikethroughColor(red: 1.0, green: 0.0, blue: 0.0)
        #expect(attrs.pointer != nil)
    }

    @Test @MainActor func textAttributesFamilyAndSize() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addFamily("monospace")
        attrs.addSizePoints(14.0)
        attrs.addSizeAbsolute(20)
        #expect(attrs.pointer != nil)
    }

    @Test @MainActor func textAttributesWeight() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addWeight(.bold)
        attrs.addLight()
        attrs.addStyle(.oblique)
        #expect(attrs.pointer != nil)
    }

    // MARK: - Picture

    @Test @MainActor func pictureCreation() {
        ensureAdwInit()
        let pic = Picture()
        #expect(pic.canShrink == true)
    }

    @Test @MainActor func pictureCanShrink() {
        ensureAdwInit()
        let pic = Picture()
        pic.canShrink = false
        #expect(pic.canShrink == false)
        pic.canShrink = true
        #expect(pic.canShrink == true)
    }

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

    @Test @MainActor func pictureAlternativeText() {
        ensureAdwInit()
        let pic = Picture()
        #expect(pic.alternativeText == nil)
        pic.alternativeText = "A photo of a sunset"
        #expect(pic.alternativeText == "A photo of a sunset")
        pic.alternativeText = nil
        #expect(pic.alternativeText == nil)
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

    @Test @MainActor func videoCreation() {
        ensureAdwInit()
        let video = Video()
        #expect(video.autoplay == false)
        #expect(video.loop == false)
    }

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

    // MARK: - UriLauncher

    @Test @MainActor func uriLauncherCreation() {
        ensureAdwInit()
        let launcher = UriLauncher(uri: "https://gnome.org")
        #expect(launcher.uri == "https://gnome.org")
    }

    @Test @MainActor func uriLauncherSetUri() {
        ensureAdwInit()
        let launcher = UriLauncher(uri: "https://example.com")
        #expect(launcher.uri == "https://example.com")
        launcher.uri = "https://gtk.org"
        #expect(launcher.uri == "https://gtk.org")
        launcher.uri = nil
        #expect(launcher.uri == nil)
    }
}
