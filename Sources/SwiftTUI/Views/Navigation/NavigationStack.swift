import Foundation

/// A type that represents a navigation path for programmatic navigation
public struct NavigationPath: Sendable {
    internal var path: [String] = []
    
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
    private let pathBinding: Binding<NavigationPath>?
    
    private let content: Content
    
    /// Creates a navigation stack with internal navigation state
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.pathBinding = nil
    }
    
    /// Creates a navigation stack with external path binding
    public init(path: Binding<NavigationPath>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.pathBinding = path
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Breadcrumb navigation bar
            let currentHistory = pathBinding?.wrappedValue.path ?? navigationHistory
            if !currentHistory.isEmpty {
                breadcrumbView(history: currentHistory)
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
    
    private func breadcrumbView(history: [String]) -> some View {
        HStack {
            // Home indicator
            Button("🏠") {
                navigateToRoot()
            }
            .foregroundColor(Color.blue)
            
            // Breadcrumb trail
            ForEach(Array(history.enumerated()), id: \.offset) { index, item in
                Text(" > ")
                    .foregroundColor(Color.gray)
                
                Button(item) {
                    navigateTo(index: index + 1)
                }
                .foregroundColor(index == history.count - 1 ? Color.white : Color.blue)
            }
            
            Spacer()
            
            // Navigation help text
            Text("ESC: Back")
                .foregroundColor(Color.gray)
        }
        .padding(.horizontal)
    }
    
    private func navigateBack() {
        if let pathBinding = pathBinding {
            pathBinding.wrappedValue.removeLast()
        } else {
            guard !navigationHistory.isEmpty else { return }
            navigationHistory.removeLast()
        }
    }
    
    private func navigateToRoot() {
        if let pathBinding = pathBinding {
            pathBinding.wrappedValue = NavigationPath()
        } else {
            navigationHistory.removeAll()
        }
    }
    
    private func navigateTo(index: Int) {
        if let pathBinding = pathBinding {
            let currentCount = pathBinding.wrappedValue.count
            guard index <= currentCount else { return }
            let itemsToRemove = currentCount - index
            pathBinding.wrappedValue.removeLast(itemsToRemove)
        } else {
            guard index <= navigationHistory.count else { return }
            let itemsToRemove = navigationHistory.count - index
            navigationHistory.removeLast(itemsToRemove)
        }
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