# Claude AI Instructions for SwiftTUI Development

## Context & Framework Overview

SwiftTUI is an enterprise-grade terminal UI framework that provides SwiftUI-compatible APIs for building professional command-line applications. It offers comprehensive state management, advanced form validation, data visualization, navigation systems, animations, and accessibility features - all optimized for terminal environments.

**Key Characteristics:**
- **SwiftUI API Compatibility**: Nearly identical APIs to enable seamless code sharing
- **Terminal Optimization**: Keyboard-first interaction, ASCII/Unicode rendering, terminal-aware colors
- **Enterprise Features**: Professional forms, tables, validation, responsive design, error handling
- **Modern Swift**: Swift 6 compliance, structured concurrency, `@Observable` protocol
- **Comprehensive**: 100+ public APIs covering all aspects of terminal UI development

## Development Philosophy & Guidelines

### 1. SwiftUI Compatibility Priority
Always prioritize SwiftUI-compatible patterns and APIs. Code should be portable between SwiftUI and SwiftTUI with minimal changes.

**Preferred Patterns:**
```swift
// ✅ SwiftUI-compatible state management
@State private var isExpanded = false
@ObservedObject var dataModel: DataModel
@Environment(\.colorScheme) var colorScheme

// ✅ Familiar view composition
VStack(alignment: .leading, spacing: 1) {
    Text("Title").bold()
    Button("Action") { performAction() }
}
.padding()
.border(.gray)
```

### 2. Terminal-First Design Thinking
Design interactions and layouts specifically for terminal environments:

**Terminal-Optimized Interactions:**
- Keyboard navigation (Tab, Shift+Tab, Arrow keys)
- Enter/Space for selection, Escape for back/cancel
- Meaningful keyboard shortcuts for power users
- Screen reader and accessibility compatibility

**Visual Design Considerations:**
- Use terminal-appropriate colors (respect color schemes)
- Design for variable terminal sizes (responsive layouts)
- Leverage ASCII/Unicode characters for visual elements
- Provide loading indicators for async operations

### 3. Modern Swift & Concurrency
Embrace Swift 6 features and structured concurrency patterns:

```swift
@Observable
class AppViewModel {
    @ObservableProperty var data: [Item] = []
    @ObservableProperty var isLoading = false
    @Published var errorMessage: String?
    
    @MainActor
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
```

## Comprehensive Feature Set Guidance

### State Management Architecture

SwiftTUI provides multiple layers of state management for different use cases:

#### 1. View-Local State
```swift
struct CounterView: View {
    @State private var count = 0
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Text("Count: \(count)")
                .foregroundColor(count > 0 ? .green : .red)
                .animation(.easeInOut(duration: 0.3), value: count)
            
            Button("Increment") {
                withAnimation(.spring()) {
                    count += 1
                    isAnimating = true
                }
            }
        }
    }
}
```

#### 2. Observable Data Models
```swift
@Observable
class UserManager {
    @ObservableProperty var users: [User] = []
    @ObservableProperty var isLoading = false
    @ObservableProperty var selectedUser: User?
    @Published var searchText = ""
    
    var filteredUsers: [User] {
        searchText.isEmpty ? users : 
            users.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    @MainActor
    func loadUsers() async throws {
        isLoading = true
        defer { isLoading = false }
        
        users = try await userService.fetchUsers()
    }
}
```

#### 3. Focus Management
```swift
enum FormField: Hashable {
    case username, email, password
}

struct LoginForm: View {
    @State private var credentials = LoginCredentials()
    @FocusState private var focusedField: FormField?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            TextField("Username", text: $credentials.username)
                .focused($focusedField, equals: .username)
            
            TextField("Email", text: $credentials.email)
                .focused($focusedField, equals: .email)
            
            SecureField("Password", text: $credentials.password)
                .focused($focusedField, equals: .password)
        }
        .onSubmit {
            // Handle tab navigation between fields
            switch focusedField {
            case .username:
                focusedField = .email
            case .email:
                focusedField = .password
            default:
                submitForm()
            }
        }
    }
}
```

### Professional Form Development

SwiftTUI excels at creating enterprise-grade forms with comprehensive validation:

