import Foundation

/// Represents a key equivalent for keyboard shortcuts and input handling
public struct KeyEquivalent: Hashable, Sendable {
    public let character: Character
    
    public init(_ character: Character) {
        self.character = character
    }
    
    // Common key equivalents
    public static let escape = KeyEquivalent("\u{1B}")
    public static let tab = KeyEquivalent("\t")
    public static let space = KeyEquivalent(" ")
    public static let `return` = KeyEquivalent("\n")
    public static let enter = KeyEquivalent("\n")
    public static let delete = KeyEquivalent("\u{7F}")
    public static let backspace = KeyEquivalent("\u{8}")
    
    // Note: Arrow keys in terminal environments are typically handled 
    // by the ArrowKeyParser and don't map to single characters
}

extension KeyEquivalent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.character = value.first ?? " "
    }
}

extension Character {
    /// Convenience method to create a KeyEquivalent from a Character
    public var keyEquivalent: KeyEquivalent {
        KeyEquivalent(self)
    }
}