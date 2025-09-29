# SwiftTUI

Swift 6.2+
![platform macos](https://user-images.githubusercontent.com/13484323/184016156-817e14dc-24b5-4b46-a4d4-0de9391a37a4.svg)
![platform linux](https://user-images.githubusercontent.com/13484323/184016263-afa5dd0c-8d9a-4fba-91fe-23e892d64cca.svg)

An innovative, exceptionally simple way to build text-based user interfaces.

SwiftTUI brings SwiftUI to the terminal. It provides a comprehensive, SwiftUI-compatible API for building professional terminal applications with text-based user interfaces. Perfect for CLI tools, data dashboards, system administration interfaces, and any application where a terminal UI is preferred.

![](screenshot.png)

### What is working

SwiftTUI provides enterprise-grade terminal UI capabilities with comprehensive SwiftUI compatibility:

**✓ State Management System**
- Property wrappers: `@State`, `@Binding`, `@Environment`, `@ObservedObject`, `@StateObject`
- `@Observable` protocol with automatic UI updates
- `@Published` properties and reactive data flow
- `@FocusState` for advanced focus management

**✓ Professional Form System**
- `TextField` and `SecureField` with SwiftUI-compatible bindings
- Comprehensive validation system with built-in validators
- Input formatting (currency, phone, email, date)
- `Picker`, `Stepper`, `Slider` controls
- Real-time validation with visual error indicators

**✓ Advanced Layout System**
- Stacks: `VStack`, `HStack`, `ZStack` with `.frame()`, `.padding()`
- Grid layouts: `LazyVGrid`, `LazyHGrid`, `Grid` with flexible sizing
- `GeometryReader` and responsive design components
- Professional border styling and visual effects

**✓ Data Display Components**
- `List` with keyboard navigation and selection
- Advanced `Table` with sorting, filtering, and multi-row selection
- `ScrollView` for large content areas
- `ForEach` and `Group` for structured content

**✓ Navigation System**
- `NavigationStack` with breadcrumb navigation
- `NavigationLink` for declarative navigation
- Automatic keyboard navigation (Escape for back)
- Programmatic navigation with `NavigationPath`

**✓ Animation & Visual Polish**
- `withAnimation` for smooth state changes
- Loading components: `LoadingSpinner`, `ProgressBar`, `SkeletonView`
- Animation curves and interpolation functions
- Text effects and transition animations

**✓ Rich Styling System**
- `Color` with ANSI, xterm and TrueColor support
- Semantic colors (`.primary`, `.secondary`, `.clear`)
- Color opacity and gradients (`LinearGradient`)
- Text styling: bold, italic, underline, strikethrough

**✓ Input & Interaction**
- Comprehensive keyboard handling with `onKeyPress`, `KeyEquivalent`
- `onTapGesture`, `.onAppear()`, `.onDisappear()`
- Focus management with automatic tab order
- Accessibility support with screen reader compatibility

**✓ Enterprise Features**
- Error handling and user guidance systems
- Help overlays and guided tours
- Form validation with professional error display
- Comprehensive debug utilities

**✓ SwiftUI Compatibility**
- Identical APIs for seamless code sharing
- `@ViewBuilder` and view composition patterns
- Structural identity and view diffing like SwiftUI
- Compatible property wrapper behaviors

### Getting started

To use SwiftTUI, add the SwiftTUI package dependency to your Swift package. Import SwiftTUI in your files, and write your views using the same patterns as SwiftUI with full feature support. Then, start the terminal application using one of your views as the root view.

#### Basic Example

This is the simplest SwiftTUI app you can write:

```swift
import SwiftTUI

struct MyTerminalView: View {
  var body: some View {
    Text("Hello, world!")
  }
}

Application(rootView: MyTerminalView()).start()
```

#### Advanced Example with State Management

```swift
import SwiftTUI

struct CounterApp: View {
    @State private var count = 0
    @State private var showHelp = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 1) {
                Text("Counter: \(count)")
                    .bold()
                    .foregroundColor(.blue)
                
                HStack {
                    Button("Decrease") { count -= 1 }
                        .foregroundColor(.red)
                    
                    Button("Increase") { count += 1 }
                        .foregroundColor(.green)
                    
                    Button("Help") { showHelp.toggle() }
                        .foregroundColor(.yellow)
                }
                
                if showHelp {
                    Text("Use the buttons to change the counter value")
                        .foregroundColor(.secondary)
                        .padding()
                        .border(.gray)
                }
            }
            .padding()
        }
    }
}

Application(rootView: CounterApp()).start()
```

#### Professional Form Example

```swift
import SwiftTUI

struct RegistrationForm: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("User Registration")
                .bold()
                .foregroundColor(.blue)
            
            ValidatedTextField("Username", text: $username)
                .with(Validators.Required(), Validators.MinLength(3))
            
            TextField.email("Email", text: $email)
            
            ValidatedSecureField("Password", text: $password)
                .with(Validators.MinLength(8))
            
            Button("Register") {
                // Handle registration
            }
            .foregroundColor(.green)
            .padding(.top, 1)
        }
        .padding()
        .border(.blue)
    }
}
```

#### Installation

Add SwiftTUI as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/rensbreur/SwiftTUI.git", from: "1.0.0")
]
```

To run your app, change to your package's directory and run it from the terminal:

```bash
swift run
```

### Advanced Features & Usage Patterns

#### Enterprise Data Management

SwiftTUI provides professional-grade components for complex data handling:

```swift
// Advanced table with search, sorting, and selection
Table(employees, selection: $selectedEmployees) {
    TableColumn("Name", value: \.name)
    TableColumn("Department", value: \.department)
    TableColumn("Salary") { employee in
        Text(employee.salary, format: .currency(code: "USD"))
    }
}
.searchable(text: $searchText)
.onReceive(searchText.publisher) { newValue in
    filterEmployees(newValue)
}
```

#### Reactive Architecture

Build responsive applications with automatic UI updates:

```swift
@Observable
class AppViewModel {
    @ObservableProperty var isLoading = false
    @ObservableProperty var data: [Item] = []
    @Published var errorMessage: String?
    
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            data = try await dataService.fetchItems()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct DataView: View {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingSpinner.default
                Text("Loading data...")
            } else {
                List(viewModel.data) { item in
                    Text(item.title)
                }
            }
        }
        .onAppear {
            Task { await viewModel.loadData() }
        }
    }
}
```

#### Professional Forms with Validation

Create robust forms with comprehensive validation:

```swift
struct UserForm: View {
    @State private var formData = UserFormData()
    @StateObject private var validator = FormValidator()
    
