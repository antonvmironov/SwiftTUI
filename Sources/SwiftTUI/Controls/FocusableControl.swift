import Foundation

/// A control wrapper that provides focus management
internal class FocusableControl<Value>: Control where Value: Hashable & Sendable {
    var focusValue: Value?
    var focusBinding: FocusStateBinding<Value>?
    
    override var selectable: Bool { 
        // Make this control selectable so it can receive focus
        children.first?.selectable ?? false
    }
    
    override func becomeFirstResponder() {
        super.becomeFirstResponder()
        
        // Update the focus state when this control becomes focused
        if let focusValue = focusValue {
            focusBinding?.wrappedValue = focusValue
        }
        
        // Delegate to child control if it's selectable
        if let child = children.first, child.selectable {
            child.becomeFirstResponder()
        }
    }
    
    override func resignFirstResponder() {
        super.resignFirstResponder()
        
        // Clear focus state when losing focus
        if focusBinding?.wrappedValue == focusValue {
            focusBinding?.wrappedValue = nil
        }
        
        // Delegate to child control
        if let child = children.first {
            child.resignFirstResponder()
        }
    }
    
    override func size(proposedSize: Size) -> Size {
        guard let child = children.first else { return Size.zero }
        return child.size(proposedSize: proposedSize)
    }
    
    override func layout(size: Size) {
        super.layout(size: size)
        if let child = children.first {
            child.layout(size: size)
        }
    }
    
    override func handleEvent(_ char: Character) {
        // Delegate event handling to child
        children.first?.handleEvent(char)
    }
}