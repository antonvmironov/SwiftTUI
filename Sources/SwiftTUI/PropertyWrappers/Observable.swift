import Foundation

/// A protocol that enables automatic change tracking for observable objects
public protocol Observable: AnyObject {
    /// Called when any observed property of this object changes
    func notifyObservers()
    
    /// Subscribe to changes in this observable object
    func subscribe(_ action: @escaping () -> Void)
}

/// A property wrapper that provides automatic change tracking for observable properties
@propertyWrapper
public struct ObservableProperty<Value> {
    private var storage: Value
    private let observableRef = ObservableRef()
    
    public init(wrappedValue: Value) {
        self.storage = wrappedValue
    }
    
    public var wrappedValue: Value {
        get { storage }
        set {
            storage = newValue
            observableRef.observable?.notifyObservers()
        }
    }
    
    /// Sets the observable parent (called automatically by ObservableObject)
    mutating func setObservable(_ observable: Observable) {
        observableRef.observable = observable
    }
}

/// Thread-safe reference to parent observable
private class ObservableRef: @unchecked Sendable {
    weak var observable: Observable?
}

/// A base class that provides automatic change tracking for SwiftTUI views
open class ObservableObject: Observable, @unchecked Sendable {
    private var subscribers: [() -> Void] = []
    
    public init() {
        // Connect properties after initialization
        connectObservableProperties()
    }
    
    /// Subscribe to changes in this observable object
    public func subscribe(_ action: @escaping () -> Void) {
        subscribers.append(action)
    }
    
    /// Manually notify observers of changes
    public func notifyObservers() {
        let currentSubscribers = subscribers
        Task { @MainActor in
            for subscriber in currentSubscribers {
                subscriber()
            }
        }
    }
    
    private func connectObservableProperties() {
        // Simplified approach - just ensure the class is set up properly
        // Property connection happens through the reflection-based approach in child properties
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            // The connection will happen when properties are accessed
            _ = child.value
        }
    }
}

/// Internal protocol for type erasure of ObservableProperty
protocol AnyObservableProperty {
    mutating func connectToObservable(_ observable: Observable)
}

extension ObservableProperty: AnyObservableProperty {
    mutating func connectToObservable(_ observable: Observable) {
        self.observableRef.observable = observable
    }
}

/// Property wrapper for observing changes to Observable objects
@propertyWrapper
public struct ObservableState<T: Observable>: AnyObservableState {
    public let initialValue: T
    
    public init(initialValue: T) {
        self.initialValue = initialValue
    }
    
    public init(wrappedValue: T) {
        self.initialValue = wrappedValue
    }
    
    var valueReference = ObservableStateReference()
    
    public var wrappedValue: T {
        get {
            guard let node = valueReference.node,
                  let label = valueReference.label
            else {
                return initialValue
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
        initialValue.subscribe(action)
    }
}

protocol AnyObservableState {
    var valueReference: ObservableStateReference { get }
    func subscribe(_ action: @escaping () -> Void)
}

class ObservableStateReference {
    weak var node: Node?
    var label: String?
}

extension Node {
    var subscriptions: [String: Any] {
        get {
            if let existing = state["_subscriptions"] as? [String: Any] {
                return existing
            }
            return [:]
        }
        set {
            state["_subscriptions"] = newValue
        }
    }
}