#### 1. Comprehensive Validation System
```swift
struct RegistrationForm: View {
    @State private var formData = RegistrationData()
    @StateObject private var validator = FormValidator()
    @State private var isSubmitting = false
    
    var body: some View {
        ValidatedForm { validator in
            VStack(alignment: .leading, spacing: 1) {
                Group {
                    // Username with multiple validators
                    ValidatedTextField("Username", text: $formData.username)
                        .with(
                            Validators.Required("Username is required"),
                            Validators.MinLength(3, message: "At least 3 characters"),
                            Validators.Custom { username in
                                username.allSatisfy(\.isAlphanumeric) ?
                                    .valid : .invalid("Letters and numbers only")
                            }
                        )
                    
                    // Formatted input fields
                    TextField.email("Email Address", text: $formData.email)
                    TextField.phone("Phone Number", text: $formData.phone)
                    TextField.currency("Salary", value: $formData.salary)
                    
                    // Secure fields with validation
                    ValidatedSecureField("Password", text: $formData.password)
                        .with(
                            Validators.MinLength(8),
                            Validators.Custom { password in
                                let hasUppercase = password.contains { $0.isUppercase }
                                let hasNumber = password.contains { $0.isNumber }
                                return (hasUppercase && hasNumber) ?
                                    .valid : .invalid("Must contain uppercase and number")
                            }
                        )
                    
                    ValidatedSecureField("Confirm Password", text: $formData.confirmPassword)
                        .with(
                            Validators.Custom { [formData] confirmPassword in
                                confirmPassword == formData.password ?
                                    .valid : .invalid("Passwords must match")
                            }
                        )
                }
                
                // Form controls
                HStack {
                    Button("Cancel") {
                        resetForm()
                    }
                    .foregroundColor(.red)
                    
                    Spacer()
                    
                    if isSubmitting {
                        LoadingSpinner.default
                        Text("Submitting...")
                    } else {
                        Button("Register") {
                            Task { await submitForm() }
                        }
                        .foregroundColor(.green)
                        .disabled(!validator.isFormValid)
                    }
                }
                .padding(.top, 1)
                
                // Error summary
                if !validator.errors.isEmpty {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Please fix the following errors:")
                            .foregroundColor(.red)
                            .bold()
                        
                        ForEach(validator.errors, id: \.self) { error in
                            Text("• \(error)")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.top, 1)
                }
            }
            .padding()
            .border(.blue)
        }
    }
    
    @MainActor
    private func submitForm() async {
        guard validator.validateAll() else { return }
        
        isSubmitting = true
        defer { isSubmitting = false }
        
        do {
            try await userService.register(formData)
            // Handle success
        } catch {
            // Handle error
        }
    }
}
```

#### 2. Advanced Form Controls
```swift
struct PreferencesForm: View {
    @State private var settings = UserSettings()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Picker with multiple selection styles
            Picker("Theme", selection: $settings.theme) {
                ForEach(Theme.allCases, id: \.self) { theme in
                    Text(theme.displayName).tag(theme)
                }
            }
            
            // Stepper for numeric input
            Stepper("Refresh Interval: \(settings.refreshInterval)s", 
                   value: $settings.refreshInterval, 
                   in: 5...300, 
                   step: 5)
            
            // Slider for percentage values
            VStack(alignment: .leading) {
                Text("Opacity: \(Int(settings.opacity * 100))%")
                Slider(value: $settings.opacity, in: 0...1, step: 0.1)
            }
            
            // Toggle alternatives using buttons
            HStack {
                Text("Enable Notifications:")
                Button(settings.notificationsEnabled ? "✓ On" : "✗ Off") {
                    settings.notificationsEnabled.toggle()
                }
                .foregroundColor(settings.notificationsEnabled ? .green : .red)
            }
        }
        .padding()
    }
}
```

### Advanced Data Management