    var body: some View {
        ValidatedForm { validator in
            VStack(alignment: .leading, spacing: 1) {
                ValidatedTextField("Username", text: $formData.username)
                    .with(
                        Validators.Required("Username is required"),
                        Validators.MinLength(3, message: "Username must be at least 3 characters"),
                        Validators.Custom { username in
                            // Custom validation logic
                            return username.allSatisfy(\.isAlphanumeric) ? 
                                .valid : .invalid("Username must contain only letters and numbers")
                        }
                    )
                
                TextField.currency("Salary", value: $formData.salary)
                TextField.phone("Phone", text: $formData.phone)
                TextField.email("Email", text: $formData.email)
                
                Button("Submit") {
                    if validator.validateAll() {
                        submitForm(formData)
                    }
                }
                .disabled(!validator.isFormValid)
            }
        }
    }
}
```

#### Responsive Design

Build interfaces that adapt to terminal size:

```swift
struct DashboardView: View {
    var body: some View {
        ResponsiveView { context in
            if context.isNarrow {
                // Single column layout for narrow terminals
                VStack(spacing: 1) {
                    MetricsPanel()
                    ChartsPanel()
                    ControlsPanel()
                }
            } else {
                // Multi-column layout for wide terminals
                HStack(spacing: 2) {
                    VStack {
                        MetricsPanel()
                        ControlsPanel()
                    }
                    .frame(width: 30)
                    
                    ChartsPanel()
                }
            }
        }
    }
}
```

#### Animation and Visual Polish

Add smooth transitions and loading states:

```swift
struct AnimatedCounter: View {
    @State private var count = 0
    @State private var isIncreasing = false
    
