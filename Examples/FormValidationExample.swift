import SwiftTUI

/// Example demonstrating Form Validation functionality in SwiftTUI
/// Shows various validators, error display, and form submission
struct FormValidationExample: View {
    
    @State private var currentDemo = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Header and demo selector
            HStack {
                Text("📝 Form Validation Demo")
                    .bold()
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button("Next Demo (\(currentDemo + 1)/4)") {
                    currentDemo = (currentDemo + 1) % 4
                }
                .foregroundColor(.green)
            }
            .padding(.bottom)
            
            // Demo content
            Group {
                switch currentDemo {
                case 0:
                    registrationFormDemo
                case 1:
                    loginFormDemo
                case 2:
                    validatorShowcaseDemo
                case 3:
                    complexValidationDemo
                default:
                    registrationFormDemo
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var registrationFormDemo: some View {
        RegistrationFormDemo()
    }
    
    @ViewBuilder
    private var loginFormDemo: some View {
        LoginFormDemo()
    }
    
    @ViewBuilder
    private var validatorShowcaseDemo: some View {
        ValidatorShowcaseDemo()
    }
    
    @ViewBuilder
    private var complexValidationDemo: some View {
        ComplexValidationDemo()
    }
}

/// Registration form with comprehensive validation
struct RegistrationFormDemo: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var age = ""
    @State private var submitted = false
    
    private var nameValidator: FieldValidator {
        CompositeValidator(
            Validators.Required(message: "Name is required"),
            Validators.MinLength(2, message: "Name must be at least 2 characters")
        )
    }
    
    private var emailValidator: FieldValidator {
        CompositeValidator(
            Validators.Required(message: "Email is required"),
            Validators.Email(message: "Please enter a valid email address")
        )
    }
    
    private var passwordValidator: FieldValidator {
        CompositeValidator(
            Validators.Required(message: "Password is required"),
            Validators.MinLength(8, message: "Password must be at least 8 characters"),
            Validators.Custom { password in
                let hasUpper = password.rangeOfCharacter(from: .uppercaseLetters) != nil
                let hasLower = password.rangeOfCharacter(from: .lowercaseLetters) != nil
                let hasDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
                
                if hasUpper && hasLower && hasDigit {
                    return .valid
                } else {
                    return .invalid("Password must contain uppercase, lowercase, and a digit")
                }
            }
        )
    }
    
    private var confirmPasswordValidator: FieldValidator {
        Validators.Custom { confirmPassword in
            confirmPassword == password ? .valid : .invalid("Passwords do not match")
        }
    }
    
    private var ageValidator: FieldValidator {
        CompositeValidator(
            Validators.Required(message: "Age is required"),
            Validators.Numeric(message: "Age must be a number"),
            Validators.Custom { value in
                if let age = Int(value), age >= 18, age <= 120 {
                    return .valid
                } else {
                    return .invalid("Age must be between 18 and 120")
                }
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("👤 User Registration")
                .bold()
                .foregroundColor(.purple)
                .padding(.bottom)
            
            ValidatedForm { formValidator in
                ValidatedTextField("Full Name", text: $name, validator: nameValidator)
                ValidatedTextField("Email Address", text: $email, validator: emailValidator)
                ValidatedSecureField("Password", text: $password, validator: passwordValidator)
                ValidatedSecureField("Confirm Password", text: $confirmPassword, validator: confirmPasswordValidator)
                ValidatedTextField("Age", text: $age, validator: ageValidator)
                
                Button("Create Account") {
                    submitted = true
                    let isValid = validateForm()
                    if isValid {
                        // Process registration
                    }
                }
                .foregroundColor(.green)
                .padding(.top)
            }
            
            if submitted {
                Divider()
                    .padding(.vertical, 1)
                
                if isFormValid() {
                    Text("✅ Registration successful!")
                        .foregroundColor(.green)
                        .bold()
                } else {
                    Text("❌ Please fix the errors above")
                        .foregroundColor(.red)
                        .bold()
                }
            }
        }
    }
    
    private func validateForm() -> Bool {
        // In a real implementation, this would trigger validation on all fields
        return isFormValid()
    }
    
    private func isFormValid() -> Bool {
        return nameValidator.validate(name).isValid &&
               emailValidator.validate(email).isValid &&
               passwordValidator.validate(password).isValid &&
               confirmPasswordValidator.validate(confirmPassword).isValid &&
               ageValidator.validate(age).isValid
    }
}

/// Simple login form
struct LoginFormDemo: View {
    @State private var username = ""
    @State private var password = ""
    @State private var submitted = false
    
    private var usernameValidator: FieldValidator {
        CompositeValidator(
            Validators.Required(message: "Username is required"),
            Validators.MinLength(3, message: "Username must be at least 3 characters")
        )
    }
    
    private var passwordValidator: FieldValidator {
        Validators.Required(message: "Password is required")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("🔐 User Login")
                .bold()
                .foregroundColor(.blue)
                .padding(.bottom)
            
            Text("Simple form with basic validation")
                .foregroundColor(.secondary)
                .italic()
                .padding(.bottom)
            
            ValidatedTextField("Username", text: $username, validator: usernameValidator)
            ValidatedSecureField("Password", text: $password, validator: passwordValidator)
            
            HStack {
                Button("Sign In") {
                    submitted = true
                }
                .foregroundColor(.blue)
                
                Button("Clear") {
                    username = ""
                    password = ""
                    submitted = false
                }
                .foregroundColor(.secondary)
            }
            .padding(.top)
            
            if submitted {
                Divider()
                    .padding(.vertical, 1)
                
                let usernameValid = usernameValidator.validate(username).isValid
                let passwordValid = passwordValidator.validate(password).isValid
                
                if usernameValid && passwordValid {
                    Text("✅ Login successful!")
                        .foregroundColor(.green)
                } else {
                    Text("❌ Invalid credentials")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

/// Showcase of different validators
struct ValidatorShowcaseDemo: View {
    @State private var requiredField = ""
    @State private var emailField = ""
    @State private var numericField = ""
    @State private var lengthField = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("🛠️ Validator Showcase")
                .bold()
                .foregroundColor(.orange)
                .padding(.bottom)
            
            Text("Demonstrates different validation types")
                .foregroundColor(.secondary)
                .italic()
                .padding(.bottom)
            
            ValidatedTextField(
                "Required Field",
                text: $requiredField,
                validator: Validators.Required()
            )
            
            ValidatedTextField(
                "Email Field",
                text: $emailField,
                validator: Validators.Email()
            )
            
            ValidatedTextField(
                "Numeric Field",
                text: $numericField,
                validator: Validators.Numeric()
            )
            
            ValidatedTextField(
                "Length Field (3-10 chars)",
                text: $lengthField,
                validator: CompositeValidator(
                    Validators.MinLength(3),
                    Validators.MaxLength(10)
                )
            )
        }
    }
}

/// Complex validation example
struct ComplexValidationDemo: View {
    @State private var productCode = ""
    @State private var quantity = ""
    @State private var discountCode = ""
    
    private var productCodeValidator: FieldValidator {
        Validators.Custom { code in
            let pattern = "^[A-Z]{2}[0-9]{4}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
            return predicate.evaluate(with: code) ? 
                .valid : .invalid("Format: AA0000 (e.g., AB1234)")
        }
    }
    
    private var quantityValidator: FieldValidator {
        CompositeValidator(
            Validators.Numeric(),
            Validators.Custom { value in
                if let qty = Int(value), qty > 0, qty <= 100 {
                    return .valid
                } else {
                    return .invalid("Quantity must be between 1 and 100")
                }
            }
        )
    }
    
    private var discountValidator: FieldValidator {
        Validators.Custom { code in
            let validCodes = ["SAVE10", "WELCOME", "STUDENT"]
            return validCodes.contains(code.uppercased()) ? 
                .valid : .invalid("Invalid discount code")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("🏪 Order Form")
                .bold()
                .foregroundColor(.cyan)
                .padding(.bottom)
            
            Text("Complex business validation rules")
                .foregroundColor(.secondary)
                .italic()
                .padding(.bottom)
            
            ValidatedTextField(
                "Product Code",
                text: $productCode,
                validator: productCodeValidator
            )
            
            ValidatedTextField(
                "Quantity",
                text: $quantity,
                validator: quantityValidator
            )
            
            ValidatedTextField(
                "Discount Code (optional)",
                text: $discountCode,
                validator: discountCode.isEmpty ? 
                    Validators.Custom { _ in .valid } : discountValidator
            )
            
            Text("💡 Tips:")
                .bold()
                .padding(.top)
            Text("• Product Code: AA0000 format")
            Text("• Quantity: 1-100")
            Text("• Valid codes: SAVE10, WELCOME, STUDENT")
        }
    }
}

/// Main application for form validation demos
struct FormValidationApp: View {
    var body: some View {
        Window("Form Validation Demo") {
            FormValidationExample()
        }
    }
}

// Usage:
// let app = FormValidationApp()
// app.start()