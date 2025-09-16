import Foundation

/// Simple animated components for terminal environments
/// Demonstrates basic animation concepts without complex concurrency

/// A basic loading spinner that can show different animation states
public struct SimpleSpinner: View {
    private let characters: [String]
    private let current: Int
    
    /// Creates a spinner showing a specific character from the sequence
    /// - Parameters:
    ///   - characters: Array of characters to choose from
    ///   - current: Index of the current character to display
    public init(characters: [String] = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"], current: Int = 0) {
        self.characters = characters.isEmpty ? ["|", "/", "-", "\\"] : characters
        self.current = max(0, current % self.characters.count)
    }
    
    /// Creates an ASCII-style spinner
    public static func ascii(current: Int = 0) -> SimpleSpinner {
        SimpleSpinner(characters: ["|", "/", "-", "\\"], current: current)
    }
    
    /// Creates a dots-style spinner
    public static func dots(current: Int = 0) -> SimpleSpinner {
        SimpleSpinner(characters: ["   ", ".  ", ".. ", "..."], current: current)
    }
    
    public var body: some View {
        Text(characters[current])
    }
}

/// A simple progress bar that can be manually updated
public struct SimpleProgressBar: View {
    private let progress: Double
    private let width: Int
    private let fillCharacter: String
    private let emptyCharacter: String
    
    /// Creates a progress bar
    /// - Parameters:
    ///   - progress: Progress value between 0.0 and 1.0
    ///   - width: Width of the progress bar in characters
    ///   - fillCharacter: Character for filled portion
    ///   - emptyCharacter: Character for empty portion
    public init(
        progress: Double,
        width: Int = 20,
        fillCharacter: String = "█",
        emptyCharacter: String = "░"
    ) {
        self.progress = max(0.0, min(1.0, progress))
        self.width = max(1, width)
        self.fillCharacter = fillCharacter
        self.emptyCharacter = emptyCharacter
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            let filledWidth = Int(Double(width) * progress)
            let emptyWidth = width - filledWidth
            
            // Filled portion
            if filledWidth > 0 {
                Text(String(repeating: fillCharacter, count: filledWidth))
                    .foregroundColor(.green)
            }
            
            // Empty portion
            if emptyWidth > 0 {
                Text(String(repeating: emptyCharacter, count: emptyWidth))
                    .foregroundColor(.gray)
            }
        }
    }
}

/// A text component that can show different emphasis states
public struct AnimatableText: View {
    private let text: String
    private let isHighlighted: Bool
    
    /// Creates text that can be highlighted for animation effects
    /// - Parameters:
    ///   - text: The text to display
    ///   - isHighlighted: Whether the text should be highlighted
    public init(_ text: String, isHighlighted: Bool = false) {
        self.text = text
        self.isHighlighted = isHighlighted
    }
    
    public var body: some View {
        Text(text)
            .foregroundColor(isHighlighted ? .white : .gray)
            .bold(isHighlighted)
    }
}

/// A dots indicator that can show different states
public struct AnimatableDots: View {
    private let dotCount: Int
    private let activeDot: Int
    
    /// Creates dots with one active dot
    /// - Parameters:
    ///   - dotCount: Number of dots to display
    ///   - activeDot: Index of the active dot
    public init(dotCount: Int = 3, activeDot: Int = 0) {
        self.dotCount = max(1, dotCount)
        self.activeDot = max(0, activeDot % self.dotCount)
    }
    
    public var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<dotCount, id: \.self) { index in
                Text("●")
                    .foregroundColor(activeDot == index ? .white : .gray)
                    .bold(activeDot == index)
            }
        }
    }
}

/// A transition effect that can show/hide content
public struct TransitionView<Content: View>: View {
    private let content: Content
    private let isVisible: Bool
    private let direction: TransitionDirection
    
    public enum TransitionDirection {
        case none
        case slide
        case fade
    }
    
    /// Creates a view that can be transitioned in/out
    /// - Parameters:
    ///   - content: The content to show/hide
    ///   - isVisible: Whether the content should be visible
    ///   - direction: The transition direction (placeholder for now)
    public init(content: Content, isVisible: Bool, direction: TransitionDirection = .none) {
        self.content = content
        self.isVisible = isVisible
        self.direction = direction
    }
    
    public var body: some View {
        Group {
            if isVisible {
                content
            } else {
                EmptyView()
            }
        }
    }
}