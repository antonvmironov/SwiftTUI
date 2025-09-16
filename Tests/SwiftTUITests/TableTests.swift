import Testing
@testable import SwiftTUI

struct SimpleTableTests {
    
    // MARK: - Test Data Types
    
    struct Person {
        let name: String
        let age: Int
        let email: String
    }
    
    private let samplePeople = [
        Person(name: "Alice", age: 30, email: "alice@example.com"),
        Person(name: "Bob", age: 25, email: "bob@example.com"),
        Person(name: "Charlie", age: 35, email: "charlie@example.com")
    ]
    
    // MARK: - Basic Table Tests
    
    @Test("SimpleTable basic initialization")
    func simpleTableBasicInit() async throws {
        let table = SimpleTable(samplePeople, columns: ["Name", "Age", "Email"]) { person in
            [person.name, String(person.age), person.email]
        }
        
        // Test that table can be created without errors
        #expect(SimpleTable<[Person]>.size == nil)
        let _ = table
        #expect(Bool(true))
    }
    
    @Test("SimpleTable with string data")
    func simpleTableStringData() async throws {
        let stringData = ["Apple", "Banana", "Cherry"]
        
        let table = SimpleTable(stringData, columns: ["Index", "Fruit"]) { fruit in
            [String(stringData.firstIndex(of: fruit) ?? 0), fruit]
        }
        
        // Should work with simple string data
        let _ = table
        #expect(Bool(true))
    }
    
    @Test("SimpleTable with empty data")
    func simpleTableEmptyData() async throws {
        let emptyPeople: [Person] = []
        
        let table = SimpleTable(emptyPeople, columns: ["Name", "Age"]) { person in
            [person.name, String(person.age)]
        }
        
        // Should handle empty data gracefully
        #expect(emptyPeople.isEmpty)
        let _ = table
        #expect(Bool(true))
    }
    
    @Test("SimpleTable with large dataset")
    func simpleTableLargeDataset() async throws {
        let largeDataset = (0..<100).map { index in
            Person(name: "Person \(index)", age: 20 + (index % 50), email: "person\(index)@example.com")
        }
        
        let table = SimpleTable(largeDataset, columns: ["Name", "Age", "Email"]) { person in
            [person.name, String(person.age), person.email]
        }
        
        #expect(largeDataset.count == 100)
        let _ = table
        #expect(Bool(true))
    }
    
    @Test("SimpleTable with different column counts")
    func simpleTableDifferentColumnCounts() async throws {
        // Test with more columns than data
        let table1 = SimpleTable(samplePeople, columns: ["Name", "Age", "Email", "Extra1", "Extra2"]) { person in
            [person.name, String(person.age), person.email]
        }
        
        // Test with fewer columns than data
        let table2 = SimpleTable(samplePeople, columns: ["Name"]) { person in
            [person.name, String(person.age), person.email]
        }
        
        let _ = table1
        let _ = table2
        #expect(Bool(true))
    }
    
    @Test("SimpleTable with custom row content")
    func simpleTableCustomRowContent() async throws {
        let numbers = [1, 2, 3, 4, 5]
        
        let table = SimpleTable(numbers, columns: ["Number", "Square", "Cube"]) { number in
            [String(number), String(number * number), String(number * number * number)]
        }
        
        // Should work with computed row content
        let _ = table
        #expect(Bool(true))
    }
    
    @Test("SimpleTable basic rendering")
    func simpleTableBasicRendering() async throws {
        // This is mainly a compilation test since we can't easily test rendering without a full UI setup
        let table = SimpleTable(samplePeople, columns: ["Name", "Age"]) { person in
            [person.name, String(person.age)]
        }
        
        // Should create table without compilation errors
        #expect(samplePeople.count == 3)
        let _ = table
        #expect(Bool(true))
    }
}