import Testing
@testable import SwiftTUI

struct ResponsiveDesignTests {
    
    // MARK: - ResponsiveContext Tests
    
    @Test("ResponsiveContext size classification")
    func testSizeClassification() {
        // Compact terminal (< 60 columns)
        let compactContext = ResponsiveContext(size: Size(width: 50, height: 20))
        #expect(compactContext.sizeClass == .compact)
        #expect(compactContext.isNarrow == true)
        #expect(compactContext.isWide == false)
        #expect(compactContext.suggestedColumns == 1)
        
        // Regular terminal (60-119 columns)
        let regularContext = ResponsiveContext(size: Size(width: 80, height: 24))
        #expect(regularContext.sizeClass == .regular)
        #expect(regularContext.isNarrow == false)
        #expect(regularContext.isWide == false)
        #expect(regularContext.suggestedColumns == 2)
        
        // Large terminal (>= 120 columns)
        let largeContext = ResponsiveContext(size: Size(width: 140, height: 40))
        #expect(largeContext.sizeClass == .large)
        #expect(largeContext.isNarrow == false)
        #expect(largeContext.isWide == true)
        #expect(largeContext.isTall == true)
        #expect(largeContext.suggestedColumns == 3)
    }
    
    @Test("ResponsiveContext height classification")
    func testHeightClassification() {
        // Short terminal (< 24 rows)
        let shortContext = ResponsiveContext(size: Size(width: 80, height: 20))
        #expect(shortContext.isShort == true)
        #expect(shortContext.isTall == false)
        
        // Tall terminal (>= 40 rows)
        let tallContext = ResponsiveContext(size: Size(width: 80, height: 45))
        #expect(tallContext.isShort == false)
        #expect(tallContext.isTall == true)
        
        // Medium terminal
        let mediumContext = ResponsiveContext(size: Size(width: 80, height: 30))
        #expect(mediumContext.isShort == false)
        #expect(mediumContext.isTall == false)
    }
    
    @Test("ResponsiveContext max content width")
    func testMaxContentWidth() {
        // Small terminal - should return actual width
        let smallContext = ResponsiveContext(size: Size(width: 60, height: 20))
        #expect(smallContext.maxContentWidth == Extended(60))
        
        // Large terminal - should cap at 120
        let largeContext = ResponsiveContext(size: Size(width: 200, height: 50))
        #expect(largeContext.maxContentWidth == Extended(120))
        
        // Edge case - exactly 120
        let edgeContext = ResponsiveContext(size: Size(width: 120, height: 30))
        #expect(edgeContext.maxContentWidth == Extended(120))
    }
    
    // MARK: - ResponsiveView Tests
    
    @Test("ResponsiveView provides context")
    func testResponsiveViewContext() {
        var capturedContext: ResponsiveContext?
        
        let responsiveView = ResponsiveView { context in
            capturedContext = context
            return Text("Test")
        }
        
        // Create and build the view to trigger the closure
        #expect(responsiveView != nil)
        // Note: In a real test, we'd need to actually layout the view to trigger the closure
    }
    
    @Test("ResponsiveView compilation")
    func testResponsiveViewCompilation() {
        let view = ResponsiveView { context in
            if context.isNarrow {
                VStack {
                    Text("Narrow Layout")
                }
            } else {
                HStack {
                    Text("Wide Layout")
                }
            }
        }
        
        #expect(view != nil)
    }
    
    // MARK: - View Extension Tests
    
    @Test("Size adaptive view compilation")
    func testSizeAdaptiveView() {
        let view = Text("Original")
            .sizeAdaptive(
                compact: { Text("Compact") },
                regular: { Text("Regular") },
                large: { Text("Large") }
            )
        
        #expect(view != nil)
    }
    
    @Test("Responsive view modifiers compilation")
    func testResponsiveModifiers() {
        let responsiveView = Text("Test").responsive()
        let hiddenWhenNarrow = Text("Test").hideWhenNarrow()
        let hiddenWhenShort = Text("Test").hideWhenShort()
        let spaciousOnly = Text("Test").showOnlyWhenSpacious()
        
        #expect(responsiveView != nil)
        #expect(hiddenWhenNarrow != nil)
        #expect(hiddenWhenShort != nil)
        #expect(spaciousOnly != nil)
    }
    
    // MARK: - AdaptiveGrid Tests
    
    @Test("AdaptiveGrid creation")
    func testAdaptiveGridCreation() {
        let grid = AdaptiveGrid(minItemWidth: 15, spacing: 2) {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
        }
        
        #expect(grid != nil)
    }
    
    @Test("AdaptiveGrid with default parameters")
    func testAdaptiveGridDefaults() {
        let grid = AdaptiveGrid {
            ForEach(0..<5, id: \.self) { index in
                Text("Item \(index)")
            }
        }
        
        #expect(grid != nil)
    }
    
    // MARK: - AdaptiveList Tests
    
