import SwiftTUI

/// Example demonstrating advanced Table functionality in SwiftTUI
/// Shows sorting, selection, keyboard navigation, and various column types
struct AdvancedTableExample: View {
    
    // Sample data models
    struct Employee: Identifiable {
        let id: Int
        let name: String
        let department: String
        let salary: Int
        let experience: Int
        let email: String
        let isActive: Bool
    }
    
    struct Product: Identifiable {
        let id: String
        let name: String
        let category: String
        let price: Double
        let stock: Int
        let rating: Double
    }
    
    @State private var selectedEmployees: Set<Int> = []
    @State private var selectedProducts: Set<String> = []
    @State private var showEmployees = true
    
    let employees = [
        Employee(id: 1, name: "Alice Johnson", department: "Engineering", salary: 85000, experience: 5, email: "alice@company.com", isActive: true),
        Employee(id: 2, name: "Bob Smith", department: "Marketing", salary: 72000, experience: 3, email: "bob@company.com", isActive: true),
        Employee(id: 3, name: "Carol Davis", department: "Engineering", salary: 95000, experience: 8, email: "carol@company.com", isActive: false),
        Employee(id: 4, name: "David Wilson", department: "Sales", salary: 68000, experience: 2, email: "david@company.com", isActive: true),
        Employee(id: 5, name: "Eva Martinez", department: "HR", salary: 75000, experience: 6, email: "eva@company.com", isActive: true),
        Employee(id: 6, name: "Frank Brown", department: "Engineering", salary: 92000, experience: 7, email: "frank@company.com", isActive: true),
        Employee(id: 7, name: "Grace Lee", department: "Marketing", salary: 78000, experience: 4, email: "grace@company.com", isActive: false)
    ]
    
