import Testing
@testable import SwiftTUI

struct TableTests {
    
    // Test data structure
    struct Person: Identifiable {
        let id: Int
        let name: String
        let age: Int
        let email: String
    }
    
    let sampleData = [
        Person(id: 1, name: "Alice", age: 30, email: "alice@example.com"),
        Person(id: 2, name: "Bob", age: 25, email: "bob@example.com"),
        Person(id: 3, name: "Charlie", age: 35, email: "charlie@example.com")
    ]
    
    @Test("Table basic initialization without selection")
    func testTableBasicInit() {
        let table = Table(sampleData) {
            TableColumn<Person>("Name") { person in person.name }
            TableColumn<Person>("Age") { person in String(person.age) }
            TableColumn<Person>("Email") { person in person.email }
        }
        
        let _ = table
    }

    @Test("Table initialization with selection")
    func testTableWithSelection() {
        @State var selection: Set<Int> = []
        
        let table = Table(sampleData, selection: $selection) {
            TableColumn<Person>("Name") { person in person.name }
            TableColumn<Person>("Age") { person in String(person.age) }
        }
        
        let _ = table
    }

    @Test("TableColumn initialization with string extractor")
    func testTableColumnStringExtractor() {
        let column = TableColumn<Person>("Name") { person in person.name }
        
        #expect(column.title == "Name")
        #expect(column.id == "Name")
        
        let person = Person(id: 1, name: "Test", age: 30, email: "test@example.com")
        #expect(column.content(person) == "Test")
    }
    
    @Test("TableColumn initialization with custom ID")
    func testTableColumnCustomId() {
        let column = TableColumn<Person>(
            id: "person_name",
            title: "Full Name"
        ) { person in person.name }
        
        #expect(column.id == "person_name")
        #expect(column.title == "Full Name")
    }
    
    @Test("TableColumn with KeyPath")
    func testTableColumnKeyPath() {
        let nameColumn = TableColumn<Person>("Name", value: \Person.name)
        let ageColumn = TableColumn<Person>("Age", value: \Person.age)

        let person = Person(id: 1, name: "Alice", age: 30, email: "alice@example.com")
        
        #expect(nameColumn.content(person) == "Alice")
        #expect(ageColumn.content(person) == "30")
    }
    
    @Test("TableSortDescriptor creation")
    func testTableSortDescriptor() {
        let ascendingSort = TableSortDescriptor(columnId: "name", order: .ascending)
        let descendingSort = TableSortDescriptor(columnId: "age", order: .descending)
        
        #expect(ascendingSort.columnId == "name")
        #expect(ascendingSort.order == .ascending)
        #expect(descendingSort.order == .descending)
    }
    
    @Test("SortOrder enumeration")
    func testSortOrder() {
        let ascending = SortOrder.ascending
        let descending = SortOrder.descending
        
        #expect(ascending == .ascending)
        #expect(descending == .descending)
        #expect(ascending != descending)
    }
    
    @Test("TableColumnBuilder result builder")
    func testTableColumnBuilder() {
        @TableColumnBuilder<Person>
        func buildColumns() -> [TableColumn<Person>] {
            TableColumn<Person>("Name") { $0.name }
            TableColumn<Person>("Email") { $0.email }
        }
        
        let columns = buildColumns()
        #expect(columns.count == 2)
        #expect(columns[0].title == "Name")
        #expect(columns[1].title == "Email")
    }
    
    @Test("Table with complex column configuration")
    func testTableComplexColumns() {
        let table = Table(sampleData) {
            TableColumn<Person>("ID", value: \Person.id)
            TableColumn<Person>("Name", value: \Person.name)
            TableColumn<Person>("Age", value: \Person.age)
            TableColumn<Person>("Contact") { person in person.email }
        }
        
        let _ = table
    }

    @Test("Table selection binding behavior")
    func testTableSelectionBinding() {
        @State var selectedIds: Set<Int> = [1, 3]
        
        let table = Table(sampleData, selection: $selectedIds) {
            TableColumn<Person>("Name", value: \Person.name)
        }
        
        let _ = table
        // Note: In a real app, selection would be tested through UI interaction
    }

    @Test("Empty table data")
    func testEmptyTable() {
        let emptyData: [Person] = []
        
        let table = Table(emptyData) {
            TableColumn<Person>("Name", value: \Person.name)
            TableColumn<Person>("Age", value: \Person.age)
        }
        
        let _ = table
    }

    @Test("Table with single column")
    func testSingleColumnTable() {
        let table = Table(sampleData) {
            TableColumn<Person>("Name", value: \Person.name)
        }
        
        let _ = table
    }

    @Test("Table column content extraction")
    func testColumnContentExtraction() {
        let nameColumn = TableColumn<Person>("Name") { $0.name }
        let ageColumn = TableColumn<Person>("Age") { String($0.age) }
        
        let person = sampleData[0]
        
        #expect(nameColumn.content(person) == "Alice")
        #expect(ageColumn.content(person) == "30")
    }
}
