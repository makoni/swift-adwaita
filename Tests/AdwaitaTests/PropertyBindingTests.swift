// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct PropertyBindingTests {

    // MARK: - Property Binding

    @Test @MainActor func bindPropertySyncsOnCreate() {
        ensureAdwInit()
        let source = Switch()
        source.active = true
        let target = Switch()
        target.active = false
        _ = source.bind(.active, to: target, property: .active)
        #expect(target.active == true, "Binding with SYNC_CREATE should sync value immediately")
    }

    @Test @MainActor func bindPropertyPropagatesChanges() {
        ensureAdwInit()
        let source = Switch()
        source.active = false
        let target = Switch()
        _ = source.bind(.active, to: target, property: .active)
        source.active = true
        #expect(target.active == true, "Target should update when source changes")
    }

    @Test @MainActor func bindLabelToLabel() {
        ensureAdwInit()
        let source = Label("Hello")
        let target = Label("")
        // GtkLabel's GObject property for displayed text is "label", not "text"
        _ = source.bind(.label, to: target, property: .label)
        #expect(target.text == "Hello", "Binding should sync initial value")
        source.text = "World"
        #expect(target.text == "World", "Target should update when source label changes")
    }

    @Test @MainActor func bindVisibleProperty() {
        ensureAdwInit()
        let source = Switch()
        source.active = true
        let target = Button(label: "Test")
        _ = source.bind(.active, to: target, property: .visible)
        #expect(target.visible == true)
        source.active = false
        #expect(target.visible == false, "Button visibility should follow switch state")
    }

    @Test @MainActor func bindSensitiveProperty() {
        ensureAdwInit()
        let sw = Switch()
        sw.active = true
        let button = Button(label: "Action")
        _ = sw.bind(.active, to: button, property: .sensitive)
        #expect(button.sensitive == true)
        sw.active = false
        #expect(button.sensitive == false, "Button sensitivity should follow switch state")
    }

    // MARK: - Widget Common Properties

    @Test @MainActor func widgetVisibleProperty() {
        ensureAdwInit()
        let label = Label("Test")
        #expect(label.visible == true, "Widgets are visible by default")
        label.visible = false
        #expect(label.visible == false)
        label.visible = true
        #expect(label.visible == true)
    }

    @Test @MainActor func widgetSensitiveProperty() {
        ensureAdwInit()
        let button = Button(label: "Test")
        #expect(button.sensitive == true, "Widgets are sensitive by default")
        button.sensitive = false
        #expect(button.sensitive == false)
    }

    @Test @MainActor func widgetOpacityProperty() {
        ensureAdwInit()
        let label = Label("Test")
        label.opacity = 0.5
        #expect(abs(label.opacity - 0.5) < 0.01)
        label.opacity = 1.0
        #expect(abs(label.opacity - 1.0) < 0.01)
    }

    @Test @MainActor func widgetTooltipTextProperty() {
        ensureAdwInit()
        let button = Button(label: "Test")
        button.tooltipText = "Click me"
        #expect(button.tooltipText == "Click me")
    }

    @Test @MainActor func widgetSizeRequest() {
        ensureAdwInit()
        let label = Label("Test")
        label.setSizeRequest(width: 100, height: 50)
        var w: Int32 = 0, h: Int32 = 0
        gtk_widget_get_size_request(label.widgetPointer, &w, &h)
        #expect(w == 100)
        #expect(h == 50)
    }

    @Test @MainActor func widgetMargins() {
        ensureAdwInit()
        let label = Label("Test")
        label.setMargins(16)
        #expect(label.marginTop == 16)
        #expect(label.marginBottom == 16)
        #expect(label.marginStart == 16)
        #expect(label.marginEnd == 16)
    }

    @Test @MainActor func widgetIndividualMargins() {
        ensureAdwInit()
        let label = Label("Test")
        label.marginTop = 10
        label.marginBottom = 20
        label.marginStart = 30
        label.marginEnd = 40
        #expect(label.marginTop == 10)
        #expect(label.marginBottom == 20)
        #expect(label.marginStart == 30)
        #expect(label.marginEnd == 40)
    }

    @Test @MainActor func widgetHalignValign() {
        ensureAdwInit()
        let label = Label("Test")
        label.halign = .center
        label.valign = .end
        #expect(label.halign == .center)
        #expect(label.valign == .end)
    }

    @Test @MainActor func widgetExpandProperties() {
        ensureAdwInit()
        let label = Label("Test")
        label.hexpand = true
        label.vexpand = true
        #expect(label.hexpand == true)
        #expect(label.vexpand == true)
        label.hexpand = false
        #expect(label.hexpand == false)
    }

    // MARK: - Edge Cases

    @Test @MainActor func emptyLabelText() {
        ensureAdwInit()
        let label = Label("")
        #expect(label.text == "")
        label.text = "non-empty"
        #expect(label.text == "non-empty")
        label.text = ""
        #expect(label.text == "")
    }

    @Test @MainActor func entryMaxLength() {
        ensureAdwInit()
        let entry = Entry()
        entry.maxLength = 5
        #expect(entry.maxLength == 5)
        entry.text = "abcdefgh"
        // GTK truncates to max length
        #expect(entry.text.count <= 5)
    }

    @Test @MainActor func scaleValueClamping() {
        ensureAdwInit()
        let scale = Scale(orientation: .horizontal, min: 0, max: 100, step: 1)
        scale.value = 50
        #expect(abs(scale.value - 50) < 0.01)
        scale.value = -10 // Below min
        #expect(scale.value >= 0, "Scale should clamp to minimum")
        scale.value = 200 // Above max
        #expect(scale.value <= 100, "Scale should clamp to maximum")
    }

    @Test @MainActor func spinButtonValueClamping() {
        ensureAdwInit()
        let spin = SpinButton(min: 0, max: 10, step: 1)
        spin.value = 5
        #expect(abs(spin.value - 5) < 0.01)
        spin.value = -5
        #expect(spin.value >= 0, "SpinButton should clamp to minimum")
        spin.value = 20
        #expect(spin.value <= 10, "SpinButton should clamp to maximum")
    }

    @Test @MainActor func levelBarMinMax() {
        ensureAdwInit()
        let bar = LevelBar()
        bar.minValue = 0
        bar.maxValue = 100
        bar.value = 75
        #expect(abs(bar.value - 75) < 0.01)
        #expect(abs(bar.minValue - 0) < 0.01)
        #expect(abs(bar.maxValue - 100) < 0.01)
    }

    @Test @MainActor func progressBarFraction() {
        ensureAdwInit()
        let bar = ProgressBar()
        bar.fraction = 0.0
        #expect(abs(bar.fraction - 0.0) < 0.01)
        bar.fraction = 0.5
        #expect(abs(bar.fraction - 0.5) < 0.01)
        bar.fraction = 1.0
        #expect(abs(bar.fraction - 1.0) < 0.01)
    }
}
#endif
