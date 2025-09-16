import Testing
@testable import SwiftTUI

struct CellTests {
    
    // MARK: - Initialization Tests
    
    @Test("Default initialization sets correct defaults")
    func defaultInitialization() throws {
        let cell = Cell(char: "A")
        
        #expect(cell.char == "A")
        #expect(cell.foregroundColor == Color.default)
        #expect(cell.backgroundColor == nil)
        #expect(cell.attributes == CellAttributes())
    }
    
    @Test("Full initialization sets all properties correctly")
    func fullInitialization() throws {
        let attributes = CellAttributes(bold: true, italic: true)
        let cell = Cell(
            char: "B",
            foregroundColor: Color.red,
            backgroundColor: Color.blue,
            attributes: attributes
        )
        
        #expect(cell.char == "B")
        #expect(cell.foregroundColor == Color.red)
        #expect(cell.backgroundColor == Color.blue)
        #expect(cell.attributes == attributes)
    }
    
    @Test("Partial initialization uses defaults for unspecified properties")
    func partialInitialization() throws {
        let cell = Cell(char: "C", foregroundColor: Color.green)
        
        #expect(cell.char == "C")
        #expect(cell.foregroundColor == Color.green)
        #expect(cell.backgroundColor == nil)
        #expect(cell.attributes == CellAttributes())
    }
    
    @Test("Initialization with background only")
    func initializationWithBackgroundOnly() throws {
        let cell = Cell(char: "D", backgroundColor: Color.yellow)
        
        #expect(cell.char == "D")
        #expect(cell.foregroundColor == Color.default)
        #expect(cell.backgroundColor == Color.yellow)
        #expect(cell.attributes == CellAttributes())
    }
    
    @Test("Initialization with attributes only")
    func initializationWithAttributesOnly() throws {
        let attributes = CellAttributes(underline: true)
        let cell = Cell(char: "E", attributes: attributes)
        
        #expect(cell.char == "E")
        #expect(cell.foregroundColor == Color.default)
        #expect(cell.backgroundColor == nil)
        #expect(cell.attributes == attributes)
    }
    
    // MARK: - Character Tests
    
    @Test("Different character types are handled correctly")
    func differentCharacters() throws {
        let alphanumeric = Cell(char: "1")
        let special = Cell(char: "@")
        let unicode = Cell(char: "🚀")
        let space = Cell(char: " ")
        
        #expect(alphanumeric.char == "1")
        #expect(special.char == "@")
        #expect(unicode.char == "🚀")
        #expect(space.char == " ")
    }
    
    // MARK: - Equality Tests
    
    @Test("Cell equality works for character and foreground color")
    func equality() throws {
        let cell1 = Cell(char: "A", foregroundColor: Color.red)
        let cell2 = Cell(char: "A", foregroundColor: Color.red)
        let cell3 = Cell(char: "B", foregroundColor: Color.red)
        let cell4 = Cell(char: "A", foregroundColor: Color.blue)
        
        #expect(cell1 == cell2)
        #expect(cell1 != cell3)
        #expect(cell1 != cell4)
    }
    
    @Test("Cell equality works with background color")
    func equalityWithBackground() throws {
        let cell1 = Cell(char: "A", backgroundColor: Color.red)
        let cell2 = Cell(char: "A", backgroundColor: Color.red)
        let cell3 = Cell(char: "A", backgroundColor: Color.blue)
        let cell4 = Cell(char: "A") // No background
        
        #expect(cell1 == cell2)
        #expect(cell1 != cell3)
        #expect(cell1 != cell4)
    }
    
    @Test("Cell equality works with attributes")
    func equalityWithAttributes() throws {
        let attributes1 = CellAttributes(bold: true)
        let attributes2 = CellAttributes(bold: true)
        let attributes3 = CellAttributes(italic: true)
        
        let cell1 = Cell(char: "A", attributes: attributes1)
        let cell2 = Cell(char: "A", attributes: attributes2)
        let cell3 = Cell(char: "A", attributes: attributes3)
        
        #expect(cell1 == cell2)
        #expect(cell1 != cell3)
    }
    
    @Test("Full equality with all properties set")
    func fullEquality() throws {
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
        
        #expect(cell1 == cell2)
    }
    
    // MARK: - Background Color Tests
    
    @Test("Background color defaults to nil")
    func nilBackgroundColor() throws {
        let cell = Cell(char: "A")
        #expect(cell.backgroundColor == nil)
    }
    
    @Test("Background color can be set")
    func setBackgroundColor() throws {
        var cell = Cell(char: "A")
        cell.backgroundColor = Color.green
        #expect(cell.backgroundColor == Color.green)
    }
    
    @Test("Background color can be cleared")
    func clearBackgroundColor() throws {
        var cell = Cell(char: "A", backgroundColor: Color.red)
        cell.backgroundColor = nil
        #expect(cell.backgroundColor == nil)
    }
    
    // MARK: - Property Modification Tests
    
    @Test("Character can be modified")
    func modifyChar() throws {
        var cell = Cell(char: "A")
        cell.char = "B"
        #expect(cell.char == "B")
    }
    
    @Test("Foreground color can be modified")
    func modifyForegroundColor() throws {
        var cell = Cell(char: "A")
        cell.foregroundColor = Color.green
        #expect(cell.foregroundColor == Color.green)
    }
    
    @Test("Attributes can be modified")
    func modifyAttributes() throws {
        var cell = Cell(char: "A")
        let newAttributes = CellAttributes(bold: true, underline: true)
        cell.attributes = newAttributes
        #expect(cell.attributes == newAttributes)
    }
    
    // MARK: - Complex Scenarios Tests
    
    @Test("Cell with all features works correctly")
    func cellWithAllFeatures() throws {
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
        
        #expect(cell.char == "★")
        #expect(cell.foregroundColor == Color.brightYellow)
        #expect(cell.backgroundColor == Color.black)
        #expect(cell.attributes == attributes)
    }
    
    @Test("Cell arrays work correctly")
    func cellArrays() throws {
        let cells = [
            Cell(char: "H"),
            Cell(char: "e"),
            Cell(char: "l"),
            Cell(char: "l"),
            Cell(char: "o")
        ]
        
        #expect(cells.count == 5)
        #expect(cells[0].char == "H")
        #expect(cells[4].char == "o")
        
        // Test that different cells with same char are equal by default
        #expect(cells[2] == cells[3]) // Both are "l"
    }
}