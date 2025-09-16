import Foundation

/// A comprehensive help system for terminal applications
public struct HelpOverlay: View {
    private let sections: [HelpSection]
    private let onDismiss: () -> Void
    
    public init(sections: [HelpSection], onDismiss: @escaping () -> Void) {
        self.sections = sections
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ResponsiveView { context in
            VStack(alignment: .leading, spacing: 1) {
                // Header
                HStack {
                    Text("Help")
                        .bold()
                        .foregroundColor(.blue)
                    Spacer()
                    Button("✕ Close") { onDismiss() }
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 1)
                
                // Help sections
                if context.isNarrow {
                    // Single column for narrow terminals
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(sections, id: \.title) { section in
                            HelpSectionView(section: section)
                        }
                    }
                } else {
                    // Multi-column for wider terminals
                    AdaptiveGrid(minItemWidth: 35, spacing: 2) {
                        ForEach(sections, id: \.title) { section in
                            HelpSectionView(section: section)
                        }
                    }
                }
                
                // Footer with navigation hints
                HStack {
                    Text("Navigate: ↑↓ arrows, Tab, Enter to select")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.top, 1)
            }
            .padding()
            .frame(maxWidth: context.maxContentWidth)
            .border(.blue)
            .background(.clear)
        }
    }
}

/// Individual help section view
public struct HelpSectionView: View {
    let section: HelpSection
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(section.title)
                .bold()
                .foregroundColor(.blue)
            
            ForEach(section.items, id: \.shortcut) { item in
                HStack {
                    Text(item.shortcut)
                        .frame(width: 8, alignment: .leading)
                        .foregroundColor(.yellow)
                        .bold()
                    Text(item.description)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(1)
        .border(.gray)
    }
}

/// Help section data model
public struct HelpSection {
    public let title: String
    public let items: [HelpItem]
    
    public init(title: String, items: [HelpItem]) {
        self.title = title
        self.items = items
    }
}

/// Individual help item
public struct HelpItem {
    public let shortcut: String
    public let description: String
    
    public init(shortcut: String, description: String) {
        self.shortcut = shortcut
        self.description = description
    }
}

/// Contextual tooltip for providing guidance
public struct Tooltip: View {
    private let content: String
    private let position: TooltipPosition
    private let isVisible: Bool
    
    public init(content: String, position: TooltipPosition = .bottom, isVisible: Bool = true) {
        self.content = content
        self.position = position
        self.isVisible = isVisible
    }
    
    public var body: some View {
        if isVisible {
            Text(content)
                .padding(.horizontal, 1)
                .border(.yellow)
                .background(.black)
                .foregroundColor(.yellow)
        }
    }
}

/// Tooltip positioning
public enum TooltipPosition {
    case top, bottom, left, right
}

/// Guided tour component for feature introduction
public struct GuidedTour: View {
    private let steps: [TourStep]
    private let onComplete: () -> Void
    
    @State private var currentStep = 0
    
    public init(steps: [TourStep], onComplete: @escaping () -> Void) {
        self.steps = steps
        self.onComplete = onComplete
    }
    
