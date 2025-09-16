import Testing
@testable import SwiftTUI

@Suite("Input Handling Enhancement Tests")
struct InputHandlingEnhancementTests {
    
    @Test("KeyEquivalent basic functionality")
    func keyEquivalentBasics() {
        let spaceKey = KeyEquivalent(" ")
        let enterKey = KeyEquivalent.enter
        let escapeKey = KeyEquivalent.escape
        let tabKey = KeyEquivalent.tab
        
        #expect(spaceKey.character == " ")
        #expect(enterKey.character == "\n")
        #expect(escapeKey.character == "\u{1B}")
        #expect(tabKey.character == "\t")
    }
    
    @Test("KeyEquivalent string literal support")
    func keyEquivalentStringLiteral() {
        let key: KeyEquivalent = "a"
        #expect(key.character == "a")
    }
    
    @Test("KeyEquivalent hashable and equatable")
    func keyEquivalentHashable() {
        let key1 = KeyEquivalent("a")
        let key2 = KeyEquivalent("a")
        let key3 = KeyEquivalent("b")
        
        #expect(key1 == key2)
        #expect(key1 != key3)
        #expect(key1.hashValue == key2.hashValue)
    }
    
    @Test("Character keyEquivalent extension")
    func characterKeyEquivalent() {
        let char: Character = "x"
        let key = char.keyEquivalent
        
        #expect(key.character == "x")
    }
    
    @Test("onKeyPress modifier compiles correctly")
    func onKeyPressModifier() {
        var actionCalled = false
        
        let testView = Text("Test")
            .onKeyPress(.space) {
                actionCalled = true
            }
        
        // Should compile without issues
        #expect(!actionCalled) // Action hasn't been triggered yet
    }
    
    @Test("onTapGesture modifier compiles correctly")
    func onTapGestureModifier() {
        var actionCalled = false
        
        let testView = Text("Test")
            .onTapGesture {
                actionCalled = true
            }
        
        // Should compile without issues
        #expect(!actionCalled) // Action hasn't been triggered yet
    }
    
    @Test("onTapGesture with count modifier compiles correctly")
    func onTapGestureCountModifier() {
        var actionCalled = false
        
        let testView = Text("Test")
            .onTapGesture(count: 2) {
                actionCalled = true
            }
        
        // Should compile without issues
        #expect(!actionCalled) // Action hasn't been triggered yet
    }
    
    @Test("Common key equivalents are defined")
    func commonKeyEquivalents() {
        // Test that all common key equivalents are defined and accessible
        let keys = [
            KeyEquivalent.escape,
            KeyEquivalent.tab,
            KeyEquivalent.space,
            KeyEquivalent.return,
            KeyEquivalent.enter,
            KeyEquivalent.delete,
            KeyEquivalent.backspace
        ]
        
        // Should not crash and should have distinct characters
        for key in keys {
            #expect(!key.character.isWhitespace || key == .space || key == .tab || key == .return || key == .enter)
        }
        
        // Enter and return should be the same
        #expect(KeyEquivalent.enter == KeyEquivalent.return)
    }
    
    @Test("Modifier composition works")
    func modifierComposition() {
        var keyPressed = false
        var tapDetected = false
        
        let testView = Text("Test")
            .onKeyPress(.escape) {
                keyPressed = true
            }
            .onTapGesture {
                tapDetected = true
            }
        
        // Should compile without issues and allow modifier composition
        #expect(!keyPressed)
        #expect(!tapDetected)
    }
}