# GitHub Copilot Instructions for SwiftTUI Development

## Overview

SwiftTUI is a comprehensive terminal UI framework that brings SwiftUI's declarative syntax and patterns to command-line applications. When working with SwiftTUI, follow these guidelines to write idiomatic, efficient code that leverages the framework's full capabilities.

## Core Development Principles

### 1. SwiftUI Compatibility First
- **Always use SwiftUI-compatible APIs** when available
- Prefer `@State`, `@Binding`, `@ObservedObject` over manual state management
- Use familiar SwiftUI patterns: `VStack`, `HStack`, view modifiers, `@ViewBuilder`
- Write code that could easily be ported between SwiftUI and SwiftTUI

### 2. Modern Swift Patterns
- Use Swift 6 concurrency with `async`/`await` and `@MainActor`
- Leverage `@Observable` protocol for reactive data models
- Prefer structured concurrency over callbacks
- Use `@Published` properties in observable objects

### 3. Terminal-Optimized Design
- Design for keyboard navigation (Tab, arrow keys, Enter, Escape)
- Use appropriate colors that work in terminal environments
- Consider terminal size constraints and responsive design
- Provide meaningful keyboard shortcuts and accessibility hints

## Code Generation Guidelines

### State Management
```swift
// Prefer Observable pattern for view models
@Observable
class UserViewModel {
    @ObservableProperty var users: [User] = []
    @ObservableProperty var isLoading = false
    @Published var errorMessage: String?
    
    @MainActor
    func loadUsers() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            users = try await userService.fetchUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// Use StateObject for view model lifecycle
struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        // View implementation
    }
}
```

### Form Development
```swift
// Always use comprehensive validation
struct UserForm: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @StateObject private var validator = FormValidator()
    
    var body: some View {
        ValidatedForm { validator in
            VStack(alignment: .leading, spacing: 1) {
                ValidatedTextField("Username", text: $username)
                    .with(
                        Validators.Required(),
                        Validators.MinLength(3)
                    )
                
                TextField.email("Email", text: $email)
                
                ValidatedSecureField("Password", text: $password)
                    .with(Validators.MinLength(8))
                
                Button("Submit") {
                    if validator.validateAll() {
                        submit()
                    }
                }
                .disabled(!validator.isFormValid)
            }
        }
    }
}
```

### Navigation Patterns
```swift
// Use NavigationStack for complex navigation
struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 1) {
                NavigationLink("Users", destination: UserListView())
                NavigationLink("Settings", destination: SettingsView())
                NavigationLink("Reports", destination: ReportsView())
            }
            .padding()
        }
    }
}
```

### Data Display
```swift
// Use Table for complex data with search and selection
struct DataView: View {
    @State private var data: [Item] = []
    @State private var selectedItems: Set<Item.ID> = []
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            TextField("Search...", text: $searchText)
            
            Table(filteredData, selection: $selectedItems) {
                TableColumn("Name", value: \.name)
                TableColumn("Category", value: \.category)
                TableColumn("Status") { item in
                    Text(item.status.rawValue)
                        .foregroundColor(item.status.color)
                }
            }
            
            Text("\(selectedItems.count) selected")
                .foregroundColor(.secondary)
        }
    }
    
    var filteredData: [Item] {
        searchText.isEmpty ? data : 
            data.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
}
```

### Animation and Visual Polish
```swift
// Use withAnimation for smooth state changes
struct AnimatedCounter: View {
    @State private var count = 0
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                LoadingSpinner.default
                Text("Processing...")
            } else {
                Text("Count: \(count)")
                    .foregroundColor(count > 0 ? .green : .red)
                    .animation(.easeInOut(duration: 0.3), value: count)
            }
            
            Button("Increment") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    count += 1
                }
            }
        }
    }
}
```

## Common Patterns to Suggest

### 1. Responsive Design
```swift
ResponsiveView { context in
    if context.isNarrow {
        VStack { /* narrow layout */ }
    } else {
        HStack { /* wide layout */ }
    }
}
```

