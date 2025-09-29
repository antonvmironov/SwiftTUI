import Testing
@testable import SwiftTUI

@Suite("FormValidation Tests")
@MainActor
struct FormValidationTests {
    // Helper to assert a value conforms to SwiftTUI.View at compile time
    private func isView<V: View>(_: V) -> Bool { true }

    @Test("ValidationResult enum")
    func testValidationResult() {
        let valid = ValidationResult.valid
        let invalid = ValidationResult.invalid("Error message")
        
        #expect(valid.isValid == true)
        #expect(invalid.isValid == false)
        #expect(valid.errorMessage == nil)
        #expect(invalid.errorMessage == "Error message")
    }
    
    @Test("Required validator")
    func testRequiredValidator() {
        let validator = Validators.Required()
        
        #expect(validator.validate("test").isValid == true)
        #expect(validator.validate("").isValid == false)
        #expect(validator.validate("   ").isValid == false)
        #expect(validator.validate("\n\t").isValid == false)
    }
    
    @Test("Required validator with custom message")
    func testRequiredValidatorCustomMessage() {
        let validator = Validators.Required(message: "Custom error")
        let result = validator.validate("")
        
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Custom error")
    }
    
    @Test("MinLength validator")
    func testMinLengthValidator() {
        let validator = Validators.MinLength(5)
        
        #expect(validator.validate("12345").isValid == true)
        #expect(validator.validate("123456").isValid == true)
        #expect(validator.validate("1234").isValid == false)
        #expect(validator.validate("").isValid == false)
    }
    
    @Test("MaxLength validator")
    func testMaxLengthValidator() {
        let validator = Validators.MaxLength(5)
        
        #expect(validator.validate("12345").isValid == true)
        #expect(validator.validate("1234").isValid == true)
        #expect(validator.validate("123456").isValid == false)
        #expect(validator.validate("").isValid == true)
    }
    
    @Test("Email validator")
    func testEmailValidator() {
        let validator = Validators.Email()
        
        #expect(validator.validate("test@example.com").isValid == true)
        #expect(validator.validate("user.name@domain.org").isValid == true)
        #expect(validator.validate("test@").isValid == false)
        #expect(validator.validate("@example.com").isValid == false)
        #expect(validator.validate("invalid").isValid == false)
        #expect(validator.validate("").isValid == false)
    }
    
    @Test("Numeric validator")
    func testNumericValidator() {
        let validator = Validators.Numeric()
        
        #expect(validator.validate("123").isValid == true)
        #expect(validator.validate("123.45").isValid == true)
        #expect(validator.validate("-123").isValid == true)
        #expect(validator.validate("abc").isValid == false)
        #expect(validator.validate("12abc").isValid == false)
        #expect(validator.validate("").isValid == false)
    }
    
    @Test("Custom validator")
    func testCustomValidator() {
        let validator = Validators.Custom { value in
            value.count % 2 == 0 ? .valid : .invalid("Must be even length")
        }
        
        #expect(validator.validate("ab").isValid == true)
        #expect(validator.validate("abcd").isValid == true)
        #expect(validator.validate("a").isValid == false)
        #expect(validator.validate("abc").isValid == false)
        
        let result = validator.validate("abc")
        #expect(result.errorMessage == "Must be even length")
    }
    
    @Test("CompositeValidator with multiple validators")
    func testCompositeValidator() {
        let validator = CompositeValidator(
            Validators.Required(),
            Validators.MinLength(3),
            Validators.MaxLength(10)
        )
        
        #expect(validator.validate("test").isValid == true)
        #expect(validator.validate("hello world").isValid == false) // Too long
        #expect(validator.validate("ab").isValid == false) // Too short
        #expect(validator.validate("").isValid == false) // Empty
    }
    
    @Test("CompositeValidator returns first error")
    func testCompositeValidatorFirstError() {
        let validator = CompositeValidator(
            Validators.Required(message: "Required error"),
            Validators.MinLength(5, message: "Length error")
        )
        
        let result = validator.validate("")
        #expect(result.isValid == false)
        #expect(result.errorMessage == "Required error")
    }
    
