import Foundation

/// A type that represents a navigation path for programmatic navigation
public struct NavigationPath: Sendable {
    private var path: [String] = []
    
    public init() {}
    
    public init<S: Sequence>(_ elements: S) where S.Element == String {
        self.path = Array(elements)
    }
    
    public mutating func append(_ value: String) {
        path.append(value)
    }
    
    public mutating func removeLast(_ count: Int = 1) {
        let removeCount = min(count, path.count)
        path.removeLast(removeCount)
    }
    
    public var count: Int {
        path.count
    }
    
    public var isEmpty: Bool {
        path.isEmpty
    }
}

/// A simplified navigation stack for basic navigation
public struct NavigationStack<Content: View>: View {
    @State private var navigationHistory: [String] = []
    
    private let content: Content
    
    /// Creates a navigation stack with internal navigation state
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Breadcrumb navigation bar
            if !navigationHistory.isEmpty {
                breadcrumbView
                    .padding(.bottom, 1)
                Divider()
            }
            
            // Main content area
            content
        }
        // .onKeyPress(.escape) { @MainActor in
        //     navigateBack()
        // }
    }
    
    private var breadcrumbView: some View {
        HStack {
            // Home indicator
            Button("🏠") {
                navigateToRoot()
            }
            .foregroundColor(Color.blue)
            
            // Breadcrumb trail
            ForEach(Array(navigationHistory.enumerated()), id: \.offset) { index, item in
                Text(" > ")
                    .foregroundColor(Color.gray)
                
                Button(item) {
                    navigateTo(index: index + 1)
                }
                .foregroundColor(index == navigationHistory.count - 1 ? Color.white : Color.blue)
            }
            
            Spacer()
            
            // Navigation help text
            Text("ESC: Back")
                .foregroundColor(Color.gray)
        }
        .padding(.horizontal)
    }
    
    private func navigateBack() {
        guard !navigationHistory.isEmpty else { return }
        navigationHistory.removeLast()
    }
    
    private func navigateToRoot() {
        navigationHistory.removeAll()
    }
    
    private func navigateTo(index: Int) {
        guard index <= navigationHistory.count else { return }
        let itemsToRemove = navigationHistory.count - index
        navigationHistory.removeLast(itemsToRemove)
    }
}

/// Extension to support navigation destination modifier placeholder
extension View {
    /// Declares a navigation destination for a specific value type
    public func navigationDestination<D: Hashable, C: View>(
        for data: D.Type,
        @ViewBuilder destination: @escaping (D) -> C
    ) -> some View {
        // Simplified implementation - just returns self for now
        self
    }
}