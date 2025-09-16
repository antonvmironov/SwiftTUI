import SwiftTUI

/// Comprehensive example demonstrating SwiftTUI's animation system
/// Shows various animation components and techniques for terminal UIs
struct AnimationDemoExample: View {
    @State private var progressValue: Double = 0.3
    @State private var spinnerIndex: Int = 0
    @State private var isTextHighlighted: Bool = false
    @State private var activeDot: Int = 0
    @State private var showTransition: Bool = true
    @State private var animationSpeed: Double = 1.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Header
            Text("🎬 SwiftTUI Animation System Demo")
                .bold()
                .foregroundColor(.green)
                .padding(.bottom, 1)
            
            Divider()
            
            // Spinner Section
            spinnerSection
            
            Divider()
            
            // Progress Bar Section
            progressSection
            
            Divider()
            
            // Text Animation Section
            textAnimationSection
            
            Divider()
            
            // Transition Section
            transitionSection
            
            Divider()
            
            // Controls Section
            controlsSection
            
            Divider()
            
            // Animation Info
            animationInfoSection
        }
        .padding()
    }
    
    @ViewBuilder
    private var spinnerSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("📀 Loading Spinners")
                .bold()
                .foregroundColor(.blue)
            
            HStack(spacing: 3) {
                Text("Unicode:")
                SimpleSpinner(current: spinnerIndex)
                
                Text("ASCII:")
                SimpleSpinner.ascii(current: spinnerIndex)
                
                Text("Dots:")
                SimpleSpinner.dots(current: spinnerIndex)
            }
            
            Text("Spinner State: Frame \(spinnerIndex + 1)")
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("📊 Progress Indicators")
                .bold()
                .foregroundColor(.purple)
            
            HStack {
                Text("Progress:")
                SimpleProgressBar(progress: progressValue, width: 25)
                Text("\(Int(progressValue * 100))%")
            }
            
            HStack {
                Text("Custom:")
                SimpleProgressBar(
                    progress: progressValue,
                    width: 20,
                    fillCharacter: "▓",
                    emptyCharacter: "░"
                )
            }
        }
    }
    
    @ViewBuilder
    private var textAnimationSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("✨ Text Animation")
                .bold()
                .foregroundColor(.yellow)
            
            HStack {
                Text("Status:")
                AnimatableText("Processing...", isHighlighted: isTextHighlighted)
            }
            
            HStack {
                Text("Dots:")
                AnimatableDots(dotCount: 4, activeDot: activeDot)
            }
        }
    }
    
    @ViewBuilder
    private var transitionSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("🎭 View Transitions")
                .bold()
                .foregroundColor(.cyan)
            
            HStack {
                Text("Content:")
                TransitionView(
                    content: Text("Hello, Animation!").foregroundColor(.green),
                    isVisible: showTransition,
                    direction: .slide
                )
            }
            
            if !showTransition {
                Text("(Content hidden)")
                    .foregroundColor(.red)
                    .italic()
            }
        }
    }
    
    @ViewBuilder
    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("🎮 Controls")
                .bold()
                .foregroundColor(.white)
            
            HStack {
                Button("Next Spinner") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        spinnerIndex = (spinnerIndex + 1) % 10
                    }
                }
                .foregroundColor(.blue)
                
                Button("Update Progress") {
                    withAnimation(.easeOut(duration: 0.5)) {
                        progressValue = Double.random(in: 0...1)
                    }
                }
                .foregroundColor(.purple)
            }
            
            HStack {
                Button("Toggle Text") {
                    withAnimation(.default) {
                        isTextHighlighted.toggle()
                    }
                }
                .foregroundColor(.yellow)
                
                Button("Next Dot") {
                    withAnimation(.linear(duration: 0.3)) {
                        activeDot = (activeDot + 1) % 4
                    }
                }
                .foregroundColor(.cyan)
            }
            
            HStack {
                Button("Toggle Transition") {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showTransition.toggle()
                    }
                }
                .foregroundColor(.green)
                
                Button("Reset All") {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        resetAnimations()
                    }
                }
                .foregroundColor(.red)
            }
        }
    }
    
    @ViewBuilder
    private var animationInfoSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("ℹ️  Animation System Info")
                .bold()
                .foregroundColor(.gray)
            
            Text("• withAnimation() provides SwiftUI-compatible API")
            Text("• Animation curves: linear, easeIn, easeOut, easeInOut")
            Text("• Custom timing and delays supported")
            Text("• Interpolation functions for smooth transitions")
            Text("• Terminal-optimized visual effects")
            
            Text("Current Speed: \(String(format: "%.1fx", animationSpeed))")
                .foregroundColor(.secondary)
        }
    }
    
    private func resetAnimations() {
        spinnerIndex = 0
        progressValue = 0.3
        isTextHighlighted = false
        activeDot = 0
        showTransition = true
        animationSpeed = 1.0
    }
}