#### 1. Professional Tables with Search and Selection
```swift
struct EmployeeManagementView: View {
    @StateObject private var viewModel = EmployeeViewModel()
    @State private var selectedEmployees: Set<Employee.ID> = []
    @State private var searchText = ""
    @State private var sortOrder = [SortDescriptor(\Employee.name)]
    
    var body: some View {
        VStack(spacing: 1) {
            // Search and filter controls
            HStack {
                TextField("Search employees...", text: $searchText)
                    .frame(minWidth: 30)
                
                Picker("Department", selection: $viewModel.selectedDepartment) {
                    Text("All").tag(nil as Department?)
                    ForEach(Department.allCases, id: \.self) { dept in
                        Text(dept.name).tag(dept as Department?)
                    }
                }
                .frame(width: 20)
            }
            .padding(.bottom, 1)
            
            // Professional data table
            Table(viewModel.filteredEmployees, 
                  selection: $selectedEmployees,
                  sortOrder: $sortOrder) {
                
                TableColumn("Name", value: \.name) { employee in
                    HStack {
                        Text(employee.name)
                        if employee.isManager {
                            Text("👑").foregroundColor(.yellow)
                        }
                    }
                }
                
                TableColumn("Department", value: \.department.name)
                
                TableColumn("Salary") { employee in
                    Text(employee.salary, format: .currency(code: "USD"))
                        .foregroundColor(employee.salary > 100000 ? .green : .primary)
                }
                
                TableColumn("Status") { employee in
                    Text(employee.status.rawValue)
                        .foregroundColor(employee.status.color)
                }
                
                TableColumn("Actions") { employee in
                    HStack {
                        Button("Edit") { editEmployee(employee) }
                            .foregroundColor(.blue)
                        Button("Delete") { deleteEmployee(employee) }
                            .foregroundColor(.red)
                    }
                }
            }
            .onChange(of: sortOrder) { _, newOrder in
                viewModel.applySortOrder(newOrder)
            }
            
            // Status bar with selection info
            HStack {
                Text("Showing \(viewModel.filteredEmployees.count) of \(viewModel.allEmployees.count) employees")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if !selectedEmployees.isEmpty {
                    Text("\(selectedEmployees.count) selected")
                        .foregroundColor(.blue)
                    
                    Button("Bulk Actions") {
                        showBulkActions = true
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding(.top, 1)
        }
        .padding()
        .onAppear {
            Task { await viewModel.loadEmployees() }
        }
    }
}
```

#### 2. Grid Layouts for Dashboards
```swift
struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        ResponsiveView { context in
            ScrollView {
                if context.isNarrow {
                    // Single column for narrow terminals
                    VStack(spacing: 2) {
                        ForEach(viewModel.widgets) { widget in
                            WidgetView(widget: widget)
                        }
                    }
                } else {
                    // Grid layout for wider terminals
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 2) {
                        ForEach(viewModel.widgets) { widget in
                            WidgetView(widget: widget)
                                .frame(minHeight: 8)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            Task { await viewModel.loadDashboardData() }
        }
        .refreshable {
            await viewModel.refreshData()
        }
    }
}

struct WidgetView: View {
    let widget: DashboardWidget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack {
                Text(widget.title)
                    .bold()
                    .foregroundColor(.blue)
                
                Spacer()
                
                if widget.isLoading {
                    LoadingSpinner.dots()
                } else {
                    Text(widget.lastUpdated, style: .relative)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            
            switch widget.type {
            case .metric:
                MetricWidgetContent(data: widget.data)
            case .chart:
                ChartWidgetContent(data: widget.data)
            case .list:
                ListWidgetContent(data: widget.data)
            }
        }
        .padding()
        .border(.gray)
        .background(Color.clear)
    }
}
```

### Navigation and App Architecture

#### 1. Comprehensive Navigation System
```swift
struct MainApplication: View {
    @State private var navigationPath = NavigationPath()
    @StateObject private var appState = AppState()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            MainMenuView()
                .navigationDestination(for: NavigationDestination.self) { destination in
                    destinationView(for: destination)
                }
        }
        .environment(\.navigationPath, $navigationPath)
        .environmentObject(appState)
        .onKeyPress(.escape) {
            // Handle global back navigation
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
                return .handled
            }
            return .ignored
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: NavigationDestination) -> some View {
        switch destination {
        case .userManagement:
            UserManagementView()
        case .settings:
            SettingsView()
        case .reports:
            ReportsView()
        case .userDetail(let userID):
            UserDetailView(userID: userID)
        }
    }
}

struct MainMenuView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.navigationPath) private var navigationPath
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Main Menu")
                .bold()
                .foregroundColor(.blue)
                .padding(.bottom, 1)
            
            NavigationLink("👥 User Management", 
                          destination: NavigationDestination.userManagement)
            
            NavigationLink("⚙️ Settings", 
                          destination: NavigationDestination.settings)
            
            NavigationLink("📊 Reports", 
                          destination: NavigationDestination.reports)
            
            Divider()
                .padding(.vertical, 1)
            
            // Quick actions
            Button("🔄 Refresh Data") {
                Task { await appState.refreshAllData() }
            }
            .foregroundColor(.green)
            
            Button("❓ Help") {
                showHelp = true
            }
            .foregroundColor(.blue)
            
            Button("🚪 Exit") {
                exit(0)
            }
            .foregroundColor(.red)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
```

