# SwiftTUI Public API Index

This document provides a comprehensive index of all public declarations in SwiftTUI, organized by category for easy reference.

## Core Framework

### Application
- **`Application`** - Main application class for starting SwiftTUI apps
- **`Application.RunLoopType`** - Enum defining different run loop types (dispatch, etc.)

### View Protocol
- **`View`** - Core protocol that all views must conform to
- **`PrimitiveView`** - Protocol for primitive views that don't compose other views

## Property Wrappers & State Management

### Core Property Wrappers
- **`@State<T>`** - Manages local view state
- **`@Binding<T>`** - Creates two-way data bindings
- **`@Environment<T>`** - Accesses environment values
- **`@FocusState<Value>`** - Manages focus state for form controls
- **`@StateObject<T>`** - Manages the lifecycle of observable objects
- **`@ObservedObject<T>`** - Observes changes in observable objects
- **`@Published<Value>`** - Marks properties as observable in PublishableObject

### Observable System
- **`Observable`** - Protocol for objects that can be observed for changes
- **`ObservableObject`** - Base class for observable objects
- **`ObservableProperty<Value>`** - Property wrapper for individual observable properties
- **`PublishableObject`** - Base class supporting @Published properties

### Environment System
- **`EnvironmentKey`** - Protocol for defining environment keys
- **`EnvironmentValues`** - Container for environment values

## Layout & Structure

### Stack Layouts
- **`VStack`** - Vertical stack layout
- **`HStack`** - Horizontal stack layout  
- **`ZStack`** - Depth-based stack layout
- **`Spacer`** - Flexible space in layouts

### Grid Layouts
- **`LazyVGrid`** - Vertical grid layout with lazy loading
- **`LazyHGrid`** - Horizontal grid layout with lazy loading
- **`Grid`** - Simple grid layout
- **`GridItem`** - Defines grid column/row properties
- **`GridRow`** - Helper for grid row content

### Layout Properties
- **`Alignment`** - Defines alignment options
- **`HorizontalAlignment`** - Horizontal alignment options
- **`VerticalAlignment`** - Vertical alignment options
- **`Edges`** - Defines edge sets for padding/borders
- **`Extended`** - Extended layout measurements
- **`Size`** - Size structure for layout

### Responsive Layout
- **`ResponsiveView`** - View that adapts to terminal size
- **`AdaptiveLayout`** - Adaptive layout components
- **`GeometryReader`** - Provides access to layout geometry

## Views & Controls

### Text Display
- **`Text`** - Text display view with rich styling options
- **`Divider`** - Visual separator view

### Form Controls
- **`Button<Label>`** - Interactive button with customizable label
- **`TextField`** - Text input field with binding support
- **`SecureField`** - Secure text input for passwords
- **`Picker<Content>`** - Selection picker with dropdown interface
- **`Stepper`** - Numeric input with increment/decrement controls
- **`Slider`** - Slider control for value selection

### Advanced Text Input
- **`TextEditor`** - Multi-line text editing
- **`FormattedTextField`** - Text field with input formatting
- **`ValidatedTextField`** - Text field with validation
- **`ValidatedSecureField`** - Secure field with validation

### Data Display
- **`List<Data, Content>`** - Scrollable list with selection support
- **`ForEach<Data, Content>`** - Repeating view builder
- **`ScrollView<Content>`** - Scrollable container view
- **`Table<Data>`** - Advanced table with sorting and selection
- **`SimpleTable`** - Basic tabular data display

### Error Handling & User Guidance
- **`ErrorMessage`** - Standardized error display
- **`HelpOverlay`** - Comprehensive help system
- **`GuidedTour`** - Interactive feature introduction
- **`Tooltip`** - Contextual help tooltips
- **`StatusIndicator`** - Application status display

## Input & Interaction

### Input Handling
- **`KeyEquivalent`** - Represents keyboard shortcuts
- **`onKeyPress(_:action:)`** - Handle specific key presses
- **`onTapGesture(action:)`** - Handle tap/enter events

