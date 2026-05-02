#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct AnimationTests {

    // MARK: - CallbackAnimationTarget

    @Test @MainActor func callbackTargetCreation() {
        ensureAdwInit()
        var received: Double?
        let target = CallbackAnimationTarget { value in
            received = value
        }
        #expect(received == nil)
        _ = target // keep alive
    }

    // MARK: - TimedAnimation

    @Test @MainActor func timedAnimationCreation() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 1, duration: 300, target: target)
        #expect(abs(anim.valueFrom - 0) < 0.01)
        #expect(abs(anim.valueTo - 1) < 0.01)
        #expect(anim.duration == 300)
    }

    @Test @MainActor func timedAnimationProperties() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 100, duration: 500, target: target)
        anim.duration = 1000
        #expect(anim.duration == 1000)
        anim.repeatCount = 3
        #expect(anim.repeatCount == 3)
        anim.reverse = true
        #expect(anim.reverse == true)
        anim.alternate = true
        #expect(anim.alternate == true)
    }

    @Test @MainActor func timedAnimationEasing() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 1, duration: 300, target: target)
        anim.easing = .easeInOutCubic
        #expect(anim.easing == .easeInOutCubic)
        anim.easing = .linear
        #expect(anim.easing == .linear)
    }

    @Test @MainActor func timedAnimationValueRange() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: -50, to: 50, duration: 200, target: target)
        anim.valueFrom = 10
        anim.valueTo = 90
        #expect(abs(anim.valueFrom - 10) < 0.01)
        #expect(abs(anim.valueTo - 90) < 0.01)
    }

    @Test @MainActor func timedAnimationState() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 1, duration: 300, target: target)
        #expect(anim.state == .idle)
    }

    @Test @MainActor func timedAnimationSkip() {
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
        #expect(anim.state == .finished)
        #expect(finalValue != nil)
    }

    @Test @MainActor func timedAnimationReset() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 1, duration: 300, target: target)
        anim.play()
        anim.reset()
        #expect(anim.state == .idle)
    }

    @Test @MainActor func timedAnimationOnDone() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let anim = TimedAnimation(widget: widget, from: 0, to: 1, duration: 100, target: target)
        var done = false
        anim.onDone { done = true }
        anim.play()
        anim.skip()
        #expect(done, "onDone should fire after skip completes the animation")
    }

    // MARK: - SpringAnimation

    @Test @MainActor func springAnimationCreation() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let params = SpringParams(dampingRatio: 0.8, mass: 1.0, stiffness: 100.0)
        let anim = SpringAnimation(widget: widget, from: 0, to: 1, springParams: params, target: target)
        #expect(abs(anim.valueFrom - 0) < 0.01)
        #expect(abs(anim.valueTo - 1) < 0.01)
    }

    @Test @MainActor func springAnimationProperties() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let params = SpringParams(dampingRatio: 1.0, mass: 1.0, stiffness: 100.0)
        let anim = SpringAnimation(widget: widget, from: 0, to: 100, springParams: params, target: target)
        anim.initialVelocity = 50
        #expect(abs(anim.initialVelocity - 50) < 0.01)
        anim.clamp = true
        #expect(anim.clamp == true)
        anim.epsilon = 0.01
        #expect(abs(anim.epsilon - 0.01) < 0.001)
    }

    @Test @MainActor func springAnimationCalculateValue() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let params = SpringParams(dampingRatio: 1.0, mass: 1.0, stiffness: 100.0)
        let anim = SpringAnimation(widget: widget, from: 0, to: 100, springParams: params, target: target)
        let valueAtStart = anim.calculateValue(0)
        #expect(abs(valueAtStart - 0) < 0.01, "Value at t=0 should be from value")
        let velocityAtStart = anim.calculateVelocity(0)
        #expect(abs(velocityAtStart - 0) < 0.01, "Velocity at t=0 should be 0 with no initial velocity")
    }

    @Test @MainActor func springAnimationEstimatedDuration() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let params = SpringParams(dampingRatio: 0.5, mass: 1.0, stiffness: 100.0)
        let anim = SpringAnimation(widget: widget, from: 0, to: 1, springParams: params, target: target)
        #expect(anim.estimatedDuration > 0, "Spring animation should have a positive estimated duration")
    }

    @Test @MainActor func springAnimationSkipAndDone() {
        ensureAdwInit()
        let widget = Label("Host")
        let target = CallbackAnimationTarget { _ in }
        let params = SpringParams(dampingRatio: 1.0, mass: 1.0, stiffness: 100.0)
        let anim = SpringAnimation(widget: widget, from: 0, to: 1, springParams: params, target: target)
        var done = false
        anim.onDone { done = true }
        anim.play()
        anim.skip()
        #expect(done, "onDone should fire after spring animation skip")
        #expect(anim.state == .finished)
    }

    // MARK: - SpringParams

    @Test @MainActor func springParamsFromDampingRatio() {
        ensureAdwInit()
        let params = SpringParams(dampingRatio: 0.8, mass: 1.0, stiffness: 100.0)
        #expect(abs(params.dampingRatio - 0.8) < 0.01)
        #expect(abs(params.mass - 1.0) < 0.01)
        #expect(abs(params.stiffness - 100.0) < 0.01)
        #expect(params.damping > 0)
    }

    @Test @MainActor func springParamsFromDamping() {
        ensureAdwInit()
        let params = SpringParams(damping: 10, mass: 1.0, stiffness: 100.0)
        #expect(abs(params.damping - 10) < 0.01)
        #expect(abs(params.mass - 1.0) < 0.01)
        #expect(abs(params.stiffness - 100.0) < 0.01)
    }

    @Test @MainActor func springParamsCriticallyDamped() {
        ensureAdwInit()
        let params = SpringParams(dampingRatio: 1.0, mass: 1.0, stiffness: 100.0)
        #expect(abs(params.dampingRatio - 1.0) < 0.01, "Ratio 1.0 means critically damped")
    }

    // MARK: - AnimationTarget Reuse

    @Test @MainActor func animationTargetCanBeReused() {
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
        #expect(count1 > 0, "Target should have received values from first animation")

        let anim2 = TimedAnimation(widget: widget, from: 0, to: 1, duration: 100, target: target)
        anim2.play()
        anim2.skip()
        #expect(values.count > count1, "Target should have received values from second animation")
    }
}
#endif
