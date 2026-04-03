#if swift(>=6.3)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct LayoutAndMenuTests {

    // MARK: - GMenuRef

    @Test @MainActor func gmenuCreation() {
        ensureAdwInit()
        let menu = GMenuRef()
        _ = menu // verify creation doesn't crash
    }

    @Test @MainActor func gmenuAppendItems() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Open", action: "app.open")
        menu.append("Save", action: "app.save")
    }

    @Test @MainActor func gmenuAppendItem() {
        ensureAdwInit()
        let menu = GMenuRef()
        let item = GMenuItemRef(label: "Quit", action: "app.quit")
        menu.appendItem(item)
    }

    @Test @MainActor func gmenuAppendSection() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Cut", action: "edit.cut")
        section.append("Copy", action: "edit.copy")
        menu.appendSection("Edit", section: section)
    }

    @Test @MainActor func gmenuAppendSectionNilLabel() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Paste", action: "edit.paste")
        menu.appendSection(nil, section: section)
    }

    @Test @MainActor func popoverMenuPresentReturnsFalseWithoutLiveRoot() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Copy", action: "app.copy")

        let row = ListBoxRow()
        let popoverMenu = PopoverMenu(model: menu)

        #expect(popoverMenu.present(from: row, x: 4, y: 4) == false)
        #expect(popoverMenu.parent?.widgetPointer == row.widgetPointer)
    }

    @Test @MainActor func gmenuAppendSubmenu() {
        ensureAdwInit()
        let menu = GMenuRef()
        let submenu = GMenuRef()
        submenu.append("Zoom In", action: "view.zoomIn")
        submenu.append("Zoom Out", action: "view.zoomOut")
        menu.appendSubmenu("View", submenu: submenu)
    }

    @Test @MainActor func gmenuInsertAndRemove() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("First", action: "app.first")
        menu.insert(0, label: "Zeroth", action: "app.zeroth")
        menu.remove(0)
    }

    @Test @MainActor func gmenuRemoveAll() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("A", action: "app.a")
        menu.append("B", action: "app.b")
        menu.removeAll()
    }

    @Test @MainActor func gmenuFreeze() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Static", action: "app.static")
        menu.freeze()
    }

    // MARK: - GMenuItemRef

    @Test @MainActor func gmenuItemCreation() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Open", action: "app.open")
        _ = item
    }

    @Test @MainActor func gmenuItemSetLabel() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Old", action: "app.test")
        item.setLabel("New")
    }

    @Test @MainActor func gmenuItemSetIconName() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Open", action: "app.open")
        item.setIconName("document-open-symbolic")
    }

    @Test @MainActor func gmenuItemSetAttribute() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Test", action: "app.test")
        item.setAttribute("custom-key", value: "custom-value")
    }

    @Test @MainActor func gmenuItemNilLabelAndAction() {
        ensureAdwInit()
        let item = GMenuItemRef(label: nil, action: nil)
        _ = item
    }

    // MARK: - Carousel (extended)

    @Test @MainActor func carouselNPagesEmpty() {
        ensureAdwInit()
        let carousel = Carousel()
        #expect(carousel.nPages == 0)
    }

    @Test @MainActor func carouselPositionDefault() {
        ensureAdwInit()
        let carousel = Carousel()
        #expect(carousel.position == 0.0)
    }

    @Test @MainActor func carouselInteractiveRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        #expect(carousel.interactive == true)
        carousel.interactive = false
        #expect(carousel.interactive == false)
        carousel.interactive = true
        #expect(carousel.interactive == true)
    }

    @Test @MainActor func carouselAllowMouseDragRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.allowMouseDrag = true
        #expect(carousel.allowMouseDrag == true)
        carousel.allowMouseDrag = false
        #expect(carousel.allowMouseDrag == false)
    }

    @Test @MainActor func carouselAllowScrollWheelRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        let initial = carousel.allowScrollWheel
        carousel.allowScrollWheel = !initial
        #expect(carousel.allowScrollWheel == !initial)
    }

    @Test @MainActor func carouselAllowLongSwipesRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.allowLongSwipes = true
        #expect(carousel.allowLongSwipes == true)
        carousel.allowLongSwipes = false
        #expect(carousel.allowLongSwipes == false)
    }

    @Test @MainActor func carouselRevealDuration() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.revealDuration = 500
        #expect(carousel.revealDuration == 500)
    }

    @Test @MainActor func carouselScrollTo() {
        ensureAdwInit()
        let carousel = Carousel()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        carousel.append(page1)
        carousel.append(page2)
        carousel.scrollTo(page1, animate: false)
    }

    @Test @MainActor func carouselOnPageChanged() {
        ensureAdwInit()
        let carousel = Carousel()
        var called = false
        let conn = carousel.onPageChanged { _ in
            called = true
        }
        #expect(conn is SignalConnection)
        conn.disconnect()
        _ = called
    }

    @Test @MainActor func carouselGetNthPage() {
        ensureAdwInit()
        let carousel = Carousel()
        let page1 = Label("First")
        carousel.append(page1)
        let retrieved = carousel.getNthPage(0)
        _ = retrieved // verify retrieval doesn't crash
    }

    // MARK: - CarouselIndicatorDots

    @Test @MainActor func carouselIndicatorDotsCreation() {
        ensureAdwInit()
        let dots = CarouselIndicatorDots()
        _ = dots
    }

    @Test @MainActor func carouselIndicatorDotsCarouselProperty() {
        ensureAdwInit()
        let dots = CarouselIndicatorDots()
        #expect(dots.carousel == nil)
        let carousel = Carousel()
        dots.carousel = carousel
        #expect(dots.carousel != nil)
        dots.carousel = nil
        #expect(dots.carousel == nil)
    }

    // MARK: - CarouselIndicatorLines

    @Test @MainActor func carouselIndicatorLinesCreation() {
        ensureAdwInit()
        let lines = CarouselIndicatorLines()
        _ = lines
    }

    @Test @MainActor func carouselIndicatorLinesCarouselProperty() {
        ensureAdwInit()
        let lines = CarouselIndicatorLines()
        #expect(lines.carousel == nil)
        let carousel = Carousel()
        lines.carousel = carousel
        #expect(lines.carousel != nil)
        lines.carousel = nil
        #expect(lines.carousel == nil)
    }

    // MARK: - ViewSwitcher

    @Test @MainActor func viewSwitcherCreation() {
        ensureAdwInit()
        let switcher = ViewSwitcher()
        _ = switcher
    }

    @Test @MainActor func viewSwitcherStackProperty() {
        ensureAdwInit()
        let switcher = ViewSwitcher()
        #expect(switcher.stack == nil)
        let stack = ViewStack()
        switcher.stack = stack
        #expect(switcher.stack != nil)
        switcher.stack = nil
        #expect(switcher.stack == nil)
    }

    @Test @MainActor func viewSwitcherPolicy() {
        ensureAdwInit()
        let switcher = ViewSwitcher()
        switcher.policy = .wide
        #expect(switcher.policy == .wide)
        switcher.policy = .narrow
        #expect(switcher.policy == .narrow)
    }

    // MARK: - ViewSwitcherBar

    @Test @MainActor func viewSwitcherBarCreation() {
        ensureAdwInit()
        let bar = ViewSwitcherBar()
        _ = bar
    }

    @Test @MainActor func viewSwitcherBarStackProperty() {
        ensureAdwInit()
        let bar = ViewSwitcherBar()
        #expect(bar.stack == nil)
        let stack = ViewStack()
        bar.stack = stack
        #expect(bar.stack != nil)
    }

    @Test @MainActor func viewSwitcherBarReveal() {
        ensureAdwInit()
        let bar = ViewSwitcherBar()
        #expect(bar.reveal == false)
        bar.reveal = true
        #expect(bar.reveal == true)
        bar.reveal = false
        #expect(bar.reveal == false)
    }

    // MARK: - InlineViewSwitcher

    @Test @MainActor func inlineViewSwitcherCreation() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else {
            // libadwaita < 1.7; skip gracefully.
            return
        }
        _ = switcher
    }

    @Test @MainActor func inlineViewSwitcherStackProperty() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else { return }
        #expect(switcher.stack == nil)
        let stack = ViewStack()
        switcher.stack = stack
        #expect(switcher.stack != nil)
    }

    @Test @MainActor func inlineViewSwitcherDisplayMode() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else { return }
        switcher.displayMode = .icons
        #expect(switcher.displayMode == .icons)
        switcher.displayMode = .labels
        #expect(switcher.displayMode == .labels)
        switcher.displayMode = .both
        #expect(switcher.displayMode == .both)
    }

    @Test @MainActor func inlineViewSwitcherCanShrinkAndHomogeneous() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else { return }
        switcher.canShrink = true
        #expect(switcher.canShrink == true)
        switcher.homogeneous = true
        #expect(switcher.homogeneous == true)
    }

    // MARK: - ViewStackPage

    @Test @MainActor func viewStackPageProperties() {
        ensureAdwInit()
        let stack = ViewStack()
        let child = Label("Hello")
        let page = stack.addTitled(child, name: "hello", title: "Hello")

        #expect(page.title == "Hello")
        #expect(page.name == "hello")

        page.title = "Changed"
        #expect(page.title == "Changed")

        page.iconName = "go-home-symbolic"
        #expect(page.iconName == "go-home-symbolic")

        page.badgeNumber = 42
        #expect(page.badgeNumber == 42)

        page.needsAttention = true
        #expect(page.needsAttention == true)

        page.useUnderline = true
        #expect(page.useUnderline == true)

        page.visible = false
        #expect(page.visible == false)
    }

    @Test @MainActor func viewStackPageChild() {
        ensureAdwInit()
        let stack = ViewStack()
        let child = Label("Content")
        let page = stack.add(child)
        _ = page.child // read-only; should not crash
    }
}
#endif
