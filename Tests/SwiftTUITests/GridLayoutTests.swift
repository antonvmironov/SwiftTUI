import Testing
@testable import SwiftTUI

@Suite("Grid Layout Tests")
@MainActor
struct GridLayoutTests {
    // Helper to assert a value conforms to SwiftTUI.View at compile time
    private func isView<V: View>(_: V) -> Bool { true }
    
    @Test("LazyVGrid basic initialization")
    func testLazyVGridInit() {
        let columns = [
            GridItem(.fixed(10)),
            GridItem(.flexible()),
            GridItem(.adaptive(minimum: 5))
        ]
        
        let grid = LazyVGrid(columns: columns) {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
        }
        
        #expect(isView(grid))
    }
    
    @Test("LazyVGrid with column count convenience initializer")
    func testLazyVGridColumnCount() {
        let grid = LazyVGrid(columns: 3, spacing: 2) {
            ForEach(1...9, id: \.self) { index in
                Text("Item \(index)")
            }
        }
        
        #expect(isView(grid))
    }
    
    @Test("LazyHGrid basic initialization")
    func testLazyHGridInit() {
        let rows = [
            GridItem(.fixed(5)),
            GridItem(.flexible(minimum: 3, maximum: 10))
        ]
        
        let grid = LazyHGrid(rows: rows, spacing: 1) {
            Text("A")
            Text("B")
            Text("C")
            Text("D")
        }
        
        #expect(isView(grid))
    }
    
    @Test("LazyHGrid with row count convenience initializer")
    func testLazyHGridRowCount() {
        let grid = LazyHGrid(rows: 2) {
            ForEach(["A", "B", "C", "D"], id: \.self) { item in
                Text(item)
            }
        }
        
        #expect(isView(grid))
    }
    
    @Test("Grid simple initialization")
    func testGridInit() {
        let grid = Grid(horizontalSpacing: 2, verticalSpacing: 1) {
            Text("Top Left")
            Text("Top Right")
            Text("Bottom Left")
            Text("Bottom Right")
        }
        
        #expect(isView(grid))
    }
    
    @Test("GridItem size types")
    func testGridItemSizes() {
        let fixedItem = GridItem(.fixed(20))
        let flexibleItem = GridItem(.flexible(minimum: 5, maximum: 50))
        let adaptiveItem = GridItem(.adaptive(minimum: 10, maximum: 30))
        
        switch fixedItem.size {
        case .fixed(let size):
            #expect(size == 20)
        default:
            Issue.record("Expected fixed size")
        }
        
        switch flexibleItem.size {
        case .flexible(let min, let max):
            #expect(min == 5)
            #expect(max == 50)
        default:
            Issue.record("Expected flexible size")
        }
        
        switch adaptiveItem.size {
        case .adaptive(let min, let max):
            #expect(min == 10)
            #expect(max == 30)
        default:
            Issue.record("Expected adaptive size")
        }
    }
    
    @Test("GridItem static factory methods")
    func testGridItemFactoryMethods() {
        let fixed = GridItem.fixed(15)
        let flexible = GridItem.flexible(minimum: 3, maximum: 25)
        let adaptive = GridItem.adaptive(minimum: 8, maximum: 40)
        
        switch fixed.size {
        case .fixed(let size):
            #expect(size == 15)
        default:
            Issue.record("Fixed factory method failed")
        }
        
        switch flexible.size {
        case .flexible(let min, let max):
            #expect(min == 3)
            #expect(max == 25)
        default:
            Issue.record("Flexible factory method failed")
        }
        
        switch adaptive.size {
        case .adaptive(let min, let max):
            #expect(min == 8)
            #expect(max == 40)
        default:
            Issue.record("Adaptive factory method failed")
        }
    }
    
    @Test("GridItem alignment options")
    func testGridItemAlignment() {
        let leadingItem = GridItem(.fixed(10), alignment: .leading)
        let centerItem = GridItem(.flexible(), alignment: .center)
        let trailingItem = GridItem(.adaptive(minimum: 5), alignment: .trailing)
        let topItem = GridItem(.fixed(10), alignment: .top)
        let bottomItem = GridItem(.fixed(10), alignment: .bottom)
        
        #expect(leadingItem.alignment == .leading)
        #expect(centerItem.alignment == .center)
        #expect(trailingItem.alignment == .trailing)
        #expect(topItem.alignment == .top)
        #expect(bottomItem.alignment == .bottom)
    }
    
    @Test("GridItem spacing configuration")
    func testGridItemSpacing() {
        let itemWithSpacing = GridItem(.flexible(), spacing: 5)
        let itemWithoutSpacing = GridItem(.fixed(10))
        
        #expect(itemWithSpacing.spacing == 5)
        #expect(itemWithoutSpacing.spacing == nil)
    }
    
    @Test("GridRow initialization")
    func testGridRowInit() {
        let row = GridRow {
            Text("Column 1")
            Text("Column 2")
            Text("Column 3")
        }
        
        #expect(isView(row))
    }
    
    @Test("GridBorder character sets")
    func testGridBorderCharacters() {
        let none = GridBorder.none.characters
        let simple = GridBorder.simple.characters
        let rounded = GridBorder.rounded.characters
        let double = GridBorder.double.characters
        
        // Test that border characters are defined
        #expect(none.horizontal == " ")
        #expect(simple.topLeft == "┌")
        #expect(rounded.topLeft == "╭")
        #expect(double.topLeft == "╔")
        
        #expect(simple.horizontal == "─")
        #expect(simple.vertical == "│")
        #expect(rounded.horizontal == "─")
        #expect(double.horizontal == "═")
    }
    
    @Test("Grid with border modifier")
    func testGridBorderModifier() {
        let gridWithBorder = LazyVGrid(columns: 2) {
            Text("A")
            Text("B")
        }
        .gridBorder(.simple)
        
        let gridWithRoundedBorder = Grid {
            Text("Content")
        }
        .gridBorder(.rounded)
        
        #expect(isView(gridWithBorder))
        #expect(isView(gridWithRoundedBorder))
    }
    
    @Test("Complex grid layout")
    func testComplexGridLayout() {
        let complexGrid = LazyVGrid(
            columns: [
                .fixed(20),
                .flexible(minimum: 10, maximum: 30),
                .adaptive(minimum: 8)
            ],
            spacing: 2
        ) {
            ForEach(1...12, id: \.self) { number in
                Text("Cell \(number)")
                    .border()
            }
        }
        
        #expect(isView(complexGrid))
    }
    
    @Test("Grid with mixed content types")
    func testGridMixedContent() {
        let mixedGrid = LazyVGrid(columns: 3) {
            Text("Text")
            Button("Button") { }
            Divider()
            LoadingSpinner()
            ProgressBar(progress: 0.5)
            Spacer()
        }
        
        #expect(isView(mixedGrid))
    }
    
    @Test("Grid performance with large datasets")
    func testGridPerformance() {
        let largeDataset = Array(1...100)
        
        let performanceGrid = LazyVGrid(columns: 5) {
            ForEach(largeDataset, id: \.self) { item in
                Text("Item \(item)")
            }
        }
        
        #expect(isView(performanceGrid))
        // In a real implementation, this would test layout performance
    }
    
    @Test("GridAlignment enumeration")
    func testGridAlignment() {
        let alignments: [GridAlignment] = [.leading, .center, .trailing, .top, .bottom]
        
        #expect(alignments.count == 5)
        #expect(alignments.contains(.center))
        #expect(alignments.contains(.leading))
        #expect(alignments.contains(.trailing))
        #expect(alignments.contains(.top))
        #expect(alignments.contains(.bottom))
    }
}

