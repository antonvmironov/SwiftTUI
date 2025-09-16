import Foundation

/// A property wrapper type that tracks focus state in the terminal UI
@propertyWrapper
public struct FocusState<Value>: AnyFocusState, Sendable where Value: Hashable & Sendable {
    public let initialValue: Value?
    
    /// Creates a focus state with a wrapped value
    public init(wrappedValue: Value? = nil) {
        self.initialValue = wrappedValue
    }
    
    var valueReference = FocusStateReference()
    
    public var wrappedValue: Value? {
        get {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                return initialValue
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
    
    /// Creates a Bool focus state with default false
    public init() {
        self.initialValue = false
    }
    
    /// Creates a Bool focus state with a wrapped value
    public init(wrappedValue: Bool) {
        self.initialValue = wrappedValue
    }
    
    var valueReference = FocusStateReference()
    
    public var wrappedValue: Bool {
        get {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                return initialValue
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
public struct FocusStateBinding<Value>: Sendable where Value: Hashable & Sendable {
    private let get: @Sendable () -> Value?
    private let set: @Sendable (Value?) -> Void
    
    init(get: @escaping @Sendable () -> Value?, set: @escaping @Sendable (Value?) -> Void) {
        self.get = get
        self.set = set
    }
    
    public var wrappedValue: Value? {
        get { get() }
        nonmutating set { set(newValue) }
    }
}

/// A specialized binding for Bool focus state
public struct BoolFocusStateBinding: Sendable {
    private let get: @Sendable () -> Bool
    private let set: @Sendable (Bool) -> Void
    
    init(get: @escaping @Sendable () -> Bool, set: @escaping @Sendable (Bool) -> Void) {
        self.get = get
        self.set = set
    }
    
    public var wrappedValue: Bool {
        get { get() }
        nonmutating set { set(newValue) }
    }
}

/// Protocol for focus state property wrappers
protocol AnyFocusState {
    var valueReference: FocusStateReference { get }
}

/// Reference holder for focus state
class FocusStateReference: @unchecked Sendable {
    weak var node: Node?
    var label: String?
}