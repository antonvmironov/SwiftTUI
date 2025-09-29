import Foundation

/// A property wrapper that creates and manages the lifecycle of an observable object
/// This is the structured concurrency equivalent of SwiftUI's @StateObject
@propertyWrapper
public struct StateObject<T: Observable>: AnyObservableState {
    private let factory: () -> T
    private let fallbackStorage = FallbackObjectStorage<T>()
    
    public init(wrappedValue factory: @escaping @autoclosure () -> T) {
        self.factory = factory
    }
    
    public init(_ factory: @escaping () -> T) {
        self.factory = factory
    }
    
    var valueReference = ObservableStateReference()
    
    public var wrappedValue: T {
        get {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                // Fallback for testing - create and store instance if needed
                if fallbackStorage.value == nil {
                    fallbackStorage.value = factory()
                }
                return fallbackStorage.value!
            }
            
            // Check if we already have an instance stored
            if let existingValue = node.state[label] as? T {
                return existingValue
            }
            
            // Create new instance and store it
            let newValue = factory()
            node.state[label] = newValue
            
            // Subscribe to changes if not already subscribed
            if node.subscriptions[label] == nil {
                let subscription: () -> Void = { [weak node] in
                    guard let node = node else { return }
                    Task { @MainActor in
                        node.root.application?.invalidateNode(node)
                    }
                }
                newValue.subscribe(subscription)
                
                // Store a dummy subscription marker
                node.subscriptions[label] = true
            }
            
            return newValue
        }
        nonmutating set {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                // Fallback storage for testing
                fallbackStorage.value = newValue
                return
            }
            node.state[label] = newValue
            
            // Subscribe to changes if not already subscribed
            if node.subscriptions[label] == nil {
                let subscription: () -> Void = { [weak node] in
                    guard let node = node else { return }
                    Task { @MainActor in
                        node.root.application?.invalidateNode(node)
                    }
                }
                newValue.subscribe(subscription)
                
                // Store a dummy subscription marker
                node.subscriptions[label] = true
            }
        }
    }
    
    func subscribe(_ action: @escaping () -> Void) {
        // Subscribe to the current value if available
        if let node = valueReference.node,
           let label = valueReference.label,
           let value = node.state[label] as? T {
            value.subscribe(action)
        } else {
            // Subscribe to factory instance for initial setup
            factory().subscribe(action)
        }
    }
}

/// A property wrapper that observes an existing observable object
/// This is the structured concurrency equivalent of SwiftUI's @ObservedObject
@propertyWrapper
public struct ObservedObject<T: Observable>: AnyObservableState {
    public let initialValue: T
    private let fallbackStorage = FallbackObjectStorage<T>()
    
    public init(wrappedValue: T) {
        self.initialValue = wrappedValue
        self.fallbackStorage.value = wrappedValue
    }
    
    var valueReference = ObservableStateReference()
    
    public var wrappedValue: T {
        get {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                // Fallback for testing
                return fallbackStorage.value ?? initialValue
            }
            if let value = node.state[label] {
                return value as! T
            }
            return initialValue
        }
        nonmutating set {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                // Fallback storage for testing
                fallbackStorage.value = newValue
                return
            }
            node.state[label] = newValue
            
            // Subscribe to changes if not already subscribed
            if node.subscriptions[label] == nil {
                let subscription: () -> Void = { [weak node] in
                    guard let node = node else { return }
                    Task { @MainActor in
                        node.root.application?.invalidateNode(node)
                    }
                }
                newValue.subscribe(subscription)
                
                // Store a dummy subscription marker
                node.subscriptions[label] = true
            }
        }
    }
    
    func subscribe(_ action: @escaping () -> Void) {
        (fallbackStorage.value ?? initialValue).subscribe(action)
    }
}

/// Helper class for fallback object storage
private class FallbackObjectStorage<T>: @unchecked Sendable {
    var value: T?
}