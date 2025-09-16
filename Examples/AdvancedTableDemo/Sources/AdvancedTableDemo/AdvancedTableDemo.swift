import SwiftTUI
import Foundation

/// Advanced Table Demo Application showcasing enhanced table features
/// This demonstrates the improved Table component with search, filtering, 
/// and professional data management capabilities.
@main
struct AdvancedTableDemo {
    static func main() {
        Application(rootView: AdvancedTableDemoView()).start()
    }
}

struct AdvancedTableDemoView: View {
    
    // Sample data for demonstration
    struct Employee: Identifiable {
        let id: Int
        let name: String
        let department: String
        let role: String
        let salary: Double
        let isActive: Bool
        let hireDate: String
    }
    
    let employees = [
        Employee(id: 1, name: "Alice Johnson", department: "Engineering", role: "Senior Developer", salary: 95000, isActive: true, hireDate: "2021-03-15"),
        Employee(id: 2, name: "Bob Smith", department: "Marketing", role: "Marketing Manager", salary: 78000, isActive: true, hireDate: "2020-07-22"),
        Employee(id: 3, name: "Carol Davis", department: "Engineering", role: "Tech Lead", salary: 110000, isActive: true, hireDate: "2019-11-08"),
        Employee(id: 4, name: "David Wilson", department: "Sales", role: "Sales Representative", salary: 65000, isActive: false, hireDate: "2022-01-12"),
        Employee(id: 5, name: "Eva Martinez", department: "HR", role: "HR Specialist", salary: 72000, isActive: true, hireDate: "2021-09-03"),
        Employee(id: 6, name: "Frank Taylor", department: "Engineering", role: "DevOps Engineer", salary: 88000, isActive: true, hireDate: "2020-12-14"),
        Employee(id: 7, name: "Grace Lee", department: "Finance", role: "Financial Analyst", salary: 75000, isActive: true, hireDate: "2022-04-18"),
        Employee(id: 8, name: "Henry Brown", department: "Marketing", role: "Content Writer", salary: 58000, isActive: true, hireDate: "2021-08-25"),
        Employee(id: 9, name: "Ivy Chen", department: "Engineering", role: "Junior Developer", salary: 70000, isActive: true, hireDate: "2023-02-01"),
        Employee(id: 10, name: "Jack Robinson", department: "Sales", role: "Sales Manager", salary: 92000, isActive: true, hireDate: "2019-05-30")
    ]
    
    @State private var selectedEmployees: Set<Int> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Header
            Text("🏢 Advanced Employee Management System")
                .bold()
                .foregroundColor(.blue)
                .padding(.bottom, 1)
            
            Text("Enhanced Table with Search, Sorting & Selection")
                .foregroundColor(.secondary)
                .padding(.bottom, 2)
            
            // Enhanced table with all advanced features
            Table(employees, selection: $selectedEmployees) {
                TableColumn("ID", value: \Employee.id)
                TableColumn("👤 Name", value: \Employee.name)
                TableColumn("🏢 Department", value: \Employee.department)
                TableColumn("💼 Role", value: \Employee.role)
                TableColumn("💰 Salary") { (employee: Employee) in
                    formatSalary(employee.salary)
                }
                TableColumn("📅 Hire Date", value: \Employee.hireDate)
                TableColumn("Status") { (employee: Employee) in
                    employee.isActive ? "🟢 Active" : "🔴 Inactive"
                }
            }
            
            // Selection summary
            Spacer()
            
            VStack(alignment: .leading, spacing: 1) {
                Text("📊 Selection Summary:")
                    .bold()
                    .foregroundColor(.yellow)
                
                if selectedEmployees.isEmpty {
                    Text("No employees selected")
                        .foregroundColor(.secondary)
                } else {
                    Text("Selected \(selectedEmployees.count) employee(s)")
                        .foregroundColor(.green)
                    
                    let selectedNames = employees
                        .filter { selectedEmployees.contains($0.id) }
                        .map { $0.name }
                        .joined(separator: ", ")
                    
                    Text("Names: \(selectedNames)")
                        .foregroundColor(.cyan)
                }
            }
            .padding(.top, 1)
            
            // Instructions
            VStack(alignment: .leading, spacing: 0) {
                Text("🔧 Instructions:")
                    .bold()
                    .foregroundColor(.magenta)
                
                Text("• Click column headers to sort")
                    .foregroundColor(.white)
                Text("• Use search bar to filter employees")
                    .foregroundColor(.white)
                Text("• Click rows to select/deselect")
                    .foregroundColor(.white)
                Text("• Multiple selections supported")
                    .foregroundColor(.white)
            }
            .padding(.top, 1)
        }
        .padding()
    }
    
    private func formatSalary(_ salary: Double) -> String {
        return String(format: "$%.0f", salary)
    }
}

/// Additional demo showcasing different table configurations
struct TableVariationsDemo: View {
    
    struct Product: Identifiable {
        let id: Int
        let name: String
        let category: String
        let price: Double
        let rating: Double
        let inStock: Bool
    }
    
    let products = [
        Product(id: 1, name: "MacBook Pro 16\"", category: "Laptops", price: 2499.99, rating: 4.8, inStock: true),
        Product(id: 2, name: "iPhone 15 Pro", category: "Smartphones", price: 1199.99, rating: 4.7, inStock: true),
        Product(id: 3, name: "iPad Air", category: "Tablets", price: 699.99, rating: 4.6, inStock: false),
        Product(id: 4, name: "Apple Watch Ultra", category: "Wearables", price: 799.99, rating: 4.5, inStock: true),
        Product(id: 5, name: "AirPods Pro", category: "Audio", price: 249.99, rating: 4.4, inStock: true)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("🛍️ Product Catalog - Read-Only Table")
                .bold()
                .foregroundColor(.green)
                .padding(.bottom, 1)
            
            // Read-only table without selection
            Table(products) {
                TableColumn("🆔", value: \Product.id)
                TableColumn("📱 Product", value: \Product.name)
                TableColumn("🏷️ Category", value: \Product.category)
                TableColumn("💰 Price") { (product: Product) in
                    String(format: "$%.2f", product.price)
                }
                TableColumn("⭐ Rating") { (product: Product) in
                    String(format: "%.1f ⭐", product.rating)
                }
                TableColumn("📦 Stock") { (product: Product) in
                    product.inStock ? "✅" : "❌"
                }
            }
            
            Spacer()
            
            Text("📋 Features Demonstrated:")
                .bold()
                .foregroundColor(.yellow)
            
            Text("✓ Multi-column sorting")
                .foregroundColor(.green)
            Text("✓ Custom column formatting")
                .foregroundColor(.green)
            Text("✓ Emoji-enhanced headers")
                .foregroundColor(.green)
            Text("✓ Search and filtering capabilities")
                .foregroundColor(.green)
            Text("✓ Professional data presentation")
                .foregroundColor(.green)
        }
        .padding()
    }
}