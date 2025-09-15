import XCTest
@testable import SwiftTUI

final class CellAttributesTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() throws {
        let attributes = CellAttributes()
        
        XCTAssertFalse(attributes.bold)
        XCTAssertFalse(attributes.italic)
        XCTAssertFalse(attributes.underline)
        XCTAssertFalse(attributes.strikethrough)
        XCTAssertFalse(attributes.inverted)
    }
    
    func testCustomInitialization() throws {
        let attributes = CellAttributes(
            bold: true,
            italic: false,
            underline: true,
            strikethrough: false,
            inverted: true
        )
        
        XCTAssertTrue(attributes.bold)
        XCTAssertFalse(attributes.italic)
        XCTAssertTrue(attributes.underline)
        XCTAssertFalse(attributes.strikethrough)
        XCTAssertTrue(attributes.inverted)
    }
    
    func testPartialInitialization() throws {
        let attributes = CellAttributes(bold: true, underline: true)
        
        XCTAssertTrue(attributes.bold)
        XCTAssertFalse(attributes.italic)
        XCTAssertTrue(attributes.underline)
        XCTAssertFalse(attributes.strikethrough)
        XCTAssertFalse(attributes.inverted)
    }
    
    // MARK: - Equality Tests
    
    func testEquality() throws {
        let attributes1 = CellAttributes(bold: true, italic: false)
        let attributes2 = CellAttributes(bold: true, italic: false)
        let attributes3 = CellAttributes(bold: false, italic: false)
        
        XCTAssertEqual(attributes1, attributes2)
        XCTAssertNotEqual(attributes1, attributes3)
    }
    
    func testEqualityWithAllProperties() throws {
        let attributes1 = CellAttributes(
            bold: true,
            italic: true,
            underline: true,
            strikethrough: true,
            inverted: true
        )
        let attributes2 = CellAttributes(
            bold: true,
            italic: true,
            underline: true,
            strikethrough: true,
            inverted: true
        )
        let attributes3 = CellAttributes(
            bold: true,
            italic: true,
            underline: true,
            strikethrough: true,
            inverted: false // Different
        )
        
        XCTAssertEqual(attributes1, attributes2)
        XCTAssertNotEqual(attributes1, attributes3)
    }
    
    // MARK: - Individual Property Tests
    
    func testBoldProperty() throws {
        var attributes = CellAttributes()
        XCTAssertFalse(attributes.bold)
        
        attributes.bold = true
        XCTAssertTrue(attributes.bold)
    }
    
    func testItalicProperty() throws {
        var attributes = CellAttributes()
        XCTAssertFalse(attributes.italic)
        
        attributes.italic = true
        XCTAssertTrue(attributes.italic)
    }
    
    func testUnderlineProperty() throws {
        var attributes = CellAttributes()
        XCTAssertFalse(attributes.underline)
        
        attributes.underline = true
        XCTAssertTrue(attributes.underline)
    }
    
    func testStrikethroughProperty() throws {
        var attributes = CellAttributes()
        XCTAssertFalse(attributes.strikethrough)
        
        attributes.strikethrough = true
        XCTAssertTrue(attributes.strikethrough)
    }
    
    func testInvertedProperty() throws {
        var attributes = CellAttributes()
        XCTAssertFalse(attributes.inverted)
        
        attributes.inverted = true
        XCTAssertTrue(attributes.inverted)
    }
    
    // MARK: - Combined Properties Tests
    
    func testMultipleAttributes() throws {
        let attributes = CellAttributes(bold: true, italic: true, underline: true)
        
        XCTAssertTrue(attributes.bold)
        XCTAssertTrue(attributes.italic)
        XCTAssertTrue(attributes.underline)
        XCTAssertFalse(attributes.strikethrough)
        XCTAssertFalse(attributes.inverted)
    }
    
    func testAllAttributesTrue() throws {
        let attributes = CellAttributes(
            bold: true,
            italic: true,
            underline: true,
            strikethrough: true,
            inverted: true
        )
        
        XCTAssertTrue(attributes.bold)
        XCTAssertTrue(attributes.italic)
        XCTAssertTrue(attributes.underline)
        XCTAssertTrue(attributes.strikethrough)
        XCTAssertTrue(attributes.inverted)
    }
}