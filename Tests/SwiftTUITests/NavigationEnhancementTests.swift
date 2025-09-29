import Testing
@testable import SwiftTUI

@Suite("Navigation Enhancement Tests")
@MainActor
struct NavigationEnhancementTests {
    // Helper to assert a value conforms to SwiftTUI.View at compile time
    private func isView<V: View>(_: V) -> Bool { true }

    @Test("NavigationLink with string title compiles correctly")
    func navigationLinkWithTitle() {
        let destinationView = Text("Destination")
        let navLink = NavigationLink("Go to Destination", destination: destinationView)
        
        #expect(isView(destinationView))
        #expect(isView(navLink))
    }
    
    @Test("NavigationLink with custom label compiles correctly")
    func navigationLinkWithCustomLabel() {
        let destinationView = Text("Destination")
        let navLink = NavigationLink(destination: destinationView) {
            HStack {
                Text("Custom")
                Text("Label")
            }
        }
        
        #expect(isView(destinationView))
        #expect(isView(navLink))
    }
    
    @Test("NavigationLink provides SwiftUI-compatible API")
    func navigationLinkAPI() {
        // Test that NavigationLink provides the expected SwiftUI-compatible interface
        let destination = Text("Detail View")
        
        // String title variant
        let link1 = NavigationLink("Details", destination: destination)
        
        // Custom label variant
        let link2 = NavigationLink(destination: destination) {
            Text("Go to Details")
        }
        
        #expect(isView(destination))
        #expect(isView(link1))
        #expect(isView(link2))
    }

    @Test("NavigationLink integrates with other components")
    func navigationLinkIntegration() {
        let destinationView = VStack {
            Text("Detail View")
            Button("Action") { }
        }
        
        let listView = VStack {
            NavigationLink("First Item", destination: destinationView)
            NavigationLink("Second Item", destination: destinationView)
            NavigationLink("Third Item", destination: destinationView)
        }
        
        #expect(isView(destinationView))
        #expect(isView(listView))
    }
}
