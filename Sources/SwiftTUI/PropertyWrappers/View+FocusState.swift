import Foundation

extension View {
    func setupFocusStateProperties(node: Node) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let focusState = child.value as? AnyFocusState {
                let label = child.label?.dropFirst() ?? "focus"
                focusState.valueReference.node = node
                focusState.valueReference.label = String(label)
            }
        }
    }
}

/// A modifier that makes a view focusable with a specific focus value
private struct Focused<Content: View, Value>: View, PrimitiveView, ModifierView where Value: Hashable & Sendable {
    let content: Content
    private let value: Value
    private let focusBinding: FocusStateBinding<Value>
    
    init(content: Content, value: Value, focus: FocusStateBinding<Value>) {
        self.content = content
        self.value = value
        self.focusBinding = focus
    }
    
    static var size: Int? { Content.size }
    
    func buildNode(_ node: Node) {
        node.controls = WeakSet<Control>()
        node.addNode(at: 0, Node(view: content.view))
    }
    
    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
        
        // Update focus binding for all focusable controls
        for control in node.controls?.values ?? [] {
            if let focusableControl = control as? FocusableControl<Value> {
                focusableControl.focusBinding = focusBinding
                focusableControl.focusValue = value
            }
        }
    }
    
    func passControl(_ control: Control, node: Node) -> Control {
        if let focusableControl = control as? FocusableControl<Value> {
            focusableControl.focusValue = value
            focusableControl.focusBinding = focusBinding
            return focusableControl
        } else {
            let wrapper = FocusableControl<Value>()
            wrapper.focusValue = value
            wrapper.focusBinding = focusBinding
            wrapper.addSubview(control, at: 0)
            node.controls?.add(wrapper)
            return wrapper
        }
    }
}

// Extension to add focused modifier to View
extension View {
    /// Makes this view focusable with the specified focus value
    public func focused<Value>(_ binding: FocusStateBinding<Value>, equals value: Value) -> some View where Value: Hashable & Sendable {
        Focused(content: self, value: value, focus: binding)
    }
    
    /// Makes this view focusable for boolean focus state
    public func focused(_ binding: FocusStateBinding<Bool>) -> some View {
        focused(binding, equals: true)
    }
}