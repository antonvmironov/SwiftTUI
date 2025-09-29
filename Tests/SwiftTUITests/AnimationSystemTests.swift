import Testing
@testable import SwiftTUI

/// Tests for the animation system components
struct AnimationSystemTests {
    
    // Helper to assert a value conforms to SwiftTUI.View at compile time
    private func isView<V: View>(_: V) -> Bool { true }
    
    @Test("Animation struct creation")
    func testAnimationCreation() {
        let defaultAnim = Animation.default
        #expect(defaultAnim.duration == 0.25)
        #expect(defaultAnim.easing == .easeInOut)
        #expect(defaultAnim.delay == 0)
        
        let linearAnim = Animation.linear(duration: 1.0)
        #expect(linearAnim.duration == 1.0)
        #expect(linearAnim.easing == .linear)
        #expect(linearAnim.delay == 0)
        
        let easeInAnim = Animation.easeIn(duration: 0.5)
        #expect(easeInAnim.duration == 0.5)
        #expect(easeInAnim.easing == .easeIn)
        
        let easeOutAnim = Animation.easeOut(duration: 0.8)
        #expect(easeOutAnim.duration == 0.8)
        #expect(easeOutAnim.easing == .easeOut)
        
        let easeInOutAnim = Animation.easeInOut(duration: 1.5)
        #expect(easeInOutAnim.duration == 1.5)
        #expect(easeInOutAnim.easing == .easeInOut)
    }
    
    @Test("Animation delay")
    func testAnimationDelay() {
        let baseAnim = Animation.linear(duration: 1.0)
        let delayedAnim = baseAnim.delay(0.5)
        
        #expect(delayedAnim.duration == 1.0)
        #expect(delayedAnim.easing == .linear)
        #expect(delayedAnim.delay == 0.5)
    }
    
    @Test("Animation curves")
    func testAnimationCurves() {
        let linear = AnimationCurve.linear
        let easeIn = AnimationCurve.easeIn
        let easeOut = AnimationCurve.easeOut
        let easeInOut = AnimationCurve.easeInOut
        
        // Test at 0% progress
        #expect(linear.progress(for: 0.0) == 0.0)
        #expect(easeIn.progress(for: 0.0) == 0.0)
        #expect(easeOut.progress(for: 0.0) == 0.0)
        #expect(easeInOut.progress(for: 0.0) == 0.0)
        
        // Test at 100% progress
        #expect(linear.progress(for: 1.0) == 1.0)
        #expect(easeIn.progress(for: 1.0) == 1.0)
        #expect(easeOut.progress(for: 1.0) == 1.0)
        #expect(easeInOut.progress(for: 1.0) == 1.0)
        
        // Test at 50% progress
        #expect(linear.progress(for: 0.5) == 0.5)
        #expect(easeIn.progress(for: 0.5) == 0.25) // Slower start
        #expect(easeOut.progress(for: 0.5) == 0.75) // Faster start
        #expect(easeInOut.progress(for: 0.5) == 0.5) // Symmetric
    }
    
    @Test("Animation curve clamping")
    func testAnimationCurveClamping() {
        let linear = AnimationCurve.linear
        
        // Test values outside 0-1 range are clamped
        #expect(linear.progress(for: -0.5) == 0.0)
        #expect(linear.progress(for: 1.5) == 1.0)
        #expect(linear.progress(for: -10.0) == 0.0)
        #expect(linear.progress(for: 10.0) == 1.0)
    }
    
    @Test("Interpolation functions")
    func testInterpolation() {
        // Test Double interpolation
        let doubleResult = interpolate(from: 0.0, to: 10.0, progress: 0.5)
        #expect(doubleResult == 5.0)
        
        let doubleResult2 = interpolate(from: -5.0, to: 5.0, progress: 0.25)
        #expect(doubleResult2 == -2.5)
        
        // Test Float interpolation
        let floatResult = interpolate(from: 0.0 as Float, to: 20.0 as Float, progress: 0.1)
        #expect(floatResult == 2.0)
        
        // Test Int interpolation
        let intResult = interpolate(from: 0, to: 100, progress: 0.3)
        #expect(intResult == 30)
        
        let intResult2 = interpolate(from: -10, to: 10, progress: 0.75)
        #expect(intResult2 == 5)
    }
    
