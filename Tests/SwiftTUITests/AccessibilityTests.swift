import Testing
@testable import SwiftTUI

/// Tests for accessibility support in SwiftTUI
@Suite("Accessibility Tests")
@MainActor
struct AccessibilityTests {
    
    // Helper to assert a value conforms to SwiftTUI.View at compile time
    private func isView<V: View>(_: V) -> Bool { true }
    
//    @Test("AnyView is a View")
//    func testAnyViewIsView() {
//        let any = AnyView(Text("Hello"))
//        #expect(isView(any))
//    }
    
    @Test("AccessibilityInfo creation")
    func testAccessibilityInfoCreation() {
        let info1 = AccessibilityInfo()
        #expect(info1.label == nil)
        #expect(info1.hint == nil)
        #expect(info1.role == nil)
        #expect(!info1.isHidden)
        
        let info2 = AccessibilityInfo(
            label: "Test Label",
            hint: "Test Hint",
            role: .button,
            isHidden: true
        )
        #expect(info2.label == "Test Label")
        #expect(info2.hint == "Test Hint")
        #expect(info2.role == .button)
        #expect(info2.isHidden)
    }
    
    @Test("AccessibilityRole descriptions")
    func testAccessibilityRoleDescriptions() {
        #expect(AccessibilityRole.button.description == "button")
        #expect(AccessibilityRole.text.description == "text")
        #expect(AccessibilityRole.textField.description == "text field")
        #expect(AccessibilityRole.list.description == "list")
        #expect(AccessibilityRole.table.description == "table")
        #expect(AccessibilityRole.header.description == "header")
        #expect(AccessibilityRole.navigation.description == "navigation")
        #expect(AccessibilityRole.progress.description == "progress indicator")
        #expect(AccessibilityRole.spinner.description == "loading spinner")
        #expect(AccessibilityRole.alert.description == "alert")
        #expect(AccessibilityRole.dialog.description == "dialog")
        #expect(AccessibilityRole.menu.description == "menu")
        #expect(AccessibilityRole.tab.description == "tab")
        #expect(AccessibilityRole.link.description == "link")
    }
    
    @Test("Accessibility modifiers")
    func testAccessibilityModifiers() {
        let text = Text("Hello")
        
        let labeledText = text.accessibilityLabel("Test Label")
        #expect(isView(labeledText))
        
        let hintedText = text.accessibilityHint("Test Hint")
        #expect(isView(hintedText))
        
        let roledText = text.accessibilityRole(.button)
        #expect(isView(roledText))
        
        let hiddenText = text.accessibilityHidden()
        #expect(isView(hiddenText))
        
        let combinedText = text.accessibility(
            label: "Combined Label",
            hint: "Combined Hint",
            role: .header
        )
        #expect(isView(combinedText))
    }
    
    @Test("KeyboardNavigation shortcuts")
    func testKeyboardNavigationShortcuts() {
        let shortcuts = KeyboardNavigation.StandardShortcut.allCases
        #expect(shortcuts.count == 13)
        
        #expect(KeyboardNavigation.StandardShortcut.tab.description == "Tab")
        #expect(KeyboardNavigation.StandardShortcut.shiftTab.description == "Shift+Tab")
        #expect(KeyboardNavigation.StandardShortcut.enter.description == "Enter")
        #expect(KeyboardNavigation.StandardShortcut.escape.description == "Escape")
        #expect(KeyboardNavigation.StandardShortcut.space.description == "Space")
        #expect(KeyboardNavigation.StandardShortcut.arrowUp.description == "Arrow Up")
        #expect(KeyboardNavigation.StandardShortcut.arrowDown.description == "Arrow Down")
        #expect(KeyboardNavigation.StandardShortcut.arrowLeft.description == "Arrow Left")
        #expect(KeyboardNavigation.StandardShortcut.arrowRight.description == "Arrow Right")
        #expect(KeyboardNavigation.StandardShortcut.home.description == "Home")
        #expect(KeyboardNavigation.StandardShortcut.end.description == "End")
        #expect(KeyboardNavigation.StandardShortcut.pageUp.description == "Page Up")
        #expect(KeyboardNavigation.StandardShortcut.pageDown.description == "Page Down")
    }
    
    @Test("KeyboardNavigation hint generation")
    func testKeyboardNavigationHints() {
        let singleShortcut = [KeyboardNavigation.StandardShortcut.tab]
        let singleHint = KeyboardNavigation.navigationHint(shortcuts: singleShortcut)
        #expect(singleHint == "Use Tab to navigate")
        
        let multipleShortcuts = [
            KeyboardNavigation.StandardShortcut.arrowUp,
            KeyboardNavigation.StandardShortcut.arrowDown
        ]
        let multipleHint = KeyboardNavigation.navigationHint(shortcuts: multipleShortcuts)
        #expect(multipleHint == "Use Arrow Up, Arrow Down to navigate")
        
        let interactionHint = KeyboardNavigation.interactionHint(
            action: "activate",
            shortcut: .enter
        )
        #expect(interactionHint == "activate with Enter")
    }
    
    @Test("AccessibleButton creation")
    func testAccessibleButton() {
        var buttonPressed = false
        
        let button1 = AccessibleButton("Test Button") {
            buttonPressed = true
        }
        #expect(isView(button1))
        
        let button2 = AccessibleButton(
            "Custom Button",
            action: { buttonPressed = true },
            accessibilityLabel: "Custom Label",
            accessibilityHint: "Custom Hint"
        )
        #expect(isView(button2))
        #expect(!buttonPressed)
    }
    
    @Test("AccessibleTextField creation")
    func testAccessibleTextField() {
        @State var text = "Initial"
        
        let textField1 = AccessibleTextField("Username", text: $text)
        #expect(isView(textField1))
        
        let textField2 = AccessibleTextField(
            "Email",
            text: $text,
            accessibilityLabel: "Email Address",
            accessibilityHint: "Enter your email address"
        )
        #expect(isView(textField2))
    }
    
    @Test("AccessibilityInfo equality")
    func testAccessibilityInfoEquality() {
        let info1 = AccessibilityInfo(label: "Test", hint: "Hint", role: .button)
        let info2 = AccessibilityInfo(label: "Test", hint: "Hint", role: .button)
        let info3 = AccessibilityInfo(label: "Different", hint: "Hint", role: .button)
        
        #expect(info1 == info2)
        #expect(info1 != info3)
    }
}

