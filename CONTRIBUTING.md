# Contributing to SwiftTUI

Thank you for your interest in contributing to SwiftTUI! This guide will help you understand how to contribute effectively to this comprehensive terminal UI framework.

## Project Overview

SwiftTUI is a professional terminal UI framework that brings SwiftUI's declarative syntax and patterns to command-line applications. Our goal is to provide enterprise-grade terminal UI capabilities while maintaining full SwiftUI API compatibility.

### Key Goals
1. **SwiftUI Compatibility**: Match SwiftUI APIs exactly where possible
2. **Terminal Optimization**: Adapt features appropriately for terminal environments  
3. **Enterprise Ready**: Provide professional-grade components and features
4. **Modern Swift**: Use Swift 6 concurrency and best practices
5. **Comprehensive Testing**: Ensure reliability through thorough testing

## Getting Started

### Prerequisites
- Swift 6.1 or later
- macOS 15+ (primary development platform)
- Linux support (secondary but important)
- Terminal emulator for testing

### Setting Up the Development Environment

1. **Clone the repository**:
   ```bash
   git clone https://github.com/rensbreur/SwiftTUI.git
   cd SwiftTUI
   ```

2. **Build the project**:
   ```bash
   swift build
   ```

3. **Run tests**:
   ```bash
   swift test
   ```

4. **Try the examples**:
   ```bash
   cd Examples/ToDoList
   swift run
   ```

## Development Guidelines

### Code Style and Standards

#### 1. SwiftUI API Compatibility
Always prioritize SwiftUI-compatible APIs:

```swift
// ✅ Good - Matches SwiftUI exactly
TextField("Username", text: $username)
    .focused($focusedField, equals: .username)

// ❌ Avoid - Custom APIs unless necessary
CustomTextField(placeholder: "Username", binding: $username)
```

#### 2. Swift 6 Compliance
Use modern Swift patterns:

```swift
// ✅ Use @Observable for reactive objects
@Observable
class DataModel {
    @ObservableProperty var items: [Item] = []
    @Published var searchText = ""
}

// ✅ Use structured concurrency
@MainActor
func loadData() async throws {
    items = try await dataService.fetchItems()
}
```

#### 3. Terminal-First Design
Consider terminal constraints and capabilities:

```swift
// ✅ Responsive design
ResponsiveView { context in
    if context.isNarrow {
        VStack { /* narrow layout */ }
    } else {
        HStack { /* wide layout */ }
    }
}

// ✅ Keyboard navigation
.onKeyPress(.escape) { 
    // Handle back navigation
    return .handled
}
```

### File Organization

The codebase is organized as follows:

```
Sources/SwiftTUI/
├── Accessibility/          # Accessibility features
├── Animation/              # Animation system
├── Controls/               # Window and focus management
├── Debug/                  # Debug utilities
├── Drawing/                # Terminal rendering
├── Layout/                 # Layout system components
├── Navigation/             # Navigation components
├── PropertyWrappers/       # State management
├── RunLoop/               # Application lifecycle
├── Modifiers/             # View modifiers
├── Views/                 # UI components
│   ├── Controls/          # Form controls and input
│   ├── ErrorHandling/     # Error and guidance systems
│   ├── Layout/            # Layout views
│   └── Structural/        # Basic structural views
└── ViewGraph/             # Core view system
```

### Adding New Features

#### 1. Start with SwiftUI Research
Before implementing a new feature:
- Research the equivalent SwiftUI API
- Understand the expected behavior and edge cases
- Consider how it should adapt to terminal environments

#### 2. Design for Terminal Use
Consider these terminal-specific aspects:
- **Keyboard Navigation**: How will users navigate with keyboard only?
- **Visual Representation**: How will this look in ASCII/Unicode?
- **Size Constraints**: How will this work in small terminals?
- **Accessibility**: How will screen readers interact with this?

#### 3. Implementation Pattern
Follow this pattern for new features:

```swift
// 1. Core component implementation
public struct NewComponent<Content: View>: View {
    // Private properties for state
    private let content: Content
    
    // Public initializer matching SwiftUI
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    // Body implementation
    public var body: some View {
        // Implementation
    }
}

// 2. View extensions for modifiers
public extension View {
    func newModifier() -> some View {
        // Modifier implementation
    }
}

// 3. Comprehensive tests
final class NewComponentTests {
    @Test func testBasicFunctionality() {
        // Test implementation
    }
    
    @Test func testEdgeCases() {
        // Edge case tests
    }
}
```

#### 4. Testing Requirements
Every new feature must include:
- **Unit tests** for core functionality
- **Integration tests** for complex interactions
- **Edge case tests** for error conditions
- **Performance tests** for data-heavy features
- **Accessibility tests** when applicable

### Documentation Standards

#### 1. Public API Documentation
All public APIs must include comprehensive documentation:

