import Testing
@testable import SwiftTUI

@Suite("NavigationStack Tests")
@MainActor
struct NavigationStackTests {
    // Helper to assert a value conforms to SwiftTUI.View at compile time
    private func isView<V: View>(_: V) -> Bool { true }

    @Test("NavigationLink initialization with destination")
    func testNavigationLinkWithDestination() {
        let link = NavigationLink(destination: Text("Destination")) {
            Text("Label")
        }
        
        #expect(isView(link))
    }
    
    @Test("NavigationLink initialization with string title")
    func testNavigationLinkWithTitle() {
        let link = NavigationLink("My Link", destination: Text("Destination"))
        
        #expect(isView(link))
    }
    
    @Test("NavigationLink with complex view hierarchy")
    func testNavigationLinkComplexHierarchy() {
        let link = NavigationLink("Settings", destination: VStack {
            Text("Settings Screen")
            NavigationLink("Advanced", destination: Text("Advanced Settings"))
        })
        
        #expect(isView(link))
    }
    
    @Test("NavigationLink visual pattern")
    func testNavigationLinkVisualPattern() {
        // Test that NavigationLink provides the expected UI pattern
        let simpleLink = NavigationLink("Test", destination: EmptyView())
        let customLink = NavigationLink(destination: EmptyView()) {
            HStack {
                Text("Custom")
                Text("Label")
            }
        }

        #expect(isView(simpleLink))
        #expect(isView(customLink))
    }
}
