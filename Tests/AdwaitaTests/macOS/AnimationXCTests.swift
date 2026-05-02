#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita

final class AnimationXCTests: XCTestCase {

    // MARK: - CallbackAnimationTarget

    @MainActor func test_callbackTargetCreation() {
        ensureAdwInit()
        var received: Double?
        let target = CallbackAnimationTarget { value in
            received = value
        }
        XCTAssertNil(received)
        _ = target // keep alive
    }

    // MARK: - TimedAnimation

    @MainActor func test_timedAnimationCreation() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 1, duration: 300, target: target)
        XCTAssertTrue(abs(anim.valueFrom - 0) < 0.01)
        XCTAssertTrue(abs(anim.valueTo - 1) < 0.01)
        XCTAssertTrue(anim.duration == 300)
    }

    @MainActor func test_timedAnimationProperties() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 100, duration: 500, target: target)
        anim.duration = 1000
        XCTAssertTrue(anim.duration == 1000)
        anim.repeatCount = 3
        XCTAssertTrue(anim.repeatCount == 3)
        anim.reverse = true
        XCTAssertTrue(anim.reverse == true)
        anim.alternate = true
        XCTAssertTrue(anim.alternate == true)
    }

    @MainActor func test_timedAnimationEasing() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 1, duration: 300, target: target)
        anim.easing = .easeInOutCubic
        XCTAssertTrue(anim.easing == .easeInOutCubic)
        anim.easing = .linear
        XCTAssertTrue(anim.easing == .linear)
    }

    @MainActor func test_timedAnimationValueRange() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: -50, to: 50, duration: 200, target: target)
        anim.valueFrom = 10
        anim.valueTo = 90
        XCTAssertTrue(abs(anim.valueFrom - 10) < 0.01)
        XCTAssertTrue(abs(anim.valueTo - 90) < 0.01)
    }

    @MainActor func test_timedAnimationState() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 1, duration: 300, target: target)
        XCTAssertTrue(anim.state == .idle)
    }

    @MainActor func test_timedAnimationSkip() {
        ensureAdwInit()
        let widget = Label("Host")
        var finalValue: Double?
        let target = CallbackAnimationTarget { value in
            finalValue = value
        }
        let anim = TimedAnimation(widget: widget, from: 0, to: 100, duration: 1000, target: target)
        anim.play()
        anim.skip()
        // After skip, animation should jump to the end value
        XCTAssertTrue(anim.state == .finished)
        XCTAssertNotNil(finalValue)
    }

    @MainActor func test_timedAnimationReset() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 1, duration: 300, target: target)
        anim.play()
        anim.reset()
        XCTAssertTrue(anim.state == .idle)
    }

    @MainActor func test_timedAnimationOnDone() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 1, duration: 100, target: target)
        var done = false
        anim.onDone { done = true }
        anim.play()
        anim.skip()
        XCTAssertTrue(done, "onDone should fire after skip completes the animation")
    }

    // MARK: - SpringAnimation

    @MainActor func test_springAnimationCreation() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let params = SpringParams(dampingRatio: 0.8, mass: 1.0, stiffness: 100.0)
        let anim = SpringAnimation(widget: widget, from: 0, to: 1, springParams: params, target: target)
        XCTAssertTrue(abs(anim.valueFrom - 0) < 0.01)
        XCTAssertTrue(abs(anim.valueTo - 1) < 0.01)
    }

    @MainActor func test_springAnimationProperties() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let params = SpringParams(dampingRatio: 1.0, mass: 1.0, stiffness: 100.0)
        let anim = SpringAnimation(widget: widget, from: 0, to: 100, springParams: params, target: target)
        anim.initialVelocity = 50
        XCTAssertTrue(abs(anim.initialVelocity - 50) < 0.01)
        anim.clamp = true
        XCTAssertTrue(anim.clamp == true)
        anim.epsilon = 0.01
        XCTAssertTrue(abs(anim.epsilon - 0.01) < 0.001)
    }

    @MainActor func test_springAnimationCalculateValue() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let params = SpringParams(dampingRatio: 1.0, mass: 1.0, stiffness: 100.0)
        let anim = SpringAnimation(widget: widget, from: 0, to: 100, springParams: params, target: target)
        let valueAtStart = anim.calculateValue(0)
        XCTAssertTrue(abs(valueAtStart - 0) < 0.01, "Value at t=0 should be from value")
        let velocityAtStart = anim.calculateVelocity(0)
        XCTAssertTrue(abs(velocityAtStart - 0) < 0.01, "Velocity at t=0 should be 0 with no initial velocity")
    }

    @MainActor func test_springAnimationEstimatedDuration() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let params = SpringParams(dampingRatio: 0.5, mass: 1.0, stiffness: 100.0)
        let anim = SpringAnimation(widget: widget, from: 0, to: 1, springParams: params, target: target)
        XCTAssertTrue(anim.estimatedDuration > 0, "Spring animation should have a positive estimated duration")
    }

    @MainActor func test_springAnimationSkipAndDone() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let params = SpringParams(dampingRatio: 1.0, mass: 1.0, stiffness: 100.0)
        let anim = SpringAnimation(widget: widget, from: 0, to: 1, springParams: params, target: target)
        var done = false
        anim.onDone { done = true }
        anim.play()
        anim.skip()
        XCTAssertTrue(done, "onDone should fire after spring animation skip")
        XCTAssertTrue(anim.state == .finished)
    }

    // MARK: - SpringParams

    @MainActor func test_springParamsFromDampingRatio() {
        ensureAdwInit()
        let params = SpringParams(dampingRatio: 0.8, mass: 1.0, stiffness: 100.0)
        XCTAssertTrue(abs(params.dampingRatio - 0.8) < 0.01)
        XCTAssertTrue(abs(params.mass - 1.0) < 0.01)
        XCTAssertTrue(abs(params.stiffness - 100.0) < 0.01)
        XCTAssertTrue(params.damping > 0)
    }

    @MainActor func test_springParamsFromDamping() {
        ensureAdwInit()
        let params = SpringParams(damping: 10, mass: 1.0, stiffness: 100.0)
        XCTAssertTrue(abs(params.damping - 10) < 0.01)
        XCTAssertTrue(abs(params.mass - 1.0) < 0.01)
        XCTAssertTrue(abs(params.stiffness - 100.0) < 0.01)
    }

    @MainActor func test_springParamsCriticallyDamped() {
        ensureAdwInit()
        let params = SpringParams(dampingRatio: 1.0, mass: 1.0, stiffness: 100.0)
        XCTAssertTrue(abs(params.dampingRatio - 1.0) < 0.01, "Ratio 1.0 means critically damped")
    }

    // MARK: - AnimationTarget Reuse

    @MainActor func test_animationTargetCanBeReused() {
        ensureAdwInit()
        let widget = Label("Host")
        var values: [Double] = []
        let target = CallbackAnimationTarget { value in
            values.append(value)
        }
        let anim1 = TimedAnimation(widget: widget, from: 0, to: 1, duration: 100, target: target)
        anim1.play()
        anim1.skip()
        let count1 = values.count
        XCTAssertTrue(count1 > 0, "Target should have received values from first animation")

        let anim2 = TimedAnimation(widget: widget, from: 0, to: 1, duration: 100, target: target)
        anim2.play()
        anim2.skip()
        XCTAssertTrue(values.count > count1, "Target should have received values from second animation")
    }
}
#endif
