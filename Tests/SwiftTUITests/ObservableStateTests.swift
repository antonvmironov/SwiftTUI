import Testing
import SwiftTUI

@Suite("Observable State Tests")
struct ObservableStateTests {
    
    class TestObservableObject: ObservableObject {
        @ObservableProperty var name: String = ""
        @ObservableProperty var age: Int = 0
        @ObservableProperty var isActive: Bool = false
        
        func updateName(_ newName: String) {
            name = newName
        }
    }
    
    @Test("ObservableObject creation")
    func observableObjectCreation() async throws {
        let obj = TestObservableObject()
        #expect(obj.name == "")
        #expect(obj.age == 0)
        #expect(obj.isActive == false)
    }
    
    @Test("ObservableProperty updates")
    func observablePropertyUpdates() async throws {
        let obj = TestObservableObject()
        
        obj.name = "Test"
        #expect(obj.name == "Test")
        
        obj.age = 25
        #expect(obj.age == 25)
        
        obj.isActive = true
        #expect(obj.isActive == true)
    }
    
    @Test("Observable subscription")
    func observableSubscription() async throws {
        let obj = TestObservableObject()
        var notificationCount = 0
        
        obj.subscribe {
            notificationCount += 1
        }
        
        obj.name = "Updated"
        
        // Give some time for the async notification
        try await Task.sleep(for: .milliseconds(10))
        
        #expect(notificationCount > 0)
    }
    
    @Test("ObservableState property wrapper creation")
    func observableStateCreation() async throws {
        @ObservableState var testObject = TestObservableObject()
        
        #expect(testObject.name == "")
        #expect(testObject.age == 0)
    }
    
    @Test("ObservableState value access")
    func observableStateValueAccess() async throws {
        let obj = TestObservableObject()
        @ObservableState var testObject = obj
        
        testObject.name = "Hello"
        #expect(testObject.name == "Hello")
        
        testObject.age = 30
        #expect(testObject.age == 30)
    }
    
    @Test("Multiple observable properties")
    func multipleObservableProperties() async throws {
        let obj = TestObservableObject()
        var nameChangeCount = 0
        var ageChangeCount = 0
        
        obj.subscribe {
            // This will be called for any property change
            if obj.name != "" {
                nameChangeCount += 1
            }
            if obj.age != 0 {
                ageChangeCount += 1
            }
        }
        
        obj.name = "Test"
        obj.age = 25
        
        // Give some time for async notifications
        try await Task.sleep(for: .milliseconds(20))
        
        #expect(obj.name == "Test")
        #expect(obj.age == 25)
    }
    
    @Test("Observable base protocol conformance")
    func observableProtocolConformance() async throws {
        let obj = TestObservableObject()
        let observable: Observable = obj
        
        var notificationReceived = false
        observable.subscribe {
            notificationReceived = true
        }
        
        obj.notifyObservers()
        
        // Give some time for async notification
        try await Task.sleep(for: .milliseconds(10))
        
        #expect(notificationReceived == true)
    }
}