    let products = [
        Product(id: "P001", name: "Laptop Pro", category: "Electronics", price: 1299.99, stock: 15, rating: 4.5),
        Product(id: "P002", name: "Wireless Mouse", category: "Electronics", price: 49.99, stock: 50, rating: 4.2),
        Product(id: "P003", name: "Desk Chair", category: "Furniture", price: 299.99, stock: 8, rating: 4.0),
        Product(id: "P004", name: "Monitor 27\"", category: "Electronics", price: 399.99, stock: 12, rating: 4.7),
        Product(id: "P005", name: "Keyboard Mechanical", category: "Electronics", price: 129.99, stock: 25, rating: 4.6),
        Product(id: "P006", name: "Standing Desk", category: "Furniture", price: 599.99, stock: 5, rating: 4.3)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Header and controls
            HStack {
                Text("📊 Advanced Table Demo")
                    .bold()
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button(showEmployees ? "Show Products" : "Show Employees") {
                    showEmployees.toggle()
                }
                .foregroundColor(.green)
            }
            .padding(.bottom)
            
            // Instructions
            VStack(alignment: .leading, spacing: 1) {
                Text("💡 Table Features:")
                    .bold()
                Text("• ↑↓ Arrow keys: Navigate rows")
                Text("• Click column headers: Sort (▲▼ indicators)")
                Text("• Space/Enter: Toggle selection")
                Text("• Multi-column sorting supported")
            }
            .padding(.bottom)
            
            // Table content
            if showEmployees {
                employeeTableView
            } else {
                productTableView
            }
            
            // Selection summary
            selectionSummary
        }
        .padding()
    }
    
    @ViewBuilder
    private var employeeTableView: some View {
        VStack(alignment: .leading) {
            Text("👥 Employee Directory")
                .bold()
                .foregroundColor(.purple)
                .padding(.bottom, 1)
            
            Table(employees, selection: $selectedEmployees) {
                TableColumn("ID", value: \Employee.id)
                TableColumn("Name", value: \Employee.name)
                TableColumn("Department", value: \Employee.department)
                TableColumn("Salary") { employee in
                    "$\(employee.salary.formatted())"
                }
                TableColumn("Experience") { employee in
                    "\(employee.experience) years"
                }
                TableColumn("Status") { employee in
                    employee.isActive ? "✅ Active" : "❌ Inactive"
                }
            }
        }
    }
    
    @ViewBuilder
    private var productTableView: some View {
        VStack(alignment: .leading) {
            Text("🛍️ Product Catalog")
                .bold()
                .foregroundColor(.orange)
                .padding(.bottom, 1)
            
            Table(products, selection: $selectedProducts) {
                TableColumn("SKU", value: \Product.id)
                TableColumn("Product Name", value: \Product.name)
                TableColumn("Category", value: \Product.category)
                TableColumn("Price") { product in
                    "$\(product.price, specifier: "%.2f")"
                }
                TableColumn("Stock") { product in
                    "\(product.stock) units"
                }
                TableColumn("Rating") { product in
                    String(repeating: "⭐", count: Int(product.rating)) + 
                    " (\(product.rating, specifier: "%.1f"))"
                }
            }
        }
    }
    
    @ViewBuilder
    private var selectionSummary: some View {
        Divider()
            .padding(.vertical)
        
        VStack(alignment: .leading, spacing: 1) {
            Text("📋 Selection Summary:")
                .bold()
            
            if showEmployees {
                if selectedEmployees.isEmpty {
                    Text("No employees selected")
                        .foregroundColor(.secondary)
                } else {
                    Text("Selected employees: \(selectedEmployees.count)")
                        .foregroundColor(.blue)
                    
                    ForEach(Array(selectedEmployees), id: \.self) { id in
                        if let employee = employees.first(where: { $0.id == id }) {
                            Text("• \(employee.name) (\(employee.department))")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } else {
                if selectedProducts.isEmpty {
                    Text("No products selected")
                        .foregroundColor(.secondary)
                } else {
                    Text("Selected products: \(selectedProducts.count)")
                        .foregroundColor(.blue)
                    
                    ForEach(Array(selectedProducts), id: \.self) { id in
                        if let product = products.first(where: { $0.id == id }) {
                            Text("• \(product.name) - $\(product.price, specifier: "%.2f")")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
}

/// Example of Table without selection (read-only)
struct ReadOnlyTableExample: View {
    
    struct Stats: Identifiable {
        let id = UUID()
        let metric: String
        let value: String
        let change: String
        let trend: String
    }
    
    let stats = [
        Stats(metric: "Revenue", value: "$125,430", change: "+12.5%", trend: "📈"),
        Stats(metric: "Users", value: "8,451", change: "+8.2%", trend: "📈"),
        Stats(metric: "Orders", value: "1,203", change: "-2.1%", trend: "📉"),
        Stats(metric: "Conversion", value: "3.4%", change: "+0.3%", trend: "📈"),
        Stats(metric: "Bounce Rate", value: "35.2%", change: "-1.2%", trend: "📈")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("📊 Dashboard Statistics")
                .bold()
                .foregroundColor(.green)
                .padding(.bottom)
            
            Text("Read-only table (no selection)")
                .foregroundColor(.secondary)
                .italic()
                .padding(.bottom, 1)
            
            Table(stats) {
                TableColumn("Metric", value: \Stats.metric)
                TableColumn("Current Value", value: \Stats.value)
                TableColumn("Change", value: \Stats.change)
                TableColumn("Trend", value: \Stats.trend)
            }
        }
        .padding()
    }
}

/// Example of customized table with complex data transformation
struct CustomTableExample: View {
    
    struct Transaction: Identifiable {
        let id: String
        let date: Date
        let description: String
        let amount: Double
        let type: TransactionType
        let category: String
    }
    
    enum TransactionType: String, CaseIterable {
        case income = "Income"
        case expense = "Expense"
        case transfer = "Transfer"
    }
    
    @State private var selectedTransactions: Set<String> = []
    
    let transactions = [
        Transaction(id: "T001", date: Date().addingTimeInterval(-86400 * 5), description: "Salary Payment", amount: 3500.00, type: .income, category: "Salary"),
        Transaction(id: "T002", date: Date().addingTimeInterval(-86400 * 3), description: "Grocery Shopping", amount: -125.50, type: .expense, category: "Food"),
        Transaction(id: "T003", date: Date().addingTimeInterval(-86400 * 2), description: "Electric Bill", amount: -85.30, type: .expense, category: "Utilities"),
        Transaction(id: "T004", date: Date().addingTimeInterval(-86400 * 1), description: "Freelance Project", amount: 750.00, type: .income, category: "Freelance"),
        Transaction(id: "T005", date: Date(), description: "Coffee", amount: -4.50, type: .expense, category: "Food")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("💰 Transaction History")
                .bold()
                .foregroundColor(.blue)
                .padding(.bottom)
            
            Table(transactions, selection: $selectedTransactions) {
                TableColumn("Date") { transaction in
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    return formatter.string(from: transaction.date)
                }
                
                TableColumn("Description", value: \Transaction.description)
                
                TableColumn("Amount") { transaction in
                    let prefix = transaction.amount >= 0 ? "+" : ""
                    return "\(prefix)$\(transaction.amount, specifier: "%.2f")"
                }
                
                TableColumn("Type") { transaction in
                    let icon = transaction.type == .income ? "💰" : 
                              transaction.type == .expense ? "💸" : "🔄"
                    return "\(icon) \(transaction.type.rawValue)"
                }
                
                TableColumn("Category", value: \Transaction.category)
            }
            
            if !selectedTransactions.isEmpty {
                Divider()
                    .padding(.vertical)
                
                let totalSelected = transactions
                    .filter { selectedTransactions.contains($0.id) }
                    .reduce(0) { $0 + $1.amount }
                
                Text("Selected total: $\(totalSelected, specifier: "%.2f")")
                    .bold()
                    .foregroundColor(totalSelected >= 0 ? .green : .red)
            }
        }
        .padding()
    }
}

// Example usage in a real application
struct TableDemoApp: View {
    @State private var currentDemo = 0
    
    let demos = [
        ("Advanced Table", AnyView(AdvancedTableExample())),
        ("Read-Only Table", AnyView(ReadOnlyTableExample())),
        ("Custom Table", AnyView(CustomTableExample()))
    ]
    
    var body: some View {
        Window("Table Component Demo") {
            VStack {
                // Demo selector
                HStack {
                    ForEach(Array(demos.enumerated()), id: \.offset) { index, demo in
                        Button(demo.0) {
                            currentDemo = index
                        }
                        .foregroundColor(currentDemo == index ? .blue : .secondary)
                    }
                }
                .padding(.bottom)
                
                // Current demo
                demos[currentDemo].1
            }
        }
    }
}

// Usage:
// let app = TableDemoApp()
// app.start()