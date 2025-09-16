# SwiftTUI Improvement Wishlist

This document outlines improvements that would make SwiftTUI more compatible with SwiftUI, facilitating easier porting of SwiftUI applications to terminal environments.

## Background

During the implementation of ChoreApp-tui as a terminal UI port of ChoreLib (which uses SwiftUI), several misalignments between SwiftTUI and SwiftUI APIs were encountered. This wishlist aims to bridge those gaps to enable more seamless code sharing and porting between the two frameworks.

## Core API Compatibility Issues

### 1. State Management and Property Wrappers

**Current Gap:**
- SwiftUI: Full support for `@Observable`, `@State`, `@Binding`, `@Environment` with automatic dependency tracking
- SwiftTUI: Limited property wrapper support, manual state management required

**Wishlist:**
- [ ] Full `@Observable` macro support for automatic change tracking
- [ ] Enhanced `@State` with automatic view invalidation
- [ ] `@Environment` with complex object support
- [ ] `@StateObject` and `@ObservedObject` equivalents for MVVM patterns
- [ ] `@Published` property wrapper support

**Impact:** Would allow direct sharing of ViewModel classes and state management logic between SwiftUI and SwiftTUI implementations.

### 2. Navigation and Routing

**Current Gap:**
- SwiftUI: `NavigationStack`, `NavigationLink`, automatic back button handling, programmatic navigation
- SwiftTUI: Manual navigation state management, no built-in navigation stack

**Wishlist:**
- [ ] `NavigationStack` equivalent with automatic keyboard navigation (Tab/Shift+Tab)
- [ ] `NavigationLink` for declarative navigation
- [ ] Built-in breadcrumb support for terminal environments
- [ ] Automatic "Back" action handling (e.g., Escape key)
- [ ] `navigationDestination` modifier support

**Impact:** Would enable the same navigation patterns used in SwiftUI apps, making the Supply → Unit Editor flow more natural.

### 3. Color and Styling

**Current Gap:**
- SwiftUI: Rich color system with `Color.primary`, `Color.secondary`, opacity modifiers, gradients
- SwiftTUI: Limited ANSI color palette, no opacity support

**Wishlist:**
- [x] Color opacity support (`.opacity(0.3)` → appropriate terminal styling) ✅ **COMPLETED**
- [x] `Color.clear` equivalent for transparent backgrounds ✅ **COMPLETED**
- [x] `Color.primary`, `Color.secondary` semantic colors ✅ **COMPLETED**
- [ ] Theme-aware colors that adapt to terminal color schemes
- [ ] Gradient support using character-based patterns

**Impact:** Would allow visual styling code to be shared between SwiftUI and SwiftTUI without modification.

**Recent Progress:**
- ✅ Added `Color.clear` for transparent backgrounds (produces empty escape sequences)
- ✅ Added `Color.primary` and `Color.secondary` semantic colors for better theming
- ✅ Added `.opacity()` modifier with terminal-appropriate rendering (uses dim effect for low opacity)
- ✅ Enhanced all existing color types (ANSI, XTerm, TrueColor) to support opacity
- ✅ Added comprehensive test suite (6 new tests, all passing)
- ✅ Maintained full backward compatibility with existing color usage

### 4. Input Handling and Event System

**Current Gap:**
- SwiftUI: Rich gesture system, `onTapGesture`, `onKeyPress`, automatic focus management
- SwiftTUI: Basic input handling, manual key processing

**Wishlist:**
- [ ] `onKeyPress` modifier with `KeyEquivalent` support
- [ ] `onTapGesture` equivalent (Enter key simulation)
- [ ] Focus management system with `@FocusState`
- [ ] Automatic tab order for form navigation
- [ ] Gesture composition and priority handling

**Impact:** Would enable interactive forms and complex input handling patterns used in SwiftUI apps.

### 5. View Lifecycle and Animation

**Current Gap:**
- SwiftUI: `onAppear`, `onDisappear`, smooth animations, transitions
- SwiftTUI: Limited lifecycle events, no animation support

**Wishlist:**
- [ ] Full `onAppear` and `onDisappear` support without concurrency issues
- [ ] Text-based animation system (e.g., loading spinners, progress bars)
- [ ] View transitions with character-based effects
- [ ] `withAnimation` equivalent for smooth state changes
- [ ] Automatic loading states and skeleton views

**Impact:** Would allow lifecycle-dependent logic and visual feedback to work consistently across both platforms.

## Form and Input Components

### 6. TextField and Form Controls

**Current Gap:**
- SwiftUI: Rich `TextField` with bindings, formatters, validation
- SwiftTUI: Basic text input with action closures

