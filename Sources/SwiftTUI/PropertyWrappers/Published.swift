import Foundation

/// A property wrapper that publishes changes to observable objects using structured concurrency
/// This is the structured concurrency equivalent of Combine's @Published
@propertyWrapper
public struct Published<Value>: @unchecked Sendable {
    private var storage: Value
    private weak var publisher: (any PublishingObject)?
    
    public init(wrappedValue: Value) {
        self.storage = wrappedValue
        self.publisher = nil
    }
    
    public var wrappedValue: Value {
        get { storage }
        set {
            storage = newValue
            publisher?.objectDidChange()
        }
    }
    
    public var projectedValue: Published<Value> { self }
}

/// Protocol for objects that can publish changes
public protocol PublishingObject: AnyObject {
    /// Called when any @Published property changes
    func objectDidChange()
}

/// Extension for type erasure of Published properties
protocol AnyPublished {
    mutating func setPublisher(_ publisher: any PublishingObject)
}

extension Published: AnyPublished {
    mutating func setPublisher(_ publisher: any PublishingObject) {
        self.publisher = publisher
    }
}

/// An enhanced version of ObservableObject that supports @Published properties
open class PublishableObject: ObservableObject, PublishingObject, @unchecked Sendable {
    
    public override init() {
        super.init()
        // Use reflection to connect all @Published properties to this object
        connectPublishedProperties()
    }
    
    /// Called when any @Published property changes - triggers UI updates
    public func objectDidChange() {
        notifyObservers()
    }
    
    private func connectPublishedProperties() {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if var publishedProperty = child.value as? AnyPublished {
                publishedProperty.setPublisher(self)
            }
        }
    }
}