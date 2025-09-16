import Foundation

/// A control for selecting a value from a bounded linear range of values
/// Similar to SwiftUI's Slider but optimized for terminal environments using ASCII art
public struct Slider<Label: View, ValueLabel: View>: View {
    private let value: Binding<Double>
    private let bounds: ClosedRange<Double>
    private let step: Double?
    private let label: Label?
    private let minimumValueLabel: ValueLabel?
    private let maximumValueLabel: ValueLabel?
    private let trackLength: Int
    
    /// Creates a slider with a range of values
    public init<V: BinaryFloatingPoint>(
        value: Binding<V>,
        in bounds: ClosedRange<V>,
        step: V? = nil
    ) where Label == EmptyView, ValueLabel == EmptyView {
        self.value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = V($0) }
        )
        self.bounds = Double(bounds.lowerBound)...Double(bounds.upperBound)
        self.step = step.map(Double.init)
        self.label = nil
        self.minimumValueLabel = nil
        self.maximumValueLabel = nil
        self.trackLength = 20
    }
    
    /// Creates a slider with a label
    public init<V: BinaryFloatingPoint>(
        value: Binding<V>,
        in bounds: ClosedRange<V>,
        step: V? = nil,
        @ViewBuilder label: () -> Label
    ) where ValueLabel == EmptyView {
        self.value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = V($0) }
        )
        self.bounds = Double(bounds.lowerBound)...Double(bounds.upperBound)
        self.step = step.map(Double.init)
        self.label = label()
        self.minimumValueLabel = nil
        self.maximumValueLabel = nil
        self.trackLength = 20
    }
    
    /// Creates a slider with value labels
    public init<V: BinaryFloatingPoint>(
        value: Binding<V>,
        in bounds: ClosedRange<V>,
        step: V? = nil,
        @ViewBuilder minimumValueLabel: () -> ValueLabel,
        @ViewBuilder maximumValueLabel: () -> ValueLabel
    ) where Label == EmptyView {
        self.value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = V($0) }
        )
        self.bounds = Double(bounds.lowerBound)...Double(bounds.upperBound)
        self.step = step.map(Double.init)
        self.label = nil
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
        self.trackLength = 20
    }
    
    /// Creates a slider with all labels
    public init<V: BinaryFloatingPoint>(
        value: Binding<V>,
        in bounds: ClosedRange<V>,
        step: V? = nil,
        @ViewBuilder label: () -> Label,
        @ViewBuilder minimumValueLabel: () -> ValueLabel,
        @ViewBuilder maximumValueLabel: () -> ValueLabel
    ) {
        self.value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = V($0) }
        )
        self.bounds = Double(bounds.lowerBound)...Double(bounds.upperBound)
        self.step = step.map(Double.init)
        self.label = label()
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
        self.trackLength = 20
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            // Label (if provided)
            if let label = label {
                label
            }
            
            // Value display
            HStack {
                Text("Value: \(formattedValue)")
                    .foregroundColor(Color.blue)
                Spacer()
            }
            
            // Slider track
            HStack(spacing: 0) {
                // Minimum value label
                if let minimumValueLabel = minimumValueLabel {
                    minimumValueLabel
                        .foregroundColor(Color.gray)
                }
                
                // Slider track visualization
                Text(sliderTrack)
                    .foregroundColor(Color.white)
                
                // Maximum value label
                if let maximumValueLabel = maximumValueLabel {
                    maximumValueLabel
                        .foregroundColor(Color.gray)
                }
            }
            
            // Keyboard instructions
            Text("Use ← → keys or +/- to adjust")
                .foregroundColor(Color.gray)
        }
        // Keyboard navigation removed due to concurrency issues
        // .onKeyPress(.leftArrow) { @MainActor in
        //     decrementValue()
        // }
        // .onKeyPress(.rightArrow) { @MainActor in
        //     incrementValue()
        // }
        // .onKeyPress(KeyEquivalent(key: .character("-"))) { @MainActor in
        //     decrementValue()
        // }
        // .onKeyPress(KeyEquivalent(key: .character("+"))) { @MainActor in
        //     incrementValue()
        // }
    }
    
    private var formattedValue: String {
        if let step = step, step >= 1 {
            return String(Int(value.wrappedValue))
        } else {
            return String(format: "%.2f", value.wrappedValue)
        }
    }
    
    private var sliderTrack: String {
        let range = bounds.upperBound - bounds.lowerBound
        let normalizedValue = (value.wrappedValue - bounds.lowerBound) / range
        let thumbPosition = Int(normalizedValue * Double(trackLength - 1))
        
        var track = ""
        for i in 0..<trackLength {
            if i == thumbPosition {
                track += "●"  // Thumb/handle
            } else if i < thumbPosition {
                track += "━"  // Filled track
            } else {
                track += "─"  // Empty track
            }
        }
        
        return "[\(track)]"
    }
    
    private var stepSize: Double {
        return step ?? (bounds.upperBound - bounds.lowerBound) / Double(trackLength)
    }
    
    private func incrementValue() {
        let newValue = min(value.wrappedValue + stepSize, bounds.upperBound)
        value.wrappedValue = newValue
    }
    
    private func decrementValue() {
        let newValue = max(value.wrappedValue - stepSize, bounds.lowerBound)
        value.wrappedValue = newValue
    }
}

/// Convenience extensions for common slider patterns
extension Slider where Label == Text, ValueLabel == Text {
    /// Creates a percentage slider (0-100%)
    public static func percentage(
        _ title: String,
        value: Binding<Double>
    ) -> Slider<Text, Text> {
        Slider(
            value: value,
            in: 0...100,
            step: 1,
            label: { Text(title) },
            minimumValueLabel: { Text("0%") },
            maximumValueLabel: { Text("100%") }
        )
    }
    
    /// Creates a volume slider (0-10)
    public static func volume(
        _ title: String,
        value: Binding<Int>
    ) -> Slider<Text, Text> {
        let doubleBinding = Binding<Double>(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = Int($0) }
        )
        
        return Slider(
            value: doubleBinding,
            in: 0...10,
            step: 1,
            label: { Text(title) },
            minimumValueLabel: { Text("0") },
            maximumValueLabel: { Text("10") }
        )
    }
}