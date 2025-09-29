import Testing
@testable import SwiftTUI

@Suite("TextField Binding Tests")
@MainActor
struct TextFieldBindingTests {

    @Test("TextField with @Binding initializer compiles correctly")
    func textFieldWithBinding() {
        // Test that we can create the view without crashing
        let textField = TextField("Enter text", text: Binding(
            get: { "test" },
            set: { _ in }
        ))
        #expect(textField.placeholder == "Enter text")
        #expect(textField.text != nil)
        #expect(textField.action == nil)
    }
    
    @Test("TextField with action initializer still works")
    func textFieldWithAction() {
        let textField = TextField(placeholder: "Enter text") { text in
            // Action closure
        }
        
        #expect(textField.placeholder == "Enter text")
        #expect(textField.text == nil)
        #expect(textField.action != nil)
    }
    
    @Test("TextField with empty placeholder creates correct binding")
    func textFieldWithEmptyPlaceholder() {
        let textField = TextField("", text: Binding(
            get: { "value" },
            set: { _ in }
        ))
        
        #expect(textField.placeholder == nil)
        #expect(textField.text != nil)
    }
    
    @Test("TextField with non-empty placeholder retains it")
    func textFieldWithNonEmptyPlaceholder() {
        let textField = TextField("Type here", text: Binding(
            get: { "value" },
            set: { _ in }
        ))
        
        #expect(textField.placeholder == "Type here")
        #expect(textField.text != nil)
    }
}
