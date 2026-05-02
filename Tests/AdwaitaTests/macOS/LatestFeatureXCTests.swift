#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class LatestFeatureXCTests: XCTestCase {

    // MARK: - Individual Margin Fluent Setters

    @MainActor func test_fluentMarginStart() {
        ensureAdwInit()
        let label = Label("Test").marginStart(8)
        XCTAssertTrue(label.marginStart == 8)
    }

    @MainActor func test_fluentMarginEnd() {
        ensureAdwInit()
        let label = Label("Test").marginEnd(16)
        XCTAssertTrue(label.marginEnd == 16)
    }

    @MainActor func test_fluentMarginTop() {
        ensureAdwInit()
        let label = Label("Test").marginTop(4)
        XCTAssertTrue(label.marginTop == 4)
    }

    @MainActor func test_fluentMarginBottom() {
        ensureAdwInit()
        let label = Label("Test").marginBottom(12)
        XCTAssertTrue(label.marginBottom == 12)
    }

    // MARK: - Children Iteration Tests

    @MainActor func test_widgetChildren() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        let c = Label("C")
        box.append(a)
        box.append(b)
        box.append(c)
        let kids = box.children()
        XCTAssertTrue(kids.count == 3)
    }

    @MainActor func test_widgetForEachChild() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        box.append(Label("A"))
        box.append(Label("B"))
        var count = 0
        box.forEachChild { _ in count += 1 }
        XCTAssertTrue(count == 2)
    }

    // MARK: - MenuButton Convenience Tests

    @MainActor func test_menuButtonLabelInit() {
        ensureAdwInit()
        let btn = MenuButton(label: "File")
        XCTAssertTrue(btn.label == "File")
    }

    @MainActor func test_menuButtonIconInit() {
        ensureAdwInit()
        let btn = MenuButton(icon: .openMenu)
        XCTAssertTrue(btn.iconName == "open-menu-symbolic")
    }

    // MARK: - Revealer Signal Tests

    @MainActor func test_revealerOnChildRevealed() {
        ensureAdwInit()
        let revealer = Revealer()
        // Just verify it connects without crashing
        let conn = revealer.onChildRevealed {}
        XCTAssertTrue(conn is SignalConnection)
    }

    // MARK: - Expander Signal Tests

    @MainActor func test_expanderOnExpanded() {
        ensureAdwInit()
        let expander = Expander(label: "Details")
        let conn = expander.onExpanded {}
        XCTAssertTrue(conn is SignalConnection)
    }

    // MARK: - Popover Signal Tests

    @MainActor func test_popoverOnVisibilityChanged() {
        ensureAdwInit()
        let popover = Popover()
        let conn = popover.onVisibilityChanged {}
        XCTAssertTrue(conn is SignalConnection)
    }

    // MARK: - Gesture Convenience Tests

    @MainActor func test_widgetOnClick() {
        ensureAdwInit()
        var clicked = false
        let label = Label("Click me")
        let conn = label.onClick { clicked = true }
        XCTAssertTrue(conn is SignalConnection)
        XCTAssertFalse(clicked)
    }

    @MainActor func test_widgetOnClickDetailed() {
        ensureAdwInit()
        let label = Label("Click me")
        let conn = label.onClick { nPress, x, y in
            _ = (nPress, x, y)
        }
        XCTAssertTrue(conn is SignalConnection)
    }

    @MainActor func test_widgetOnLongPress() {
        ensureAdwInit()
        let label = Label("Hold me")
        let conn = label.onLongPress { x, y in _ = (x, y) }
        XCTAssertTrue(conn is SignalConnection)
    }

    @MainActor func test_widgetOnSwipe() {
        ensureAdwInit()
        let label = Label("Swipe me")
        let conn = label.onSwipe { vx, vy in _ = (vx, vy) }
        XCTAssertTrue(conn is SignalConnection)
    }

    // MARK: - findChild Tests

    @MainActor func test_widgetFindChild() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let inner = Box(orientation: GTK_ORIENTATION_HORIZONTAL, spacing: 0)
        let label = Label("Deep")
        inner.append(label)
        box.append(inner)
        // Should find the label inside the inner box
        let found = box.findChild(ofType: Label.self)
        XCTAssertNotNil(found)
    }

    @MainActor func test_widgetFindChildEmpty() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let found = box.findChild(ofType: Label.self)
        XCTAssertNil(found)
    }

    // MARK: - Grid Convenience Tests

    @MainActor func test_gridConvenienceInit() {
        ensureAdwInit()
        let grid = Grid(columnSpacing: 8, rowSpacing: 12)
        XCTAssertTrue(grid.columnSpacing == 8)
        XCTAssertTrue(grid.rowSpacing == 12)
    }

    // MARK: - Paned Convenience Tests

    @MainActor func test_panedConvenienceInit() {
        ensureAdwInit()
        let start = Label("Left")
        let end = Label("Right")
        let paned = Paned(start: start, end: end)
        XCTAssertNotNil(paned.startChild)
        XCTAssertNotNil(paned.endChild)
    }

    // MARK: - NavigationView Push Convenience Tests

    @MainActor func test_navigationViewPushConvenience() {
        ensureAdwInit()
        let nav = NavigationView()
        let root = NavigationPage(child: Label("Root"), title: "Root")
        nav.add(root)
        let page = nav.push(title: "Detail", child: Label("Detail Content"))
        XCTAssertTrue(page.title == "Detail")
    }

    @MainActor func test_navigationViewPushTagConvenience() {
        ensureAdwInit()
        let nav = NavigationView()
        let root = NavigationPage(child: Label("Root"), title: "Root")
        nav.add(root)
        let page = nav.push(title: "Settings", tag: "settings", child: Label("Settings"))
        XCTAssertTrue(page.title == "Settings")
        XCTAssertTrue(page.tag == "settings")
    }

    // MARK: - TextBuffer Convenience Tests

    @MainActor func test_textBufferTextInRange() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        XCTAssertTrue(buf.text(in: 0 ..< 5) == "Hello")
        XCTAssertTrue(buf.text(in: 6 ..< 11) == "World")
    }

    @MainActor func test_textBufferInsertAtOffset() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        buf.insert("Beautiful ", at: 6)
        XCTAssertTrue(buf.text == "Hello Beautiful World")
    }

    @MainActor func test_textBufferApplyTagInRange() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        let tag = buf.createTag(name: "test-tag")
        tag.weight = 700
        buf.applyTag(tag, in: 0 ..< 5)
        // Should not crash
        buf.removeTag(tag, in: 0 ..< 5)
    }

    // MARK: - TextTag Preset Tests

    @MainActor func test_textTagBoldPreset() {
        ensureAdwInit()
        let tag = TextTag.bold()
        XCTAssertTrue(tag.weight == 700)
    }

    @MainActor func test_textTagItalicPreset() {
        ensureAdwInit()
        let tag = TextTag.italic()
        XCTAssertTrue(tag.style == .italic)
    }

    @MainActor func test_textTagMonospacePreset() {
        ensureAdwInit()
        let tag = TextTag.monospace()
        // Just verify it doesn't crash — family is write-only
        XCTAssertTrue(tag is TextTag)
    }

    @MainActor func test_textTagColoredPreset() {
        ensureAdwInit()
        let tag = TextTag.colored("red", name: "error")
        XCTAssertTrue(tag is TextTag)
    }

    // MARK: - Stack Signal Tests

    @MainActor func test_stackOnVisibleChildChanged() {
        ensureAdwInit()
        let stack = Stack()
        let conn = stack.onVisibleChildChanged {}
        XCTAssertTrue(conn is SignalConnection)
    }

    // MARK: - Entry Selection Tests

    @MainActor func test_entrySelectAll() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello World"
        entry.selectAll()
        XCTAssertTrue(entry.hasSelection)
    }

    @MainActor func test_entryCursorPosition() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello"
        entry.cursorPosition = 3
        XCTAssertTrue(entry.cursorPosition == 3)
    }

    @MainActor func test_entryClearSelection() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello"
        entry.selectAll()
        entry.clearSelection()
        XCTAssertFalse(entry.hasSelection)
    }

    // MARK: - Paned Signal Tests

    @MainActor func test_panedOnPositionChanged() {
        ensureAdwInit()
        let paned = Paned()
        let conn = paned.onPositionChanged {}
        XCTAssertTrue(conn is SignalConnection)
    }

    // MARK: - Notebook Fluent Tests

    @MainActor func test_notebookScrollableFluent() {
        ensureAdwInit()
        let nb = Notebook().scrollable()
        XCTAssertTrue(nb.scrollable == true)
    }

    @MainActor func test_notebookTabPosFluent() {
        ensureAdwInit()
        let nb = Notebook().tabPos(GTK_POS_LEFT)
        XCTAssertTrue(nb.tabPos == GTK_POS_LEFT)
    }

}
#endif