```swift
/// A professional data table with sorting, searching, and selection capabilities.
///
/// `Table` provides a SwiftUI-compatible interface for displaying tabular data
/// with advanced features optimized for terminal environments.
///
/// ## Usage
/// ```swift
/// Table(employees, selection: $selectedEmployees) {
///     TableColumn("Name", value: \.name)
///     TableColumn("Department", value: \.department)
/// }
/// ```
///
/// ## Features
/// - Multi-column sorting with visual indicators
/// - Keyboard navigation and selection
/// - Search and filtering capabilities
/// - Responsive design for different terminal sizes
///
/// - Parameters:
///   - data: The data collection to display
///   - selection: Binding to track selected items
///   - content: Column definitions using TableColumnBuilder
public struct Table<Data, Selection>: View where Data: RandomAccessCollection {
    // Implementation
}
```

#### 2. Example Code
Include practical examples in documentation:

```swift
/// ## Basic Table
/// ```swift
/// Table(users) {
///     TableColumn("Name", value: \.name)
///     TableColumn("Email", value: \.email)
/// }
/// ```
///
/// ## Table with Selection
/// ```swift
/// @State private var selectedUsers: Set<User.ID> = []
/// 
/// Table(users, selection: $selectedUsers) {
///     TableColumn("Name", value: \.name)
///     TableColumn("Status") { user in
///         Text(user.status.rawValue)
///             .foregroundColor(user.status.color)
///     }
/// }
/// ```
```

### Testing Guidelines

#### 1. Test Structure
Organize tests by feature area:

```swift
final class TableTests {
    @Test("Basic table creation and display")
    func testBasicTable() {
        // Test basic functionality
    }
    
    @Test("Table with selection binding")
    func testTableSelection() {
        // Test selection behavior
    }
    
    @Test("Table sorting functionality")
    func testTableSorting() {
        // Test sorting behavior
    }
    
    @Test("Empty table handling")
    func testEmptyTable() {
        // Test edge case
    }
}
```

#### 2. Mock Data and Services
Create reusable test data:

```swift
extension User {
    static let sampleData: [User] = [
        User(id: 1, name: "John Doe", email: "john@example.com"),
        User(id: 2, name: "Jane Smith", email: "jane@example.com"),
        // Additional test data
    ]
}
```

#### 3. Integration Testing
Test component interactions:

```swift
@Test("Navigation stack with table selection")
func testNavigationTableIntegration() {
    // Test that table selection triggers navigation correctly
}
```

### Performance Considerations

#### 1. Large Dataset Handling
For components that handle large datasets:
- Use lazy loading where appropriate
- Implement efficient filtering and searching
- Consider pagination for very large sets
- Profile memory usage with substantial data

#### 2. Rendering Optimization
- Minimize terminal screen updates
- Use efficient string building for complex layouts
- Cache formatted content when possible
- Consider terminal size impacts on performance

## Pull Request Process

### 1. Before Submitting
- [ ] Feature branch created from `main`
- [ ] All tests pass (`swift test`)
- [ ] Code builds without warnings (`swift build`)
- [ ] Documentation updated for public APIs
- [ ] Examples added for new features
- [ ] Performance impact considered

### 2. Pull Request Guidelines

#### Title and Description
- Use descriptive titles: "Add Table component with sorting and selection"
- Explain the motivation for the change
- Describe the implementation approach
- List any breaking changes
- Include testing details

#### Code Review Checklist
- [ ] SwiftUI API compatibility maintained
- [ ] Terminal optimization considered
- [ ] Swift 6 concurrency patterns used
- [ ] Comprehensive tests included
- [ ] Documentation complete
- [ ] Examples provided
- [ ] Performance impact acceptable

### 3. Review Process
1. **Automated Checks**: GitHub Actions run tests and builds
2. **Code Review**: Maintainers review for quality and consistency
3. **Testing**: Reviewers test functionality manually
4. **Documentation Review**: Ensure documentation is complete
5. **Final Approval**: Merge when all requirements met

## Feature Request Process

### 1. Research Phase
Before proposing a new feature:
- Check if equivalent SwiftUI API exists
- Review existing issues and discussions
- Consider terminal environment constraints
- Evaluate implementation complexity

### 2. Proposal Template
Use this template for feature requests:

```markdown
## Feature Request: [Component/Feature Name]

### SwiftUI Equivalent
Describe the equivalent SwiftUI API or pattern.

### Terminal Adaptation
Explain how this should work in terminal environments.

### Use Cases
Provide specific examples of when this would be useful.

### Implementation Approach
Suggest how this might be implemented.

### Testing Considerations
Describe what testing would be required.
```

### 3. Discussion and Refinement
- Community discussion on the issue
- Refinement of requirements and API design
- Implementation planning and coordination

## Community Guidelines

### Code of Conduct
- Be respectful and inclusive
- Focus on constructive feedback
- Help newcomers learn the codebase
- Maintain professional communication

### Getting Help
- **Issues**: Report bugs and request features
- **Discussions**: Ask questions and share ideas
- **Documentation**: Check existing docs first
- **Examples**: Look at example projects for patterns

### Recognition
Contributors are recognized through:
- Git commit attribution
- Release notes mentions
- Community recognition
- Maintainer recommendations

## Advanced Contributions

### 1. Performance Optimization
- Profile performance with large datasets
- Optimize terminal rendering efficiency
- Improve memory usage patterns
- Benchmark against baseline performance

### 2. Platform Support
- Test on different terminal emulators
- Ensure Linux compatibility
- Consider Windows terminal support
- Handle platform-specific terminal features

### 3. Accessibility Improvements
- Enhance screen reader support
- Improve keyboard navigation
- Add high contrast support
- Test with accessibility tools

### 4. Documentation and Examples
- Create comprehensive tutorials
- Build real-world example applications
- Improve API documentation
- Create migration guides from other frameworks

## Release Process

### Versioning
SwiftTUI follows semantic versioning:
- **Major**: Breaking API changes
- **Minor**: New features, backward compatible
- **Patch**: Bug fixes, no API changes

### Release Criteria
For each release:
- [ ] All tests passing
- [ ] Documentation updated
- [ ] Examples working
- [ ] Performance regression testing
- [ ] Breaking changes documented
- [ ] Migration guide provided (if needed)

Thank you for contributing to SwiftTUI! Your efforts help make terminal UI development more accessible and powerful for the Swift community.