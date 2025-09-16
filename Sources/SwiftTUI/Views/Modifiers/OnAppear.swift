import Foundation

public extension View {
    /// Adds an action to perform when this view appears.
    /// - Parameter action: The action to perform when the view appears
    /// - Returns: A view that triggers the action when it appears
    func onAppear(_ action: @escaping @MainActor () -> Void) -> some View {
        return OnAppear(content: self, action: action)
    }
    
    /// Adds an action to perform when this view disappears.
    /// - Parameter action: The action to perform when the view disappears
    /// - Returns: A view that triggers the action when it disappears
    func onDisappear(_ action: @escaping @MainActor () -> Void) -> some View {
        return OnDisappear(content: self, action: action)
    }
}

private struct OnAppear<Content: View>: View, PrimitiveView, ModifierView {
    let content: Content
    let action: @MainActor () -> Void

    static var size: Int? { Content.size }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: content.view))
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
    }

    func passControl(_ control: Control, node: Node) -> Control {
        if let onAppearControl = control.parent as? OnAppearControl { 
            onAppearControl.action = action
            return onAppearControl 
        }
        let onAppearControl = OnAppearControl(action: action)
        onAppearControl.addSubview(control, at: 0)
        return onAppearControl
    }

    private class OnAppearControl: Control {
        var action: @MainActor () -> Void
        var didAppear = false

        init(action: @escaping @MainActor () -> Void) {
            self.action = action
        }

        override func size(proposedSize: Size) -> Size {
            children[0].size(proposedSize: proposedSize)
        }

        override func layout(size: Size) {
            super.layout(size: size)
            children[0].layout(size: size)
            if !didAppear {
                didAppear = true
                Task { @MainActor [action] in 
                    action()
                }
            }
        }
    }
}

private struct OnDisappear<Content: View>: View, PrimitiveView, ModifierView {
    let content: Content
    let action: @MainActor () -> Void

    static var size: Int? { Content.size }

    func buildNode(_ node: Node) {
        node.addNode(at: 0, Node(view: content.view))
    }

    func updateNode(_ node: Node) {
        node.view = self
        node.children[0].update(using: content.view)
    }

    func passControl(_ control: Control, node: Node) -> Control {
        if let onDisappearControl = control.parent as? OnDisappearControl { 
            onDisappearControl.action = action
            return onDisappearControl 
        }
        let onDisappearControl = OnDisappearControl(action: action)
        onDisappearControl.addSubview(control, at: 0)
        return onDisappearControl
    }

    private class OnDisappearControl: Control {
        var action: @MainActor () -> Void

        init(action: @escaping @MainActor () -> Void) {
            self.action = action
        }

        override func size(proposedSize: Size) -> Size {
            children[0].size(proposedSize: proposedSize)
        }

        override func layout(size: Size) {
            super.layout(size: size)
            children[0].layout(size: size)
        }
        
        deinit {
            Task { @MainActor [action] in 
                action()
            }
        }
    }
}
