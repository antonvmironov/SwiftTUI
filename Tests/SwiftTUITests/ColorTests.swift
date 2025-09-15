import XCTest
@testable import SwiftTUI

final class ColorTests: XCTestCase {
    
    // MARK: - ANSI Color Tests
    
    func testBasicANSIColors() throws {
        let black = Color.black
        let red = Color.red
        let green = Color.green
        let blue = Color.blue
        
        // Test that they are different colors
        XCTAssertNotEqual(black, red)
        XCTAssertNotEqual(red, green)
        XCTAssertNotEqual(green, blue)
        
        // Test that same colors are equal
        XCTAssertEqual(Color.black, Color.black)
        XCTAssertEqual(Color.red, Color.red)
        
        // Test other colors exist
        _ = Color.yellow
        _ = Color.magenta
        _ = Color.cyan
        _ = Color.white
    }
    
    func testBrightANSIColors() throws {
        let brightBlack = Color.brightBlack
        let brightRed = Color.brightRed
        let brightGreen = Color.brightGreen
        
        // Test that bright colors are different from regular colors
        XCTAssertNotEqual(Color.black, brightBlack)
        XCTAssertNotEqual(Color.red, brightRed)
        XCTAssertNotEqual(Color.green, brightGreen)
        
        // Test gray alias
        XCTAssertEqual(Color.gray, Color.brightBlack)
        
        // Test other bright colors exist
        _ = Color.brightYellow
        _ = Color.brightBlue
        _ = Color.brightMagenta
        _ = Color.brightCyan
        _ = Color.brightWhite
    }
    
    func testDefaultColor() throws {
        let defaultColor = Color.default
        
        // Test that default color is different from others
        XCTAssertNotEqual(defaultColor, Color.black)
        XCTAssertNotEqual(defaultColor, Color.white)
        
        // Test that multiple references are equal
        XCTAssertEqual(Color.default, Color.default)
    }
    
    // MARK: - XTerm Color Tests
    
    func testXTermColorCreation() throws {
        let color1 = Color.xterm(red: 0, green: 0, blue: 0)
        let color2 = Color.xterm(red: 5, green: 5, blue: 5)
        let color3 = Color.xterm(red: 2, green: 3, blue: 4)
        
        // Test that different colors are not equal
        XCTAssertNotEqual(color1, color2)
        XCTAssertNotEqual(color1, color3)
        XCTAssertNotEqual(color2, color3)
        
        // Test that same colors are equal
        let color1Copy = Color.xterm(red: 0, green: 0, blue: 0)
        XCTAssertEqual(color1, color1Copy)
    }
    
    func testXTermGrayscale() throws {
        let gray1 = Color.xterm(white: 0)
        let gray2 = Color.xterm(white: 23)
        let gray3 = Color.xterm(white: 12)
        
        // Test that different grayscale colors are not equal
        XCTAssertNotEqual(gray1, gray2)
        XCTAssertNotEqual(gray1, gray3)
        XCTAssertNotEqual(gray2, gray3)
        
        // Test that same grayscale colors are equal
        let gray1Copy = Color.xterm(white: 0)
        XCTAssertEqual(gray1, gray1Copy)
    }
    
    // MARK: - True Color Tests
    
    func testTrueColorCreation() throws {
        let color1 = Color.trueColor(red: 255, green: 0, blue: 0)
        let color2 = Color.trueColor(red: 0, green: 255, blue: 0)
        let color3 = Color.trueColor(red: 0, green: 0, blue: 255)
        
        // Test that different colors are not equal
        XCTAssertNotEqual(color1, color2)
        XCTAssertNotEqual(color1, color3)
        XCTAssertNotEqual(color2, color3)
        
        // Test that same colors are equal
        let color1Copy = Color.trueColor(red: 255, green: 0, blue: 0)
        XCTAssertEqual(color1, color1Copy)
    }
    
    func testTrueColorBoundaries() throws {
        // Test boundary values
        let black = Color.trueColor(red: 0, green: 0, blue: 0)
        let white = Color.trueColor(red: 255, green: 255, blue: 255)
        let midRange = Color.trueColor(red: 128, green: 128, blue: 128)
        
        XCTAssertNotEqual(black, white)
        XCTAssertNotEqual(black, midRange)
        XCTAssertNotEqual(white, midRange)
    }
    
    // MARK: - Color Type Mixing Tests
    
    func testDifferentColorTypes() throws {
        let ansiRed = Color.red
        let trueRed = Color.trueColor(red: 255, green: 0, blue: 0)
        let xtermRed = Color.xterm(red: 5, green: 0, blue: 0)
        
        // Colors of different types should not be equal even if they represent similar colors
        XCTAssertNotEqual(ansiRed, trueRed)
        XCTAssertNotEqual(ansiRed, xtermRed)
        XCTAssertNotEqual(trueRed, xtermRed)
    }
    
    // MARK: - Hashable Tests
    
    func testColorHashable() throws {
        let color1 = Color.red
        let color2 = Color.red
        let color3 = Color.blue
        
        // Same colors should have same hash
        XCTAssertEqual(color1.hashValue, color2.hashValue)
        
        // Different colors should (likely) have different hashes
        XCTAssertNotEqual(color1.hashValue, color3.hashValue)
        
        // Test that colors can be used in sets
        let colorSet: Set<Color> = [Color.red, Color.blue, Color.red]
        XCTAssertEqual(colorSet.count, 2) // Should only contain red and blue
    }
    
    // MARK: - Internal Methods Tests (accessible via @testable import)
    
    func testForegroundEscapeSequence() throws {
        let red = Color.red
        let escapeSeq = red.foregroundEscapeSequence
        
        // Should return some escape sequence string
        XCTAssertFalse(escapeSeq.isEmpty)
        XCTAssertTrue(escapeSeq.contains("31")) // ANSI red foreground code
    }
    
    func testBackgroundEscapeSequence() throws {
        let red = Color.red
        let escapeSeq = red.backgroundEscapeSequence
        
        // Should return some escape sequence string
        XCTAssertFalse(escapeSeq.isEmpty)
        XCTAssertTrue(escapeSeq.contains("41")) // ANSI red background code
    }
}