    @Test("ValidatedTextField initialization")
    func testValidatedTextField() {
        @State var text = ""
        let validator = Validators.Required()
        
        let field = ValidatedTextField("Username", text: $text, validator: validator)
        #expect(isView(field))
    }
    
    @Test("ValidatedSecureField initialization")
    func testValidatedSecureField() {
        @State var password = ""
        let validator = Validators.MinLength(8)
        
        let field = ValidatedSecureField("Password", text: $password, validator: validator)
        #expect(isView(field))
    }
    
    @Test("FormValidator field registration")
    func testFormValidator() {
        let formValidator = FormValidator()
        
        #expect(formValidator.isValid == true)
        #expect(formValidator.errors.isEmpty == true)
        
        formValidator.register(field: "username", result: .valid)
        #expect(formValidator.isValid == true)
        
        formValidator.register(field: "email", result: .invalid("Invalid email"))
        #expect(formValidator.isValid == false)
        #expect(formValidator.errors.count == 1)
        #expect(formValidator.errors.first == "Invalid email")
    }
    
    @Test("FormValidator validateAll")
    func testFormValidatorValidateAll() {
        let formValidator = FormValidator()
        
        formValidator.register(field: "field1", result: .valid)
        formValidator.register(field: "field2", result: .invalid("Error 1"))
        formValidator.register(field: "field3", result: .invalid("Error 2"))
        
        let isValid = formValidator.validateAll()
        #expect(isValid == false)
        #expect(formValidator.errors.count == 2)
    }
    
    @Test("ValidatedForm initialization")
    func testValidatedForm() {
        let form = ValidatedForm { validator in
            ValidatedTextField("Name", text: .constant(""), validator: Validators.Required())
            ValidatedTextField("Email", text: .constant(""), validator: Validators.Email())
        }
        
        #expect(isView(form))
    }
    
    @Test("Password validation example")
    func testPasswordValidation() {
        let passwordValidator = CompositeValidator(
            Validators.Required(message: "Password is required"),
            Validators.MinLength(8, message: "Password must be at least 8 characters"),
            Validators.Custom { password in
                let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
                let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
                let hasDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
                
                if hasUppercase && hasLowercase && hasDigit {
                    return .valid
                } else {
                    return .invalid("Password must contain uppercase, lowercase, and a digit")
                }
            }
        )
        
        #expect(passwordValidator.validate("").isValid == false)
        #expect(passwordValidator.validate("short").isValid == false)
        #expect(passwordValidator.validate("nouppercase123").isValid == false)
        #expect(passwordValidator.validate("NOLOWERCASE123").isValid == false)
        #expect(passwordValidator.validate("NoDigits").isValid == false)
        #expect(passwordValidator.validate("ValidPass123").isValid == true)
    }
    
    @Test("Registration form validation example")
    func testRegistrationFormValidation() {
        let nameValidator = CompositeValidator(
            Validators.Required(),
            Validators.MinLength(2)
        )
        
        let emailValidator = CompositeValidator(
            Validators.Required(),
            Validators.Email()
        )
        
        let ageValidator = CompositeValidator(
            Validators.Required(),
            Validators.Numeric(),
            Validators.Custom { value in
                if let age = Int(value), age >= 18 {
                    return .valid
                } else {
                    return .invalid("Must be 18 or older")
                }
            }
        )
        
        // Test valid data
        #expect(nameValidator.validate("John Doe").isValid == true)
        #expect(emailValidator.validate("john@example.com").isValid == true)
        #expect(ageValidator.validate("25").isValid == true)
        
        // Test invalid data
        #expect(nameValidator.validate("").isValid == false)
        #expect(emailValidator.validate("invalid-email").isValid == false)
        #expect(ageValidator.validate("17").isValid == false)
    }
}
