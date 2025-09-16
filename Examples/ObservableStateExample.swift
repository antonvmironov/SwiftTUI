import SwiftTUI

// Define a model using the Observable system
class UserProfile: ObservableObject {
    @ObservableProperty var firstName: String = ""
    @ObservableProperty var lastName: String = ""
    @ObservableProperty var email: String = ""
    @ObservableProperty var age: Int = 18
    @ObservableProperty var isSubscribed: Bool = false
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
    
    func reset() {
        firstName = ""
        lastName = ""
        email = ""
        age = 18
        isSubscribed = false
    }
}

// Define a counter model for demonstration
class Counter: ObservableObject {
    @ObservableProperty var count: Int = 0
    
    func increment() {
        count += 1
    }
    
    func decrement() {
        count -= 1
    }
    
    func reset() {
        count = 0
    }
}

struct ObservableStateExampleView: View {
    @ObservableState private var userProfile = UserProfile()
    @ObservableState private var counter = Counter()
    @State private var showDetails = false
    
    var body: some View {
        VStack {
            Text("SwiftTUI Observable State Example")
                .bold()
                .padding()
            
            Text("Automatic UI updates when observable properties change")
                .foregroundColor(.secondary)
                .padding()
            
            // Counter Section
            VStack {
                Text("Counter Demo")
                    .bold()
                
                Text("Count: \(counter.count)")
                    .foregroundColor(counter.count > 0 ? .green : (counter.count < 0 ? .red : .primary))
                    .padding()
                
                HStack {
                    Button("-") {
                        counter.decrement()
                    }
                    
                    Button("Reset") {
                        counter.reset()
                    }
                    
                    Button("+") {
                        counter.increment()
                    }
                }
                .padding()
            }
            .padding()
            
            Divider()
            
            // User Profile Section
            VStack {
                Text("User Profile Demo")
                    .bold()
                
                if !userProfile.fullName.isEmpty {
                    Text("Welcome, \(userProfile.fullName)!")
                        .foregroundColor(.green)
                        .padding()
                } else {
                    Text("Please enter your information")
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                VStack {
                    TextField("First Name", text: Binding(
                        get: { userProfile.firstName },
                        set: { userProfile.firstName = $0 }
                    ))
                    .padding()
                    
                    TextField("Last Name", text: Binding(
                        get: { userProfile.lastName },
                        set: { userProfile.lastName = $0 }
                    ))
                    .padding()
                    
                    TextField("Email", text: Binding(
                        get: { userProfile.email },
                        set: { userProfile.email = $0 }
                    ))
                    .padding()
                }
                
                HStack {
                    Text("Age: \(userProfile.age)")
                    
                    Button("-") {
                        if userProfile.age > 0 {
                            userProfile.age -= 1
                        }
                    }
                    
                    Button("+") {
                        if userProfile.age < 150 {
                            userProfile.age += 1
                        }
                    }
                }
                .padding()
                
                Button(userProfile.isSubscribed ? "Unsubscribe" : "Subscribe") {
                    userProfile.isSubscribed.toggle()
                }
                .padding()
                
                Button("Reset Profile") {
                    userProfile.reset()
                }
                .padding()
            }
            .padding()
            
            if showDetails {
                VStack {
                    Text("Profile Details:")
                        .bold()
                    Text("First: '\(userProfile.firstName)'")
                    Text("Last: '\(userProfile.lastName)'")
                    Text("Email: '\(userProfile.email)'")
                    Text("Age: \(userProfile.age)")
                    Text("Subscribed: \(userProfile.isSubscribed ? "Yes" : "No")")
                }
                .padding()
            }
            
            Button(showDetails ? "Hide Details" : "Show Details") {
                showDetails.toggle()
            }
            .padding()
            
            Text("🎉 All UI updates happen automatically!")
                .foregroundColor(.blue)
                .padding()
        }
    }
}

Application(rootView: ObservableStateExampleView())
    .run()