### 2. Error Handling
```swift
// Always provide user-friendly error handling
@State private var errorMessage: String?

// In view body:
if let errorMessage = errorMessage {
    ErrorMessage(errorMessage)
        .foregroundColor(.red)
        .padding()
}
```

### 3. Focus Management
```swift
@FocusState private var focusedField: FieldType?

TextField("Username", text: $username)
    .focused($focusedField, equals: .username)

SecureField("Password", text: $password)
    .focused($focusedField, equals: .password)
```

### 4. Grid Layouts
```swift
LazyVGrid(columns: [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
], spacing: 1) {
    ForEach(items) { item in
        ItemView(item: item)
    }
}
```

## Code Quality Standards

### Performance
- Use `LazyVGrid`/`LazyHGrid` for large datasets
- Implement proper data filtering and pagination
- Cache expensive computations in view models
- Use `@StateObject` for view model lifecycle management

### Accessibility
- Add accessibility labels: `.accessibilityLabel("Submit form")`
- Provide keyboard navigation hints
- Support screen reader compatibility
- Use semantic colors (`.primary`, `.secondary`)

### Error Handling
- Always validate user input
- Provide clear error messages
- Implement proper loading states
- Handle async operations safely

### Testing
- Write testable view models with dependency injection
- Test validation logic comprehensively
- Verify accessibility features
- Test responsive design at different sizes

## Anti-Patterns to Avoid

### Don't
```swift
// Don't use manual state management when @State is available
var count = 0 // ❌

// Don't ignore validation
TextField("Email", text: $email) // ❌ No validation

// Don't hardcode layouts
HStack { /* fixed layout */ } // ❌ Not responsive

// Don't use callbacks when async/await is available
loadData { result in /* ... */ } // ❌ Use async/await
```

### Do
```swift
// Use proper state management
@State private var count = 0 // ✅

// Always validate input
TextField.email("Email", text: $email) // ✅ Built-in validation

// Use responsive design
ResponsiveView { context in /* ... */ } // ✅ Adapts to size

// Use modern concurrency
Task { await loadData() } // ✅ Modern async pattern
```

## Framework-Specific Features

### Input Formatting
- Use `TextField.currency()`, `TextField.phone()`, `TextField.email()` for formatted input
- Implement comprehensive validation with `ValidatedTextField`
- Use `FormValidator` for form-level validation management

### Visual Effects
- Use `Color.primary`, `Color.secondary` for semantic colors
- Apply `.opacity()` for visual hierarchy
- Use `LoadingSpinner`, `ProgressBar` for async operations
- Apply animations with `withAnimation()` and `.animation()` modifier

### Navigation
- Use `NavigationStack` for complex navigation hierarchies
- Implement breadcrumb navigation automatically
- Handle back navigation with Escape key
- Use `NavigationLink` for declarative navigation

### Data Management
- Use `Table` component for sortable, searchable data
- Implement multi-selection with `Set<ID>` bindings
- Use `List` for simple data display with keyboard navigation
- Apply search functionality with `searchable()` modifier

## Integration Patterns

### MVVM Architecture
```swift
@Observable
class FeatureViewModel {
    @ObservableProperty var state: FeatureState = .idle
    @Published var errorMessage: String?
    
    @MainActor
    func performAction() async {
        state = .loading
        
        do {
            let result = try await service.performAction()
            state = .success(result)
        } catch {
            state = .error
            errorMessage = error.localizedDescription
        }
    }
}
```

### Dependency Injection
```swift
struct FeatureView: View {
    @StateObject private var viewModel: FeatureViewModel
    
    init(service: FeatureService = .shared) {
        self._viewModel = StateObject(wrappedValue: FeatureViewModel(service: service))
    }
}
```

This guidance will help you write idiomatic SwiftTUI code that leverages the framework's comprehensive feature set while maintaining SwiftUI compatibility and terminal-optimized design patterns.