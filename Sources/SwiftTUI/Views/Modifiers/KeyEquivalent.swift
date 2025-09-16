import Foundation

/// Represents keyboard modifiers for key combinations
public struct KeyModifiers: OptionSet, Hashable, Sendable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let shift = KeyModifiers(rawValue: 1 << 0)
    public static let control = KeyModifiers(rawValue: 1 << 1)
    public static let alt = KeyModifiers(rawValue: 1 << 2)
    public static let command = KeyModifiers(rawValue: 1 << 3)
}

/// Represents a key for use in key equivalents
public enum Key: Hashable, Sendable {
    case character(Character)
    case tab
    case escape
    case space
    case enter
    case delete
    case backspace
    case up
    case down
    case left
    case right
    
    public var character: Character? {
        switch self {
        case .character(let char):
            return char
        case .tab:
            return "\t"
        case .space:
            return " "
        case .enter:
            return "\n"
        case .delete:
            return "\u{7F}"
        case .backspace:
            return "\u{8}"
        case .escape:
            return "\u{1B}"
        default:
            return nil
        }
    }
}

/// Represents a key equivalent for keyboard shortcuts and input handling
public struct KeyEquivalent: Hashable, Sendable {
    public let key: Key
    public let modifiers: KeyModifiers
    
    public init(key: Key, modifiers: KeyModifiers = []) {
        self.key = key
        self.modifiers = modifiers
    }
    
    public init(_ character: Character) {
        self.key = .character(character)
        self.modifiers = []
    }
    
    // Common key equivalents
    public static let escape = KeyEquivalent(key: .escape)
    public static let tab = KeyEquivalent(key: .tab)
    public static let space = KeyEquivalent(key: .space)
    public static let `return` = KeyEquivalent(key: .enter)
    public static let enter = KeyEquivalent(key: .enter)
    public static let delete = KeyEquivalent(key: .delete)
    public static let backspace = KeyEquivalent(key: .backspace)
    
    // Arrow keys
    public static let upArrow = KeyEquivalent(key: .up)
    public static let downArrow = KeyEquivalent(key: .down)
    public static let leftArrow = KeyEquivalent(key: .left)
    public static let rightArrow = KeyEquivalent(key: .right)
    
    /// Convenience computed property for legacy compatibility
    public var character: Character {
        key.character ?? " "
    }
}

extension KeyEquivalent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        if let firstChar = value.first {
            self.key = .character(firstChar)
            self.modifiers = []
        } else {
            self.key = .space
            self.modifiers = []
        }
    }
}

extension Character {
    /// Convenience method to create a KeyEquivalent from a Character
    public var keyEquivalent: KeyEquivalent {
        KeyEquivalent(self)
    }
}