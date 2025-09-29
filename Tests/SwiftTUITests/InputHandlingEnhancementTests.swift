import Testing
@testable import SwiftTUI

actor CallFlag {
    private var value = false
    func set() { value = true }
    func get() -> Bool { value }
}

@Suite("Input Handling Enhancement Tests")
struct InputHandlingEnhancementTests {
    // Helper to assert a value conforms to SwiftTUI.View at compile time
    private func isView<V: View>(_: V) -> Bool { true }

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
    @MainActor
    func onKeyPressModifier() async {
        let flag = CallFlag()

        let testView = Text("Test")
            .onKeyPress(.space) {
                Task { await flag.set() }
            }
        
        // Should compile without issues and not signal before any event occurs
        #expect(await flag.get() == false)
        #expect(isView(testView))
    }
    
    @Test("onTapGesture modifier compiles correctly")
    @MainActor
    func onTapGestureModifier() async {
        let flag = CallFlag()
        
        let testView = Text("Test")
            .onTapGesture {
                Task { await flag.set() }
            }
        
        // Should compile without issues and not signal before any event occurs
        #expect(await flag.get() == false)
        #expect(isView(testView))
    }
    
    @Test("onTapGesture with count modifier compiles correctly")
    @MainActor
    func onTapGestureCountModifier() async {
        let flag = CallFlag()
        
        let testView = Text("Test")
            .onTapGesture(count: 2) {
                Task { await flag.set() }
            }
        
        // Should compile without issues and not signal before any event occurs
        #expect(await flag.get() == false)
        #expect(isView(testView))
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
    @MainActor
    func modifierComposition() async {
        let keyFlag = CallFlag()
        let tapFlag = CallFlag()
        
        let testView = Text("Test")
            .onKeyPress(.escape) {
                Task { await keyFlag.set() }
            }
            .onTapGesture {
                Task { await tapFlag.set() }
            }
        
        // Should compile without issues and allow modifier composition
        #expect(await keyFlag.get() == false)
        #expect(await tapFlag.get() == false)
        #expect(isView(testView))
    }
}
