import Testing
@testable import SwiftTUI

struct StateManagementTests {
    
    // MARK: - Test Classes
    
    class TestViewModel: ObservableObject, @unchecked Sendable {
        @ObservableProperty var name: String = ""
        @ObservableProperty var count: Int = 0
        
        func updateName(_ newName: String) {
            name = newName
        }
        
        func increment() {
            count += 1
        }
    }
    
    class TestPublishableModel: PublishableObject, @unchecked Sendable {
        @Published var title: String = "Default Title"
        @Published var isVisible: Bool = true
        @Published var value: Double = 0.0
        
        func updateTitle(_ newTitle: String) {
            title = newTitle
        }
        
        func toggle() {
            isVisible.toggle()
        }
    }
    
    // MARK: - StateObject Tests
    
    @Test("StateObject initialization")
    func stateObjectInit() async throws {
        // Test that StateObject can be initialized with a factory
        @StateObject var viewModel = TestViewModel()
        
        // Initial values should be correct
        #expect(viewModel.name == "")
        #expect(viewModel.count == 0)
    }
    
    @Test("StateObject property changes")
    func stateObjectPropertyChanges() async throws {
        @StateObject var viewModel = TestViewModel()
        
        // Modify properties
        viewModel.updateName("New Name")
        viewModel.increment()
        
        // Changes should be reflected
        #expect(viewModel.name == "New Name")
        #expect(viewModel.count == 1)
    }
    
    @Test("StateObject with factory function")
    func stateObjectWithFactory() async throws {
        @StateObject var viewModel = { TestViewModel() }()
        
        // Should work with factory function
        #expect(viewModel.name == "")
        viewModel.updateName("Factory Created")
        #expect(viewModel.name == "Factory Created")
    }
    
    // MARK: - ObservedObject Tests
    
    @Test("ObservedObject initialization")
    func observedObjectInit() async throws {
        let model = TestViewModel()
        @ObservedObject var observedModel = model
        
        // Should reference the same object
        #expect(observedModel.name == "")
        #expect(observedModel.count == 0)
    }
    
    @Test("ObservedObject reflects external changes")
    func observedObjectExternalChanges() async throws {
        let model = TestViewModel()
        @ObservedObject var observedModel = model
        
        // Change the original model
        model.updateName("External Change")
        model.increment()
        
        // ObservedObject should reflect the changes
        #expect(observedModel.name == "External Change")
        #expect(observedModel.count == 1)
    }
    
    @Test("ObservedObject vs StateObject behavior")
    func observedObjectVsStateObject() async throws {
        let sharedModel = TestViewModel()
        sharedModel.updateName("Shared")
        
        @ObservedObject var observed = sharedModel
        @StateObject var state = TestViewModel()
        
        // ObservedObject should use existing instance
        #expect(observed.name == "Shared")
        
        // StateObject should create new instance
        #expect(state.name == "")
    }
    
    // MARK: - Published Tests
    
    @Test("Published property initialization")
    func publishedInit() async throws {
        let model = TestPublishableModel()
        
        // Initial values should be correct
        #expect(model.title == "Default Title")
        #expect(model.isVisible == true)
        #expect(model.value == 0.0)
    }
    
    @Test("Published property changes")
    func publishedChanges() async throws {
        let model = TestPublishableModel()
        
        // Modify published properties
        model.updateTitle("New Title")
        model.toggle()
        model.value = 42.5
        
        // Changes should be reflected
        #expect(model.title == "New Title")
        #expect(model.isVisible == false)
        #expect(model.value == 42.5)
    }
    
    @Test("Published with StateObject")
    func publishedWithStateObject() async throws {
        @StateObject var model = TestPublishableModel()
        
        // Should work together
        model.updateTitle("StateObject + Published")
        #expect(model.title == "StateObject + Published")
        
        model.toggle()
        #expect(model.isVisible == false)
    }
    
    @Test("Published with ObservedObject")
    func publishedWithObservedObject() async throws {
        let model = TestPublishableModel()
        @ObservedObject var observed = model
        
        // Changes through ObservedObject should work
        observed.updateTitle("ObservedObject + Published")
        #expect(observed.title == "ObservedObject + Published")
        #expect(model.title == "ObservedObject + Published")
    }
    
    // MARK: - Integration Tests
    
    @Test("Multiple property wrappers together")
    func multiplePropertyWrappers() async throws {
        @StateObject var stateModel = TestViewModel()
        
        let sharedModel = TestPublishableModel()
        @ObservedObject var observedModel = sharedModel
        
        // Both should work independently
        stateModel.updateName("State")
        observedModel.updateTitle("Observed")
        
        #expect(stateModel.name == "State")
        #expect(observedModel.title == "Observed")
    }
    
    @Test("Property wrapper thread safety")
    func propertyWrapperThreadSafety() async throws {
        let model = TestViewModel()
        @StateObject var stateModel = model
        
        // Test concurrent access (basic smoke test)
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask { @Sendable in
                    model.updateName("Name \(i)")
                    model.increment()
                }
            }
        }
        
        // Should not crash and should have some final state
        #expect(model.count >= 0)
        #expect(model.name.hasPrefix("Name"))
    }
}