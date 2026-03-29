import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct MediaProtocolTests {

    // MARK: - MediaStream

    @Test @MainActor func mediaStreamCreation() {
        ensureAdwInit()
        // Creating from a non-existent file should still create the object
        let stream = MediaStream(filename: "/dev/null")
        #expect(stream.isPlaying == false)
        #expect(stream.ended == false)
        #expect(stream.isMuted == false)
    }

    @Test @MainActor func mediaStreamVolume() {
        ensureAdwInit()
        let stream = MediaStream(filename: "/dev/null")
        stream.volume = 0.5
        #expect(stream.volume > 0.49 && stream.volume < 0.51)
        stream.isMuted = true
        #expect(stream.isMuted == true)
    }

    @Test @MainActor func mediaStreamLoop() {
        ensureAdwInit()
        let stream = MediaStream(filename: "/dev/null")
        stream.loop = true
        #expect(stream.loop == true)
        stream.loop = false
        #expect(stream.loop == false)
    }

    @Test @MainActor func mediaStreamInfo() {
        ensureAdwInit()
        let stream = MediaStream(filename: "/dev/null")
        // Duration and timestamp default to 0 for an unprepared stream
        #expect(stream.duration == 0)
        #expect(stream.timestamp == 0)
    }

    // MARK: - Video with MediaStream

    @Test @MainActor func videoMediaStreamType() {
        ensureAdwInit()
        let video = Video()
        // Initially no media stream
        #expect(video.mediaStream == nil)
    }

    @Test @MainActor func videoSetMediaStream() {
        ensureAdwInit()
        let video = Video()
        let stream = MediaStream(filename: "/dev/null")
        video.mediaStream = stream
        #expect(video.mediaStream != nil)
    }

    // MARK: - MediaControls with MediaStream

    @Test @MainActor func mediaControlsWithStream() {
        ensureAdwInit()
        let stream = MediaStream(filename: "/dev/null")
        let controls = MediaControls(stream: stream)
        #expect(controls.mediaStream != nil)
    }

    @Test @MainActor func mediaControlsSetStream() {
        ensureAdwInit()
        let controls = MediaControls()
        #expect(controls.mediaStream == nil)
        let stream = MediaStream(filename: "/dev/null")
        controls.mediaStream = stream
        #expect(controls.mediaStream != nil)
    }

    // MARK: - ToggleButton convenience init

    @Test @MainActor func toggleButtonConvenienceInit() {
        ensureAdwInit()
        var toggled = false
        let btn = ToggleButton(label: "Toggle", onToggled: {
            toggled = true
        })
        #expect(btn.active == false)
        // No crash = success, handler was set
    }

    // MARK: - DragSource isDragging

    @Test @MainActor func dragSourceIsDragging() {
        ensureAdwInit()
        let drag = DragSource()
        #expect(drag.isDragging == false)
    }

    // MARK: - CallbackAnimationTarget Swift init

    @Test @MainActor func callbackAnimationTargetSwiftInit() {
        ensureAdwInit()
        var called = false
        let target = CallbackAnimationTarget { _ in
            called = true
        }
        // The target is created with a Swift closure, not raw C pointers
        #expect(target.pointer != UnsafeMutableRawPointer(bitPattern: 0))
    }

    // MARK: - TextAttributes

    @Test @MainActor func textAttributesCreation() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addBold()
        attrs.addItalic()
        // No crash = success
    }

    @Test @MainActor func textAttributesForegroundColor() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addForegroundColor(red: 1.0, green: 0.0, blue: 0.0)
        attrs.addUnderline(.single)
        // No crash = success
    }

    @Test @MainActor func textAttributesFamily() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addFamily("monospace")
        attrs.addSizePoints(14)
        // No crash = success
    }

    @Test @MainActor func textAttributesStrikethrough() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addStrikethrough()
        attrs.addStrikethroughColor(red: 0.5, green: 0.5, blue: 0.5)
        // No crash = success
    }

    @Test @MainActor func textAttributesWeight() {
        ensureAdwInit()
        let attrs = TextAttributes()
        attrs.addWeight(.semibold)
        attrs.addLight()
        // No crash = success
    }

    @Test @MainActor func entryRowTextAttributes() {
        ensureAdwInit()
        let row = EntryRow()
        #expect(row.textAttributes == nil)
        let attrs = TextAttributes()
        attrs.addBold()
        row.textAttributes = attrs
        let retrieved = row.textAttributes
        #expect(retrieved != nil)
    }

    // MARK: - Swipeable protocol

    @Test @MainActor func carouselIsSwipeable() {
        ensureAdwInit()
        let carousel = Carousel()
        let _: any Swipeable = carousel
        // Carousel conforms to Swipeable
    }

    @Test @MainActor func navigationViewIsSwipeable() {
        ensureAdwInit()
        let nav = NavigationView()
        let _: any Swipeable = nav
        // NavigationView conforms to Swipeable
    }

    @Test @MainActor func overlaySplitViewIsSwipeable() {
        ensureAdwInit()
        let split = OverlaySplitView()
        let _: any Swipeable = split
        // OverlaySplitView conforms to Swipeable
    }

    @Test @MainActor func swipeTrackerWithSwipeable() {
        ensureAdwInit()
        let carousel = Carousel()
        let tracker = SwipeTracker(swipeable: carousel)
        #expect(tracker.enabled == true)
        tracker.enabled = false
        #expect(tracker.enabled == false)
    }

    // MARK: - Container Protocol Conformance

    @Test @MainActor func boxConformsToContainer() {
        ensureAdwInit()
        let box = Box(orientation: .horizontal, spacing: 0)
        let _: any Container = box
        let child = Label("hi")
        box.append(child)
        box.remove(child)
    }

    @Test @MainActor func listBoxConformsToContainer() {
        ensureAdwInit()
        let list = ListBox()
        let _: any Container = list
        let child = Label("hi")
        list.append(child)
        list.remove(child)
    }

    @Test @MainActor func flowBoxConformsToContainer() {
        ensureAdwInit()
        let flow = FlowBox()
        let _: any Container = flow
        let child = Label("hi")
        flow.append(child)
        flow.remove(child)
    }

    @Test @MainActor func carouselConformsToContainer() {
        ensureAdwInit()
        let carousel = Carousel()
        let _: any Container = carousel
        let child = Label("hi")
        carousel.append(child)
        carousel.remove(child)
    }

    @Test @MainActor func wrapBoxConformsToContainer() {
        ensureAdwInit()
        guard let wrap = WrapBox() else { return }
        let _: any Container = wrap
        let child = Label("hi")
        wrap.append(child)
        wrap.remove(child)
    }

    // MARK: - Convenience Initializer Tests

    @Test @MainActor func switchRowConvenienceInit() {
        ensureAdwInit()
        let row = SwitchRow(title: "Dark Mode")
        #expect(row.title == "Dark Mode")
    }

    @Test @MainActor func switchRowConvenienceInitActive() {
        ensureAdwInit()
        let row = SwitchRow(title: "Enabled", active: true)
        #expect(row.title == "Enabled")
        #expect(row.active == true)
    }

    @Test @MainActor func entryRowConvenienceInit() {
        ensureAdwInit()
        let row = EntryRow(title: "Username")
        #expect(row.title == "Username")
    }

    @Test @MainActor func spinRowConvenienceInit() {
        ensureAdwInit()
        let row = SpinRow(title: "Volume", min: 0, max: 100, step: 1)
        #expect(row.title == "Volume")
    }

    @Test @MainActor func expanderRowConvenienceInit() {
        ensureAdwInit()
        let row = ExpanderRow(title: "Advanced")
        #expect(row.title == "Advanced")
    }

    @Test @MainActor func expanderRowConvenienceInitSubtitle() {
        ensureAdwInit()
        let row = ExpanderRow(title: "Advanced", subtitle: "More options")
        #expect(row.title == "Advanced")
        #expect(row.subtitle == "More options")
    }

    @Test @MainActor func comboRowConvenienceInit() {
        ensureAdwInit()
        let row = ComboRow(title: "Theme")
        #expect(row.title == "Theme")
    }

    @Test @MainActor func passwordEntryRowConvenienceInit() {
        ensureAdwInit()
        let row = PasswordEntryRow(title: "Password")
        #expect(row.title == "Password")
    }

    @Test @MainActor func preferencesGroupConvenienceInit() {
        ensureAdwInit()
        let group = PreferencesGroup(title: "General")
        #expect(group.title == "General")
    }

    @Test @MainActor func preferencesGroupConvenienceInitDescription() {
        ensureAdwInit()
        let group = PreferencesGroup(title: "General", description: "Basic settings")
        #expect(group.title == "General")
        #expect(group.description == "Basic settings")
    }

    @Test @MainActor func preferencesPageConvenienceInit() {
        ensureAdwInit()
        let page = PreferencesPage(title: "Appearance")
        #expect(page.title == "Appearance")
    }

    @Test @MainActor func preferencesPageConvenienceInitIcon() {
        ensureAdwInit()
        let page = PreferencesPage(title: "Appearance", iconName: "display-symbolic")
        #expect(page.title == "Appearance")
        #expect(page.iconName == "display-symbolic")
    }

    @Test @MainActor func statusPageConvenienceInit() {
        ensureAdwInit()
        let page = StatusPage(title: "No Results", description: "Try a different search")
        #expect(page.title == "No Results")
        #expect(page.description == "Try a different search")
    }

    @Test @MainActor func statusPageConvenienceInitIcon() {
        ensureAdwInit()
        let page = StatusPage(title: "Error", description: "Something went wrong", iconName: "dialog-error-symbolic")
        #expect(page.title == "Error")
        #expect(page.description == "Something went wrong")
        #expect(page.iconName == "dialog-error-symbolic")
    }

    @Test @MainActor func actionRowConvenienceInit() {
        ensureAdwInit()
        let row = ActionRow(title: "Wi-Fi")
        #expect(row.title == "Wi-Fi")
    }

    @Test @MainActor func actionRowConvenienceInitSubtitle() {
        ensureAdwInit()
        let row = ActionRow(title: "Wi-Fi", subtitle: "Connected")
        #expect(row.title == "Wi-Fi")
        #expect(row.subtitle == "Connected")
    }

}
