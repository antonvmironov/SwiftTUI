import Testing
import SwiftTUI

@Suite("List Component Tests") 
@MainActor
struct ListTests {

    // Helper to assert a value conforms to SwiftTUI.View at compile time
    private func isView<V: View>(_: V) -> Bool { true }
    
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
        #expect(isView(list))
        #expect(List<[Item], Int, Text>.size == nil)
    }
    
    @Test("List creates with custom ID keypath")
    func listWithCustomID() async throws {
        let list = List(sampleItems, id: \.id) { item in
            Text(item.name)
        }
        
        // Verify the list can be created with custom ID
        #expect(isView(list))
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
        #expect(isView(list))
    }
    
    @Test("List with selection and custom ID")
    func listWithSelectionAndID() async throws {
        @State var selectedItem: Int? = nil
        
        let list = List(sampleItems, id: \.id, selection: $selectedItem) { item in
            Text(item.name)
        }
        
        // Verify the list can be created with both selection and custom ID
        #expect(selectedItem == nil)
        #expect(isView(list))
    }
    
    @Test("List with simple string data")
    func listWithStringData() async throws {
        let items = ["Apple", "Banana", "Cherry"]
        
        let list = List(items, id: \.self) { item in
            Text(item)
        }
        
        // Verify list works with simple string data
        #expect(isView(list))
        #expect(List<[String], String, Text>.size == nil)
    }
    
    @Test("List selection binding updates")
    func listSelectionUpdates() async throws {
        var selectedItem: Int? = nil
        
        // Set initial selection
        selectedItem = 2
        
        let binding = Binding(get: { selectedItem }, set: { selectedItem = $0 })
        let list = List(sampleItems, selection: binding) { item in
            Text(item.name)
        }
        
        // Verify selection binding works
        #expect(selectedItem == 2)
        #expect(isView(list))
    }
    
    @Test("List handles empty data gracefully")
    func listWithEmptyData() async throws {
        let emptyItems: [Item] = []
        
        let list = List(emptyItems) { item in
            Text(item.name)
        }
        
        // List should handle empty data without issues
        #expect(isView(list))
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
        
        #expect(isView(list))
    }
}
