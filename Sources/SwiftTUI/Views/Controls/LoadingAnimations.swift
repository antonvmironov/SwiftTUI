import Foundation

/// A simple loading spinner animation for terminal environments
public struct LoadingSpinner: View, Sendable {
    private let characters: [String]
    
    /// Creates a loading spinner with the default spinning character animation
    public init() {
        self.characters = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
    }
    
    /// Creates a loading spinner with custom characters
    /// - Parameter characters: Array of characters to cycle through
    public init(characters: [String]) {
        self.characters = characters.isEmpty ? ["|", "/", "-", "\\"] : characters
    }
    
    /// Creates a loading spinner with a simple ASCII style
    public static var ascii: LoadingSpinner {
        LoadingSpinner(characters: ["|", "/", "-", "\\"])
    }
    
    /// Creates a loading spinner with dots animation
    public static var dots: LoadingSpinner {
        LoadingSpinner(characters: ["   ", ".  ", ".. ", "..."])
    }
    
    public var body: some View {
        // For now, show the first character as a static representation
        // In a full implementation, this could integrate with SwiftTUI's animation system
        Text(characters.first ?? "⠋")
    }
}

/// A progress bar component for terminal environments
public struct ProgressBar: View, Sendable {
    private let progress: Double
    private let width: Int
    private let fillCharacter: String
    private let emptyCharacter: String
    
    /// Creates a progress bar
    /// - Parameters:
    ///   - progress: Progress value between 0.0 and 1.0
    ///   - width: Width of the progress bar in characters (default: 20)
    ///   - fillCharacter: Character used for filled portion (default: "█")
    ///   - emptyCharacter: Character used for empty portion (default: "░")
    public init(progress: Double, width: Int = 20, fillCharacter: String = "█", emptyCharacter: String = "░") {
        self.progress = max(0.0, min(1.0, progress))
        self.width = max(1, width)
        self.fillCharacter = fillCharacter
        self.emptyCharacter = emptyCharacter
    }
    
    public var body: some View {
        let filledWidth = Int(progress * Double(width))
        let emptyWidth = width - filledWidth
        
        HStack(spacing: 0) {
            Text(String(repeating: fillCharacter, count: filledWidth))
                .foregroundColor(.green)
            Text(String(repeating: emptyCharacter, count: emptyWidth))
                .foregroundColor(.brightBlack)
        }
    }
}

/// A skeleton loading view that shows a placeholder pattern
public struct SkeletonView: View, Sendable {
    private let width: Int
    private let height: Int
    
    /// Creates a skeleton loading view
    /// - Parameters:
    ///   - width: Width in characters
    ///   - height: Height in lines (default: 1)
    public init(width: Int, height: Int = 1) {
        self.width = max(1, width)
        self.height = max(1, height)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<height, id: \.self) { _ in
                Text(String(repeating: "░", count: width))
                    .foregroundColor(.brightBlack)
            }
        }
    }
}

/// A simple loading indicator that combines text with a spinner
public struct LoadingIndicator: View, Sendable {
    private let text: String
    private let spinner: LoadingSpinner
    
    /// Creates a loading indicator with custom text and spinner
    /// - Parameters:
    ///   - text: The loading message to display
    ///   - spinner: The spinner to use (default: standard spinner)
    public init(_ text: String, spinner: LoadingSpinner = LoadingSpinner()) {
        self.text = text
        self.spinner = spinner
    }
    
    public var body: some View {
        HStack {
            spinner
            Text(text)
                .foregroundColor(.secondary)
        }
    }
}