import Testing
@testable import SwiftTUI

@Suite("Error Handling Tests")
@MainActor
struct ErrorHandlingTests {
    
    // Helper to assert a value conforms to SwiftTUI.View at compile time
    private func isView<V: View>(_: V) -> Bool { true }
    
    // MARK: - ErrorMessage Tests
    
    @Test("ErrorMessage creation")
    func testErrorMessageCreation() {
        let error = DisplayableError(
            title: "Test Error",
            message: "This is a test error message",
            severity: .error,
            suggestions: ["Try again", "Check your input"],
            details: "Additional error details"
        )
        
        let errorMessage = ErrorMessage(error: error, showDetails: true)
        #expect(isView(errorMessage))
    }
    
    @Test("DisplayableError with different severities")
    func testDisplayableErrorSeverities() {
        let infoError = DisplayableError(
            title: "Info",
            message: "Information message",
            severity: .info
        )
        
        let warningError = DisplayableError(
            title: "Warning",
            message: "Warning message",
            severity: .warning
        )
        
        let criticalError = DisplayableError(
            title: "Critical Error",
            message: "Critical error message",
            severity: .critical
        )
        
        #expect(infoError.severity == .info)
        #expect(warningError.severity == .warning)
        #expect(criticalError.severity == .critical)
    }
    
    @Test("ErrorSeverity properties")
    func testErrorSeverityProperties() {
        #expect(ErrorSeverity.info.icon == "ℹ")
        #expect(ErrorSeverity.warning.icon == "⚠")
        #expect(ErrorSeverity.error.icon == "✗")
        #expect(ErrorSeverity.critical.icon == "🛑")
        
        #expect(ErrorSeverity.info.color == .blue)
        #expect(ErrorSeverity.warning.color == .yellow)
        #expect(ErrorSeverity.error.color == .red)
        #expect(ErrorSeverity.critical.color == .red)
    }
    
    @Test("ErrorAction creation")
    func testErrorActionCreation() {
        var actionCalled = false
        
        let action = ErrorAction(title: "Retry", style: .primary) {
            actionCalled = true
        }
        
        #expect(action.title == "Retry")
        #expect(action.style == .primary)
        
        action.handler()
        #expect(actionCalled == true)
    }
    
    @Test("ActionStyle properties")
    func testActionStyleProperties() {
        #expect(ActionStyle.default.color == .secondary)
        #expect(ActionStyle.primary.color == .blue)
        #expect(ActionStyle.destructive.color == .red)
    }
    
    @Test("ErrorMessage with actions")
    func testErrorMessageWithActions() {
        let error = DisplayableError(
            title: "Confirmation Required",
            message: "Are you sure you want to proceed?",
            severity: .warning,
            actions: [
                ErrorAction(title: "Cancel", style: .default) { },
                ErrorAction(title: "Delete", style: .destructive) { }
            ]
        )
        
        let errorMessage = ErrorMessage(error: error)
        #expect(isView(errorMessage))
        #expect(error.actions.count == 2)
    }
    
    // MARK: - ErrorToast Tests
    
    @Test("ErrorToast creation")
    func testErrorToastCreation() {
        let error = DisplayableError(
            title: "Toast Error",
            message: "This is a toast message",
            severity: .info
        )
        
        var dismissed = false
        let toast = ErrorToast(error: error, duration: 1.0) {
            dismissed = true
        }
        
        #expect(isView(toast))
        #expect(!dismissed) // should not have been triggered
    }
    
    // MARK: - ErrorBoundary Tests
    
    @Test("ErrorBoundary creation")
    func testErrorBoundaryCreation() {
        let boundary = ErrorBoundary {
            Text("Normal Content")
        } errorContent: { error in
            Text("Error: \(error.message)")
        }
        
        #expect(isView(boundary))
    }
    
    // MARK: - UserGuidance Tests
    
    @Test("HelpSection creation")
    func testHelpSectionCreation() {
        let section = HelpSection(
            title: "Navigation",
            items: [
                HelpItem(shortcut: "↑↓", description: "Move up/down"),
                HelpItem(shortcut: "Tab", description: "Next field"),
                HelpItem(shortcut: "Enter", description: "Select/Submit")
            ]
        )
        
        #expect(section.title == "Navigation")
        #expect(section.items.count == 3)
        #expect(section.items[0].shortcut == "↑↓")
        #expect(section.items[0].description == "Move up/down")
    }
    
