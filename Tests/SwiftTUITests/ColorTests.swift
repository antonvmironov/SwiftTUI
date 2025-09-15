import Testing
@testable import SwiftTUI

struct ColorTests {
    
    // MARK: - ANSI Color Tests
    
    @Test("Basic ANSI colors are distinct and self-equal")
    func basicANSIColors() throws {
        let black = Color.black
        let red = Color.red
        let green = Color.green
        let blue = Color.blue
        
        // Test that they are different colors
        #expect(black != red)
        #expect(red != green)
        #expect(green != blue)
        
        // Test that same colors are equal
        #expect(Color.black == Color.black)
        #expect(Color.red == Color.red)
        
        // Test other colors exist
        _ = Color.yellow
        _ = Color.magenta
        _ = Color.cyan
        _ = Color.white
    }
    
    @Test("Bright ANSI colors are distinct from regular colors")
    func brightANSIColors() throws {
        let brightBlack = Color.brightBlack
        let brightRed = Color.brightRed
        let brightGreen = Color.brightGreen
        
        // Test that bright colors are different from regular colors
        #expect(Color.black != brightBlack)
        #expect(Color.red != brightRed)
        #expect(Color.green != brightGreen)
        
        // Test gray alias
        #expect(Color.gray == Color.brightBlack)
        
        // Test other bright colors exist
        _ = Color.brightYellow
        _ = Color.brightBlue
        _ = Color.brightMagenta
        _ = Color.brightCyan
        _ = Color.brightWhite
    }
    
    @Test("Default color is distinct and self-equal")
    func defaultColor() throws {
        let defaultColor = Color.default
        
        // Test that default color is different from others
        #expect(defaultColor != Color.black)
        #expect(defaultColor != Color.white)
        
        // Test that multiple references are equal
        #expect(Color.default == Color.default)
    }
    
    // MARK: - XTerm Color Tests
    
    @Test("XTerm colors with different values are distinct")
    func xtermColorCreation() throws {
        let color1 = Color.xterm(red: 0, green: 0, blue: 0)
        let color2 = Color.xterm(red: 5, green: 5, blue: 5)
        let color3 = Color.xterm(red: 2, green: 3, blue: 4)
        
        // Test that different colors are not equal
        #expect(color1 != color2)
        #expect(color1 != color3)
        #expect(color2 != color3)
        
        // Test that same colors are equal
        let color1Copy = Color.xterm(red: 0, green: 0, blue: 0)
        #expect(color1 == color1Copy)
    }
    
    @Test("XTerm grayscale colors are distinct")
    func xtermGrayscale() throws {
        let gray1 = Color.xterm(white: 0)
        let gray2 = Color.xterm(white: 23)
        let gray3 = Color.xterm(white: 12)
        
        // Test that different grayscale colors are not equal
        #expect(gray1 != gray2)
        #expect(gray1 != gray3)
        #expect(gray2 != gray3)
        
        // Test that same grayscale colors are equal
        let gray1Copy = Color.xterm(white: 0)
        #expect(gray1 == gray1Copy)
    }
    
    // MARK: - True Color Tests
    
    @Test("True colors with different RGB values are distinct")
    func trueColorCreation() throws {
        let color1 = Color.trueColor(red: 255, green: 0, blue: 0)
        let color2 = Color.trueColor(red: 0, green: 255, blue: 0)
        let color3 = Color.trueColor(red: 0, green: 0, blue: 255)
        
        // Test that different colors are not equal
        #expect(color1 != color2)
        #expect(color1 != color3)
        #expect(color2 != color3)
        
        // Test that same colors are equal
        let color1Copy = Color.trueColor(red: 255, green: 0, blue: 0)
        #expect(color1 == color1Copy)
    }
    
    @Test("True color boundary values are handled correctly")
    func trueColorBoundaries() throws {
        // Test boundary values
        let black = Color.trueColor(red: 0, green: 0, blue: 0)
        let white = Color.trueColor(red: 255, green: 255, blue: 255)
        let midRange = Color.trueColor(red: 128, green: 128, blue: 128)
        
        #expect(black != white)
        #expect(black != midRange)
        #expect(white != midRange)
    }
    
    // MARK: - Color Type Mixing Tests
    
    @Test("Different color types are never equal")
    func differentColorTypes() throws {
        let ansiRed = Color.red
        let trueRed = Color.trueColor(red: 255, green: 0, blue: 0)
        let xtermRed = Color.xterm(red: 5, green: 0, blue: 0)
        
        // Colors of different types should not be equal even if they represent similar colors
        #expect(ansiRed != trueRed)
        #expect(ansiRed != xtermRed)
        #expect(trueRed != xtermRed)
    }
    
    // MARK: - Hashable Tests
    
    @Test("Colors implement Hashable correctly")
    func colorHashable() throws {
        let color1 = Color.red
        let color2 = Color.red
        let color3 = Color.blue
        
        // Same colors should have same hash
        #expect(color1.hashValue == color2.hashValue)
        
        // Different colors should (likely) have different hashes
        #expect(color1.hashValue != color3.hashValue)
        
        // Test that colors can be used in sets
        let colorSet: Set<Color> = [Color.red, Color.blue, Color.red]
        #expect(colorSet.count == 2) // Should only contain red and blue
    }
    
    // MARK: - Internal Methods Tests (accessible via @testable import)
    
    @Test("Foreground escape sequence contains correct ANSI codes")
    func foregroundEscapeSequence() throws {
        let red = Color.red
        let escapeSeq = red.foregroundEscapeSequence
        
        // Should return some escape sequence string
        #expect(!escapeSeq.isEmpty)
        #expect(escapeSeq.contains("31")) // ANSI red foreground code
    }
    
    @Test("Background escape sequence contains correct ANSI codes")
    func backgroundEscapeSequence() throws {
        let red = Color.red
        let escapeSeq = red.backgroundEscapeSequence
        
        // Should return some escape sequence string
        #expect(!escapeSeq.isEmpty)
        #expect(escapeSeq.contains("41")) // ANSI red background code
    }
}