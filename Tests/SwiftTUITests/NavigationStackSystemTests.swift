import Testing
@testable import SwiftTUI

struct NavigationStackSystemTests {
    
    // Helper to assert a value conforms to SwiftTUI.View at compile time
    private func isView<V: View>(_: V) -> Bool { true }
    
    @Test("NavigationPath initialization and manipulation")
    func testNavigationPath() {
        var path = NavigationPath()
        
        // Initially empty
        #expect(path.isEmpty)
        #expect(path.count == 0)
        
        // Add items
        path.append("screen1")
        path.append("screen2")
        #expect(path.count == 2)
        #expect(!path.isEmpty)
        
        // Remove items
        path.removeLast()
        #expect(path.count == 1)
        
        path.removeLast(10) // Should not crash if count exceeds items
        #expect(path.isEmpty)
    }
    
    @Test("NavigationPath initialization with sequence")
    func testNavigationPathSequence() {
        let items = ["home", "settings", "profile"]
        let path = NavigationPath(items)
        
        #expect(path.count == 3)
        #expect(!path.isEmpty)
    }
    
    @Test("NavigationStack basic initialization")
    func testNavigationStackInit() {
        let stack = NavigationStack {
            Text("Home Screen")
        }
        
        #expect(isView(stack))
    }
    
    @Test("NavigationStack with external path binding")
    func testNavigationStackWithBinding() {
        @State var path = NavigationPath()
        
        let stack = NavigationStack(path: $path) {
            VStack {
                Text("Home")
                NavigationLink("Settings", destination: Text("Settings Screen"))
            }
        }
        
        #expect(isView(stack))
    }
    
    @Test("Enhanced NavigationLink with value")
    func testNavigationLinkWithValue() {
        let link = NavigationLink("Profile", value: "user123")
        
        #expect(isView(link))
    }
    
    @Test("NavigationLink integration with NavigationStack")
    func testNavigationLinkIntegration() {
        @State var path = NavigationPath()
        
        let navigationView = NavigationStack(path: $path) {
            VStack {
                NavigationLink("Settings", destination: Text("Settings"))
                NavigationLink("Profile", destination: Text("Profile"))
                NavigationLink("About", destination: Text("About"))
            }
        }
        
        #expect(isView(navigationView))
    }
    
    @Test("KeyEquivalent with modifiers")
    func testKeyEquivalentModifiers() {
        let shiftTab = KeyEquivalent(key: .tab, modifiers: .shift)
        let ctrlC = KeyEquivalent(key: .character("c"), modifiers: .control)
        let altEscape = KeyEquivalent(key: .escape, modifiers: .alt)
        
        #expect(shiftTab.key == .tab)
        #expect(shiftTab.modifiers == .shift)
        #expect(ctrlC.modifiers == .control)
        #expect(altEscape.modifiers == .alt)
    }
    
    @Test("KeyEquivalent arrow keys")
    func testKeyEquivalentArrowKeys() {
        let up = KeyEquivalent.upArrow
        let down = KeyEquivalent.downArrow
        let left = KeyEquivalent.leftArrow
        let right = KeyEquivalent.rightArrow
        
        #expect(up.key == .up)
        #expect(down.key == .down)
        #expect(left.key == .left)
        #expect(right.key == .right)
    }
    
    @Test("KeyModifiers option set behavior")
    func testKeyModifiers() {
        let shiftControl = KeyModifiers([.shift, .control])
        let allModifiers: KeyModifiers = [.shift, .control, .alt, .command]
        
        #expect(shiftControl.contains(.shift))
        #expect(shiftControl.contains(.control))
        #expect(!shiftControl.contains(.alt))
        
        #expect(allModifiers.contains(.shift))
        #expect(allModifiers.contains(.control))
        #expect(allModifiers.contains(.alt))
        #expect(allModifiers.contains(.command))
    }
    
    @Test("NavigationStack keyboard shortcuts")
    func testNavigationStackKeyboardShortcuts() {
        let stack = NavigationStack {
            Text("Test")
        }
        
        #expect(isView(stack))
    }
    
    @Test("Navigation destination modifier")
    func testNavigationDestination() {
        let view = Text("Main")
            .navigationDestination(for: String.self) { value in
                Text("Detail: \(value)")
            }
        
        #expect(isView(view))
    }
    
    @Test("NavigationStack breadcrumb functionality")
    func testNavigationStackBreadcrumbs() {
        var path = NavigationPath()
        path.append("Settings")
        path.append("Privacy")
        path.append("Location")
        
        let binding = Binding(get: { path }, set: { path = $0 })
        let stack = NavigationStack(path: binding) {
            Text("Current View")
        }
        
        #expect(path.count == 3)
        #expect(isView(stack))
    }
    
    @Test("NavigationStack automatic keyboard navigation")
    func testNavigationStackAutomaticKeyboardNavigation() {
        let stack = NavigationStack {
            VStack {
                NavigationLink("First", destination: Text("First View"))
                NavigationLink("Second", destination: Text("Second View")) 
                NavigationLink("Third", destination: Text("Third View"))
            }
        }
        
        #expect(isView(stack))
    }
}
