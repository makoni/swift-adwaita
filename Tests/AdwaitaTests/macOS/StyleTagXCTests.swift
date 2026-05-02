#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class StyleTagXCTests: XCTestCase {

    // MARK: - SearchEntry searchDelay

    @MainActor func test_searchEntryDelay() {
        ensureAdwInit()
        let entry = SearchEntry()
        entry.searchDelay = 500
        XCTAssertTrue(entry.searchDelay == 500)
    }

    // MARK: - ToggleButton enhancements

    @MainActor func test_toggleButtonChild() {
        ensureAdwInit()
        let btn = ToggleButton()
        let label = Label("Custom")
        btn.child = label
        XCTAssertNotNil(btn.child)
    }

    @MainActor func test_toggleButtonHasFrame() {
        ensureAdwInit()
        let btn = ToggleButton(label: "Test")
        XCTAssertTrue(btn.hasFrame == true)
        btn.hasFrame = false
        XCTAssertTrue(btn.hasFrame == false)
    }

    // MARK: - Widget tree navigation

    @MainActor func test_widgetParent() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let label = Label("Child")
        box.append(label)
        XCTAssertNotNil(label.parent)
    }

    @MainActor func test_widgetFirstLastChild() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        box.append(a)
        box.append(b)
        XCTAssertNotNil(box.firstChild)
        XCTAssertNotNil(box.lastChild)
    }

    @MainActor func test_widgetSiblings() {
        ensureAdwInit()
        let box = Box(orientation: .vertical, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        box.append(a)
        box.append(b)
        XCTAssertNotNil(a.nextSibling)
        XCTAssertNotNil(b.prevSibling)
    }

    @MainActor func test_widgetActivate() {
        ensureAdwInit()
        let btn = Button(label: "Test")
        // activate() on a button without a parent returns false
        let result = btn.activate()
        _ = result
        // No crash = success
    }

    // MARK: - TextView onChanged

    @MainActor func test_textViewOnChanged() {
        ensureAdwInit()
        let tv = TextView()
        var changed = false
        tv.onChanged { changed = true }
        tv.text = "Hello"
        XCTAssertTrue(changed == true)
    }

    // MARK: - Batch 9: Widget CSS helpers

    @MainActor func test_widgetHasCSSClass() {
        ensureAdwInit()
        let label = Label("test")
        label.addCSSClass("dim-label")
        XCTAssertTrue(label.hasCSSClass("dim-label") == true)
        XCTAssertTrue(label.hasCSSClass("nonexistent") == false)
    }

    @MainActor func test_widgetCSSClassesGetSet() {
        ensureAdwInit()
        let label = Label("test")
        label.cssClasses = ["bold", "accent"]
        let classes = label.cssClasses
        XCTAssertTrue(classes.contains("bold"))
        XCTAssertTrue(classes.contains("accent"))
    }

    @MainActor func test_widgetOverflow() {
        ensureAdwInit()
        let label = Label("test")
        label.overflow = .hidden
        XCTAssertTrue(label.overflow == GtkOverflow.hidden)
        label.overflow = .visible
        XCTAssertTrue(label.overflow == GtkOverflow.visible)
    }

    // MARK: - Breakpoint addSetter overloads

    @MainActor func test_breakpointAddSetterBool() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("test")
        // Should not crash
        bp.addSetter(label, property: .visible, value: false)
    }

    @MainActor func test_breakpointAddSetterInt() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let box = Box(orientation: .vertical, spacing: 0)
        bp.addSetter(box, property: .spacing, value: 12)
    }

    @MainActor func test_breakpointAddSetterString() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("original")
        bp.addSetter(label, property: .label, value: "compact")
    }

    @MainActor func test_breakpointAddSetterDouble() {
        ensureAdwInit()
        let cond = BreakpointCondition(parse: "max-width: 500px")
        let bp = Breakpoint(condition: cond)
        let label = Label("test")
        bp.addSetter(label, property: .opacity, value: 0.5)
    }

    // MARK: - Application lifecycle

    @MainActor func test_applicationLifecycleMethods() {
        ensureAdwInit()
        let app = Application(id: "com.test.lifecycle")
        // hold/release should not crash
        app.hold()
        app.release()
    }

    // MARK: - TextTag

    @MainActor func test_textTagCreation() {
        ensureAdwInit()
        let tag = TextTag(name: "bold")
        _ = tag
        // No crash = success
    }

    @MainActor func test_textTagWeight() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "bold")
        tag.weight = 700
        XCTAssertTrue(tag.weight == 700)
    }

    @MainActor func test_textTagStrikethrough() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "strike")
        tag.strikethrough = true
        XCTAssertTrue(tag.strikethrough == true)
    }

    @MainActor func test_textTagScale() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "big")
        tag.scale = 1.5
        XCTAssertTrue(tag.scale > 1.4 && tag.scale < 1.6)
    }

    @MainActor func test_textTagSizePoints() {
        ensureAdwInit()
        let buf = TextBuffer()
        let tag = buf.createTag(name: "sized")
        tag.sizePoints = 24.0
        XCTAssertTrue(tag.sizePoints > 23.9 && tag.sizePoints < 24.1)
    }

    // MARK: - TextBuffer tags

    @MainActor func test_textBufferCreateAndApplyTag() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        let tag = buf.createTag(name: "highlight")
        tag.weight = 700
        buf.applyTag(tag, startOffset: 0, endOffset: 5)
        // No crash = success
    }

    @MainActor func test_textBufferRemoveTag() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        let tag = buf.createTag(name: "temp")
        buf.applyTag(tag, startOffset: 0, endOffset: 5)
        buf.removeTag(tag, startOffset: 0, endOffset: 5)
        // No crash = success
    }

    @MainActor func test_textBufferRemoveAllTags() {
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

    @MainActor func test_adwEasingExtendedValues() {
        // Verify all easing enum extensions are distinct values
        let easings: [AdwEasing] = [
            .easeInQuad, .easeOutQuad, .easeInOutQuad,
            .easeInQuart, .easeOutQuart, .easeInOutQuart,
            .easeInQuint, .easeOutQuint, .easeInOutQuint,
            .easeInBounce, .easeOutBounce, .easeInOutBounce
        ]
        // All should be distinct
        let unique = Set(easings.map { $0.rawValue })
        XCTAssertTrue(unique.count == 12)
    }

    // MARK: - GtkOverflow enum

    @MainActor func test_gtkOverflowEnum() {
        XCTAssertTrue(GtkOverflow.visible != GtkOverflow.hidden)
    }

    // MARK: - LevelBar offsets

    @MainActor func test_levelBarOffsetValues() {
        ensureAdwInit()
        let bar = LevelBar()
        bar.addOffsetValue(name: "custom-low", value: 0.25)
        bar.addOffsetValue(name: "custom-high", value: 0.75)
        // No crash = success
        bar.removeOffsetValue(name: "custom-low")
        bar.removeOffsetValue(name: "custom-high")
    }

    // MARK: - AdwAnimationState enum

    @MainActor func test_adwAnimationStateEnum() {
        let states: [AdwAnimationState] = [.idle, .paused, .playing, .finished]
        let unique = Set(states.map { $0.rawValue })
        XCTAssertTrue(unique.count == 4)
    }

}
#endif
