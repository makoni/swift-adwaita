import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct StyleTagTests {

    // MARK: - SearchEntry searchDelay

    @Test @MainActor func searchEntryDelay() {
        ensureAdwInit()
        let entry = SearchEntry()
        entry.searchDelay = 500
        #expect(entry.searchDelay == 500)
    }

    // MARK: - ToggleButton enhancements

    @Test @MainActor func toggleButtonChild() {
        ensureAdwInit()
        let btn = ToggleButton()
        let label = Label("Custom")
        btn.child = label
        #expect(btn.child != nil)
    }

    @Test @MainActor func toggleButtonHasFrame() {
        ensureAdwInit()
        let btn = ToggleButton(label: "Test")
        #expect(btn.hasFrame == true)
        btn.hasFrame = false
        #expect(btn.hasFrame == false)
    }

    // MARK: - Widget tree navigation

    @Test @MainActor func widgetParent() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let label = Label("Child")
        box.append(label)
        #expect(label.parent != nil)
    }

    @Test @MainActor func widgetFirstLastChild() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        box.append(a)
        box.append(b)
        #expect(box.firstChild != nil)
        #expect(box.lastChild != nil)
    }

    @Test @MainActor func widgetSiblings() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        box.append(a)
        box.append(b)
        #expect(a.nextSibling != nil)
        #expect(b.prevSibling != nil)
    }

    @Test @MainActor func widgetActivate() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        // activate() on a button without a parent returns false
        let result = btn.activate()
        _ = result
        // No crash = success
    }

    // MARK: - TextView onChanged

    @Test @MainActor func textViewOnChanged() {
        ensureAdwInit()
        let tv = TextView()
        var changed = false
        tv.onChanged { changed = true }
        tv.text = "Hello"
        #expect(changed == true)
    }

    // MARK: - Batch 9: Widget CSS helpers

    @Test @MainActor func widgetHasCSSClass() {
        ensureAdwInit()
        let label = Label("test")
        label.addCSSClass("dim-label")
        #expect(label.hasCSSClass("dim-label") == true)
        #expect(label.hasCSSClass("nonexistent") == false)
    }

    @Test @MainActor func widgetCSSClassesGetSet() {
        ensureAdwInit()
        let label = Label("test")
        label.cssClasses = ["bold", "accent"]
        let classes = label.cssClasses
        #expect(classes.contains("bold"))
        #expect(classes.contains("accent"))
    }

    @Test @MainActor func widgetOverflow() {
        ensureAdwInit()
        let label = Label("test")
        label.overflow = .hidden
        #expect(label.overflow == GtkOverflow.hidden)
        label.overflow = .visible
        #expect(label.overflow == GtkOverflow.visible)
    }

    // MARK: - Breakpoint addSetter overloads

    @Test @MainActor func breakpointAddSetterBool() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("test")
        // Should not crash
        bp.addSetter(label, property: .visible, value: false)
    }

    @Test @MainActor func breakpointAddSetterInt() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let box = Box(orientation: .vertical, spacing: 0)
        bp.addSetter(box, property: .spacing, value: 12)
    }

    @Test @MainActor func breakpointAddSetterString() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("original")
        bp.addSetter(label, property: .label, value: "compact")
    }

    @Test @MainActor func breakpointAddSetterDouble() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("test")
        bp.addSetter(label, property: .opacity, value: 0.5)
    }

    // MARK: - Application lifecycle

    @Test @MainActor func applicationLifecycleMethods() {
        ensureAdwInit()
        let app = Application(id: "com.test.lifecycle")
        // hold/release should not crash
        app.hold()
        app.release()
    }

    // MARK: - TextTag

    @Test @MainActor func textTagCreation() {
        ensureAdwInit()
        let tag = TextTag(name: "bold")
        _ = tag
        // No crash = success
    }

    @Test @MainActor func textTagWeight() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "bold")
        tag.weight = 700
        #expect(tag.weight == 700)
    }

    @Test @MainActor func textTagStrikethrough() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "strike")
        tag.strikethrough = true
        #expect(tag.strikethrough == true)
    }

    @Test @MainActor func textTagScale() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "big")
        tag.scale = 1.5
        #expect(tag.scale > 1.4 && tag.scale < 1.6)
    }

    @Test @MainActor func textTagSizePoints() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "sized")
        tag.sizePoints = 24.0
        #expect(tag.sizePoints > 23.9 && tag.sizePoints < 24.1)
    }

    // MARK: - TextBuffer tags

    @Test @MainActor func textBufferCreateAndApplyTag() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        let tag = buf.createTag(name: "highlight")
        tag.weight = 700
        buf.applyTag(tag, startOffset: 0, endOffset: 5)
        // No crash = success
    }

    @Test @MainActor func textBufferRemoveTag() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        let tag = buf.createTag(name: "temp")
        buf.applyTag(tag, startOffset: 0, endOffset: 5)
        buf.removeTag(tag, startOffset: 0, endOffset: 5)
        // No crash = success
    }

    @Test @MainActor func textBufferRemoveAllTags() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        let tag1 = buf.createTag(name: "a")
        let tag2 = buf.createTag(name: "b")
        buf.applyTag(tag1, startOffset: 0, endOffset: 5)
        buf.applyTag(tag2, startOffset: 0, endOffset: 5)
        buf.removeAllTags(startOffset: 0, endOffset: 5)
        // No crash = success
    }

    // MARK: - AdwEasing extended values

    @Test @MainActor func adwEasingExtendedValues() {
        // Verify all easing enum extensions are distinct values
        let easings: [AdwEasing] = [
            .easeInQuad, .easeOutQuad, .easeInOutQuad,
            .easeInQuart, .easeOutQuart, .easeInOutQuart,
            .easeInQuint, .easeOutQuint, .easeInOutQuint,
            .easeInBounce, .easeOutBounce, .easeInOutBounce
        ]
        // All should be distinct
        let unique = Set(easings.map { $0.rawValue })
        #expect(unique.count == 12)
    }

    // MARK: - GtkOverflow enum

    @Test @MainActor func gtkOverflowEnum() {
        #expect(GtkOverflow.visible != GtkOverflow.hidden)
    }

    // MARK: - LevelBar offsets

    @Test @MainActor func levelBarOffsetValues() {
        ensureAdwInit()
        let bar = LevelBar()
        bar.addOffsetValue(name: "custom-low", value: 0.25)
        bar.addOffsetValue(name: "custom-high", value: 0.75)
        // No crash = success
        bar.removeOffsetValue(name: "custom-low")
        bar.removeOffsetValue(name: "custom-high")
    }

    // MARK: - AdwAnimationState enum

    @Test @MainActor func adwAnimationStateEnum() {
        let states: [AdwAnimationState] = [.idle, .paused, .playing, .finished]
        let unique = Set(states.map { $0.rawValue })
        #expect(unique.count == 4)
    }

}
