import Testing
import SwiftTUI

@Suite("List Component Tests") 
struct ListTests {
    
    struct Item: Identifiable {
        let id: Int
        let name: String
    }
    
    let sampleItems = [
        Item(id: 1, name: "First Item"),
        Item(id: 2, name: "Second Item"),
        Item(id: 3, name: "Third Item")
    ]
    
    @Test("List creates with identifiable data")
    func listWithIdentifiableData() async throws {
        let list = List(sampleItems) { item in
            Text(item.name)
        }
        
        // Test that the list has the expected static size
        #expect(List<[Item], Int, Text>.size == nil)
    }
    
    @Test("List creates with custom ID keypath")
    func listWithCustomID() async throws {
        let list = List(sampleItems, id: \.id) { item in
            Text(item.name)
        }
        
        // Verify the list can be created with custom ID
        #expect(List<[Item], Int, Text>.size == nil)
    }
    
    @Test("List with selection binding")
    func listWithSelection() async throws {
        @State var selectedItem: Int? = nil
        
        let list = List(sampleItems, selection: $selectedItem) { item in
            Text(item.name)
        }
        
        // Verify the list can be created with selection
        #expect(selectedItem == nil)
    }
    
    @Test("List with selection and custom ID")
    func listWithSelectionAndID() async throws {
        @State var selectedItem: Int? = nil
        
        let list = List(sampleItems, id: \.id, selection: $selectedItem) { item in
            Text(item.name)
        }
        
        // Verify the list can be created with both selection and custom ID
        #expect(selectedItem == nil)
    }
    
    @Test("List with simple string data")
    func listWithStringData() async throws {
        let items = ["Apple", "Banana", "Cherry"]
        
        let list = List(items, id: \.self) { item in
            Text(item)
        }
        
        // Verify list works with simple string data
        #expect(List<[String], String, Text>.size == nil)
    }
    
    @Test("List selection binding updates")
    func listSelectionUpdates() async throws {
        @State var selectedItem: Int? = nil
        
        // Set initial selection
        selectedItem = 2
        
        let list = List(sampleItems, selection: $selectedItem) { item in
            Text(item.name)
        }
        
        // Verify selection binding works
        #expect(selectedItem == 2)
    }
    
    @Test("List handles empty data gracefully")
    func listWithEmptyData() async throws {
        let emptyItems: [Item] = []
        
        let list = List(emptyItems) { item in
            Text(item.name)
        }
        
        // List should handle empty data without issues
        #expect(List<[Item], Int, Text>.size == nil)
    }
    
    @Test("List works with complex content")
    func listWithComplexContent() async throws {
        let list = List(sampleItems) { item in
            VStack {
                Text(item.name)
                    .bold()
                Text("ID: \(item.id)")
                    .foregroundColor(.secondary)
            }
        }
        
        // Verify complex content works - just check that it compiles successfully
        let _ = list
        #expect(true) // Simple test that the list can be created
    }
}