    public var body: some View {
        if currentStep < steps.count {
            let step = steps[currentStep]
            
            VStack(alignment: .leading, spacing: 1) {
                // Tour progress
                HStack {
                    Text("Tour Step \(currentStep + 1) of \(steps.count)")
                        .foregroundColor(.blue)
                        .bold()
                    Spacer()
                    Button("Skip Tour") { 
                        onComplete()
                    }
                    .foregroundColor(.gray)
                }
                
                // Step content
                Text(step.title)
                    .bold()
                    .foregroundColor(.blue)
                    .padding(.top, 1)
                
                Text(step.description)
                    .foregroundColor(.primary)
                
                if !step.tips.isEmpty {
                    Text("Tips:")
                        .bold()
                        .foregroundColor(.secondary)
                        .padding(.top, 1)
                    
                    ForEach(step.tips, id: \.self) { tip in
                        HStack {
                            Text("💡")
                            Text(tip)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                // Navigation buttons
                HStack {
                    if currentStep > 0 {
                        Button("← Previous") {
                            currentStep -= 1
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    if currentStep < steps.count - 1 {
                        Button("Next →") {
                            currentStep += 1
                        }
                        .foregroundColor(.blue)
                        .bold()
                    } else {
                        Button("Finish Tour") {
                            onComplete()
                        }
                        .foregroundColor(.green)
                        .bold()
                    }
                }
                .padding(.top, 1)
            }
            .padding()
            .border(.blue)
            .background(.clear)
        }
    }
}

/// Tour step data model
public struct TourStep {
    public let title: String
    public let description: String
    public let tips: [String]
    
    public init(title: String, description: String, tips: [String] = []) {
        self.title = title
        self.description = description
        self.tips = tips
    }
}

/// Status indicator for providing feedback
public struct StatusIndicator: View {
    private let status: ApplicationStatus
    private let message: String?
    
    public init(status: ApplicationStatus, message: String? = nil) {
        self.status = status
        self.message = message
    }
    
    public var body: some View {
        HStack {
            Text(status.icon)
                .foregroundColor(status.color)
            if let message = message {
                Text(message)
                    .foregroundColor(status.color)
            }
        }
    }
}

/// Application status types
public enum ApplicationStatus {
    case idle
    case loading
    case success
    case warning
    case error
    
    public var icon: String {
        switch self {
        case .idle: return "⚪"
        case .loading: return "⏳"
        case .success: return "✅"
        case .warning: return "⚠️"
        case .error: return "❌"
        }
    }
    
    public var color: Color {
        switch self {
        case .idle: return .gray
        case .loading: return .blue
        case .success: return .green
        case .warning: return .yellow
        case .error: return .red
        }
    }
}

/// Progress indicator with status messaging
public struct ProgressIndicator: View {
    private let progress: Double
    private let total: Double
    private let message: String?
    private let showPercentage: Bool
    
    public init(
        progress: Double,
        total: Double = 100.0,
        message: String? = nil,
        showPercentage: Bool = true
    ) {
        self.progress = progress
        self.total = total
        self.message = message
        self.showPercentage = showPercentage
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let message = message {
                Text(message)
                    .foregroundColor(.blue)
            }
            
            HStack {
                // Progress bar
                let percentage = min(1.0, max(0.0, progress / total))
                let filledWidth = Int(percentage * 20) // 20 character width
                let emptyWidth = 20 - filledWidth
                
                HStack(spacing: 0) {
                    Text(String(repeating: "█", count: filledWidth))
                        .foregroundColor(.green)
                    Text(String(repeating: "░", count: emptyWidth))
                        .foregroundColor(.gray)
                }
                
                if showPercentage {
                    Text("\(Int(percentage * 100))%")
                        .foregroundColor(.blue)
                        .frame(width: 4, alignment: .trailing)
                }
            }
        }
    }
}

/// Smart validation feedback component
public struct ValidationFeedback: View {
    private let validations: [GuidanceValidationResult]
    private let showSuccessful: Bool
    
    public init(validations: [GuidanceValidationResult], showSuccessful: Bool = false) {
        self.validations = validations
        self.showSuccessful = showSuccessful
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(validations, id: \.field) { validation in
                if !validation.isValid || showSuccessful {
                    HStack {
                        Text(validation.isValid ? "✓" : "✗")
                            .foregroundColor(validation.isValid ? .green : .red)
                        Text(validation.message)
                            .foregroundColor(validation.isValid ? .green : .red)
                    }
                }
            }
        }
    }
}

/// Validation result model for user guidance
public struct GuidanceValidationResult {
    public let field: String
    public let isValid: Bool
    public let message: String
    
    public init(field: String, isValid: Bool, message: String) {
        self.field = field
        self.isValid = isValid
        self.message = message
    }
}

/// Quick action button with keyboard shortcut display
public struct QuickAction: View {
    private let title: String
    private let shortcut: String?
    private let action: () -> Void
    
    public init(title: String, shortcut: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.shortcut = shortcut
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.blue)
                if let shortcut = shortcut {
                    Spacer()
                    Text("[\(shortcut)]")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

/// Extension for common user guidance patterns
extension View {
    /// Adds a tooltip to a view
    public func tooltip(_ content: String, isVisible: Bool = true) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            self
            if isVisible {
                Tooltip(content: content)
            }
        }
    }
    
    /// Adds status indicator to a view
    public func statusIndicator(_ status: ApplicationStatus, message: String? = nil) -> some View {
        HStack {
            self
            Spacer()
            StatusIndicator(status: status, message: message)
        }
    }
    
    /// Adds contextual help button
    public func helpButton(sections: [HelpSection]) -> some View {
        HStack {
            self
            Spacer()
            Button("Help") {
                // In a real implementation, this would show the help overlay
            }
            .foregroundColor(.blue)
        }
    }
}