import Foundation

/// Accessibility support for SwiftTUI components
/// Provides screen reader hints and keyboard navigation enhancements

/// Accessibility information for views
public struct AccessibilityInfo: Equatable, Sendable {
    public let label: String?
    public let hint: String?
    public let role: AccessibilityRole?
    public let isHidden: Bool
    
    public init(
        label: String? = nil,
        hint: String? = nil,
        role: AccessibilityRole? = nil,
        isHidden: Bool = false
    ) {
        self.label = label
        self.hint = hint
        self.role = role
        self.isHidden = isHidden
    }
}

/// Accessibility roles for terminal UI components
public enum AccessibilityRole: String, CaseIterable, Sendable {
    case button
    case text
    case textField
    case list
    case table
    case header
    case navigation
    case progress
    case spinner
    case alert
    case dialog
    case menu
    case tab
    case link
    
    /// Description suitable for screen readers
    public var description: String {
        switch self {
        case .button: return "button"
        case .text: return "text"
        case .textField: return "text field"
        case .list: return "list"
        case .table: return "table"
        case .header: return "header"
        case .navigation: return "navigation"
        case .progress: return "progress indicator"
        case .spinner: return "loading spinner"
        case .alert: return "alert"
        case .dialog: return "dialog"
        case .menu: return "menu"
        case .tab: return "tab"
        case .link: return "link"
        }
    }
}

/// View extension for accessibility support
public extension View {
    /// Adds accessibility label for screen readers
    /// - Parameter label: The accessibility label
    /// - Returns: A view with accessibility label
    func accessibilityLabel(_ label: String) -> some View {
        AccessibilityModified(content: self, info: AccessibilityInfo(label: label))
    }
    
    /// Adds accessibility hint for screen readers
    /// - Parameter hint: The accessibility hint
    /// - Returns: A view with accessibility hint
    func accessibilityHint(_ hint: String) -> some View {
        AccessibilityModified(content: self, info: AccessibilityInfo(hint: hint))
    }
    
    /// Sets the accessibility role
    /// - Parameter role: The accessibility role
    /// - Returns: A view with accessibility role
    func accessibilityRole(_ role: AccessibilityRole) -> some View {
        AccessibilityModified(content: self, info: AccessibilityInfo(role: role))
    }
    
    /// Hides the view from accessibility
    /// - Parameter hidden: Whether to hide from accessibility
    /// - Returns: A view with accessibility visibility set
    func accessibilityHidden(_ hidden: Bool = true) -> some View {
        AccessibilityModified(content: self, info: AccessibilityInfo(isHidden: hidden))
    }
    
    /// Sets multiple accessibility properties at once
    /// - Parameters:
    ///   - label: The accessibility label
    ///   - hint: The accessibility hint
    ///   - role: The accessibility role
    /// - Returns: A view with accessibility properties
    func accessibility(
        label: String? = nil,
        hint: String? = nil,
        role: AccessibilityRole? = nil
    ) -> some View {
        AccessibilityModified(
            content: self, 
            info: AccessibilityInfo(label: label, hint: hint, role: role)
        )
    }
}

/// A view modifier that adds accessibility information
private struct AccessibilityModified<Content: View>: View {
    let content: Content
    let info: AccessibilityInfo
    
    var body: some View {
        content
        // Note: In a full implementation, this would integrate with the terminal's
        // accessibility infrastructure. For now, it provides the API structure.
    }
}

/// Keyboard navigation utilities
public struct KeyboardNavigation {
    /// Standard keyboard shortcuts for terminal navigation
    public enum StandardShortcut: String, CaseIterable {
        case tab = "Tab"
        case shiftTab = "Shift+Tab"
        case enter = "Enter"
        case escape = "Escape"
        case space = "Space"
        case arrowUp = "Arrow Up"
        case arrowDown = "Arrow Down"
        case arrowLeft = "Arrow Left"
        case arrowRight = "Arrow Right"
        case home = "Home"
        case end = "End"
        case pageUp = "Page Up"
        case pageDown = "Page Down"
        
        public var description: String { rawValue }
    }
    
    /// Creates accessibility hint text for keyboard navigation
    public static func navigationHint(shortcuts: [StandardShortcut]) -> String {
        let shortcutText = shortcuts.map { $0.description }.joined(separator: ", ")
        return "Use \(shortcutText) to navigate"
    }
    
    /// Creates accessibility hint for interactive elements
    public static func interactionHint(action: String, shortcut: StandardShortcut) -> String {
        return "\(action) with \(shortcut.description)"
    }
}

/// Accessibility-enhanced button
public struct AccessibleButton: View {
    private let title: String
    private let action: () -> Void
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    
    public init(
        _ title: String,
        action: @escaping () -> Void,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil
    ) {
        self.title = title
        self.action = action
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
    }
    
    public var body: some View {
        Button(title, action: action)
            .accessibilityRole(.button)
            .accessibilityLabel(accessibilityLabel ?? title)
            .accessibilityHint(
                accessibilityHint ?? 
                KeyboardNavigation.interactionHint(action: "activate", shortcut: .enter)
            )
    }
}

/// Accessibility-enhanced text field
public struct AccessibleTextField: View {
    private let title: String
    @Binding private var text: String
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    
    public init(
        _ title: String,
        text: Binding<String>,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil
    ) {
        self.title = title
        self._text = text
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
    }
    
    public var body: some View {
        TextField(title, text: $text)
            .accessibilityRole(.textField)
            .accessibilityLabel(accessibilityLabel ?? title)
            .accessibilityHint(
                accessibilityHint ?? 
                "Text field. Current value: \(text.isEmpty ? "empty" : text)"
            )
    }
}