### Form Validation
- **`ValidationResult`** - Result of field validation
- **`FieldValidator`** - Protocol for field validators
- **`Validators`** - Collection of built-in validators:
  - **`Required`** - Required field validation
  - **`MinLength`** - Minimum length validation
  - **`MaxLength`** - Maximum length validation
  - **`Email`** - Email format validation
  - **`Numeric`** - Numeric value validation
  - **`Custom`** - Custom validation logic
- **`CompositeValidator`** - Combines multiple validators
- **`FormValidator`** - Manages form-level validation
- **`ValidatedForm<Content>`** - Form with integrated validation

### Input Formatting
- **`InputFormatter`** - Protocol for input formatters
- **`CurrencyFormatter`** - Currency input formatting
- **`PhoneFormatter`** - Phone number formatting
- **`EmailFormatter`** - Email input formatting
- **`DateFormatter`** - Date input formatting

## Navigation

### Navigation Components
- **`NavigationStack`** - Navigation container with breadcrumbs
- **`NavigationLink`** - Navigation trigger with destination
- **`NavigationPath`** - Programmatic navigation management

## Animation & Visual Effects

### Animation System
- **`Animation`** - Animation configuration
- **`AnimationCurve`** - Animation timing curves (linear, easeIn, easeOut, easeInOut)
- **`withAnimation<Result>`** - Perform animated state changes
- **`interpolate`** - Value interpolation functions

### Animation Components
- **`SimpleSpinner`** - Loading spinner with multiple styles
- **`SimpleProgressBar`** - Progress indicator
- **`AnimatableText`** - Text with animation effects
- **`AnimatableDots`** - Animated dot indicators
- **`TransitionView<Content>`** - View transitions

### Loading States
- **`LoadingSpinner`** - Advanced loading spinner
- **`ProgressBar`** - Advanced progress bar
- **`SkeletonView`** - Placeholder loading state
- **`LoadingIndicator`** - Combined text + spinner

## Styling & Appearance

### Colors
- **`Color`** - Color representation with multiple formats
  - ANSI colors, XTerm colors, TrueColor support
  - Semantic colors (primary, secondary, clear)
  - Opacity support

### Visual Modifiers
- **`foregroundColor(_:)`** - Set text color
- **`background(_:)`** - Set background color
- **`border(_:style:)`** - Add borders with various styles
- **`bold(_:)`** - Bold text styling
- **`italic(_:)`** - Italic text styling
- **`strikethrough(_:)`** - Strikethrough text styling
- **`underline(_:)`** - Underlined text styling
- **`padding(_:)`** - Add padding around views
- **`frame(width:height:alignment:)`** - Set view frame

### Border Styles
- **`BorderStyle`** - Border styling options
- **`DividerStyle`** - Divider line styling

## Accessibility

### Accessibility Support
- **`AccessibilityInfo`** - Accessibility metadata
- **`AccessibilityRole`** - UI element roles for accessibility
- **`KeyboardNavigation`** - Keyboard navigation utilities
- **`AccessibleButton`** - Button with enhanced accessibility
- **`AccessibleTextField`** - Text field with accessibility support

### Accessibility Modifiers
- **`accessibilityLabel(_:)`** - Set accessibility label
- **`accessibilityHint(_:)`** - Set accessibility hint
- **`accessibilityRole(_:)`** - Set accessibility role
- **`accessibilityHidden(_:)`** - Hide from accessibility

## View Lifecycle & Events

### Lifecycle Events
- **`onAppear(_:)`** - Handle view appearance
- **`onDisappear(_:)`** - Handle view disappearance

### View Building
- **`ViewBuilder`** - Result builder for composing views
- **`Group<Content>`** - Transparent view container
- **`EmptyView`** - Empty placeholder view

## Debugging & Development

### Debug Utilities
- **`log(_:terminator:)`** - Debug logging function
- **`logTree()`** - View hierarchy debugging

## Extension Points

### Framework Extensions
- **`View.swift extensions`** - Numerous view modifier extensions
- **`Optional+View.swift`** - Optional view extensions
- Various protocol conformances and utility extensions

---

*This index reflects the comprehensive feature set implemented in SwiftTUI, including advanced state management, navigation, form handling, animations, accessibility, and professional UI components for terminal applications.*