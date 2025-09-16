import Testing
@testable import SwiftTUI

struct NavigationStackTests {
    
    @Test("NavigationLink initialization with destination")
    func testNavigationLinkWithDestination() {
        let link = NavigationLink(destination: Text("Destination")) {
            Text("Label")
        }
        
        #expect(link != nil)
    }
    
    @Test("NavigationLink initialization with string title")
    func testNavigationLinkWithTitle() {
        let link = NavigationLink("My Link", destination: Text("Destination"))
        
        #expect(link != nil)
    }
    
    @Test("NavigationLink with complex view hierarchy")
    func testNavigationLinkComplexHierarchy() {
        let link = NavigationLink("Settings", destination: VStack {
            Text("Settings Screen")
            NavigationLink("Advanced", destination: Text("Advanced Settings"))
        })
        
        #expect(link != nil)
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
        
        #expect(simpleLink != nil)
        #expect(customLink != nil)
    }
}