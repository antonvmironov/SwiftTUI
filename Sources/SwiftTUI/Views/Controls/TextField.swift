import Foundation

public struct TextField: View, PrimitiveView {
    public let placeholder: String?
    public let action: ((String) -> Void)?
    public let text: Binding<String>?

    @Environment(\.placeholderColor) private var placeholderColor: Color

    // Original initializer for backward compatibility
    public init(placeholder: String? = nil, action: @escaping (String) -> Void) {
        self.placeholder = placeholder
        self.action = action
        self.text = nil
    }
    
    // New initializer with @Binding support for SwiftUI compatibility
    public init(_ placeholder: String = "", text: Binding<String>) {
        self.placeholder = placeholder.isEmpty ? nil : placeholder
        self.action = nil
        self.text = text
    }

    static var size: Int? { 1 }

    func buildNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        if let binding = text {
            node.control = TextFieldControl(
                placeholder: placeholder ?? "", 
                placeholderColor: placeholderColor, 
                binding: binding
            )
        } else if let action = action {
            node.control = TextFieldControl(
                placeholder: placeholder ?? "", 
                placeholderColor: placeholderColor, 
                action: action
            )
        } else {
            fatalError("TextField must have either action or text binding")
        }
    }

    func updateNode(_ node: Node) {
        setupEnvironmentProperties(node: node)
        node.view = self
        let control = node.control as! TextFieldControl
        if let binding = text {
            control.binding = binding
        } else if let action = action {
            control.action = action
        }
    }

    private class TextFieldControl: Control {
        var placeholder: String
        var placeholderColor: Color
        var action: ((String) -> Void)?
        var binding: Binding<String>?

        var text: String = ""

        init(placeholder: String, placeholderColor: Color, action: @escaping (String) -> Void) {
            self.placeholder = placeholder
            self.placeholderColor = placeholderColor
            self.action = action
            self.binding = nil
        }
        
        init(placeholder: String, placeholderColor: Color, binding: Binding<String>) {
            self.placeholder = placeholder
            self.placeholderColor = placeholderColor
            self.action = nil
            self.binding = binding
            self.text = binding.wrappedValue
        }

        override func size(proposedSize: Size) -> Size {
            let displayText = binding?.wrappedValue ?? text
            return Size(width: Extended(max(displayText.count, placeholder.count)) + 1, height: 1)
        }

        override func handleEvent(_ char: Character) {
            if char == "\n" {
                if let action = action {
                    action(text)
                    self.text = ""
                }
                // For binding mode, we don't clear the text on Enter
                layer.invalidate()
                return
            }

            if char == ASCII.DEL {
                if let binding = binding {
                    if !binding.wrappedValue.isEmpty {
                        var newValue = binding.wrappedValue
                        newValue.removeLast()
                        binding.wrappedValue = newValue
                        layer.invalidate()
                    }
                } else {
                    if !self.text.isEmpty {
                        self.text.removeLast()
                        layer.invalidate()
                    }
                }
                return
            }

            if let binding = binding {
                binding.wrappedValue += String(char)
            } else {
                self.text += String(char)
            }
            layer.invalidate()
        }

        override func cell(at position: Position) -> Cell? {
            guard position.line == 0 else { return nil }
            
            let displayText = binding?.wrappedValue ?? text
            
            if displayText.isEmpty {
                if position.column.intValue < placeholder.count {
                    let showUnderline = (position.column.intValue == 0) && isFirstResponder
                    let char = placeholder[placeholder.index(placeholder.startIndex, offsetBy: position.column.intValue)]
                    return Cell(
                        char: char,
                        foregroundColor: placeholderColor,
                        attributes: CellAttributes(underline: showUnderline)
                    )
                }
                return .init(char: " ")
            }
            if position.column.intValue == displayText.count, isFirstResponder { 
                return Cell(char: " ", attributes: CellAttributes(underline: true)) 
            }
            guard position.column.intValue < displayText.count else { return .init(char: " ") }
            return Cell(char: displayText[displayText.index(displayText.startIndex, offsetBy: position.column.intValue)])
        }

        override var selectable: Bool { true }

        override func becomeFirstResponder() {
            super.becomeFirstResponder()
            layer.invalidate()
        }

        override func resignFirstResponder() {
            super.resignFirstResponder()
            layer.invalidate()
        }
    }
}

extension EnvironmentValues {
    public var placeholderColor: Color {
        get { self[PlaceholderColorEnvironmentKey.self] }
        set { self[PlaceholderColorEnvironmentKey.self] = newValue }
    }
}

private struct PlaceholderColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color { .default }
}
