import Foundation

@propertyWrapper
public struct Binding<T> {
    let get: () -> T
    let set: (T) -> Void

    public init(get: @escaping () -> T, set: @escaping (T) -> Void) {
        self.get = get
        self.set = set
    }

    public var wrappedValue: T {
        get { get() }
        nonmutating set { set(newValue) }
    }

    public var projectedValue: Binding<T> { self }
    
    /// Creates a binding with a constant value that cannot be changed
    public static func constant(_ value: T) -> Binding<T> {
        Binding(get: { value }, set: { _ in })
    }
}
