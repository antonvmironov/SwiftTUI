import XCTest
@testable import SwiftTUI

final class EdgesTests: XCTestCase {
    
    // MARK: - Individual Edge Tests
    
    func testIndividualEdges() throws {
        XCTAssertEqual(Edges.top.rawValue, 1 << 0)
        XCTAssertEqual(Edges.bottom.rawValue, 1 << 1)
        XCTAssertEqual(Edges.left.rawValue, 1 << 2)
        XCTAssertEqual(Edges.right.rawValue, 1 << 3)
        
        // Test that each edge is unique
        XCTAssertNotEqual(Edges.top, Edges.bottom)
        XCTAssertNotEqual(Edges.top, Edges.left)
        XCTAssertNotEqual(Edges.top, Edges.right)
        XCTAssertNotEqual(Edges.bottom, Edges.left)
        XCTAssertNotEqual(Edges.bottom, Edges.right)
        XCTAssertNotEqual(Edges.left, Edges.right)
    }
    
    // MARK: - Combined Edge Tests
    
    func testAllEdges() throws {
        let all = Edges.all
        
        // Should contain all individual edges
        XCTAssertTrue(all.contains(.top))
        XCTAssertTrue(all.contains(.bottom))
        XCTAssertTrue(all.contains(.left))
        XCTAssertTrue(all.contains(.right))
        
        // Should equal the union of all edges
        let expected: Edges = [.top, .bottom, .left, .right]
        XCTAssertEqual(all, expected)
    }
    
    func testHorizontalEdges() throws {
        let horizontal = Edges.horizontal
        
        // Should contain left and right
        XCTAssertTrue(horizontal.contains(.left))
        XCTAssertTrue(horizontal.contains(.right))
        
        // Should not contain top and bottom
        XCTAssertFalse(horizontal.contains(.top))
        XCTAssertFalse(horizontal.contains(.bottom))
        
        // Should equal the union of left and right
        let expected: Edges = [.left, .right]
        XCTAssertEqual(horizontal, expected)
    }
    
    func testVerticalEdges() throws {
        let vertical = Edges.vertical
        
        // Should contain top and bottom
        XCTAssertTrue(vertical.contains(.top))
        XCTAssertTrue(vertical.contains(.bottom))
        
        // Should not contain left and right
        XCTAssertFalse(vertical.contains(.left))
        XCTAssertFalse(vertical.contains(.right))
        
        // Should equal the union of top and bottom
        let expected: Edges = [.top, .bottom]
        XCTAssertEqual(vertical, expected)
    }
    
    // MARK: - Option Set Behavior Tests
    
    func testOptionSetUnion() throws {
        let topBottom: Edges = [.top, .bottom]
        let leftRight: Edges = [.left, .right]
        let all = topBottom.union(leftRight)
        
        XCTAssertEqual(all, Edges.all)
    }
    
    func testOptionSetIntersection() throws {
        let topLeft: Edges = [.top, .left]
        let topRight: Edges = [.top, .right]
        let intersection = topLeft.intersection(topRight)
        
        XCTAssertEqual(intersection, Edges.top)
    }
    
    func testOptionSetSymmetricDifference() throws {
        let topLeft: Edges = [.top, .left]
        let topRight: Edges = [.top, .right]
        let diff = topLeft.symmetricDifference(topRight)
        
        let expected: Edges = [.left, .right]
        XCTAssertEqual(diff, expected)
    }
    
    func testOptionSetSubtracting() throws {
        let all = Edges.all
        let vertical = Edges.vertical
        let horizontal = all.subtracting(vertical)
        
        XCTAssertEqual(horizontal, Edges.horizontal)
    }
    
    // MARK: - Empty Set Tests
    
    func testEmptyEdges() throws {
        let empty = Edges()
        
        XCTAssertFalse(empty.contains(.top))
        XCTAssertFalse(empty.contains(.bottom))
        XCTAssertFalse(empty.contains(.left))
        XCTAssertFalse(empty.contains(.right))
        
        XCTAssertEqual(empty.rawValue, 0)
    }
    
    // MARK: - Raw Value Tests
    
    func testRawValueInitialization() throws {
        let edges1 = Edges(rawValue: 1) // top
        let edges2 = Edges(rawValue: 2) // bottom
        let edges3 = Edges(rawValue: 4) // left
        let edges4 = Edges(rawValue: 8) // right
        
        XCTAssertEqual(edges1, .top)
        XCTAssertEqual(edges2, .bottom)
        XCTAssertEqual(edges3, .left)
        XCTAssertEqual(edges4, .right)
    }
    
    func testRawValueCombinations() throws {
        let topBottom = Edges(rawValue: 3) // 1 + 2
        let expected: Edges = [.top, .bottom]
        
        XCTAssertEqual(topBottom, expected)
        XCTAssertEqual(topBottom, Edges.vertical)
    }
    
    // MARK: - Sendable Conformance Tests
    
    func testSendableConformance() throws {
        // Test that Edges can be used across actor boundaries
        let edges = Edges.all
        
        // This test verifies that the type compiles with Sendable conformance
        // In actual usage, this would be passed to async functions or actors
        XCTAssertEqual(edges, Edges.all)
    }
    
    // MARK: - Equality Tests
    
    func testEdgesEquality() throws {
        let edges1: Edges = [.top, .left]
        let edges2: Edges = [.top, .left]
        let edges3: Edges = [.top, .right]
        
        XCTAssertEqual(edges1, edges2)
        XCTAssertNotEqual(edges1, edges3)
    }
    
    // MARK: - Static Property Consistency Tests
    
    func testStaticPropertyConsistency() throws {
        // Ensure all static properties are consistent
        XCTAssertEqual(Edges.all.rawValue, 15) // 1 + 2 + 4 + 8
        XCTAssertEqual(Edges.horizontal.rawValue, 12) // 4 + 8
        XCTAssertEqual(Edges.vertical.rawValue, 3) // 1 + 2
    }
}