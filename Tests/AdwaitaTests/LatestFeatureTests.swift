#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct LatestFeatureTests {

    // MARK: - Individual Margin Fluent Setters

    @Test @MainActor func fluentMarginStart() {
        ensureAdwInit()
        let label = Label("Test").marginStart(8)
        #expect(label.marginStart == 8)
    }

    @Test @MainActor func fluentMarginEnd() {
        ensureAdwInit()
        let label = Label("Test").marginEnd(16)
        #expect(label.marginEnd == 16)
    }

    @Test @MainActor func fluentMarginTop() {
        ensureAdwInit()
        let label = Label("Test").marginTop(4)
        #expect(label.marginTop == 4)
    }

    @Test @MainActor func fluentMarginBottom() {
        ensureAdwInit()
        let label = Label("Test").marginBottom(12)
        #expect(label.marginBottom == 12)
    }

    // MARK: - Children Iteration Tests

    @Test @MainActor func widgetChildren() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let a = Label("A")
        let b = Label("B")
        let c = Label("C")
        box.append(a)
        box.append(b)
        box.append(c)
        let kids = box.children()
        #expect(kids.count == 3)
    }

    @Test @MainActor func widgetForEachChild() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        box.append(Label("A"))
        box.append(Label("B"))
        var count = 0
        box.forEachChild { _ in count += 1 }
        #expect(count == 2)
    }

    // MARK: - MenuButton Convenience Tests

    @Test @MainActor func menuButtonLabelInit() {
        ensureAdwInit()
        let btn = MenuButton(label: "File")
        #expect(btn.label == "File")
    }

    @Test @MainActor func menuButtonIconInit() {
        ensureAdwInit()
        let btn = MenuButton(icon: .openMenu)
        #expect(btn.iconName == "open-menu-symbolic")
    }

    // MARK: - Revealer Signal Tests

    @Test @MainActor func revealerOnChildRevealed() {
        ensureAdwInit()
        let revealer = Revealer()
        // Just verify it connects without crashing
        let conn = revealer.onChildRevealed {}
        #expect(conn is SignalConnection)
    }

    // MARK: - Expander Signal Tests

    @Test @MainActor func expanderOnExpanded() {
        ensureAdwInit()
        let expander = Expander(label: "Details")
        let conn = expander.onExpanded {}
        #expect(conn is SignalConnection)
    }

    // MARK: - Popover Signal Tests

    @Test @MainActor func popoverOnVisibilityChanged() {
        ensureAdwInit()
        let popover = Popover()
        let conn = popover.onVisibilityChanged {}
        #expect(conn is SignalConnection)
    }

    // MARK: - Gesture Convenience Tests

    @Test @MainActor func widgetOnClick() {
        ensureAdwInit()
        var clicked = false
        let label = Label("Click me")
        let conn = label.onClick { clicked = true }
        #expect(conn is SignalConnection)
        #expect(!clicked)
    }

    @Test @MainActor func widgetOnClickDetailed() {
        ensureAdwInit()
        let label = Label("Click me")
        let conn = label.onClick { nPress, x, y in
            _ = (nPress, x, y)
        }
        #expect(conn is SignalConnection)
    }

    @Test @MainActor func widgetOnLongPress() {
        ensureAdwInit()
        let label = Label("Hold me")
        let conn = label.onLongPress { x, y in _ = (x, y) }
        #expect(conn is SignalConnection)
    }

    @Test @MainActor func widgetOnSwipe() {
        ensureAdwInit()
        let label = Label("Swipe me")
        let conn = label.onSwipe { vx, vy in _ = (vx, vy) }
        #expect(conn is SignalConnection)
    }

    // MARK: - findChild Tests

    @Test @MainActor func widgetFindChild() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let inner = Box(orientation: GTK_ORIENTATION_HORIZONTAL, spacing: 0)
        let label = Label("Deep")
        inner.append(label)
        box.append(inner)
        // Should find the label inside the inner box
        let found = box.findChild(ofType: Label.self)
        #expect(found != nil)
    }

    @Test @MainActor func widgetFindChildEmpty() {
        ensureAdwInit()
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        let found = box.findChild(ofType: Label.self)
        #expect(found == nil)
    }

    // MARK: - Grid Convenience Tests

    @Test @MainActor func gridConvenienceInit() {
        ensureAdwInit()
        let grid = Grid(columnSpacing: 8, rowSpacing: 12)
        #expect(grid.columnSpacing == 8)
        #expect(grid.rowSpacing == 12)
    }

    // MARK: - Paned Convenience Tests

    @Test @MainActor func panedConvenienceInit() {
        ensureAdwInit()
        let start = Label("Left")
        let end = Label("Right")
        let paned = Paned(start: start, end: end)
        #expect(paned.startChild != nil)
        #expect(paned.endChild != nil)
    }

    // MARK: - NavigationView Push Convenience Tests

    @Test @MainActor func navigationViewPushConvenience() {
        ensureAdwInit()
        let nav = NavigationView()
        let root = NavigationPage(child: Label("Root"), title: "Root")
        nav.add(root)
        let page = nav.push(title: "Detail", child: Label("Detail Content"))
        #expect(page.title == "Detail")
    }

    @Test @MainActor func navigationViewPushTagConvenience() {
        ensureAdwInit()
        let nav = NavigationView()
        let root = NavigationPage(child: Label("Root"), title: "Root")
        nav.add(root)
        let page = nav.push(title: "Settings", tag: "settings", child: Label("Settings"))
        #expect(page.title == "Settings")
        #expect(page.tag == "settings")
    }

    // MARK: - TextBuffer Convenience Tests

    @Test @MainActor func textBufferTextInRange() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        #expect(buf.text(in: 0 ..< 5) == "Hello")
        #expect(buf.text(in: 6 ..< 11) == "World")
    }

    @Test @MainActor func textBufferInsertAtOffset() {
        ensureAdwInit()
        let buf = TextBuffer()
        buf.text = "Hello World"
        buf.insert("Beautiful ", at: 6)
        #expect(buf.text == "Hello Beautiful World")
    }

    @Test @MainActor func textBufferApplyTagInRange() {
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

    @Test @MainActor func textTagBoldPreset() {
        ensureAdwInit()
        let tag = TextTag.bold()
        #expect(tag.weight == 700)
    }

    @Test @MainActor func textTagItalicPreset() {
        ensureAdwInit()
        let tag = TextTag.italic()
        #expect(tag.style == .italic)
    }

    @Test @MainActor func textTagMonospacePreset() {
        ensureAdwInit()
        let tag = TextTag.monospace()
        // Just verify it doesn't crash — family is write-only
        #expect(tag is TextTag)
    }

    @Test @MainActor func textTagColoredPreset() {
        ensureAdwInit()
        let tag = TextTag.colored("red", name: "error")
        #expect(tag is TextTag)
    }

    // MARK: - Stack Signal Tests

    @Test @MainActor func stackOnVisibleChildChanged() {
        ensureAdwInit()
        let stack = Stack()
        let conn = stack.onVisibleChildChanged {}
        #expect(conn is SignalConnection)
    }

    // MARK: - Entry Selection Tests

    @Test @MainActor func entrySelectAll() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello World"
        entry.selectAll()
        #expect(entry.hasSelection)
    }

    @Test @MainActor func entryCursorPosition() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello"
        entry.cursorPosition = 3
        #expect(entry.cursorPosition == 3)
    }

    @Test @MainActor func entryClearSelection() {
        ensureAdwInit()
        let entry = Entry()
        entry.text = "Hello"
        entry.selectAll()
        entry.clearSelection()
        #expect(!entry.hasSelection)
    }

    // MARK: - Paned Signal Tests

    @Test @MainActor func panedOnPositionChanged() {
        ensureAdwInit()
        let paned = Paned()
        let conn = paned.onPositionChanged {}
        #expect(conn is SignalConnection)
    }

    // MARK: - Notebook Fluent Tests

    @Test @MainActor func notebookScrollableFluent() {
        ensureAdwInit()
        let nb = Notebook().scrollable()
        #expect(nb.scrollable == true)
    }

    @Test @MainActor func notebookTabPosFluent() {
        ensureAdwInit()
        let nb = Notebook().tabPos(GTK_POS_LEFT)
        #expect(nb.tabPos == GTK_POS_LEFT)
    }

}
#endif