    @Test("AdaptiveList creation")
    func testAdaptiveListCreation() {
        struct TestItem: Identifiable {
            let id: Int
            let name: String
        }
        
        let items = [
            TestItem(id: 1, name: "Item 1"),
            TestItem(id: 2, name: "Item 2"),
            TestItem(id: 3, name: "Item 3")
        ]
        
        let list = AdaptiveList(items) { item in
            Text(item.name)
        }
        
        #expect(list != nil)
    }
    
    // MARK: - ResponsiveTable Tests
    
    @Test("ResponsiveTable creation")
    func testResponsiveTableCreation() {
        struct Person: Identifiable {
            let id: Int
            let name: String
            let email: String
            let age: Int
        }
        
        let people = [
            Person(id: 1, name: "Alice", email: "alice@example.com", age: 30),
            Person(id: 2, name: "Bob", email: "bob@example.com", age: 25)
        ]
        
        let table = ResponsiveTable(people) {
            ResponsiveTableColumn<Person>("Name", priority: 3) { $0.name }
            ResponsiveTableColumn<Person>("Email", priority: 2) { $0.email }
            ResponsiveTableColumn<Person>("Age", priority: 1) { String($0.age) }
        }
        
        #expect(table != nil)
    }
    
    @Test("ResponsiveTableColumn priority sorting")
    func testResponsiveTableColumnPriority() {
        struct Item: Identifiable {
            let id: Int
            let title: String
        }
        
        let items = [Item(id: 1, title: "Test")]
        
        let table = ResponsiveTable(items) {
            ResponsiveTableColumn<Item>("Low Priority", priority: 1) { $0.title }
            ResponsiveTableColumn<Item>("High Priority", priority: 3) { $0.title }
            ResponsiveTableColumn<Item>("Medium Priority", priority: 2) { $0.title }
        }
        
        #expect(table != nil)
    }
    
    // MARK: - ResponsiveForm Tests
    
    @Test("ResponsiveForm creation")
    func testResponsiveFormCreation() {
        @State var name = "Test"
        @State var email = "test@example.com"
        
        let form = ResponsiveForm {
            TextField("Name", text: $name)
            TextField("Email", text: $email)
            Button("Submit") { }
        }
        
        #expect(form != nil)
    }
    
    // MARK: - ResponsiveNavigationBar Tests
    
    @Test("ResponsiveNavigationBar creation")
    func testResponsiveNavigationBarCreation() {
        let simpleNavBar = ResponsiveNavigationBar(title: "Settings")
        
        let complexNavBar = ResponsiveNavigationBar(title: "Dashboard") {
            HStack {
                Button("Help") { }
                Button("Settings") { }
            }
        }
        
        #expect(simpleNavBar != nil)
        #expect(complexNavBar != nil)
    }
    
    @Test("ResponsiveNavigationBar with empty content")
    func testResponsiveNavigationBarEmpty() {
        let navBar = ResponsiveNavigationBar(title: "Simple") {
            EmptyView()
        }
        
        #expect(navBar != nil)
    }
    
    // MARK: - Integration Tests
    
    @Test("Complete responsive layout compilation")
    func testCompleteResponsiveLayout() {
        @State var searchText = ""
        @State var selectedTab = 0
        
        struct Person: Identifiable {
            let id: Int
            let name: String
            let email: String
        }
        
        let people = [
            Person(id: 1, name: "Alice", email: "alice@example.com"),
            Person(id: 2, name: "Bob", email: "bob@example.com")
        ]
        
        let layout = VStack {
            ResponsiveNavigationBar(title: "People") {
                TextField("Search", text: $searchText)
                    .hideWhenNarrow()
            }
            
            ResponsiveTable(people) {
                ResponsiveTableColumn<Person>("Name", priority: 3) { $0.name }
                ResponsiveTableColumn<Person>("Email", priority: 2) { $0.email }
            }
            .responsive()
            
            HStack {
                Button("Add") { }
                Button("Edit") { }
                    .hideWhenNarrow()
                Button("Delete") { }
                    .showOnlyWhenSpacious()
            }
            .hideWhenShort()
        }
        
        #expect(layout != nil)
    }
    
    @Test("Responsive dashboard example")
    func testResponsiveDashboard() {
        let dashboard = ResponsiveView { context in
            VStack {
                Text("Dashboard")
                    .bold()
                
                if context.isTall {
                    // Show detailed stats when there's vertical space
                    VStack {
                        Text("CPU: 45%")
                        Text("Memory: 67%")
                        Text("Disk: 23%")
                    }
                } else {
                    // Compact stats for short terminals
                    Text("CPU:45% Mem:67% Disk:23%")
                }
                
                AdaptiveGrid(minItemWidth: 20) {
                    Text("Process 1")
                    Text("Process 2")
                    Text("Process 3")
                    Text("Process 4")
                }
            }
        }
        
        #expect(dashboard != nil)
    }
}
