// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class MediaProtocolXCTests: XCTestCase {
    private let missingMediaFilename = "/nonexistent/swift-adwaita-test-media.mp4"

    // MARK: - MediaStream

    @MainActor func test_mediaStreamCreation() {
        ensureAdwInit()
        // Creating from a non-existent file should still create the object
        let stream = MediaStream(filename: missingMediaFilename)
        XCTAssertTrue(stream.isPlaying == false)
        XCTAssertTrue(stream.ended == false)
        XCTAssertTrue(stream.isMuted == false)
    }

    @MainActor func test_mediaStreamVolume() {
        ensureAdwInit()
        let stream = MediaStream(filename: missingMediaFilename)
        stream.volume = 0.5
        XCTAssertTrue(stream.volume > 0.49 && stream.volume < 0.51)
        stream.isMuted = true
        XCTAssertTrue(stream.isMuted == true)
    }

    @MainActor func test_mediaStreamLoop() {
        ensureAdwInit()
        let stream = MediaStream(filename: missingMediaFilename)
        stream.loop = true
        XCTAssertTrue(stream.loop == true)
        stream.loop = false
        XCTAssertTrue(stream.loop == false)
    }

    @MainActor func test_mediaStreamInfo() {
        ensureAdwInit()
        let stream = MediaStream(filename: missingMediaFilename)
        // Duration and timestamp default to 0 for an unprepared stream
        XCTAssertTrue(stream.duration == 0)
        XCTAssertTrue(stream.timestamp == 0)
    }

    // MARK: - Video with MediaStream

    @MainActor func test_videoMediaStreamType() {
        ensureAdwInit()
        let video = Video()
        // Initially no media stream
        XCTAssertNil(video.mediaStream)
    }

    @MainActor func test_videoSetMediaStream() {
        ensureAdwInit()
        let video = Video()
        let stream = MediaStream(filename: missingMediaFilename)
        video.mediaStream = stream
        XCTAssertNotNil(video.mediaStream)
        video.mediaStream = nil
    }

    // MARK: - MediaControls with MediaStream

    @MainActor func test_mediaControlsWithStream() {
        ensureAdwInit()
        let stream = MediaStream(filename: missingMediaFilename)
        let controls = MediaControls(stream: stream)
        XCTAssertNotNil(controls.mediaStream)
        controls.mediaStream = nil
    }

    @MainActor func test_mediaControlsSetStream() {
        ensureAdwInit()
        let controls = MediaControls()
        XCTAssertNil(controls.mediaStream)
        let stream = MediaStream(filename: missingMediaFilename)
        controls.mediaStream = stream
        XCTAssertNotNil(controls.mediaStream)
        controls.mediaStream = nil
    }

    // MARK: - ToggleButton convenience init

    @MainActor func test_toggleButtonConvenienceInit() {
        ensureAdwInit()
        let btn = ToggleButton(label: "Toggle", onToggled: {})
        XCTAssertTrue(btn.active == false)
        // No crash = success, handler was set
    }

    // MARK: - DragSource isDragging

    @MainActor func test_dragSourceIsDragging() {
        ensureAdwInit()
        let drag = DragSource()
        XCTAssertTrue(drag.isDragging == false)
    }

    // MARK: - CallbackAnimationTarget Swift init

    @MainActor func test_callbackAnimationTargetSwiftInit() {
        ensureAdwInit()
        let target = CallbackAnimationTarget { _ in }
        // The target is created with a Swift closure, not raw C pointers
        XCTAssertTrue(target.pointer != UnsafeMutableRawPointer(bitPattern: 0))
    }

    // MARK: - TextAttributes

    @MainActor func test_textAttributesCreation() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addBold()
        attrs.addItalic()
        // No crash = success
    }

    @MainActor func test_textAttributesForegroundColor() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addForegroundColor(red: 1.0, green: 0.0, blue: 0.0)
        attrs.addUnderline(.single)
        // No crash = success
    }

    @MainActor func test_textAttributesFamily() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addFamily("monospace")
        attrs.addSizePoints(14)
        // No crash = success
    }

    @MainActor func test_textAttributesStrikethrough() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addStrikethrough()
        attrs.addStrikethroughColor(red: 0.5, green: 0.5, blue: 0.5)
        // No crash = success
    }

    @MainActor func test_textAttributesWeight() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addWeight(.semibold)
        attrs.addLight()
        // No crash = success
    }

    @MainActor func test_entryRowTextAttributes() {
        ensureAdwInit()
        let row = EntryRow()
        XCTAssertNil(row.textAttributes)
        let attrs = TextAttributes()
        attrs.addBold()
        row.textAttributes = attrs
        let retrieved = row.textAttributes
        XCTAssertNotNil(retrieved)
    }

    // MARK: - Swipeable protocol

    @MainActor func test_carouselIsSwipeable() {
        ensureAdwInit()
        let carousel = Carousel()
        let _: any Swipeable = carousel
        // Carousel conforms to Swipeable
    }

    @MainActor func test_navigationViewIsSwipeable() {
        ensureAdwInit()
        let nav = NavigationView()
        let _: any Swipeable = nav
        // NavigationView conforms to Swipeable
    }

    @MainActor func test_overlaySplitViewIsSwipeable() {
        ensureAdwInit()
        let split = OverlaySplitView()
        let _: any Swipeable = split
        // OverlaySplitView conforms to Swipeable
    }

    @MainActor func test_swipeTrackerWithSwipeable() {
        ensureAdwInit()
        let carousel = Carousel()
        let tracker = SwipeTracker(swipeable: carousel)
        XCTAssertTrue(tracker.enabled == true)
        tracker.enabled = false
        XCTAssertTrue(tracker.enabled == false)
    }

    // MARK: - Container Protocol Conformance

    @MainActor func test_boxConformsToContainer() {
        ensureAdwInit()
        let box = Box(orientation: .horizontal, spacing: 0)
        let _: any Container = box
        let child = Label("hi")
        box.append(child)
        box.remove(child)
    }

    @MainActor func test_listBoxConformsToContainer() {
        ensureAdwInit()
        let list = ListBox()
        let _: any Container = list
        let child = Label("hi")
        list.append(child)
        list.remove(child)
    }

    @MainActor func test_flowBoxConformsToContainer() {
        ensureAdwInit()
        let flow = FlowBox()
        let _: any Container = flow
        let child = Label("hi")
        flow.append(child)
        flow.remove(child)
    }

    @MainActor func test_carouselConformsToContainer() {
        ensureAdwInit()
        let carousel = Carousel()
        let _: any Container = carousel
        let child = Label("hi")
        carousel.append(child)
        carousel.remove(child)
    }

    @MainActor func test_wrapBoxConformsToContainer() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        let _: any Container = wrap
        let child = Label("hi")
        wrap.append(child)
        wrap.remove(child)
    }

    // MARK: - Convenience Initializer Tests

    @MainActor func test_switchRowConvenienceInit() {
        ensureAdwInit()
        let row = SwitchRow(title: "Dark Mode")
        XCTAssertTrue(row.title == "Dark Mode")
    }

    @MainActor func test_switchRowConvenienceInitActive() {
        ensureAdwInit()
        let row = SwitchRow(title: "Enabled", active: true)
        XCTAssertTrue(row.title == "Enabled")
        XCTAssertTrue(row.active == true)
    }

    @MainActor func test_entryRowConvenienceInit() {
        ensureAdwInit()
        let row = EntryRow(title: "Username")
        XCTAssertTrue(row.title == "Username")
    }

    @MainActor func test_spinRowConvenienceInit() {
        ensureAdwInit()
        let row = SpinRow(title: "Volume", min: 0, max: 100, step: 1)
        XCTAssertTrue(row.title == "Volume")
    }

    @MainActor func test_expanderRowConvenienceInit() {
        ensureAdwInit()
        let row = ExpanderRow(title: "Advanced")
        XCTAssertTrue(row.title == "Advanced")
    }

    @MainActor func test_expanderRowConvenienceInitSubtitle() {
        ensureAdwInit()
        let row = ExpanderRow(title: "Advanced", subtitle: "More options")
        XCTAssertTrue(row.title == "Advanced")
        XCTAssertTrue(row.subtitle == "More options")
    }

    @MainActor func test_comboRowConvenienceInit() {
        ensureAdwInit()
        let row = ComboRow(title: "Theme")
        XCTAssertTrue(row.title == "Theme")
    }

    @MainActor func test_passwordEntryRowConvenienceInit() {
        ensureAdwInit()
        let row = PasswordEntryRow(title: "Password")
        XCTAssertTrue(row.title == "Password")
    }

    @MainActor func test_preferencesGroupConvenienceInit() {
        ensureAdwInit()
        let group = PreferencesGroup(title: "General")
        XCTAssertTrue(group.title == "General")
    }

    @MainActor func test_preferencesGroupConvenienceInitDescription() {
        ensureAdwInit()
        let group = PreferencesGroup(title: "General", description: "Basic settings")
        XCTAssertTrue(group.title == "General")
        XCTAssertTrue(group.description == "Basic settings")
    }

    @MainActor func test_preferencesPageConvenienceInit() {
        ensureAdwInit()
        let page = PreferencesPage(title: "Appearance")
        XCTAssertTrue(page.title == "Appearance")
    }

    @MainActor func test_preferencesPageConvenienceInitIcon() {
        ensureAdwInit()
        let page = PreferencesPage(title: "Appearance", iconName: "display-symbolic")
        XCTAssertTrue(page.title == "Appearance")
        XCTAssertTrue(page.iconName == "display-symbolic")
    }

    @MainActor func test_statusPageConvenienceInit() {
        ensureAdwInit()
        let page = StatusPage(title: "No Results", description: "Try a different search")
        XCTAssertTrue(page.title == "No Results")
        XCTAssertTrue(page.description == "Try a different search")
    }

    @MainActor func test_statusPageConvenienceInitIcon() {
        ensureAdwInit()
        let page = StatusPage(
            title: "Error",
            description: "Something went wrong",
            iconName: "dialog-error-symbolic"
        )
        XCTAssertTrue(page.title == "Error")
        XCTAssertTrue(page.description == "Something went wrong")
        XCTAssertTrue(page.iconName == "dialog-error-symbolic")
    }

    @MainActor func test_actionRowConvenienceInit() {
        ensureAdwInit()
        let row = ActionRow(title: "Wi-Fi")
        XCTAssertTrue(row.title == "Wi-Fi")
    }

    @MainActor func test_actionRowConvenienceInitSubtitle() {
        ensureAdwInit()
        let row = ActionRow(title: "Wi-Fi", subtitle: "Connected")
        XCTAssertTrue(row.title == "Wi-Fi")
        XCTAssertTrue(row.subtitle == "Connected")
    }

}
#endif
