import Foundation

/// A control for incrementing or decrementing a value
/// Similar to SwiftUI's Stepper but optimized for terminal environments
public struct Stepper<Label: View>: View {
    private let label: Label
    private let value: Binding<Double>
    private let step: Double
    private let range: ClosedRange<Double>?
    private let onIncrement: (() -> Void)?
    private let onDecrement: (() -> Void)?
    
    /// Creates a stepper with a text label and value binding
    public init<V: BinaryFloatingPoint & CustomStringConvertible>(
        _ title: String,
        value: Binding<V>,
        in range: ClosedRange<V>? = nil,
        step: V = 1
    ) where Label == Text {
        self.label = Text(title)
        self.value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = V($0) }
        )
        self.step = Double(step)
        self.range = range.map { Double($0.lowerBound)...Double($0.upperBound) }
        self.onIncrement = nil
        self.onDecrement = nil
    }
    
    /// Creates a stepper with integer value binding
    public init<V: BinaryInteger & CustomStringConvertible>(
        _ title: String,
        value: Binding<V>,
        in range: ClosedRange<V>? = nil,
        step: V = 1
    ) where Label == Text {
        self.label = Text(title)
        self.value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = V($0) }
        )
        self.step = Double(step)
        self.range = range.map { Double($0.lowerBound)...Double($0.upperBound) }
        self.onIncrement = nil
        self.onDecrement = nil
    }
    
    /// Creates a stepper with custom increment/decrement actions
    public init(
        _ title: String,
        onIncrement: @escaping () -> Void,
        onDecrement: @escaping () -> Void
    ) where Label == Text {
        self.label = Text(title)
        self.value = .constant(0)
        self.step = 1
        self.range = nil
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
    }
    
    /// Creates a stepper with a custom label
    public init<V: BinaryFloatingPoint & CustomStringConvertible>(
        value: Binding<V>,
        in range: ClosedRange<V>? = nil,
        step: V = 1,
        @ViewBuilder label: () -> Label
    ) {
        self.label = label()
        self.value = Binding(
            get: { Double(value.wrappedValue) },
            set: { value.wrappedValue = V($0) }
        )
        self.step = Double(step)
        self.range = range.map { Double($0.lowerBound)...Double($0.upperBound) }
        self.onIncrement = nil
        self.onDecrement = nil
    }
    
    public var body: some View {
        HStack {
            label
            
            Spacer()
            
            // Decrement button
            Button("−") {
                decrementValue()
            }
            .foregroundColor(canDecrement ? Color.blue : Color.gray)
            .border()
            .frame(width: 3, height: 1)
            
            // Current value display
            Text(" \(formattedValue) ")
                .foregroundColor(Color.white)
                .border()
            
            // Increment button  
            Button("+") {
                incrementValue()
            }
            .foregroundColor(canIncrement ? Color.blue : Color.gray)
            .border()
            .frame(width: 3, height: 1)
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
        if let _ = range, step == 1 {
            // Integer formatting for integer steps
            return String(Int(value.wrappedValue))
        } else {
            // Floating point formatting
            return String(format: "%.1f", value.wrappedValue)
        }
    }
    
    private var canIncrement: Bool {
        if let range = range {
            return value.wrappedValue + step <= range.upperBound
        }
        return true
    }
    
    private var canDecrement: Bool {
        if let range = range {
            return value.wrappedValue - step >= range.lowerBound
        }
        return true
    }
    
    private func incrementValue() {
        if let onIncrement = onIncrement {
            onIncrement()
        } else if canIncrement {
            value.wrappedValue += step
        }
    }
    
    private func decrementValue() {
        if let onDecrement = onDecrement {
            onDecrement()
        } else if canDecrement {
            value.wrappedValue -= step
        }
    }
}

/// Convenience extensions for common stepper patterns
extension Stepper where Label == Text {
    /// Creates a simple stepper for integer values
    public static func integer(
        _ title: String,
        value: Binding<Int>,
        in range: ClosedRange<Int> = 0...100
    ) -> Stepper<Text> {
        Stepper(title, value: value, in: range)
    }
    
    /// Creates a simple stepper for double values  
    public static func decimal(
        _ title: String,
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...100,
        step: Double = 0.1
    ) -> Stepper<Text> {
        Stepper(title, value: value, in: range, step: step)
    }
}