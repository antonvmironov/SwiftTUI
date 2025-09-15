import XCTest
@testable import SwiftTUI

final class CellTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() throws {
        let cell = Cell(char: "A")
        
        XCTAssertEqual(cell.char, "A")
        XCTAssertEqual(cell.foregroundColor, Color.default)
        XCTAssertNil(cell.backgroundColor)
        XCTAssertEqual(cell.attributes, CellAttributes())
    }
    
    func testFullInitialization() throws {
        let attributes = CellAttributes(bold: true, italic: true)
        let cell = Cell(
            char: "B",
            foregroundColor: Color.red,
            backgroundColor: Color.blue,
            attributes: attributes
        )
        
        XCTAssertEqual(cell.char, "B")
        XCTAssertEqual(cell.foregroundColor, Color.red)
        XCTAssertEqual(cell.backgroundColor, Color.blue)
        XCTAssertEqual(cell.attributes, attributes)
    }
    
    func testPartialInitialization() throws {
        let cell = Cell(char: "C", foregroundColor: Color.green)
        
        XCTAssertEqual(cell.char, "C")
        XCTAssertEqual(cell.foregroundColor, Color.green)
        XCTAssertNil(cell.backgroundColor)
        XCTAssertEqual(cell.attributes, CellAttributes())
    }
    
    func testInitializationWithBackgroundOnly() throws {
        let cell = Cell(char: "D", backgroundColor: Color.yellow)
        
        XCTAssertEqual(cell.char, "D")
        XCTAssertEqual(cell.foregroundColor, Color.default)
        XCTAssertEqual(cell.backgroundColor, Color.yellow)
        XCTAssertEqual(cell.attributes, CellAttributes())
    }
    
    func testInitializationWithAttributesOnly() throws {
        let attributes = CellAttributes(underline: true)
        let cell = Cell(char: "E", attributes: attributes)
        
        XCTAssertEqual(cell.char, "E")
        XCTAssertEqual(cell.foregroundColor, Color.default)
        XCTAssertNil(cell.backgroundColor)
        XCTAssertEqual(cell.attributes, attributes)
    }
    
    // MARK: - Character Tests
    
    func testDifferentCharacters() throws {
        let alphanumeric = Cell(char: "1")
        let special = Cell(char: "@")
        let unicode = Cell(char: "🚀")
        let space = Cell(char: " ")
        
        XCTAssertEqual(alphanumeric.char, "1")
        XCTAssertEqual(special.char, "@")
        XCTAssertEqual(unicode.char, "🚀")
        XCTAssertEqual(space.char, " ")
    }
    
    // MARK: - Equality Tests
    
    func testEquality() throws {
        let cell1 = Cell(char: "A", foregroundColor: Color.red)
        let cell2 = Cell(char: "A", foregroundColor: Color.red)
        let cell3 = Cell(char: "B", foregroundColor: Color.red)
        let cell4 = Cell(char: "A", foregroundColor: Color.blue)
        
        XCTAssertEqual(cell1, cell2)
        XCTAssertNotEqual(cell1, cell3)
        XCTAssertNotEqual(cell1, cell4)
    }
    
    func testEqualityWithBackground() throws {
        let cell1 = Cell(char: "A", backgroundColor: Color.red)
        let cell2 = Cell(char: "A", backgroundColor: Color.red)
        let cell3 = Cell(char: "A", backgroundColor: Color.blue)
        let cell4 = Cell(char: "A") // No background
        
        XCTAssertEqual(cell1, cell2)
        XCTAssertNotEqual(cell1, cell3)
        XCTAssertNotEqual(cell1, cell4)
    }
    
    func testEqualityWithAttributes() throws {
        let attributes1 = CellAttributes(bold: true)
        let attributes2 = CellAttributes(bold: true)
        let attributes3 = CellAttributes(italic: true)
        
        let cell1 = Cell(char: "A", attributes: attributes1)
        let cell2 = Cell(char: "A", attributes: attributes2)
        let cell3 = Cell(char: "A", attributes: attributes3)
        
        XCTAssertEqual(cell1, cell2)
        XCTAssertNotEqual(cell1, cell3)
    }
    
    func testFullEquality() throws {
        let attributes = CellAttributes(bold: true, italic: true)
        
        let cell1 = Cell(
            char: "A",
            foregroundColor: Color.red,
            backgroundColor: Color.blue,
            attributes: attributes
        )
        let cell2 = Cell(
            char: "A",
            foregroundColor: Color.red,
            backgroundColor: Color.blue,
            attributes: attributes
        )
        
        XCTAssertEqual(cell1, cell2)
    }
    
    // MARK: - Background Color Tests
    
    func testNilBackgroundColor() throws {
        let cell = Cell(char: "A")
        XCTAssertNil(cell.backgroundColor)
    }
    
    func testSetBackgroundColor() throws {
        var cell = Cell(char: "A")
        cell.backgroundColor = Color.green
        XCTAssertEqual(cell.backgroundColor, Color.green)
    }
    
    func testClearBackgroundColor() throws {
        var cell = Cell(char: "A", backgroundColor: Color.red)
        cell.backgroundColor = nil
        XCTAssertNil(cell.backgroundColor)
    }
    
    // MARK: - Property Modification Tests
    
    func testModifyChar() throws {
        var cell = Cell(char: "A")
        cell.char = "B"
        XCTAssertEqual(cell.char, "B")
    }
    
    func testModifyForegroundColor() throws {
        var cell = Cell(char: "A")
        cell.foregroundColor = Color.green
        XCTAssertEqual(cell.foregroundColor, Color.green)
    }
    
    func testModifyAttributes() throws {
        var cell = Cell(char: "A")
        let newAttributes = CellAttributes(bold: true, underline: true)
        cell.attributes = newAttributes
        XCTAssertEqual(cell.attributes, newAttributes)
    }
    
    // MARK: - Complex Scenarios Tests
    
    func testCellWithAllFeatures() throws {
        let attributes = CellAttributes(
            bold: true,
            italic: true,
            underline: true,
            strikethrough: true,
            inverted: true
        )
        
        let cell = Cell(
            char: "★",
            foregroundColor: Color.brightYellow,
            backgroundColor: Color.black,
            attributes: attributes
        )
        
        XCTAssertEqual(cell.char, "★")
        XCTAssertEqual(cell.foregroundColor, Color.brightYellow)
        XCTAssertEqual(cell.backgroundColor, Color.black)
        XCTAssertEqual(cell.attributes, attributes)
    }
    
    func testCellArrays() throws {
        let cells = [
            Cell(char: "H"),
            Cell(char: "e"),
            Cell(char: "l"),
            Cell(char: "l"),
            Cell(char: "o")
        ]
        
        XCTAssertEqual(cells.count, 5)
        XCTAssertEqual(cells[0].char, "H")
        XCTAssertEqual(cells[4].char, "o")
        
        // Test that different cells with same char are equal by default
        XCTAssertEqual(cells[2], cells[3]) // Both are "l"
    }
}