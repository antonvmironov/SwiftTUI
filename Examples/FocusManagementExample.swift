import SwiftTUI

struct FocusManagementExampleView: View {
    // Define different fields that can be focused
    enum FormField: String, CaseIterable, Sendable {
        case username, password, email, submit
        
        var displayName: String {
            switch self {
            case .username: return "Username"
            case .password: return "Password"
            case .email: return "Email"
            case .submit: return "Submit Button"
            }
        }
    }
    
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @FocusState private var focusedField: FormField?
    
    var body: some View {
        VStack {
            Text("SwiftTUI Focus Management Example")
                .bold()
                .padding()
            
            Text("Use Tab to navigate between fields")
                .foregroundColor(.secondary)
                .padding()
            
            if let focusedField = focusedField {
                Text("Currently focused: \(focusedField.displayName)")
                    .foregroundColor(.green)
                    .padding()
            } else {
                Text("No field focused")
                    .foregroundColor(.brightBlack)
                    .padding()
            }
            
            VStack {
                TextField("Username", text: $username)
                    .focused($focusedField, equals: .username)
                    .padding()
                
                SecureField("Password", text: $password)
                    .focused($focusedField, equals: .password)
                    .padding()
                
                TextField("Email", text: $email)
                    .focused($focusedField, equals: .email)
                    .padding()
                
                Button("Submit") {
                    submitForm()
                }
                .focused($focusedField, equals: .submit)
                .padding()
            }
            .padding()
            
            VStack {
                Text("Focus Controls:")
                    .bold()
                
                HStack {
                    Button("Focus Username") {
                        focusedField = .username
                    }
                    
                    Button("Focus Password") {
                        focusedField = .password
                    }
                    
                    Button("Focus Email") {
                        focusedField = .email
                    }
                    
                    Button("Clear Focus") {
                        focusedField = nil
                    }
                }
                .padding()
            }
            
            VStack {
                Text("Form Data:")
                    .bold()
                
                Text("Username: \(username)")
                Text("Password: " + String(repeating: "•", count: password.count))
                Text("Email: \(email)")
            }
            .padding()
        }
    }
    
    private func submitForm() {
        // Simple form submission logic
        print("Form submitted!")
        print("Username: \(username)")
        print("Password: \(password)")
        print("Email: \(email)")
        
        // Clear the form
        username = ""
        password = ""
        email = ""
        focusedField = .username
    }
}

Application(rootView: FocusManagementExampleView())
    .run()