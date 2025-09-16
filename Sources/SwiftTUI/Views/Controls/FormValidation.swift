import Foundation

/// A form validation system for SwiftTUI that provides input validation and error display
/// Compatible with SwiftUI validation patterns

/// Validation result for form fields
public enum ValidationResult: Equatable {
    case valid
    case invalid(String)
    
    public var isValid: Bool {
        switch self {
        case .valid: return true
        case .invalid: return false
        }
    }
    
    public var errorMessage: String? {
        switch self {
        case .valid: return nil
        case .invalid(let message): return message
        }
    }
}

/// A validator protocol for form fields
public protocol FieldValidator {
    func validate(_ value: String) -> ValidationResult
}

/// Common field validators
public struct Validators {
    
    /// Validates that a field is not empty
    public struct Required: FieldValidator {
        let message: String
        
        public init(message: String = "This field is required") {
            self.message = message
        }
        
        public func validate(_ value: String) -> ValidationResult {
            value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                .invalid(message) : .valid
        }
    }
    
    /// Validates minimum length
    public struct MinLength: FieldValidator {
        let minLength: Int
        let message: String
        
        public init(_ minLength: Int, message: String? = nil) {
            self.minLength = minLength
            self.message = message ?? "Must be at least \(minLength) characters"
        }
        
        public func validate(_ value: String) -> ValidationResult {
            value.count >= minLength ? .valid : .invalid(message)
        }
    }
    
    /// Validates maximum length
    public struct MaxLength: FieldValidator {
        let maxLength: Int
        let message: String
        
        public init(_ maxLength: Int, message: String? = nil) {
            self.maxLength = maxLength
            self.message = message ?? "Must be no more than \(maxLength) characters"
        }
        
        public func validate(_ value: String) -> ValidationResult {
            value.count <= maxLength ? .valid : .invalid(message)
        }
    }
    
    /// Validates email format
    public struct Email: FieldValidator {
        let message: String
        
        public init(message: String = "Please enter a valid email address") {
            self.message = message
        }
        
        public func validate(_ value: String) -> ValidationResult {
            // Simple email validation without NSPredicate
            let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
            let range = value.range(of: emailRegex, options: .regularExpression)
            return range != nil ? .valid : .invalid(message)
        }
    }
    
    /// Validates numeric input
    public struct Numeric: FieldValidator {
        let message: String
        
        public init(message: String = "Please enter a valid number") {
            self.message = message
        }
        
        public func validate(_ value: String) -> ValidationResult {
            Double(value) != nil ? .valid : .invalid(message)
        }
    }
    
    /// Custom validation with closure
    public struct Custom: FieldValidator {
        let validator: (String) -> ValidationResult
        
        public init(_ validator: @escaping (String) -> ValidationResult) {
            self.validator = validator
        }
        
        public func validate(_ value: String) -> ValidationResult {
            validator(value)
        }
    }
}

/// Composite validator that combines multiple validators
public struct CompositeValidator: FieldValidator {
    private let validators: [FieldValidator]
    
    public init(_ validators: FieldValidator...) {
        self.validators = validators
    }
    
    public init(_ validators: [FieldValidator]) {
        self.validators = validators
    }
    
    public func validate(_ value: String) -> ValidationResult {
        for validator in validators {
            let result = validator.validate(value)
            if !result.isValid {
                return result
            }
        }
        return .valid
    }
}

/// A validated text field that shows errors
public struct ValidatedTextField: View {
    private let title: String
    @Binding private var text: String
    @State private var validationResult: ValidationResult = .valid
    private let validator: FieldValidator?
    
    /// Creates a validated text field
    public init(
        _ title: String,
        text: Binding<String>,
        validator: FieldValidator? = nil
    ) {
        self.title = title
        self._text = text
        self.validator = validator
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            TextField(title, text: $text)
                .onAppear {
                    validateInput()
                }
            
            if let errorMessage = validationResult.errorMessage {
                Text("❌ \(errorMessage)")
                    .foregroundColor(.red)
                    .italic()
            }
        }
    }
    
    /// Manually trigger validation (call this when form is submitted)
    public func validate() -> ValidationResult {
        validateInput()
        return validationResult
    }
    
    private func validateInput() {
        guard let validator = validator else {
            validationResult = .valid
            return
        }
        validationResult = validator.validate(text)
    }
}

/// A validated secure field for passwords
public struct ValidatedSecureField: View {
    private let title: String
    @Binding private var text: String
    @State private var validationResult: ValidationResult = .valid
    private let validator: FieldValidator?
    
    /// Creates a validated secure field
    public init(
        _ title: String,
        text: Binding<String>,
        validator: FieldValidator? = nil
    ) {
        self.title = title
        self._text = text
        self.validator = validator
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            SecureField(title, text: $text)
                .onAppear {
                    validateInput()
                }
            
            if let errorMessage = validationResult.errorMessage {
                Text("❌ \(errorMessage)")
                    .foregroundColor(.red)
                    .italic()
            }
        }
    }
    
    /// Manually trigger validation (call this when form is submitted)
    public func validate() -> ValidationResult {
        validateInput()
        return validationResult
    }
    
    private func validateInput() {
        guard let validator = validator else {
            validationResult = .valid
            return
        }
        validationResult = validator.validate(text)
    }
}

/// Form validation state manager
public class FormValidator: ObservableObject {
    @Published public var fields: [String: ValidationResult] = [:]
    @Published public var isValid: Bool = true
    
    public override init() {
        super.init()
    }
    
    /// Registers a field for validation
    public func register(field: String, result: ValidationResult) {
        fields[field] = result
        updateValidState()
    }
    
    /// Validates all registered fields
    public func validateAll() -> Bool {
        updateValidState()
        return isValid
    }
    
    /// Gets errors for display
    public var errors: [String] {
        fields.values.compactMap { result in
            switch result {
            case .valid: return nil
            case .invalid(let message): return message
            }
        }
    }
    
    private func updateValidState() {
        isValid = fields.values.allSatisfy { $0.isValid }
    }
}

/// Extension to add validation to existing TextField
extension View {
    /// Adds a validation button to trigger validation
    public func withValidation(
        using validator: FieldValidator,
        for text: String,
        showError: Binding<String?>
    ) -> some View {
        VStack(alignment: .leading) {
            self
            
            if let error = showError.wrappedValue {
                Text("❌ \(error)")
                    .foregroundColor(.red)
                    .italic()
            }
        }
    }
}

/// Form container that manages validation state
public struct ValidatedForm<Content: View>: View {
    @StateObject private var validator = FormValidator()
    private let content: (FormValidator) -> Content
    
    /// Creates a validated form
    public init(@ViewBuilder content: @escaping (FormValidator) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            content(validator)
            
            // Show form-level errors
            if !validator.errors.isEmpty {
                Divider()
                    .padding(.vertical, 1)
                
                Text("Please fix the following errors:")
                    .bold()
                    .foregroundColor(.red)
                
                ForEach(validator.errors, id: \.self) { error in
                    Text("• \(error)")
                        .foregroundColor(.red)
                }
            }
        }
    }
}