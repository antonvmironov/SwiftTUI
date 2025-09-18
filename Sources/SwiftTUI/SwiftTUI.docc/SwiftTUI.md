# ``SwiftTUI``

SwiftUI for terminal applications - Professional terminal UI development with SwiftUI compatibility.

## Overview

SwiftTUI brings the power and familiarity of SwiftUI to terminal applications. Build professional command-line interfaces, developer tools, system administration dashboards, and data analysis applications using the same declarative syntax and patterns you know from SwiftUI.

SwiftTUI provides enterprise-grade features including comprehensive state management, advanced form validation, data tables with search and sorting, responsive layouts, animation system, and full accessibility support - all optimized for terminal environments.

## Key Features

**🎯 SwiftUI Compatibility**: Identical APIs for seamless migration from SwiftUI applications

**📱 Comprehensive UI Components**: Professional forms, tables, navigation, and data display

**⚡ Advanced State Management**: Reactive architecture with `@Observable`, `@Published`, and automatic UI updates

**🎨 Rich Visual System**: Colors, animations, gradients, and styling adapted for terminals

**♿ Accessibility First**: Screen reader support, keyboard navigation, and inclusive design

**🏗️ Enterprise Ready**: Validation, error handling, responsive design, and performance optimization

## Documentation

This generated documentation serves as the complete API reference for SwiftTUI. For getting started and comprehensive examples, also check out:

- `README.md` - Project overview, installation, and quick start guide
- `PUBLIC_API_INDEX.md` - Organized index of all public declarations
- `SwiftTUI-Wishlist.md` - Feature roadmap and implementation status
- Example projects in the `Examples/` directory

## Getting started

Create an executable Swift package and add SwiftTUI as a dependency. Import SwiftTUI in your files, and write your views using familiar SwiftUI patterns with full feature support.

### Basic Application

```swift
import SwiftTUI

struct MyTerminalView: View {
    @State private var message = "Hello, SwiftTUI!"
    
    var body: some View {
        VStack(spacing: 1) {
            Text(message)
                .bold()
                .foregroundColor(.blue)
            
            Button("Change Message") {
                message = "SwiftTUI is awesome!"
            }
            .foregroundColor(.green)
        }
        .padding()
        .border(.gray)
    }
}
```

Add the following to `main.swift` to start the terminal application:

```swift
Application(rootView: MyTerminalView()).start()
```

### Professional Form with Validation

```swift
import SwiftTUI

struct RegistrationForm: View {
    @State private var formData = RegistrationData()
    @StateObject private var validator = FormValidator()
    
    var body: some View {
        ValidatedForm { validator in
            VStack(alignment: .leading, spacing: 1) {
                Text("User Registration")
                    .bold()
                    .foregroundColor(.blue)
                    .padding(.bottom, 1)
                
                ValidatedTextField("Username", text: $formData.username)
                    .with(
                        Validators.Required(),
                        Validators.MinLength(3)
                    )
                
                TextField.email("Email Address", text: $formData.email)
                
                ValidatedSecureField("Password", text: $formData.password)
                    .with(Validators.MinLength(8))
                
                TextField.phone("Phone Number", text: $formData.phone)
                
                Button("Register") {
                    if validator.validateAll() {
                        register(formData)
                    }
                }
                .foregroundColor(.green)
                .disabled(!validator.isFormValid)
            }
            .padding()
            .border(.blue)
        }
    }
}
```

To run your app, open Terminal, change to your package's directory and run:

```bash
swift run
```

## Topics

### Application & Core

- ``Application``

### View System

- ``View``
- ``ViewBuilder``
- ``Group``
- ``ForEach``
- ``EmptyView``

### State Management

#### Property Wrappers
- ``State``
- ``Binding``
- ``Environment``
- ``FocusState``
- ``StateObject``
- ``ObservedObject``

#### Environment System
- ``EnvironmentKey``
- ``EnvironmentValues``
- ``View/environment(_:_:)``

### Layout System

#### Stack Layouts
- ``VStack``
- ``HStack``
- ``ZStack``
- ``Spacer``

#### Layout Properties & Modifiers
- ``Alignment``
- ``HorizontalAlignment``
- ``VerticalAlignment``
- ``Edges``
- ``Extended``
- ``Size``
- ``View/frame(width:height:alignment:)``
- ``View/frame(minWidth:maxWidth:minHeight:maxHeight:alignment:)``
- ``View/padding(_:)``
- ``View/padding(_:_:)``
- ``GeometryReader``

### Views & Controls

#### Text & Display
- ``Text``
- ``Divider``

#### Form Controls
- ``Button``
- ``TextField``
- ``SecureField``

#### Data Display
- ``List``
- ``ScrollView``

### Styling & Appearance

#### Colors & Visual Effects
- ``Color``
- ``View/foregroundColor(_:)``
- ``View/background(_:)``
- ``View/border(_:style:)``
- ``BorderStyle``
- ``DividerStyle``

#### Text Styling
- ``View/bold(_:)``
- ``View/italic(_:)``
- ``View/strikethrough(_:)``
- ``View/underline(_:)``

### Input & Interaction

#### View Lifecycle
- ``View/onAppear(_:)``

#### Environment Configuration
- ``EnvironmentValues/placeholderColor``

### Debugging

- ``log(_:terminator:)``

### Advanced Features

*Note: Many additional features including advanced form validation, table components, navigation system, animation support, grid layouts, accessibility features, and professional input formatting are available. See the complete API reference and examples for detailed information on these enterprise-grade capabilities.*
