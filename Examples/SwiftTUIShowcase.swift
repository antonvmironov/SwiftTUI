import SwiftTUI

/// Professional business form demonstrating all SwiftTUI enhanced controls
struct BusinessFormExample: View {
    @State private var selectedCategory = "Product"
    @State private var quantity = 1
    @State private var price = 19.99
    @State private var rating = 8.0
    @State private var phone = ""
    @State private var email = ""
    @State private var date = ""
    @State private var description = ""
    @State private var notes = ""
    
    private let categories = ["Product", "Service", "Consultation", "Training"]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Business Order Form")
                    .bold()
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 1)
                
                // Category Selection
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                
                // Quantity and Rating
                HStack {
                    VStack(alignment: .leading) {
                        Stepper("Quantity: \(quantity)", value: $quantity, in: 1...100)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Slider.volume("Rating", value: Binding(
                            get: { Int(rating) },
                            set: { rating = Double($0) }
                        ))
                    }
                }
                
                // Price Slider
                Slider.percentage("Discount %", value: Binding(
                    get: { (price / 100.0) * 100 },
                    set: { price = ($0 / 100.0) * 100 }
                ))
                
                // Contact Information
                TextField.phone("Phone Number", text: $phone)
                TextField.email("Email Address", text: $email)
                TextField.date("Order Date", text: $date)
                
                // Description
                MultilineTextField("Description", text: $description, maxLines: 3)
                
                // Notes with word wrapping
                TextEditor.wrapped("Additional Notes", text: $notes, lineWidth: 50)
                
                // Action Buttons
                HStack {
                    Button("Save Order") {
                        // Save action
                    }
                    .foregroundColor(Color.blue)
                    .border()
                    
                    Spacer()
                    
                    Button("Cancel") {
                        // Cancel action
                    }
                    .foregroundColor(Color.red)
                    .border()
                }
                .padding(.top, 2)
                
                // Summary
                VStack(alignment: .leading, spacing: 0) {
                    Text("Order Summary:")
                        .bold()
                        .foregroundColor(Color.blue)
                    Text("Category: \(selectedCategory)")
                    Text("Quantity: \(quantity) @ $\(price, specifier: "%.2f")")
                    Text("Rating: \(Int(rating))/10")
                    Text("Contact: \(email.isEmpty ? "Not provided" : email)")
                }
                .padding(.all, 1)
                .border()
                .foregroundColor(Color.gray)
            }
            .padding(.all, 2)
        }
    }
}

/// Dashboard showing navigation and advanced components
struct DashboardExample: View {
    @State private var selectedTab = "Overview"
    @State private var searchText = ""
    @State private var filterValue = 50.0
    
    private let tabs = ["Overview", "Reports", "Settings", "Help"]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 1) {
                // Header
                HStack {
                    Text("📊 Business Dashboard")
                        .bold()
                        .foregroundColor(Color.blue)
                    
                    Spacer()
                    
                    TextField("Search...", text: $searchText)
                        .frame(width: 20)
                        .border()
                }
                
                Divider()
                
                // Tab Navigation
                HStack {
                    ForEach(tabs, id: \.self) { tab in
                        NavigationLink(tab, destination: Text("\(tab) Content"))
                            .foregroundColor(selectedTab == tab ? Color.blue : Color.gray)
                    }
                    Spacer()
                }
                
                Divider()
                
                // Main Content Area
                VStack(alignment: .leading, spacing: 2) {
                    // Filter Controls
                    HStack {
                        Text("Filters:")
                            .bold()
                        
                        Picker("Status", selection: Binding.constant("Active")) {
                            Text("All").tag("All")
                            Text("Active").tag("Active")
                            Text("Inactive").tag("Inactive")
                        }
                        
                        Spacer()
                        
                        Slider(value: $filterValue, in: 0...100, step: 1) {
                            Text("Range")
                        }
                    }
                    
                    // Data Table
                    SimpleTable(
                        data: [
                            ["Order #001", "John Doe", "$299.99", "Completed"],
                            ["Order #002", "Jane Smith", "$156.50", "Processing"],
                            ["Order #003", "Bob Johnson", "$89.99", "Pending"]
                        ],
                        headers: ["Order", "Customer", "Amount", "Status"]
                    )
                    
                    // Progress Indicators
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Processing:")
                            ProgressBar(progress: 0.75)
                                .foregroundColor(Color.blue)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Status:")
                            LoadingSpinner(style: .dots)
                        }
                    }
                }
                
                Spacer()
                
                // Footer
                HStack {
                    Text("© 2024 SwiftTUI Business Suite")
                        .foregroundColor(Color.gray)
                    Spacer()
                    Text("v1.0.0")
                        .foregroundColor(Color.gray)
                }
            }
            .padding(.all, 1)
        }
    }
}

/// Main application showcasing all features
struct SwiftTUIShowcase: View {
    @State private var currentExample = "Business Form"
    
    private let examples = ["Business Form", "Dashboard", "Grid Layout"]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 1) {
                // App Header
                HStack {
                    Text("🚀 SwiftTUI Professional Suite")
                        .bold()
                        .foregroundColor(Color.blue)
                    
                    Spacer()
                    
                    Picker("Example", selection: $currentExample) {
                        ForEach(examples, id: \.self) { example in
                            Text(example).tag(example)
                        }
                    }
                }
                
                Divider()
                
                // Content
                Group {
                    switch currentExample {
                    case "Business Form":
                        BusinessFormExample()
                    case "Dashboard":
                        DashboardExample()
                    case "Grid Layout":
                        GridLayoutExample()
                    default:
                        Text("Select an example")
                    }
                }
                
                Spacer()
            }
            .padding(.all, 1)
        }
    }
}

/// Grid layout demonstration
struct GridLayoutExample: View {
    @State private var columns = 3
    @State private var showBorders = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            // Controls
            HStack {
                Stepper("Columns: \(columns)", value: $columns, in: 2...6)
                
                Spacer()
                
                Button(showBorders ? "Hide Borders" : "Show Borders") {
                    showBorders.toggle()
                }
                .foregroundColor(Color.blue)
            }
            
            // Grid Display
            LazyVGrid(columns: columns) {
                ForEach(1...24, id: \.self) { item in
                    VStack {
                        Text("📦")
                        Text("Item \(item)")
                            .foregroundColor(Color.gray)
                    }
                    .padding(.all, 1)
                    .apply { view in
                        if showBorders {
                            view.border()
                        } else {
                            view
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

// Helper extension for conditional modifiers
extension View {
    func apply<V: View>(@ViewBuilder transform: (Self) -> V) -> V {
        transform(self)
    }
}