/// Example showing animation timing curves
struct AnimationCurvesExample: View {
    @State private var progress: Double = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("📈 Animation Timing Curves")
                .bold()
                .foregroundColor(.green)
                .padding(.bottom, 1)
            
            Text("Progress: \(String(format: "%.2f", progress))")
                .foregroundColor(.gray)
            
            // Linear curve
            curveDemo(title: "Linear", curve: .linear, progress: progress)
            
            // Ease In curve
            curveDemo(title: "Ease In", curve: .easeIn, progress: progress)
            
            // Ease Out curve
            curveDemo(title: "Ease Out", curve: .easeOut, progress: progress)
            
            // Ease In Out curve
            curveDemo(title: "Ease In Out", curve: .easeInOut, progress: progress)
            
            HStack {
                Button("Start") {
                    withAnimation(.linear(duration: 2.0)) {
                        progress = 1.0
                    }
                }
                
                Button("Reset") {
                    withAnimation(.easeOut(duration: 0.5)) {
                        progress = 0.0
                    }
                }
            }
            .padding(.top, 1)
        }
        .padding()
    }
    
    @ViewBuilder
    private func curveDemo(title: String, curve: AnimationCurve, progress: Double) -> some View {
        HStack {
            Text("\(title):")
                .frame(width: 12)
            
            let curveProgress = curve.progress(for: progress)
            SimpleProgressBar(
                progress: curveProgress,
                width: 20,
                fillCharacter: "━",
                emptyCharacter: "─"
            )
            
            Text("\(String(format: "%.2f", curveProgress))")
                .foregroundColor(.secondary)
        }
    }
}

/// Real-world example: Animated loading screen
struct LoadingScreenExample: View {
    @State private var loadingProgress: Double = 0.0
    @State private var currentStep: Int = 0
    @State private var spinnerFrame: Int = 0
    @State private var isComplete: Bool = false
    
    private let loadingSteps = [
        "Initializing application...",
        "Loading configuration...",
        "Connecting to services...",
        "Preparing interface...",
        "Almost ready..."
    ]
    
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            Text("🚀 Application Loading")
                .bold()
                .foregroundColor(.blue)
            
            if !isComplete {
                // Spinner
                HStack {
                    SimpleSpinner(current: spinnerFrame)
                    Text("Loading...")
                        .foregroundColor(.gray)
                }
                
                // Progress bar
                SimpleProgressBar(
                    progress: loadingProgress,
                    width: 40,
                    fillCharacter: "█",
                    emptyCharacter: "░"
                )
                
                Text("\(Int(loadingProgress * 100))% Complete")
                    .foregroundColor(.secondary)
                
                // Current step
                if currentStep < loadingSteps.count {
                    AnimatableText(
                        loadingSteps[currentStep],
                        isHighlighted: true
                    )
                }
            } else {
                Text("✅ Loading Complete!")
                    .bold()
                    .foregroundColor(.green)
                
                Text("Welcome to SwiftTUI!")
                    .foregroundColor(.white)
            }
            
            Button(isComplete ? "Restart" : "Simulate Loading") {
                if isComplete {
                    resetLoading()
                } else {
                    simulateLoading()
                }
            }
            .foregroundColor(.blue)
            .padding(.top, 2)
        }
        .padding()
    }
    
    private func simulateLoading() {
        // Animate progress and steps
        withAnimation(.linear(duration: 3.0)) {
            loadingProgress = 1.0
        }
        
        // Cycle through steps
        for i in 0..<loadingSteps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.6) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentStep = i
                }
            }
        }
        
        // Complete loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                isComplete = true
            }
        }
        
        // Animate spinner
        animateSpinner()
    }
    
    private func animateSpinner() {
        guard !isComplete else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            spinnerFrame = (spinnerFrame + 1) % 10
            animateSpinner()
        }
    }
    
    private func resetLoading() {
        loadingProgress = 0.0
        currentStep = 0
        spinnerFrame = 0
        isComplete = false
    }
}