### Animation and Visual Polish

#### 1. Loading States and Transitions
```swift
struct LoadingStateExample: View {
    @State private var loadingState: LoadingState = .idle
    @State private var data: [Item] = []
    
    var body: some View {
        VStack {
            switch loadingState {
            case .idle:
                Button("Load Data") {
                    Task { await loadData() }
                }
                .foregroundColor(.blue)
                
            case .loading:
                VStack {
                    LoadingSpinner.default
                    Text("Loading data...")
                        .foregroundColor(.secondary)
                    
                    ProgressBar(value: 0.3) // Simulated progress
                        .frame(width: 40)
                }
                
            case .success:
                VStack(alignment: .leading) {
                    Text("✅ Data loaded successfully")
                        .foregroundColor(.green)
                        .bold()
                    
                    List(data) { item in
                        Text(item.name)
                    }
                }
                .transition(.slide)
                
            case .error(let message):
                VStack {
                    Text("❌ Error: \(message)")
                        .foregroundColor(.red)
                        .bold()
                    
                    Button("Retry") {
                        Task { await loadData() }
                    }
                    .foregroundColor(.blue)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: loadingState)
    }
    
    @MainActor
    private func loadData() async {
        withAnimation {
            loadingState = .loading
        }
        
        do {
            // Simulate network delay
            try await Task.sleep(for: .seconds(2))
            data = try await dataService.fetchItems()
            
            withAnimation {
                loadingState = .success
            }
        } catch {
            withAnimation {
                loadingState = .error(error.localizedDescription)
            }
        }
    }
}

enum LoadingState: Equatable {
    case idle, loading, success
    case error(String)
}
```

### Error Handling and User Experience

#### 1. Comprehensive Error Management
```swift
struct ErrorHandlingExample: View {
    @StateObject private var errorHandler = ErrorHandler()
    @State private var showErrorDetails = false
    
    var body: some View {
        VStack {
            // Main content
            ContentView()
            
            // Error display overlay
            if let currentError = errorHandler.currentError {
                ErrorOverlay(
                    error: currentError,
                    onDismiss: { errorHandler.clearError() },
                    onShowDetails: { showErrorDetails = true }
                )
                .transition(.move(edge: .bottom))
            }
        }
        .sheet(isPresented: $showErrorDetails) {
            if let error = errorHandler.currentError {
                ErrorDetailView(error: error)
            }
        }
        .environmentObject(errorHandler)
    }
}

struct ErrorOverlay: View {
    let error: AppError
    let onDismiss: () -> Void
    let onShowDetails: () -> Void
    
    var body: some View {
        HStack {
            Text(error.icon)
                .foregroundColor(error.severity.color)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(error.title)
                    .bold()
                    .foregroundColor(error.severity.color)
                
                Text(error.message)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            HStack {
                if error.isRecoverable {
                    Button("Details") { onShowDetails() }
                        .foregroundColor(.blue)
                }
                
                Button("✕") { onDismiss() }
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.clear)
        .border(error.severity.color)
    }
}
```

## Best Practices for SwiftTUI Development

### 1. Performance Optimization
- Use `LazyVGrid` and `LazyHGrid` for large datasets
- Implement proper data pagination for tables
- Cache expensive computations in view models
- Use `@StateObject` for proper view model lifecycle

### 2. Accessibility and Usability
- Always provide keyboard navigation hints
- Use semantic colors for better contrast
- Add accessibility labels for all interactive elements
- Test with different terminal sizes

### 3. Error Handling
- Provide meaningful error messages
- Implement proper recovery mechanisms
- Use loading states for async operations
- Validate all user input comprehensively

### 4. Code Organization
- Separate view models from views
- Use dependency injection for testability
- Group related functionality in extensions
- Follow SwiftUI naming conventions

### 5. Testing Strategy
- Test view models independently
- Verify validation logic thoroughly
- Test responsive design at different sizes
- Ensure accessibility features work correctly

This comprehensive guide will help you leverage SwiftTUI's full potential while maintaining SwiftUI compatibility and delivering professional terminal applications.