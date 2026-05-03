// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class LayoutAndMenuXCTests: XCTestCase {

    // MARK: - GMenuRef

    @MainActor func test_gmenuCreation() {
        ensureAdwInit()
        let menu = GMenuRef()
        _ = menu // verify creation doesn't crash
    }

    @MainActor func test_gmenuAppendItems() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Open", action: "app.open")
        menu.append("Save", action: "app.save")
    }

    @MainActor func test_gmenuAppendItem() {
        ensureAdwInit()
        let menu = GMenuRef()
        let item = GMenuItemRef(label: "Quit", action: "app.quit")
        menu.appendItem(item)
    }

    @MainActor func test_gmenuAppendSection() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Cut", action: "edit.cut")
        section.append("Copy", action: "edit.copy")
        menu.appendSection("Edit", section: section)
    }

    @MainActor func test_gmenuAppendSectionNilLabel() {
        ensureAdwInit()
        let menu = GMenuRef()
        let section = GMenuRef()
        section.append("Paste", action: "edit.paste")
        menu.appendSection(nil, section: section)
    }

    @MainActor func test_popoverMenuPresentReturnsFalseWithoutLiveRoot() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Copy", action: "app.copy")

        let row = ListBoxRow()
        let popoverMenu = PopoverMenu(model: menu)

        XCTAssertTrue(popoverMenu.present(from: row, x: 4, y: 4) == false)
        XCTAssertTrue(popoverMenu.parent?.widgetPointer == row.widgetPointer)
    }

    @MainActor func test_gmenuAppendSubmenu() {
        ensureAdwInit()
        let menu = GMenuRef()
        let submenu = GMenuRef()
        submenu.append("Zoom In", action: "view.zoomIn")
        submenu.append("Zoom Out", action: "view.zoomOut")
        menu.appendSubmenu("View", submenu: submenu)
    }

    @MainActor func test_gmenuInsertAndRemove() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("First", action: "app.first")
        menu.insert(0, label: "Zeroth", action: "app.zeroth")
        menu.remove(0)
    }

    @MainActor func test_gmenuRemoveAll() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("A", action: "app.a")
        menu.append("B", action: "app.b")
        menu.removeAll()
    }

    @MainActor func test_gmenuFreeze() {
        ensureAdwInit()
        let menu = GMenuRef()
        menu.append("Static", action: "app.static")
        menu.freeze()
    }

    // MARK: - GMenuItemRef

    @MainActor func test_gmenuItemCreation() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Open", action: "app.open")
        _ = item
    }

    @MainActor func test_gmenuItemSetLabel() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Old", action: "app.test")
        item.setLabel("New")
    }

    @MainActor func test_gmenuItemSetIconName() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Open", action: "app.open")
        item.setIconName("document-open-symbolic")
    }

    @MainActor func test_gmenuItemSetAttribute() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Test", action: "app.test")
        item.setAttribute("custom-key", value: "custom-value")
    }

    @MainActor func test_gmenuItemNilLabelAndAction() {
        ensureAdwInit()
        let item = GMenuItemRef(label: nil, action: nil)
        _ = item
    }

    // MARK: - Carousel (extended)

    @MainActor func test_carouselNPagesEmpty() {
        ensureAdwInit()
        let carousel = Carousel()
        XCTAssertTrue(carousel.nPages == 0)
    }

    @MainActor func test_carouselPositionDefault() {
        ensureAdwInit()
        let carousel = Carousel()
        XCTAssertTrue(carousel.position == 0.0)
    }

    @MainActor func test_carouselInteractiveRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        XCTAssertTrue(carousel.interactive == true)
        carousel.interactive = false
        XCTAssertTrue(carousel.interactive == false)
        carousel.interactive = true
        XCTAssertTrue(carousel.interactive == true)
    }

    @MainActor func test_carouselAllowMouseDragRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.allowMouseDrag = true
        XCTAssertTrue(carousel.allowMouseDrag == true)
        carousel.allowMouseDrag = false
        XCTAssertTrue(carousel.allowMouseDrag == false)
    }

    @MainActor func test_carouselAllowScrollWheelRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        let initial = carousel.allowScrollWheel
        carousel.allowScrollWheel = !initial
        XCTAssertTrue(carousel.allowScrollWheel == !initial)
    }

    @MainActor func test_carouselAllowLongSwipesRoundTrip() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.allowLongSwipes = true
        XCTAssertTrue(carousel.allowLongSwipes == true)
        carousel.allowLongSwipes = false
        XCTAssertTrue(carousel.allowLongSwipes == false)
    }

    @MainActor func test_carouselRevealDuration() {
        ensureAdwInit()
        let carousel = Carousel()
        carousel.revealDuration = 500
        XCTAssertTrue(carousel.revealDuration == 500)
    }

    @MainActor func test_carouselScrollTo() {
        ensureAdwInit()
        let carousel = Carousel()
        let page1 = Label("Page 1")
        let page2 = Label("Page 2")
        carousel.append(page1)
        carousel.append(page2)
        carousel.scrollTo(page1, animate: false)
    }

    @MainActor func test_carouselOnPageChanged() {
        ensureAdwInit()
        let carousel = Carousel()
        var called = false
        let conn = carousel.onPageChanged { _ in
            called = true
        }
        XCTAssertTrue(conn is SignalConnection)
        conn.disconnect()
        _ = called
    }

    @MainActor func test_carouselGetNthPage() {
        ensureAdwInit()
        let carousel = Carousel()
        let page1 = Label("First")
        carousel.append(page1)
        let retrieved = carousel.getNthPage(0)
        _ = retrieved // verify retrieval doesn't crash
    }

    // MARK: - CarouselIndicatorDots

    @MainActor func test_carouselIndicatorDotsCreation() {
        ensureAdwInit()
        let dots = CarouselIndicatorDots()
        _ = dots
    }

    @MainActor func test_carouselIndicatorDotsCarouselProperty() {
        ensureAdwInit()
        let dots = CarouselIndicatorDots()
        XCTAssertNil(dots.carousel)
        let carousel = Carousel()
        dots.carousel = carousel
        XCTAssertNotNil(dots.carousel)
        dots.carousel = nil
        XCTAssertNil(dots.carousel)
    }

    // MARK: - CarouselIndicatorLines

    @MainActor func test_carouselIndicatorLinesCreation() {
        ensureAdwInit()
        let lines = CarouselIndicatorLines()
        _ = lines
    }

    @MainActor func test_carouselIndicatorLinesCarouselProperty() {
        ensureAdwInit()
        let lines = CarouselIndicatorLines()
        XCTAssertNil(lines.carousel)
        let carousel = Carousel()
        lines.carousel = carousel
        XCTAssertNotNil(lines.carousel)
        lines.carousel = nil
        XCTAssertNil(lines.carousel)
    }

    // MARK: - ViewSwitcher

    @MainActor func test_viewSwitcherCreation() {
        ensureAdwInit()
        let switcher = ViewSwitcher()
        _ = switcher
    }

    @MainActor func test_viewSwitcherStackProperty() {
        ensureAdwInit()
        let switcher = ViewSwitcher()
        XCTAssertNil(switcher.stack)
        let stack = ViewStack()
        switcher.stack = stack
        XCTAssertNotNil(switcher.stack)
        switcher.stack = nil
        XCTAssertNil(switcher.stack)
    }

    @MainActor func test_viewSwitcherPolicy() {
        ensureAdwInit()
        let switcher = ViewSwitcher()
        switcher.policy = .wide
        XCTAssertTrue(switcher.policy == .wide)
        switcher.policy = .narrow
        XCTAssertTrue(switcher.policy == .narrow)
    }

    // MARK: - ViewSwitcherBar

    @MainActor func test_viewSwitcherBarCreation() {
        ensureAdwInit()
        let bar = ViewSwitcherBar()
        _ = bar
    }

    @MainActor func test_viewSwitcherBarStackProperty() {
        ensureAdwInit()
        let bar = ViewSwitcherBar()
        XCTAssertNil(bar.stack)
        let stack = ViewStack()
        bar.stack = stack
        XCTAssertNotNil(bar.stack)
    }

    @MainActor func test_viewSwitcherBarReveal() {
        ensureAdwInit()
        let bar = ViewSwitcherBar()
        XCTAssertTrue(bar.reveal == false)
        bar.reveal = true
        XCTAssertTrue(bar.reveal == true)
        bar.reveal = false
        XCTAssertTrue(bar.reveal == false)
    }

    // MARK: - InlineViewSwitcher

    @MainActor func test_inlineViewSwitcherCreation() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else {
            // libadwaita < 1.7; skip gracefully.
            return
        }
        _ = switcher
    }

    @MainActor func test_inlineViewSwitcherStackProperty() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else { return }
        XCTAssertNil(switcher.stack)
        let stack = ViewStack()
        switcher.stack = stack
        XCTAssertNotNil(switcher.stack)
    }

    @MainActor func test_inlineViewSwitcherDisplayMode() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else { return }
        switcher.displayMode = .icons
        XCTAssertTrue(switcher.displayMode == .icons)
        switcher.displayMode = .labels
        XCTAssertTrue(switcher.displayMode == .labels)
        switcher.displayMode = .both
        XCTAssertTrue(switcher.displayMode == .both)
    }

    @MainActor func test_inlineViewSwitcherCanShrinkAndHomogeneous() {
        ensureAdwInit()
        guard let switcher = InlineViewSwitcher() else { return }
        switcher.canShrink = true
        XCTAssertTrue(switcher.canShrink == true)
        switcher.homogeneous = true
        XCTAssertTrue(switcher.homogeneous == true)
    }

    // MARK: - ViewStackPage

    @MainActor func test_viewStackPageProperties() {
        ensureAdwInit()
        let stack = ViewStack()
        let child = Label("Hello")
        let page = stack.addTitled(child, name: "hello", title: "Hello")

        XCTAssertTrue(page.title == "Hello")
        XCTAssertTrue(page.name == "hello")

        page.title = "Changed"
        XCTAssertTrue(page.title == "Changed")

        page.iconName = "go-home-symbolic"
        XCTAssertTrue(page.iconName == "go-home-symbolic")

        page.badgeNumber = 42
        XCTAssertTrue(page.badgeNumber == 42)

        page.needsAttention = true
        XCTAssertTrue(page.needsAttention == true)

        page.useUnderline = true
        XCTAssertTrue(page.useUnderline == true)

        page.visible = false
        XCTAssertTrue(page.visible == false)
    }

    @MainActor func test_viewStackPageChild() {
        ensureAdwInit()
        let stack = ViewStack()
        let child = Label("Content")
        let page = stack.add(child)
        _ = page.child // read-only; should not crash
    }
}
#endif
