import Testing
@testable import SwiftTUI

@Suite("Color Enhancement Tests")
struct ColorEnhancementTests {
    
    @Test("Color.clear produces empty escape sequences")
    func colorClearEscapeSequences() {
        let clearColor = Color.clear
        
        #expect(clearColor.foregroundEscapeSequence == "")
        #expect(clearColor.backgroundEscapeSequence == "")
    }
    
    @Test("Color.primary and Color.secondary semantic colors work")
    func semanticColors() {
        let primary = Color.primary
        let secondary = Color.secondary
        
        // These should not crash and should produce valid escape sequences
        #expect(!primary.foregroundEscapeSequence.isEmpty)
        #expect(!secondary.foregroundEscapeSequence.isEmpty)
        #expect(!primary.backgroundEscapeSequence.isEmpty)
        #expect(!secondary.backgroundEscapeSequence.isEmpty)
    }
    
    @Test("Color opacity modifier works")
    func colorOpacity() {
        let redColor = Color.red
        let transparentRed = redColor.opacity(0.5)
        let opaqueRed = redColor.opacity(1.0)
        let fullyTransparentRed = redColor.opacity(0.0)
        
        // Opacity should be clamped between 0 and 1
        let overOpaque = redColor.opacity(2.0)
        let underOpaque = redColor.opacity(-0.5)
        
        // Should not crash and should produce escape sequences
        #expect(!transparentRed.foregroundEscapeSequence.isEmpty)
        #expect(!opaqueRed.foregroundEscapeSequence.isEmpty)
        #expect(!fullyTransparentRed.foregroundEscapeSequence.isEmpty)
        #expect(!overOpaque.foregroundEscapeSequence.isEmpty)
        #expect(!underOpaque.foregroundEscapeSequence.isEmpty)
    }
    
    @Test("Color opacity is applied correctly")
    func opacityApplication() {
        let redColor = Color.red
        let dimRed = redColor.opacity(0.3) // Should trigger dim effect
        let normalRed = redColor.opacity(0.8) // Should not trigger dim
        
        let redEscape = redColor.foregroundEscapeSequence
        let dimRedEscape = dimRed.foregroundEscapeSequence
        let normalRedEscape = normalRed.foregroundEscapeSequence
        
        // Dim red should have different escape sequence (includes dim)
        #expect(dimRedEscape.contains("2m")) // Contains dim escape code
        #expect(normalRedEscape == redEscape) // No dim for higher opacity
    }
    
    @Test("All basic colors still work")
    func basicColorsWork() {
        let colors: [Color] = [
            .black, .red, .green, .yellow, .blue, .magenta, .cyan, .white,
            .brightBlack, .brightRed, .brightGreen, .brightYellow, 
            .brightBlue, .brightMagenta, .brightCyan, .brightWhite,
            .gray, .default
        ]
        
        for color in colors {
            #expect(!color.foregroundEscapeSequence.isEmpty)
            #expect(!color.backgroundEscapeSequence.isEmpty)
        }
    }
    
    @Test("TrueColor and XTerm colors work with opacity")
    func advancedColorsWithOpacity() {
        let trueColor = Color.trueColor(red: 128, green: 64, blue: 192)
        let xtermColor = Color.xterm(red: 2, green: 4, blue: 1)
        let grayscaleColor = Color.xterm(white: 12)
        
        let dimTrueColor = trueColor.opacity(0.4)
        let dimXtermColor = xtermColor.opacity(0.2)
        let dimGrayscaleColor = grayscaleColor.opacity(0.1)
        
        // Should not crash and should produce valid escape sequences
        #expect(!dimTrueColor.foregroundEscapeSequence.isEmpty)
        #expect(!dimXtermColor.foregroundEscapeSequence.isEmpty) 
        #expect(!dimGrayscaleColor.foregroundEscapeSequence.isEmpty)
    }
}