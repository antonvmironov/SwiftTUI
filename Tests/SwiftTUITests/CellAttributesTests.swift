import Testing
@testable import SwiftTUI

struct CellAttributesTests {
    
    // MARK: - Initialization Tests
    
    @Test("Default initialization sets all attributes to false")
    func defaultInitialization() throws {
        let attributes = CellAttributes()
        
        #expect(!attributes.bold)
        #expect(!attributes.italic)
        #expect(!attributes.underline)
        #expect(!attributes.strikethrough)
        #expect(!attributes.inverted)
    }
    
    @Test("Custom initialization sets attributes correctly")
    func customInitialization() throws {
        let attributes = CellAttributes(
            bold: true,
            italic: false,
            underline: true,
            strikethrough: false,
            inverted: true
        )
        
        #expect(attributes.bold)
        #expect(!attributes.italic)
        #expect(attributes.underline)
        #expect(!attributes.strikethrough)
        #expect(attributes.inverted)
    }
    
    @Test("Partial initialization uses defaults for unspecified properties")
    func partialInitialization() throws {
        let attributes = CellAttributes(bold: true, underline: true)
        
        #expect(attributes.bold)
        #expect(!attributes.italic)
        #expect(attributes.underline)
        #expect(!attributes.strikethrough)
        #expect(!attributes.inverted)
    }
    
    // MARK: - Equality Tests
    
    @Test("Equality works correctly for similar attributes")
    func equality() throws {
        let attributes1 = CellAttributes(bold: true, italic: false)
        let attributes2 = CellAttributes(bold: true, italic: false)
        let attributes3 = CellAttributes(bold: false, italic: false)
        
        #expect(attributes1 == attributes2)
        #expect(attributes1 != attributes3)
    }
    
    @Test("Equality works with all properties set")
    func equalityWithAllProperties() throws {
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
        
        #expect(attributes1 == attributes2)
        #expect(attributes1 != attributes3)
    }
    
    // MARK: - Individual Property Tests
    
    @Test("Bold property can be modified")
    func boldProperty() throws {
        var attributes = CellAttributes()
        #expect(!attributes.bold)
        
        attributes.bold = true
        #expect(attributes.bold)
    }
    
    @Test("Italic property can be modified")
    func italicProperty() throws {
        var attributes = CellAttributes()
        #expect(!attributes.italic)
        
        attributes.italic = true
        #expect(attributes.italic)
    }
    
    @Test("Underline property can be modified")
    func underlineProperty() throws {
        var attributes = CellAttributes()
        #expect(!attributes.underline)
        
        attributes.underline = true
        #expect(attributes.underline)
    }
    
    @Test("Strikethrough property can be modified")
    func strikethroughProperty() throws {
        var attributes = CellAttributes()
        #expect(!attributes.strikethrough)
        
        attributes.strikethrough = true
        #expect(attributes.strikethrough)
    }
    
    @Test("Inverted property can be modified")
    func invertedProperty() throws {
        var attributes = CellAttributes()
        #expect(!attributes.inverted)
        
        attributes.inverted = true
        #expect(attributes.inverted)
    }
    
    // MARK: - Combined Properties Tests
    
    @Test("Multiple attributes can be set simultaneously")
    func multipleAttributes() throws {
        let attributes = CellAttributes(bold: true, italic: true, underline: true)
        
        #expect(attributes.bold)
        #expect(attributes.italic)
        #expect(attributes.underline)
        #expect(!attributes.strikethrough)
        #expect(!attributes.inverted)
    }
    
    @Test("All attributes can be set to true")
    func allAttributesTrue() throws {
        let attributes = CellAttributes(
            bold: true,
            italic: true,
            underline: true,
            strikethrough: true,
            inverted: true
        )
        
        #expect(attributes.bold)
        #expect(attributes.italic)
        #expect(attributes.underline)
        #expect(attributes.strikethrough)
        #expect(attributes.inverted)
    }
}