    @Test("WithAnimation function")
    @MainActor
    func testWithAnimation() {
        var result = 0
        
        // Test that withAnimation executes the body
        let returnValue = withAnimation(.default) {
            result = 42
            return "success"
        }
        
        #expect(result == 42)
        #expect(returnValue == "success")
        
        // Test with different animation
        withAnimation(.linear(duration: 2.0)) {
            result = 100
        }
        
        #expect(result == 100)
    }
    
    @Test("SimpleSpinner creation")
    func testSimpleSpinner() {
        let defaultSpinner = SimpleSpinner()
        #expect(isView(defaultSpinner))
        
        let customSpinner = SimpleSpinner(characters: ["A", "B", "C"], current: 1)
        #expect(isView(customSpinner))
        
        let asciiSpinner = SimpleSpinner.ascii(current: 2)
        #expect(isView(asciiSpinner))
        
        let dotsSpinner = SimpleSpinner.dots(current: 0)
        #expect(isView(dotsSpinner))
    }
    
    @Test("SimpleProgressBar creation")
    func testSimpleProgressBar() {
        let progressBar = SimpleProgressBar(progress: 0.5, width: 20)
        #expect(isView(progressBar))
        
        let fullProgressBar = SimpleProgressBar(progress: 1.0, width: 10)
        #expect(isView(fullProgressBar))
        
        let emptyProgressBar = SimpleProgressBar(progress: 0.0, width: 15)
        #expect(isView(emptyProgressBar))
        
        // Test clamping
        let clampedProgressBar = SimpleProgressBar(progress: 1.5, width: 5)
        #expect(isView(clampedProgressBar))
        
        let negativeProgressBar = SimpleProgressBar(progress: -0.5, width: 8)
        #expect(isView(negativeProgressBar))
    }
    
    @Test("AnimatableText creation")
    func testAnimatableText() {
        let normalText = AnimatableText("Hello")
        #expect(isView(normalText))
        
        let highlightedText = AnimatableText("World", isHighlighted: true)
        #expect(isView(highlightedText))
    }
    
    @Test("AnimatableDots creation")
    func testAnimatableDots() {
        let defaultDots = AnimatableDots()
        #expect(isView(defaultDots))
        
        let customDots = AnimatableDots(dotCount: 5, activeDot: 2)
        #expect(isView(customDots))
        
        // Test active dot clamping
        let clampedDots = AnimatableDots(dotCount: 3, activeDot: 10)
        #expect(isView(clampedDots))
    }
    
    @Test("TransitionView creation")
    func testTransitionView() {
        let visibleTransition = TransitionView(
            content: Text("Hello"),
            isVisible: true,
            direction: .slide
        )
        #expect(isView(visibleTransition))
        
        let hiddenTransition = TransitionView(
            content: Text("World"),
            isVisible: false,
            direction: .fade
        )
        #expect(isView(hiddenTransition))
    }
    
    @Test("Animation modifiers")
    func testAnimationModifiers() {
        let text = Text("Hello")
        
        // Test animation with value
        let animatedText = text.animation(.default, value: 42)
        #expect(isView(animatedText))
        
        // Test animation without value
        let globalAnimatedText = text.animation(.linear(duration: 1.0))
        #expect(isView(globalAnimatedText))
        
        // Test nil animation
        let nilAnimatedText = text.animation(nil, value: "test")
        #expect(isView(nilAnimatedText))
    }
    
    @Test("Animation equality")
    func testAnimationEquality() {
        let anim1 = Animation.linear(duration: 1.0)
        let anim2 = Animation.linear(duration: 1.0)
        let anim3 = Animation.linear(duration: 2.0)
        
        #expect(anim1 == anim2)
        #expect(anim1 != anim3)
        
        let delayedAnim1 = anim1.delay(0.5)
        let delayedAnim2 = anim1.delay(0.5)
        let delayedAnim3 = anim1.delay(1.0)
        
        #expect(delayedAnim1 == delayedAnim2)
        #expect(delayedAnim1 != delayedAnim3)
    }
    
    @Test("Animation curve equality")
    func testAnimationCurveEquality() {
        #expect(AnimationCurve.linear == AnimationCurve.linear)
        #expect(AnimationCurve.easeIn == AnimationCurve.easeIn)
        #expect(AnimationCurve.easeOut == AnimationCurve.easeOut)
        #expect(AnimationCurve.easeInOut == AnimationCurve.easeInOut)
        
        #expect(AnimationCurve.linear != AnimationCurve.easeIn)
        #expect(AnimationCurve.easeOut != AnimationCurve.easeInOut)
    }
}
