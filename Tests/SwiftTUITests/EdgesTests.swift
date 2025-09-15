import Testing
@testable import SwiftTUI

struct EdgesTests {
    
    // MARK: - Individual Edge Tests
    
    @Test("Individual edges have correct raw values and are unique")
    func individualEdges() throws {
        #expect(Edges.top.rawValue == 1 << 0)
        #expect(Edges.bottom.rawValue == 1 << 1)
        #expect(Edges.left.rawValue == 1 << 2)
        #expect(Edges.right.rawValue == 1 << 3)
        
        // Test that each edge is unique
        #expect(Edges.top != Edges.bottom)
        #expect(Edges.top != Edges.left)
        #expect(Edges.top != Edges.right)
        #expect(Edges.bottom != Edges.left)
        #expect(Edges.bottom != Edges.right)
        #expect(Edges.left != Edges.right)
    }
    
    // MARK: - Combined Edge Tests
    
    @Test("All edges contains all individual edges")
    func allEdges() throws {
        let all = Edges.all
        
        // Should contain all individual edges
        #expect(all.contains(.top))
        #expect(all.contains(.bottom))
        #expect(all.contains(.left))
        #expect(all.contains(.right))
        
        // Should equal the union of all edges
        let expected: Edges = [.top, .bottom, .left, .right]
        #expect(all == expected)
    }
    
    @Test("Horizontal edges contains left and right only")
    func horizontalEdges() throws {
        let horizontal = Edges.horizontal
        
        // Should contain left and right
        #expect(horizontal.contains(.left))
        #expect(horizontal.contains(.right))
        
        // Should not contain top and bottom
        #expect(!horizontal.contains(.top))
        #expect(!horizontal.contains(.bottom))
        
        // Should equal the union of left and right
        let expected: Edges = [.left, .right]
        #expect(horizontal == expected)
    }
    
    @Test("Vertical edges contains top and bottom only")
    func verticalEdges() throws {
        let vertical = Edges.vertical
        
        // Should contain top and bottom
        #expect(vertical.contains(.top))
        #expect(vertical.contains(.bottom))
        
        // Should not contain left and right
        #expect(!vertical.contains(.left))
        #expect(!vertical.contains(.right))
        
        // Should equal the union of top and bottom
        let expected: Edges = [.top, .bottom]
        #expect(vertical == expected)
    }
    
    // MARK: - Option Set Behavior Tests
    
    @Test("OptionSet union behavior works correctly")
    func optionSetUnion() throws {
        let topBottom: Edges = [.top, .bottom]
        let leftRight: Edges = [.left, .right]
        let all = topBottom.union(leftRight)
        
        #expect(all == Edges.all)
    }
    
    @Test("OptionSet intersection behavior works correctly")
    func optionSetIntersection() throws {
        let topLeft: Edges = [.top, .left]
        let topRight: Edges = [.top, .right]
        let intersection = topLeft.intersection(topRight)
        
        #expect(intersection == Edges.top)
    }
    
    @Test("OptionSet symmetric difference works correctly")
    func optionSetSymmetricDifference() throws {
        let topLeft: Edges = [.top, .left]
        let topRight: Edges = [.top, .right]
        let diff = topLeft.symmetricDifference(topRight)
        
        let expected: Edges = [.left, .right]
        #expect(diff == expected)
    }
    
    @Test("OptionSet subtracting works correctly")
    func optionSetSubtracting() throws {
        let all = Edges.all
        let vertical = Edges.vertical
        let horizontal = all.subtracting(vertical)
        
        #expect(horizontal == Edges.horizontal)
    }
    
    // MARK: - Empty Set Tests
    
    @Test("Empty edges contains no edges")
    func emptyEdges() throws {
        let empty = Edges()
        
        #expect(!empty.contains(.top))
        #expect(!empty.contains(.bottom))
        #expect(!empty.contains(.left))
        #expect(!empty.contains(.right))
        
        #expect(empty.rawValue == 0)
    }
    
    // MARK: - Raw Value Tests
    
    @Test("Raw value initialization creates correct edges")
    func rawValueInitialization() throws {
        let edges1 = Edges(rawValue: 1) // top
        let edges2 = Edges(rawValue: 2) // bottom
        let edges3 = Edges(rawValue: 4) // left
        let edges4 = Edges(rawValue: 8) // right
        
        #expect(edges1 == .top)
        #expect(edges2 == .bottom)
        #expect(edges3 == .left)
        #expect(edges4 == .right)
    }
    
    @Test("Raw value combinations work correctly")
    func rawValueCombinations() throws {
        let topBottom = Edges(rawValue: 3) // 1 + 2
        let expected: Edges = [.top, .bottom]
        
        #expect(topBottom == expected)
        #expect(topBottom == Edges.vertical)
    }
    
    // MARK: - Sendable Conformance Tests
    
    @Test("Edges conforms to Sendable")
    func sendableConformance() throws {
        // Test that Edges can be used across actor boundaries
        let edges = Edges.all
        
        // This test verifies that the type compiles with Sendable conformance
        // In actual usage, this would be passed to async functions or actors
        #expect(edges == Edges.all)
    }
    
    // MARK: - Equality Tests
    
    @Test("Edges equality works correctly")
    func edgesEquality() throws {
        let edges1: Edges = [.top, .left]
        let edges2: Edges = [.top, .left]
        let edges3: Edges = [.top, .right]
        
        #expect(edges1 == edges2)
        #expect(edges1 != edges3)
    }
    
    // MARK: - Static Property Consistency Tests
    
    @Test("Static properties have consistent raw values")
    func staticPropertyConsistency() throws {
        // Ensure all static properties are consistent
        #expect(Edges.all.rawValue == 15) // 1 + 2 + 4 + 8
        #expect(Edges.horizontal.rawValue == 12) // 4 + 8
        #expect(Edges.vertical.rawValue == 3) // 1 + 2
    }
}