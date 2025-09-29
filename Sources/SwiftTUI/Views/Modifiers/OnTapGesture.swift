import Foundation

public extension View {
    /// Adds an action to perform when the view is "tapped" (Enter key is pressed).
    /// This provides a SwiftUI-compatible gesture for terminal environments.
    /// - Parameter action: The action to perform when the gesture is recognized
    /// - Returns: A view that responds to the tap gesture
    func onTapGesture(action: @escaping @MainActor () -> Void) -> some View {
        return OnTapGesture(content: self, action: action)
    }
    
    /// Adds an action to perform when the view is "tapped" with a count.
    /// In terminal environments, this responds to multiple Enter key presses.
    /// - Parameters:
    ///   - count: The number of taps required to trigger the action
    ///   - action: The action to perform when the gesture is recognized
    /// - Returns: A view that responds to the tap gesture
    func onTapGesture(count: Int, action: @escaping @MainActor () -> Void) -> some View {
        return OnTapGestureCount(content: self, count: count, action: action)
    }
}

private struct OnTapGesture<Content: View>: View, PrimitiveNodeViewBuilder, ModifierView {
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
        if let onTapControl = control.parent as? OnTapGestureControl { 
            onTapControl.action = action
            return onTapControl 
        }
        let onTapControl = OnTapGestureControl(action: action)
        onTapControl.addSubview(control, at: 0)
        return onTapControl
    }

    private class OnTapGestureControl: Control {
        var action: @MainActor () -> Void

        init(action: @escaping @MainActor () -> Void) {
            self.action = action
        }

        override var selectable: Bool { true }

        override func size(proposedSize: Size) -> Size {
            children[0].size(proposedSize: proposedSize)
        }

        override func layout(size: Size) {
            super.layout(size: size)
            children[0].layout(size: size)
        }

        override func handleEvent(_ char: Character) {
            if char == "\n" { // Enter key
                Task { @MainActor [action] in 
                    action()
                }
            } else {
                super.handleEvent(char)
            }
        }
    }
}

private struct OnTapGestureCount<Content: View>: View, PrimitiveNodeViewBuilder, ModifierView {
    let content: Content
    let count: Int
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
        if let onTapControl = control.parent as? OnTapGestureCountControl { 
            onTapControl.count = count
            onTapControl.action = action
            return onTapControl 
        }
        let onTapControl = OnTapGestureCountControl(count: count, action: action)
        onTapControl.addSubview(control, at: 0)
        return onTapControl
    }

    private class OnTapGestureCountControl: Control {
        var count: Int
        var action: @MainActor () -> Void
        private var currentCount = 0
        private var lastTapTime = Date()

        init(count: Int, action: @escaping @MainActor () -> Void) {
            self.count = count
            self.action = action
        }

        override var selectable: Bool { true }

        override func size(proposedSize: Size) -> Size {
            children[0].size(proposedSize: proposedSize)
        }

        override func layout(size: Size) {
            super.layout(size: size)
            children[0].layout(size: size)
        }

        override func handleEvent(_ char: Character) {
            if char == "\n" { // Enter key
                let now = Date()
                let timeSinceLastTap = now.timeIntervalSince(lastTapTime)
                
                // Reset if too much time has passed (more than 0.5 seconds)
                if timeSinceLastTap > 0.5 {
                    currentCount = 0
                }
                
                currentCount += 1
                lastTapTime = now
                
                if currentCount >= count {
                    currentCount = 0
                    Task { @MainActor [action] in 
                        action()
                    }
                }
            } else {
                super.handleEvent(char)
            }
        }
    }
}
