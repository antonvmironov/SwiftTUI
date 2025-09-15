import XCTest
@testable import SwiftTUI

final class AlignmentTests: XCTestCase {
    
    // MARK: - VerticalAlignment Tests
    
    func testVerticalAlignmentCases() throws {
        let allCases = VerticalAlignment.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.top))
        XCTAssertTrue(allCases.contains(.center))
        XCTAssertTrue(allCases.contains(.bottom))
    }
    
    func testVerticalAlignmentDescription() throws {
        XCTAssertEqual(VerticalAlignment.top.description, "top")
        XCTAssertEqual(VerticalAlignment.center.description, "center")
        XCTAssertEqual(VerticalAlignment.bottom.description, "bottom")
    }
    
    func testVerticalAlignmentEquality() throws {
        XCTAssertEqual(VerticalAlignment.top, VerticalAlignment.top)
        XCTAssertEqual(VerticalAlignment.center, VerticalAlignment.center)
        XCTAssertEqual(VerticalAlignment.bottom, VerticalAlignment.bottom)
        
        XCTAssertNotEqual(VerticalAlignment.top, VerticalAlignment.center)
        XCTAssertNotEqual(VerticalAlignment.center, VerticalAlignment.bottom)
        XCTAssertNotEqual(VerticalAlignment.top, VerticalAlignment.bottom)
    }
    
    func testVerticalAlignmentHashable() throws {
        let alignment1 = VerticalAlignment.top
        let alignment2 = VerticalAlignment.top
        let alignment3 = VerticalAlignment.center
        
        XCTAssertEqual(alignment1.hashValue, alignment2.hashValue)
        XCTAssertNotEqual(alignment1.hashValue, alignment3.hashValue)
        
        // Test that they can be used in sets
        let alignmentSet: Set<VerticalAlignment> = [.top, .center, .top]
        XCTAssertEqual(alignmentSet.count, 2)
    }
    
    // MARK: - HorizontalAlignment Tests
    
    func testHorizontalAlignmentCases() throws {
        let allCases = HorizontalAlignment.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.leading))
        XCTAssertTrue(allCases.contains(.center))
        XCTAssertTrue(allCases.contains(.trailing))
    }
    
    func testHorizontalAlignmentDescription() throws {
        XCTAssertEqual(HorizontalAlignment.leading.description, "leading")
        XCTAssertEqual(HorizontalAlignment.center.description, "center")
        XCTAssertEqual(HorizontalAlignment.trailing.description, "trailing")
    }
    
    func testHorizontalAlignmentEquality() throws {
        XCTAssertEqual(HorizontalAlignment.leading, HorizontalAlignment.leading)
        XCTAssertEqual(HorizontalAlignment.center, HorizontalAlignment.center)
        XCTAssertEqual(HorizontalAlignment.trailing, HorizontalAlignment.trailing)
        
        XCTAssertNotEqual(HorizontalAlignment.leading, HorizontalAlignment.center)
        XCTAssertNotEqual(HorizontalAlignment.center, HorizontalAlignment.trailing)
        XCTAssertNotEqual(HorizontalAlignment.leading, HorizontalAlignment.trailing)
    }
    
    func testHorizontalAlignmentHashable() throws {
        let alignment1 = HorizontalAlignment.leading
        let alignment2 = HorizontalAlignment.leading
        let alignment3 = HorizontalAlignment.center
        
        XCTAssertEqual(alignment1.hashValue, alignment2.hashValue)
        XCTAssertNotEqual(alignment1.hashValue, alignment3.hashValue)
        
        // Test that they can be used in sets
        let alignmentSet: Set<HorizontalAlignment> = [.leading, .center, .leading]
        XCTAssertEqual(alignmentSet.count, 2)
    }
    
    // MARK: - Alignment Tests
    
    func testAlignmentInitialization() throws {
        let alignment = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        XCTAssertEqual(alignment.horizontalAlignment, .leading)
        XCTAssertEqual(alignment.verticalAlignment, .top)
    }
    
    func testAlignmentDescription() throws {
        let alignment1 = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        XCTAssertEqual(alignment1.description, "leading-top")
        
        let alignment2 = Alignment(horizontalAlignment: .center, verticalAlignment: .bottom)
        XCTAssertEqual(alignment2.description, "center-bottom")
        
        let alignment3 = Alignment(horizontalAlignment: .trailing, verticalAlignment: .center)
        XCTAssertEqual(alignment3.description, "trailing-center")
    }
    
    func testAlignmentEquality() throws {
        let alignment1 = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        let alignment2 = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        let alignment3 = Alignment(horizontalAlignment: .center, verticalAlignment: .top)
        let alignment4 = Alignment(horizontalAlignment: .leading, verticalAlignment: .center)
        
        XCTAssertEqual(alignment1, alignment2)
        XCTAssertNotEqual(alignment1, alignment3)
        XCTAssertNotEqual(alignment1, alignment4)
        XCTAssertNotEqual(alignment3, alignment4)
    }
    
    func testAlignmentHashable() throws {
        let alignment1 = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        let alignment2 = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        let alignment3 = Alignment(horizontalAlignment: .center, verticalAlignment: .top)
        
        XCTAssertEqual(alignment1.hashValue, alignment2.hashValue)
        XCTAssertNotEqual(alignment1.hashValue, alignment3.hashValue)
        
        // Test that they can be used in sets
        let alignmentSet: Set<Alignment> = [alignment1, alignment2, alignment3]
        XCTAssertEqual(alignmentSet.count, 2)
    }
    
    // MARK: - Static Alignment Tests
    
    func testStaticAlignments() throws {
        // Test all static alignments
        XCTAssertEqual(Alignment.top.horizontalAlignment, .center)
        XCTAssertEqual(Alignment.top.verticalAlignment, .top)
        
        XCTAssertEqual(Alignment.bottom.horizontalAlignment, .center)
        XCTAssertEqual(Alignment.bottom.verticalAlignment, .bottom)
        
        XCTAssertEqual(Alignment.center.horizontalAlignment, .center)
        XCTAssertEqual(Alignment.center.verticalAlignment, .center)
        
        XCTAssertEqual(Alignment.topLeading.horizontalAlignment, .leading)
        XCTAssertEqual(Alignment.topLeading.verticalAlignment, .top)
        
        XCTAssertEqual(Alignment.leading.horizontalAlignment, .leading)
        XCTAssertEqual(Alignment.leading.verticalAlignment, .center)
        
        XCTAssertEqual(Alignment.bottomLeading.horizontalAlignment, .leading)
        XCTAssertEqual(Alignment.bottomLeading.verticalAlignment, .bottom)
        
        XCTAssertEqual(Alignment.topTrailing.horizontalAlignment, .trailing)
        XCTAssertEqual(Alignment.topTrailing.verticalAlignment, .top)
        
        XCTAssertEqual(Alignment.trailing.horizontalAlignment, .trailing)
        XCTAssertEqual(Alignment.trailing.verticalAlignment, .center)
        
        XCTAssertEqual(Alignment.bottomTrailing.horizontalAlignment, .trailing)
        XCTAssertEqual(Alignment.bottomTrailing.verticalAlignment, .bottom)
    }
    
    func testStaticAlignmentDescriptions() throws {
        XCTAssertEqual(Alignment.top.description, "center-top")
        XCTAssertEqual(Alignment.bottom.description, "center-bottom")
        XCTAssertEqual(Alignment.center.description, "center-center")
        XCTAssertEqual(Alignment.topLeading.description, "leading-top")
        XCTAssertEqual(Alignment.leading.description, "leading-center")
        XCTAssertEqual(Alignment.bottomLeading.description, "leading-bottom")
        XCTAssertEqual(Alignment.topTrailing.description, "trailing-top")
        XCTAssertEqual(Alignment.trailing.description, "trailing-center")
        XCTAssertEqual(Alignment.bottomTrailing.description, "trailing-bottom")
    }
    
    func testStaticAlignmentUniqueness() throws {
        let alignments = [
            Alignment.top, Alignment.bottom, Alignment.center,
            Alignment.topLeading, Alignment.leading, Alignment.bottomLeading,
            Alignment.topTrailing, Alignment.trailing, Alignment.bottomTrailing
        ]
        
        // All static alignments should be unique
        let alignmentSet = Set(alignments)
        XCTAssertEqual(alignmentSet.count, alignments.count)
    }
}