    @Test("HelpOverlay creation")
    func testHelpOverlayCreation() {
        let sections = [
            HelpSection(title: "Basic", items: [
                HelpItem(shortcut: "q", description: "Quit")
            ]),
            HelpSection(title: "Advanced", items: [
                HelpItem(shortcut: "Ctrl+C", description: "Force quit")
            ])
        ]
        
        var dismissed = false
        let overlay = HelpOverlay(sections: sections) {
            dismissed = true
        }
        
        #expect(isView(overlay))
        #expect(sections.count == 2)
        #expect(!dismissed) // should not have been triggered
    }
    
    @Test("TourStep creation")
    func testTourStepCreation() {
        let step = TourStep(
            title: "Welcome",
            description: "Welcome to the application",
            tips: ["Use Tab to navigate", "Press Enter to select"]
        )
        
        #expect(step.title == "Welcome")
        #expect(step.description == "Welcome to the application")
        #expect(step.tips.count == 2)
    }
    
    @Test("GuidedTour creation")
    func testGuidedTourCreation() {
        let steps = [
            TourStep(title: "Step 1", description: "First step"),
            TourStep(title: "Step 2", description: "Second step"),
            TourStep(title: "Step 3", description: "Final step")
        ]
        
        var completed = false
        let tour = GuidedTour(steps: steps) {
            completed = true
        }
        
        #expect(isView(tour))
        #expect(steps.count == 3)
        #expect(!completed) // should not have been triggered
    }
    
    @Test("ApplicationStatus properties")
    func testApplicationStatusProperties() {
        #expect(ApplicationStatus.idle.icon == "⚪")
        #expect(ApplicationStatus.loading.icon == "⏳")
        #expect(ApplicationStatus.success.icon == "✅")
        #expect(ApplicationStatus.warning.icon == "⚠️")
        #expect(ApplicationStatus.error.icon == "❌")
        
        #expect(ApplicationStatus.idle.color == .gray)
        #expect(ApplicationStatus.loading.color == .blue)
        #expect(ApplicationStatus.success.color == .green)
        #expect(ApplicationStatus.warning.color == .yellow)
        #expect(ApplicationStatus.error.color == .red)
    }
    
    @Test("StatusIndicator creation")
    func testStatusIndicatorCreation() {
        let indicator = StatusIndicator(status: .loading, message: "Processing...")
        #expect(isView(indicator))
        
        let simpleIndicator = StatusIndicator(status: .success)
        #expect(isView(simpleIndicator))
    }
    
    @Test("ProgressIndicator creation")
    func testProgressIndicatorCreation() {
        let progress = ProgressIndicator(
            progress: 50,
            total: 100,
            message: "Loading data...",
            showPercentage: true
        )
        
        #expect(isView(progress))
        
        let simpleProgress = ProgressIndicator(progress: 75)
        #expect(isView(simpleProgress))
    }
    
    @Test("GuidanceValidationResult creation")
    func testGuidanceValidationResultCreation() {
        let validResult = GuidanceValidationResult(
            field: "email",
            isValid: true,
            message: "Email format is valid"
        )
        
        let invalidResult = GuidanceValidationResult(
            field: "password",
            isValid: false,
            message: "Password must be at least 8 characters"
        )
        
        #expect(validResult.field == "email")
        #expect(validResult.isValid == true)
        #expect(invalidResult.isValid == false)
    }
    
    @Test("ValidationFeedback creation")
    func testValidationFeedbackCreation() {
        let validations = [
            GuidanceValidationResult(field: "name", isValid: true, message: "Name is valid"),
            GuidanceValidationResult(field: "email", isValid: false, message: "Invalid email format")
        ]
        
        let feedback = ValidationFeedback(validations: validations)
        let feedbackWithSuccess = ValidationFeedback(validations: validations, showSuccessful: true)
        
        #expect(isView(feedback))
        #expect(isView(feedbackWithSuccess))
    }
    
    @Test("QuickAction creation")
    func testQuickActionCreation() {
        var actionExecuted = false
        
        let action = QuickAction(title: "Save", shortcut: "Ctrl+S") {
            actionExecuted = true
        }
        
        #expect(!String(describing: action).isEmpty)
        
        let simpleAction = QuickAction(title: "Cancel") {
            actionExecuted = true
        }
        
        #expect(!String(describing: simpleAction).isEmpty)
        #expect(!actionExecuted) // should not have been triggered
    }
    