**Wishlist:**
- [x] `TextField` with `@Binding` support instead of action closures ✅ **COMPLETED**
- [ ] Built-in input validation and error display
- [ ] Number formatters and input masking
- [ ] Multiline text editing with proper wrapping
- [ ] Secure text fields for password input
- [ ] Picker and selection controls

**Impact:** Would enable form-heavy applications to share validation and input handling logic.

**Recent Progress:**
- ✅ Added new `TextField("placeholder", text: Binding<String>)` initializer for SwiftUI compatibility
- ✅ Maintains backward compatibility with existing action-based TextField
- ✅ TextField now automatically updates bound state variables as user types
- ✅ Added comprehensive tests for both @Binding and action-based TextField patterns

### 7. List and Table Components

**Current Gap:**
- SwiftUI: `List`, `Table`, automatic selection, search, sorting
- SwiftTUI: Basic iteration with manual layout

**Wishlist:**
- [ ] `List` component with automatic keyboard navigation
- [ ] `Table` with column headers, sorting, and selection
- [ ] Search functionality with filtering
- [ ] Automatic pagination for large datasets
- [ ] Section headers and footers
- [ ] Pull-to-refresh equivalent (keyboard shortcut)

**Impact:** Would make data-heavy applications much easier to port to terminal environments.

## Advanced Features

### 8. Layout System Enhancements

**Current Gap:**
- SwiftUI: Advanced layout with `LazyVGrid`, `LazyHGrid`, automatic sizing
- SwiftTUI: Basic stacks and manual frame management

**Wishlist:**
- [ ] Grid layouts for terminal (ASCII art tables)
- [ ] Automatic content sizing and wrapping
- [ ] Flexible layouts that adapt to terminal size
- [ ] `GeometryReader` equivalent for responsive design
- [ ] Safe area concepts for terminal borders

### 9. Accessibility and Localization

**Current Gap:**
- SwiftUI: Full accessibility support, localization
- SwiftTUI: Basic text display

**Wishlist:**
- [ ] Screen reader compatibility
- [ ] Keyboard-only navigation standards
- [ ] Localization support with `String` catalogs
- [ ] Right-to-left language support
- [ ] High contrast mode for accessibility

### 10. Error Handling and Debugging

**Current Gap:**
- SwiftUI: View debugging, error boundaries, helpful runtime warnings
- SwiftTUI: Basic error messages

**Wishlist:**
- [ ] SwiftUI-style view debugging output
- [ ] Better error messages for layout issues
- [ ] Terminal size compatibility warnings
- [ ] Performance profiling tools
- [ ] View hierarchy inspection

## Architectural Improvements

### 11. Composable Architecture Integration

**Current Gap:**
- The Composable Architecture (TCA) is heavily used in SwiftUI apps but doesn't work with SwiftTUI

**Wishlist:**
- [ ] TCA compatibility layer for SwiftTUI
- [ ] Store-driven architecture support
- [ ] Effect handling in terminal environments
- [ ] Navigation through TCA reducers

**Impact:** Would allow existing TCA-based SwiftUI apps to be ported with minimal changes.

### 12. Testing and Previews

**Current Gap:**
- SwiftUI: Rich preview system, UI testing capabilities
- SwiftTUI: Limited testing support

**Wishlist:**
- [ ] Preview system for rapid terminal UI development
- [ ] Automated UI testing framework
- [ ] Snapshot testing for terminal layouts
- [ ] Interactive testing tools

## Migration and Compatibility

### 13. Code Sharing Utilities

**Wishlist:**
- [ ] Compile-time flags for SwiftUI/SwiftTUI differences
- [ ] Protocol-based abstractions for cross-platform Views
- [ ] Code generation tools for shared components
- [ ] Migration guides and documentation

### 14. Performance and Platform Support

**Wishlist:**
- [ ] Better Linux compatibility
- [ ] Windows terminal support
- [ ] Performance optimizations for large UIs
- [ ] Memory usage improvements

## Conclusion

Implementing these improvements would significantly reduce the friction in porting SwiftUI applications to terminal environments using SwiftTUI. The goal is not to make SwiftTUI identical to SwiftUI, but to provide equivalent functionality that allows developers to share logic, patterns, and even components between the two platforms.

Priority should be given to:
1. State management compatibility (`@Observable`, `@Binding`)
2. Input handling (`onKeyPress`, focus management)
3. Navigation system (stack-based navigation)
4. Form components (`TextField` with bindings)

These improvements would make SwiftTUI a compelling choice for creating terminal-based interfaces that complement existing SwiftUI applications, enabling developers to provide both GUI and TUI versions of their apps with minimal code duplication.