    var body: some View {
        VStack {
            Text("Count: \(count)")
                .foregroundColor(isIncreasing ? .green : .red)
                .animation(.easeInOut(duration: 0.3), value: isIncreasing)
            
            Button("Increment") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    count += 1
                    isIncreasing = true
                }
                
                // Reset color after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isIncreasing = false
                    }
                }
            }
        }
    }
}
```

### Documentation

You can find comprehensive documentation in multiple formats:

- **[Generated Documentation](https://rensbreur.github.io/SwiftTUI/documentation/swifttui/)** - Complete API reference with examples
- **[Public API Index](PUBLIC_API_INDEX.md)** - Organized index of all public declarations  
- **[SwiftTUI Wishlist](SwiftTUI-Wishlist.md)** - Feature implementation roadmap and detailed status
- **[Follow-up Task Documentation](SwiftTUI-Followup-Task.md)** - Implementation progress and next steps

### Performance & Best Practices

#### Memory Management
- Use `@StateObject` for view model lifecycle management
- Prefer `@ObservedObject` for shared data models
- Use `@State` for simple view-local state

#### Layout Optimization
- Use `LazyVGrid` and `LazyHGrid` for large datasets
- Implement responsive design with `ResponsiveView`
- Cache expensive computations in view models

#### Error Handling
- Implement comprehensive validation with the validation system
- Provide clear error messages and recovery options
- Use loading states for async operations

#### Accessibility
- Add accessibility labels and hints for all interactive elements
- Support keyboard-only navigation
- Provide screen reader compatible descriptions

### Examples

SwiftTUI includes comprehensive example projects demonstrating various features and capabilities.

#### Core Examples

**ToDoList** ([Examples/ToDoList](Examples/ToDoList))

![](Examples/ToDoList/screenshot.png)

A simple to-do list application demonstrating basic SwiftTUI concepts. Use arrow keys to navigate, Enter/Space to complete items, and the text field to add new items. Completed items are automatically removed after half a second.

**Flags** ([Examples/Flags](Examples/Flags))

![](Examples/Flags/screenshot.png)

A flag editor for countries with simple horizontal or vertical flag designs. Demonstrates color selection, layout options, and interactive controls. Select colors to change them and use the options panel to modify flag properties.

**Numbers** ([Examples/Numbers](Examples/Numbers))

A number guessing game showcasing game logic and user interaction in terminal applications.

#### Advanced Feature Demonstrations

**Advanced Table Demo** ([Examples/AdvancedTableDemo](Examples/AdvancedTableDemo))
- Professional data management with search and filtering
- Multi-row selection with visual feedback
- Sorting and column management
- Employee management system example

**Navigation Stack Example** ([Examples/NavigationStackExample.swift](Examples/NavigationStackExample.swift))
- Declarative navigation with `NavigationStack`
- Breadcrumb navigation and automatic back handling
- Deep navigation hierarchies

**Form Validation Example** ([Examples/FormValidationExample.swift](Examples/FormValidationExample.swift))
- Comprehensive form validation system
- Real-time error feedback
- Professional input formatting

**Animation Demo** ([Examples/AnimationDemoExample.swift](Examples/AnimationDemoExample.swift))
- Loading spinners and progress indicators
- Smooth state transitions with `withAnimation`
- Visual effects and text animations

**Grid Layout Example** ([Examples/GridLayoutExample.swift](Examples/GridLayoutExample.swift))
- Flexible grid layouts with `LazyVGrid` and `LazyHGrid`
- Responsive design patterns
- Complex dashboard layouts

**Observable State Example** ([Examples/ObservableStateExample.swift](Examples/ObservableStateExample.swift))
- Reactive state management with `@Observable`
- Automatic UI updates and data binding
- MVVM architecture patterns

**SwiftTUI Showcase** ([Examples/SwiftTUIShowcase.swift](Examples/SwiftTUIShowcase.swift))
- Comprehensive feature demonstration
- Professional UI patterns and components
- Real-world application examples

### Showcase

Are you working on a project that's using SwiftTUI? Get in touch with me if you'd like to have it featured here.

#### soundcld

![](https://github.com/rensbreur/SwiftTUI/assets/13484323/b585708c-3606-495e-a96e-3eba92f39916)

This is a TUI application for SoundCloud. It's not (yet) available publicly.

### More

See a screen recording of SwiftTUI [in action](https://www.reddit.com/r/SwiftUI/comments/wlabyn/im_making_a_version_of_swiftui_for_terminal/) on Reddit.

Learn how [the diffing works](https://rensbr.eu/blog/swiftui-diffing/) on my blog.

### Documentation

You can find generated documentation [here](https://rensbreur.github.io/SwiftTUI/documentation/swifttui/).

### SwiftUI Migration & Compatibility

SwiftTUI is designed for seamless migration from SwiftUI applications. Most SwiftUI patterns work directly:

#### Property Wrappers
```swift
// SwiftUI code works directly in SwiftTUI
@State private var isExpanded = false
@ObservedObject var dataModel: MyDataModel
@Environment(\.colorScheme) var colorScheme
@FocusState private var focusedField: FieldType?
```

#### View Composition
```swift
// Same view composition patterns
VStack {
    Text("Title").bold()
    HStack {
        Button("Cancel") { /* ... */ }
        Button("OK") { /* ... */ }
    }
}
.padding()
.border(.gray)
```

#### Navigation
```swift
// Familiar navigation patterns
NavigationStack {
    List(items) { item in
        NavigationLink(item.title, destination: DetailView(item: item))
    }
}
```

#### Key Differences from SwiftUI
- **Terminal-optimized rendering**: Colors and effects adapted for terminal display
- **Keyboard-first interaction**: Tab navigation, Enter/Space selection, Escape for back
- **ASCII/Unicode styling**: Text effects using terminal capabilities
- **Performance optimizations**: Designed for efficient terminal rendering

### Use Cases

SwiftTUI is perfect for:

#### Developer Tools
- CLI applications with rich interfaces
- Build system dashboards and monitoring
- Database administration tools
- API testing and debugging interfaces

#### System Administration
- Server monitoring dashboards
- Configuration management interfaces
- Log analysis and visualization tools
- System health monitoring applications

#### Data Analysis
- Terminal-based data exploration tools
- Real-time metrics dashboards
- Report generation interfaces
- Interactive data query tools

#### Business Applications
- Customer service interfaces
- Inventory management systems
- Financial analysis tools
- Project management dashboards

### Contributing

SwiftTUI is an open-source project, and contributions are welcome! Our goal is to maintain SwiftUI compatibility while providing excellent terminal-specific features.

#### Development Guidelines
- **SwiftUI Compatibility**: Match SwiftUI APIs exactly where possible
- **Terminal Optimization**: Adapt features appropriately for terminal environments
- **Swift 6 Compliance**: Use modern concurrency patterns and strict concurrency
- **Comprehensive Testing**: Include tests for all new features
- **Documentation**: Document all public APIs with examples

#### Feature Priorities
1. **High Priority**: Core SwiftUI compatibility features
2. **Medium Priority**: Terminal-specific enhancements
3. **Lower Priority**: Advanced features and optimizations

#### Getting Involved
- **Bug Reports**: Please open issues for any bugs or compatibility problems
- **Feature Requests**: Suggest new features via GitHub issues
- **Pull Requests**: Submit PRs following our coding standards
- **Documentation**: Help improve documentation and examples

Features that SwiftUI lacks but that would be useful for terminal applications are welcome, though they should complement rather than replace SwiftUI compatibility.