    @Test("Tooltip creation")
    func testTooltipCreation() {
        let tooltip = Tooltip(content: "This is a helpful tooltip")
        let hiddenTooltip = Tooltip(content: "Hidden tooltip", isVisible: false)
        
        #expect(isView(tooltip))
        #expect(isView(hiddenTooltip))
    }
    
    // MARK: - Integration Tests
    
    @Test("Complete error handling flow")
    func testCompleteErrorHandlingFlow() {
        // Create a complex error with all features
        let error = DisplayableError(
            title: "Data Validation Failed",
            message: "The submitted data contains errors that need to be corrected.",
            severity: .error,
            suggestions: [
                "Check all required fields are filled",
                "Verify email format is correct",
                "Ensure password meets security requirements"
            ],
            details: "Validation failed on fields: email, password. Error codes: E001, E002.",
            actions: [
                ErrorAction(title: "Review Form", style: .primary) { },
                ErrorAction(title: "Clear All", style: .destructive) { },
                ErrorAction(title: "Cancel", style: .default) { }
            ]
        )
        
        // Create error message with details
        let errorMessage = ErrorMessage(error: error, showDetails: true) {
            // Dismiss handler
        }
        
        #expect(isView(errorMessage))
        #expect(error.suggestions.count == 3)
        #expect(error.actions.count == 3)
    }
    
    @Test("Complete user guidance flow")
    func testCompleteUserGuidanceFlow() {
        // Create comprehensive help system
        let helpSections = [
            HelpSection(title: "Basic Navigation", items: [
                HelpItem(shortcut: "↑↓", description: "Move between items"),
                HelpItem(shortcut: "Tab", description: "Move between sections"),
                HelpItem(shortcut: "Enter", description: "Select item")
            ]),
            HelpSection(title: "Advanced Features", items: [
                HelpItem(shortcut: "Ctrl+F", description: "Search"),
                HelpItem(shortcut: "Ctrl+N", description: "New item"),
                HelpItem(shortcut: "Del", description: "Delete item")
            ])
        ]
        
        let helpOverlay = HelpOverlay(sections: helpSections) { }
        
        // Create guided tour
        let tourSteps = [
            TourStep(
                title: "Welcome",
                description: "Welcome to the application!",
                tips: ["Take your time to explore", "Use keyboard shortcuts for efficiency"]
            ),
            TourStep(
                title: "Main Interface",
                description: "This is the main interface where you'll spend most of your time.",
                tips: ["All data is displayed here", "Use filters to find specific items"]
            ),
            TourStep(
                title: "Getting Help",
                description: "You can always access help by pressing F1.",
                tips: ["Help is context-sensitive", "Tooltips provide quick hints"]
            )
        ]
        
        let guidedTour = GuidedTour(steps: tourSteps) { }
        
        #expect(isView(helpOverlay))
        #expect(isView(guidedTour))
        #expect(helpSections.count == 2)
        #expect(tourSteps.count == 3)
    }
    
    @Test("View extensions compilation")
    func testViewExtensions() {
        let view = Text("Test")
            .tooltip("This is a tooltip")
            .statusIndicator(.loading, message: "Processing...")
            .helpButton(sections: [
                HelpSection(title: "Help", items: [
                    HelpItem(shortcut: "h", description: "Show help")
                ])
            ])
        
        #expect(isView(view))
    }
    
    @Test("Real-world error scenarios")
    func testRealWorldErrorScenarios() {
        // Network error
        let networkError = DisplayableError(
            title: "Connection Failed",
            message: "Unable to connect to the server.",
            severity: .error,
            suggestions: [
                "Check your internet connection",
                "Try again in a few moments",
                "Contact support if the problem persists"
            ],
            actions: [
                ErrorAction(title: "Retry", style: .primary) { },
                ErrorAction(title: "Work Offline", style: .default) { }
            ]
        )
        
        // Validation error
        let validationError = DisplayableError(
            title: "Invalid Input",
            message: "Please correct the highlighted fields.",
            severity: .warning,
            suggestions: [
                "All fields marked with * are required",
                "Email must be in valid format",
                "Password must be at least 8 characters"
            ]
        )
        
        // Success message
        let successMessage = DisplayableError(
            title: "Success",
            message: "Your data has been saved successfully.",
            severity: .info,
            actions: [
                ErrorAction(title: "Continue", style: .primary) { }
            ]
        )
        
        #expect(networkError.severity == .error)
        #expect(validationError.severity == .warning)
        #expect(successMessage.severity == .info)
    }
}
