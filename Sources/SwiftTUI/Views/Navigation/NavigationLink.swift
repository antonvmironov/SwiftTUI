import Foundation

/// A SwiftUI-compatible navigation link for terminal environments
/// This is a simplified version that provides the UI pattern without full navigation stack support
public struct NavigationLink<Label: View, Destination: View>: View {
    private let destination: Destination
    private let label: Label
    private let title: String?
    
    /// Creates a navigation link with a custom label
    public init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
        self.title = nil
    }
    
    /// Creates a navigation link with a text label
    public init(_ title: String, destination: Destination) where Label == Text {
        self.destination = destination
        self.label = Text(title)
        self.title = title
    }
    
    public var body: some View {
        Button(action: {
            // For now, just provide the UI pattern
            // In a full implementation, this would integrate with navigation state
        }) {
            HStack {
                label
                Spacer()
                Text(">")
                    .foregroundColor(.secondary)
            }
        }
    }
}