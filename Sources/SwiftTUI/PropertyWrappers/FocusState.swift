import Foundation

/// A property wrapper type that tracks focus state in the terminal UI
@propertyWrapper
@MainActor
public struct FocusState<Value>: AnyFocusState, Sendable where Value: Hashable & Sendable {
    public let initialValue: Value?
    private let fallbackStorage = FallbackStorage<Value>()
    
    /// Creates a focus state with a wrapped value
    public init(wrappedValue: Value? = nil) {
        self.initialValue = wrappedValue
        self.fallbackStorage.value = wrappedValue
    }
    
    var valueReference = FocusStateReference()
    
    public var wrappedValue: Value? {
        get {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                // Fallback to stored value when not connected to a node (e.g., in tests)
                return fallbackStorage.value
            }
            if let value = node.state[label] {
                return value as? Value
            }
            return initialValue
        }
        nonmutating set {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                // Fallback storage when not connected to a node (e.g., in tests)
                fallbackStorage.value = newValue
                return
            }
            
            // Update the focus state
            node.state[label] = newValue
            
            // Update the actual focus in the application
            if let rootApplication = node.root.application {
                Task { @MainActor [rootApplication, newValue] in
                    rootApplication.updateFocus(to: newValue)
                }
            }
        }
    }
    
    public var projectedValue: FocusStateBinding<Value> {
        FocusStateBinding<Value>(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

/// Specialized wrapper that works directly with Bool (non-optional)
@propertyWrapper  
public struct BoolFocusState: AnyFocusState, Sendable {
    public let initialValue: Bool
    private let fallbackStorage = BoolFallbackStorage()
    
    /// Creates a Bool focus state with default false
    public init() {
        self.initialValue = false
        self.fallbackStorage.value = false
    }
    
    /// Creates a Bool focus state with a wrapped value
    public init(wrappedValue: Bool) {
        self.initialValue = wrappedValue
        self.fallbackStorage.value = wrappedValue
    }
    
    var valueReference = FocusStateReference()
    
    public var wrappedValue: Bool {
        get {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                // Fallback to stored value when not connected to a node (e.g., in tests)
                return fallbackStorage.value
            }
            if let value = node.state[label] as? Bool {
                return value
            }
            return initialValue
        }
        nonmutating set {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                // Fallback storage when not connected to a node (e.g., in tests)
                fallbackStorage.value = newValue
                return
            }
            
            // Update the focus state
            node.state[label] = newValue
            
            // Update the actual focus in the application
            if let rootApplication = node.root.application {
                Task { @MainActor [rootApplication, newValue] in
                    rootApplication.updateBoolFocus(focused: newValue)
                }
            }
        }
    }
    
    public var projectedValue: BoolFocusStateBinding {
        BoolFocusStateBinding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

/// A specialized binding for focus state
@MainActor
public struct FocusStateBinding<Value>: Sendable where Value: Hashable & Sendable {
    private let get: @MainActor () -> Value?
    private let set: @MainActor (Value?) -> Void

    init(get: @escaping @MainActor () -> Value?, set: @escaping @MainActor (Value?) -> Void) {
        self.get = get
        self.set = set
    }
    
    public var wrappedValue: Value? {
        get { get() }
        nonmutating set { set(newValue) }
    }
}

/// A specialized binding for Bool focus state
@MainActor
public struct BoolFocusStateBinding: Sendable {
    private let get: @MainActor () -> Bool
    private let set: @MainActor (Bool) -> Void

    init(get: @escaping @MainActor () -> Bool, set: @escaping @MainActor (Bool) -> Void) {
        self.get = get
        self.set = set
    }
    
    public var wrappedValue: Bool {
        get { get() }
        nonmutating set { set(newValue) }
    }
}

/// Protocol for focus state property wrappers
@MainActor
protocol AnyFocusState {
    var valueReference: FocusStateReference { get }
}

/// Reference holder for focus state
@MainActor
class FocusStateReference: @unchecked Sendable {
    weak var node: Node?
    var label: String?
}

/// Helper class for fallback storage when not connected to a node
@MainActor
private class FallbackStorage<Value>: @unchecked Sendable where Value: Hashable & Sendable {
    var value: Value?
    
    init() {
        self.value = nil
    }
}

/// Helper class for bool fallback storage
@MainActor
private class BoolFallbackStorage: @unchecked Sendable {
    var value: Bool = false
}
