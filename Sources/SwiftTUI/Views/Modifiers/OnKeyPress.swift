import Foundation

public extension View {
    /// Adds an action to perform when a specific key is pressed.
    /// - Parameters:
    ///   - key: The key equivalent to watch for
    ///   - action: The action to perform when the key is pressed
    /// - Returns: A view that responds to the specified key press
    func onKeyPress(_ key: KeyEquivalent, action: @escaping @MainActor () -> Void) -> some View {
        return OnKeyPress(content: self, key: key, action: action)
    }
}

private struct OnKeyPress<Content: View>: View, PrimitiveView, ModifierView {
    let content: Content
    let key: KeyEquivalent
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
        if let onKeyPressControl = control.parent as? OnKeyPressControl { 
            onKeyPressControl.key = key
            onKeyPressControl.action = action
            return onKeyPressControl 
        }
        let onKeyPressControl = OnKeyPressControl(key: key, action: action)
        onKeyPressControl.addSubview(control, at: 0)
        return onKeyPressControl
    }

    private class OnKeyPressControl: Control {
        var key: KeyEquivalent
        var action: @MainActor () -> Void

        init(key: KeyEquivalent, action: @escaping @MainActor () -> Void) {
            self.key = key
            self.action = action
        }

        override func size(proposedSize: Size) -> Size {
            children[0].size(proposedSize: proposedSize)
        }

        override func layout(size: Size) {
            super.layout(size: size)
            children[0].layout(size: size)
        }

        override func handleEvent(_ char: Character) {
            if char == key.character {
                Task { @MainActor [action] in 
                    action()
                }
            } else {
                super.handleEvent(char)
            }
        }
    }
}