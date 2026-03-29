import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized) struct TextAndMediaTests {

    // MARK: - Entry

    @Test @MainActor func entryCreation() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.text == "")
    }

    @Test @MainActor func entryConvenienceInit() {
        ensureAdwInit()
        let entry = Entry(placeholder: "Name")
        #expect(entry.placeholderText == "Name")
        #expect(entry.text == "")
    }

    @Test @MainActor func entryTextProperty() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello"
        #expect(entry.text == "Hello")
        entry.text = ""
        #expect(entry.text == "")
    }

    @Test @MainActor func entryPlaceholderText() {
        ensureAdwInit()
        let entry = Entry()
        entry.placeholderText = "Search..."
        #expect(entry.placeholderText == "Search...")
        entry.placeholderText = "Type here"
        #expect(entry.placeholderText == "Type here")
    }

    @Test @MainActor func entryVisibility() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.visibility == true)
        entry.visibility = false
        #expect(entry.visibility == false)
        entry.visibility = true
        #expect(entry.visibility == true)
    }

    @Test @MainActor func entryMaxLength() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.maxLength == 0)
        entry.maxLength = 50
        #expect(entry.maxLength == 50)
    }

    @Test @MainActor func entryHasFrame() {
        ensureAdwInit()
        let entry = Entry()
        #expect(entry.hasFrame == true)
        entry.hasFrame = false
        #expect(entry.hasFrame == false)
    }

    @Test @MainActor func entryAlignment() {
        ensureAdwInit()
        let entry = Entry()
        entry.alignment = 0.5
        #expect(abs(entry.alignment - 0.5) < 0.01)
        entry.alignment = 1.0
        #expect(abs(entry.alignment - 1.0) < 0.01)
    }

    @Test @MainActor func entryInputPurpose() {
        ensureAdwInit()
        let entry = Entry()
        entry.inputPurpose = GTK_INPUT_PURPOSE_PASSWORD
        #expect(entry.inputPurpose == GTK_INPUT_PURPOSE_PASSWORD)
        entry.inputPurpose = GTK_INPUT_PURPOSE_FREE_FORM
        #expect(entry.inputPurpose == GTK_INPUT_PURPOSE_FREE_FORM)
    }

    @Test @MainActor func entryProgressFraction() {
        ensureAdwInit()
        let entry = Entry()
        #expect(abs(entry.progressFraction - 0.0) < 0.01)
        entry.progressFraction = 0.75
        #expect(abs(entry.progressFraction - 0.75) < 0.01)
    }

    @Test @MainActor func entryProgressPulseStep() {
        ensureAdwInit()
        let entry = Entry()
        entry.progressPulseStep = 0.2
        #expect(abs(entry.progressPulseStep - 0.2) < 0.01)
    }

    @Test @MainActor func entryOnChangedSignal() {
        ensureAdwInit()
        let entry = Entry()
        var changed = false
        entry.onChanged { changed = true }
        entry.text = "trigger"
        #expect(changed, "onChanged should fire when text is set")
    }

    @Test @MainActor func entryOnActivateSignal() {
        ensureAdwInit()
        let entry = Entry()
        var activated = false
        let conn = entry.onActivate { activated = true }
        // We cannot programmatically emit activate without GTK main loop,
        // but we can verify the signal connection was created.
        #expect(activated == false)
        _ = conn
    }

    @Test @MainActor func entryCursorAndSelection() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello World"
        entry.cursorPosition = 5
        #expect(entry.cursorPosition == 5)
        entry.selectAll()
        #expect(entry.hasSelection == true)
        entry.clearSelection()
        #expect(entry.hasSelection == false)
    }

    @Test @MainActor func entryIconSetAndGet() {
        ensureAdwInit()
        let entry = Entry()
        entry.setIcon(position: GTK_ENTRY_ICON_PRIMARY, iconName: "edit-find-symbolic")
        #expect(entry.iconName(at: GTK_ENTRY_ICON_PRIMARY) == "edit-find-symbolic")
        entry.setIcon(position: GTK_ENTRY_ICON_PRIMARY, iconName: nil)
        #expect(entry.iconName(at: GTK_ENTRY_ICON_PRIMARY) == nil)
    }

    // MARK: - Scale

    @Test @MainActor func scaleCreation() {
        ensureAdwInit()
        let scale = Scale()
        #expect(abs(scale.value - 0.0) < 0.01)
    }

    @Test @MainActor func scaleCreationWithParams() {
        ensureAdwInit()
        let scale = Scale(orientation: GTK_ORIENTATION_VERTICAL, min: 10, max: 200, step: 5)
        #expect(abs(scale.value - 10.0) < 0.01)
    }

    @Test @MainActor func scaleValue() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.value = 42
        #expect(abs(scale.value - 42.0) < 0.01)
    }

    @Test @MainActor func scaleDrawValue() {
        ensureAdwInit()
        let scale = Scale()
        scale.drawValue = true
        #expect(scale.drawValue == true)
        scale.drawValue = false
        #expect(scale.drawValue == false)
    }

    @Test @MainActor func scaleDigits() {
        ensureAdwInit()
        let scale = Scale()
        scale.digits = 3
        #expect(scale.digits == 3)
    }

    @Test @MainActor func scaleHasOrigin() {
        ensureAdwInit()
        let scale = Scale()
        scale.hasOrigin = false
        #expect(scale.hasOrigin == false)
        scale.hasOrigin = true
        #expect(scale.hasOrigin == true)
    }

    @Test @MainActor func scaleInverted() {
        ensureAdwInit()
        let scale = Scale()
        #expect(scale.inverted == false)
        scale.inverted = true
        #expect(scale.inverted == true)
    }

    @Test @MainActor func scaleValuePos() {
        ensureAdwInit()
        let scale = Scale()
        scale.drawValue = true
        scale.valuePos = .left
        #expect(scale.valuePos == .left)
        scale.valuePos = .right
        #expect(scale.valuePos == .right)
    }

    @Test @MainActor func scaleSetRange() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.setRange(min: -50, max: 50)
        scale.value = -25
        #expect(abs(scale.value - (-25.0)) < 0.01)
    }

    @Test @MainActor func scaleAddAndClearMarks() {
        ensureAdwInit()
        let scale = Scale(min: 0, max: 100, step: 1)
        scale.addMark(value: 25, position: .top, markup: "25%")
        scale.addMark(value: 50, position: .bottom)
        scale.addMark(value: 75)
        // clearMarks should not crash
        scale.clearMarks()
    }

    // MARK: - TextBuffer

    @Test @MainActor func textBufferCreation() {
        ensureAdwInit()
        let buffer = TextBuffer()
        #expect(buffer.text == "")
        #expect(buffer.charCount == 0)
    }

    @Test @MainActor func textBufferSetText() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello, world!"
        #expect(buffer.text == "Hello, world!")
        #expect(buffer.charCount == 13)
    }

    @Test @MainActor func textBufferInsertAtCursor() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.insertAtCursor("ABC")
        #expect(buffer.text == "ABC")
        buffer.insertAtCursor("DEF")
        #expect(buffer.text == "ABCDEF")
    }

    @Test @MainActor func textBufferLineCount() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Line1\nLine2\nLine3"
        #expect(buffer.lineCount == 3)
    }

    @Test @MainActor func textBufferSelectAndGetSelected() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        #expect(buffer.hasSelection == false)
        buffer.selectAll()
        #expect(buffer.hasSelection == true)
        #expect(buffer.selectedText == "Hello World")
    }

    @Test @MainActor func textBufferPlaceCursor() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello"
        buffer.placeCursorAtStart()
        buffer.insertAtCursor(">> ")
        #expect(buffer.text == ">> Hello")
        buffer.placeCursorAtEnd()
        buffer.insertAtCursor(" <<")
        #expect(buffer.text == ">> Hello <<")
    }

    @Test @MainActor func textBufferModified() {
        ensureAdwInit()
        let buffer = TextBuffer()
        #expect(buffer.modified == false)
        buffer.text = "Changed"
        #expect(buffer.modified == true)
        buffer.modified = false
        #expect(buffer.modified == false)
    }

    @Test @MainActor func textBufferOnChanged() {
        ensureAdwInit()
        let buffer = TextBuffer()
        var changeCount = 0
        buffer.onChanged { changeCount += 1 }
        buffer.text = "first"
        #expect(changeCount > 0, "onChanged should fire when text is set")
    }

    @Test @MainActor func textBufferInsertAtOffset() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        buffer.insert(" Beautiful", at: 5)
        #expect(buffer.text == "Hello Beautiful World")
    }

    @Test @MainActor func textBufferTextInRange() {
        ensureAdwInit()
        let buffer = TextBuffer()
        buffer.text = "Hello World"
        let sub = buffer.text(in: 0..<5)
        #expect(sub == "Hello")
    }

    // MARK: - TextView

    @Test @MainActor func textViewCreation() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.text == "")
    }

    @Test @MainActor func textViewTextProperty() {
        ensureAdwInit()
        let tv = TextView()
        tv.text = "Some content"
        #expect(tv.text == "Some content")
    }

    @Test @MainActor func textViewEditable() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.editable == true)
        tv.editable = false
        #expect(tv.editable == false)
    }

    @Test @MainActor func textViewCursorVisible() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.cursorVisible == true)
        tv.cursorVisible = false
        #expect(tv.cursorVisible == false)
    }

    @Test @MainActor func textViewWrapMode() {
        ensureAdwInit()
        let tv = TextView()
        tv.wrapMode = .word
        #expect(tv.wrapMode == .word)
        tv.wrapMode = .char
        #expect(tv.wrapMode == .char)
        tv.wrapMode = .none
        #expect(tv.wrapMode == .none)
    }

    @Test @MainActor func textViewMonospace() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.monospace == false)
        tv.monospace = true
        #expect(tv.monospace == true)
    }

    @Test @MainActor func textViewMargins() {
        ensureAdwInit()
        let tv = TextView()
        tv.leftMargin = 10
        tv.rightMargin = 20
        tv.topMargin = 5
        tv.bottomMargin = 15
        #expect(tv.leftMargin == 10)
        #expect(tv.rightMargin == 20)
        #expect(tv.topMargin == 5)
        #expect(tv.bottomMargin == 15)
    }

    @Test @MainActor func textViewJustification() {
        ensureAdwInit()
        let tv = TextView()
        tv.justification = .center
        #expect(tv.justification == .center)
        tv.justification = .right
        #expect(tv.justification == .right)
    }

    @Test @MainActor func textViewOverwrite() {
        ensureAdwInit()
        let tv = TextView()
        #expect(tv.overwrite == false)
        tv.overwrite = true
        #expect(tv.overwrite == true)
    }

    @Test @MainActor func textViewIndent() {
        ensureAdwInit()
        let tv = TextView()
        tv.indent = 16
        #expect(tv.indent == 16)
    }

    @Test @MainActor func textViewBuffer() {
        ensureAdwInit()
        let tv = TextView()
        let buffer = TextBuffer()
        buffer.text = "Shared buffer"
        tv.buffer = buffer
        #expect(tv.text == "Shared buffer")
    }

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
        tag.size = 12288  // 12 * 1024
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
