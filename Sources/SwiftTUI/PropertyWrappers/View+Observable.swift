import Foundation

extension View {
    func setupObservableStateProperties(node: Node) {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let observableState = child.value as? AnyObservableState {
                let label = child.label?.dropFirst() ?? "observable"
                observableState.valueReference.node = node
                observableState.valueReference.label = String(label)
                
                // Subscribe to changes immediately
                let subscription: () -> Void = { [weak node] in
                    guard let node = node else { return }
                    Task { @MainActor in
                        node.root.application?.invalidateNode(node)
                    }
                }
                observableState.subscribe(subscription)
            }
        }
    }
}