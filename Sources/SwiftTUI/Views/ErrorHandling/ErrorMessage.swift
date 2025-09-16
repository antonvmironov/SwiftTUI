import Foundation

/// A comprehensive error display component for terminal applications
public struct ErrorMessage: View {
    private let error: DisplayableError
    private let onDismiss: (() -> Void)?
    private let showDetails: Bool
    
    public init(
        error: DisplayableError,
        showDetails: Bool = false,
        onDismiss: (() -> Void)? = nil
    ) {
        self.error = error
        self.showDetails = showDetails
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            // Error header with icon and title
            HStack {
                Text(error.severity.icon)
                    .foregroundColor(error.severity.color)
                Text(error.title)
                    .bold()
                    .foregroundColor(error.severity.color)
                Spacer()
                if let onDismiss = onDismiss {
                    Button("✕") { onDismiss() }
                        .foregroundColor(.gray)
                }
            }
            
            // Error message
            Text(error.message)
                .foregroundColor(.primary)
            
            // Helpful suggestions
            if !error.suggestions.isEmpty {
                Text("Suggestions:")
                    .bold()
                    .foregroundColor(.secondary)
                    .padding(.top, 1)
                
                ForEach(error.suggestions, id: \.self) { suggestion in
                    HStack {
                        Text("•")
                            .foregroundColor(.secondary)
                        Text(suggestion)
                            .foregroundColor(.primary)
                    }
                }
            }
            
            // Error details (if requested)
            if showDetails {
                Text("Details:")
                    .bold()
                    .foregroundColor(.secondary)
                    .padding(.top, 1)
                
                Text(error.details ?? "No additional details available.")
                    .foregroundColor(.secondary)
            }
            
            // Action buttons
            if !error.actions.isEmpty {
                HStack(spacing: 2) {
                    ForEach(error.actions, id: \.title) { action in
                        Button(action.title) {
                            action.handler()
                        }
                        .foregroundColor(action.style.color)
                    }
                }
                .padding(.top, 1)
            }
        }
        .padding()
        .border(error.severity.color)
        .background(error.severity.backgroundColor)
    }
}

/// Represents an error that can be displayed to users
public struct DisplayableError {
    public let title: String
    public let message: String
    public let severity: ErrorSeverity
    public let suggestions: [String]
    public let details: String?
    public let actions: [ErrorAction]
    
    public init(
        title: String,
        message: String,
        severity: ErrorSeverity = .error,
        suggestions: [String] = [],
        details: String? = nil,
        actions: [ErrorAction] = []
    ) {
        self.title = title
        self.message = message
        self.severity = severity
        self.suggestions = suggestions
        self.details = details
        self.actions = actions
    }
}

/// Error severity levels with appropriate styling
public enum ErrorSeverity {
    case info
    case warning
    case error
    case critical
    
    public var icon: String {
        switch self {
        case .info: return "ℹ"
        case .warning: return "⚠"
        case .error: return "✗"
        case .critical: return "🛑"
        }
    }
    
    public var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .yellow
        case .error: return .red
        case .critical: return .red
        }
    }
    
    public var backgroundColor: Color {
        switch self {
        case .info: return .clear
        case .warning: return .clear
        case .error: return .clear
        case .critical: return .red.opacity(0.1)
        }
    }
}

/// Actionable error response
public struct ErrorAction {
    public let title: String
    public let style: ActionStyle
    public let handler: () -> Void
    
    public init(title: String, style: ActionStyle = .default, handler: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

/// Action button styling
public enum ActionStyle {
    case `default`
    case primary
    case destructive
    
    public var color: Color {
        switch self {
        case .default: return .secondary
        case .primary: return .blue
        case .destructive: return .red
        }
    }
}

/// A toast notification for temporary error messages
public struct ErrorToast: View {
    private let error: DisplayableError
    private let duration: TimeInterval
    private let onDismiss: () -> Void
    
    @State private var isVisible = true
    
    public init(
        error: DisplayableError,
        duration: TimeInterval = 3.0,
        onDismiss: @escaping () -> Void
    ) {
        self.error = error
        self.duration = duration
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        if isVisible {
            HStack {
                Text(error.severity.icon)
                    .foregroundColor(error.severity.color)
                Text(error.message)
                    .foregroundColor(.primary)
                Spacer()
                Button("✕") {
                    dismiss()
                }
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 1)
            .background(error.severity.backgroundColor)
            .border(error.severity.color)
        }
    }
    
    private func dismiss() {
        isVisible = false
        onDismiss()
    }
}

/// Error boundary component for handling view errors gracefully
public struct ErrorBoundary<Content: View, ErrorContent: View>: View {
    private let content: () -> Content
    private let errorContent: (DisplayableError) -> ErrorContent
    
    @State private var error: DisplayableError?
    
    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder errorContent: @escaping (DisplayableError) -> ErrorContent
    ) {
        self.content = content
        self.errorContent = errorContent
    }
    
    public var body: some View {
        if let error = error {
            errorContent(error)
        } else {
            content()
                .onError { displayableError in
                    self.error = displayableError
                }
        }
    }
}

extension View {
    /// Adds error handling to a view
    public func onError(_ handler: @escaping (DisplayableError) -> Void) -> some View {
        // Note: This is a placeholder implementation
        // In a real implementation, this would integrate with SwiftTUI's error system
        return self
    }
    
    /// Wraps view in an error boundary
    public func errorBoundary<ErrorContent: View>(
        @ViewBuilder errorContent: @escaping (DisplayableError) -> ErrorContent
    ) -> some View {
        ErrorBoundary(content: { self }, errorContent: errorContent)
    }
}