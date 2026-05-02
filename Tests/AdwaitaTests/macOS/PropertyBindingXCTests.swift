#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class PropertyBindingXCTests: XCTestCase {

    // MARK: - Property Binding

    @MainActor func test_bindPropertySyncsOnCreate() {
        ensureAdwInit()
        let source = Switch()
        source.active = true
        let target = Switch()
        target.active = false
        _ = source.bind(.active, to: target, property: .active)
        XCTAssertTrue(target.active == true, "Binding with SYNC_CREATE should sync value immediately")
    }

    @MainActor func test_bindPropertyPropagatesChanges() {
        ensureAdwInit()
        let source = Switch()
        source.active = false
        let target = Switch()
        _ = source.bind(.active, to: target, property: .active)
        source.active = true
        XCTAssertTrue(target.active == true, "Target should update when source changes")
    }

    @MainActor func test_bindLabelToLabel() {
        ensureAdwInit()
        let source = Label("Hello")
        let target = Label("")
        // GtkLabel's GObject property for displayed text is "label", not "text"
        _ = source.bind(.label, to: target, property: .label)
        XCTAssertTrue(target.text == "Hello", "Binding should sync initial value")
        source.text = "World"
        XCTAssertTrue(target.text == "World", "Target should update when source label changes")
    }

    @MainActor func test_bindVisibleProperty() {
        ensureAdwInit()
        let source = Switch()
        source.active = true
        let target = Button(label: "Test")
        _ = source.bind(.active, to: target, property: .visible)
        XCTAssertTrue(target.visible == true)
        source.active = false
        XCTAssertTrue(target.visible == false, "Button visibility should follow switch state")
    }

    @MainActor func test_bindSensitiveProperty() {
        ensureAdwInit()
        let sw = Switch()
        sw.active = true
        let button = Button(label: "Action")
        _ = sw.bind(.active, to: button, property: .sensitive)
        XCTAssertTrue(button.sensitive == true)
        sw.active = false
        XCTAssertTrue(button.sensitive == false, "Button sensitivity should follow switch state")
    }

    // MARK: - Widget Common Properties

    @MainActor func test_widgetVisibleProperty() {
        ensureAdwInit()
        let label = Label("Test")
        XCTAssertTrue(label.visible == true, "Widgets are visible by default")
        label.visible = false
        XCTAssertTrue(label.visible == false)
        label.visible = true
        XCTAssertTrue(label.visible == true)
    }

    @MainActor func test_widgetSensitiveProperty() {
        ensureAdwInit()
        let button = Button(label: "Test")
        XCTAssertTrue(button.sensitive == true, "Widgets are sensitive by default")
        button.sensitive = false
        XCTAssertTrue(button.sensitive == false)
    }

    @MainActor func test_widgetOpacityProperty() {
        ensureAdwInit()
        let label = Label("Test")
        label.opacity = 0.5
        XCTAssertTrue(abs(label.opacity - 0.5) < 0.01)
        label.opacity = 1.0
        XCTAssertTrue(abs(label.opacity - 1.0) < 0.01)
    }

    @MainActor func test_widgetTooltipTextProperty() {
        ensureAdwInit()
        let button = Button(label: "Test")
        button.tooltipText = "Click me"
        XCTAssertTrue(button.tooltipText == "Click me")
    }

    @MainActor func test_widgetSizeRequest() {
        ensureAdwInit()
        let label = Label("Test")
        label.setSizeRequest(width: 100, height: 50)
        var w: Int32 = 0, h: Int32 = 0
        gtk_widget_get_size_request(label.widgetPointer, &w, &h)
        XCTAssertTrue(w == 100)
        XCTAssertTrue(h == 50)
    }

    @MainActor func test_widgetMargins() {
        ensureAdwInit()
        let label = Label("Test")
        label.setMargins(16)
        XCTAssertTrue(label.marginTop == 16)
        XCTAssertTrue(label.marginBottom == 16)
        XCTAssertTrue(label.marginStart == 16)
        XCTAssertTrue(label.marginEnd == 16)
    }

    @MainActor func test_widgetIndividualMargins() {
        ensureAdwInit()
        let label = Label("Test")
        label.marginTop = 10
        label.marginBottom = 20
        label.marginStart = 30
        label.marginEnd = 40
        XCTAssertTrue(label.marginTop == 10)
        XCTAssertTrue(label.marginBottom == 20)
        XCTAssertTrue(label.marginStart == 30)
        XCTAssertTrue(label.marginEnd == 40)
    }

    @MainActor func test_widgetHalignValign() {
        ensureAdwInit()
        let label = Label("Test")
        label.halign = .center
        label.valign = .end
        XCTAssertTrue(label.halign == .center)
        XCTAssertTrue(label.valign == .end)
    }

    @MainActor func test_widgetExpandProperties() {
        ensureAdwInit()
        let label = Label("Test")
        label.hexpand = true
        label.vexpand = true
        XCTAssertTrue(label.hexpand == true)
        XCTAssertTrue(label.vexpand == true)
        label.hexpand = false
        XCTAssertTrue(label.hexpand == false)
    }

    // MARK: - Edge Cases

    @MainActor func test_emptyLabelText() {
        ensureAdwInit()
        let label = Label("")
        XCTAssertTrue(label.text == "")
        label.text = "non-empty"
        XCTAssertTrue(label.text == "non-empty")
        label.text = ""
        XCTAssertTrue(label.text == "")
    }

    @MainActor func test_entryMaxLength() {
        ensureAdwInit()
        let entry = Entry()
        entry.maxLength = 5
        XCTAssertTrue(entry.maxLength == 5)
        entry.text = "abcdefgh"
        // GTK truncates to max length
        XCTAssertTrue(entry.text.count <= 5)
    }

    @MainActor func test_scaleValueClamping() {
        ensureAdwInit()
        let scale = Scale(orientation: .horizontal, min: 0, max: 100, step: 1)
        scale.value = 50
        XCTAssertTrue(abs(scale.value - 50) < 0.01)
        scale.value = -10 // Below min
        XCTAssertTrue(scale.value >= 0, "Scale should clamp to minimum")
        scale.value = 200 // Above max
        XCTAssertTrue(scale.value <= 100, "Scale should clamp to maximum")
    }

    @MainActor func test_spinButtonValueClamping() {
        ensureAdwInit()
        let spin = SpinButton(min: 0, max: 10, step: 1)
        spin.value = 5
        XCTAssertTrue(abs(spin.value - 5) < 0.01)
        spin.value = -5
        XCTAssertTrue(spin.value >= 0, "SpinButton should clamp to minimum")
        spin.value = 20
        XCTAssertTrue(spin.value <= 10, "SpinButton should clamp to maximum")
    }

    @MainActor func test_levelBarMinMax() {
        ensureAdwInit()
        let bar = LevelBar()
        bar.minValue = 0
        bar.maxValue = 100
        bar.value = 75
        XCTAssertTrue(abs(bar.value - 75) < 0.01)
        XCTAssertTrue(abs(bar.minValue - 0) < 0.01)
        XCTAssertTrue(abs(bar.maxValue - 100) < 0.01)
    }

    @MainActor func test_progressBarFraction() {
        ensureAdwInit()
        let bar = ProgressBar()
        bar.fraction = 0.0
        XCTAssertTrue(abs(bar.fraction - 0.0) < 0.01)
        bar.fraction = 0.5
        XCTAssertTrue(abs(bar.fraction - 0.5) < 0.01)
        bar.fraction = 1.0
        XCTAssertTrue(abs(bar.fraction - 1.0) < 0.01)
    }
}
#endif
