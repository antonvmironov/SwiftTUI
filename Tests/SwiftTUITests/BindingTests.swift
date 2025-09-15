import Testing
@testable import SwiftTUI

struct BindingTests {
    
    // MARK: - Initialization Tests
    
    @Test("Basic binding initialization works correctly")
    func basicInitialization() throws {
        var value = 42
        let binding = Binding(
            get: { value },
            set: { value = $0 }
        )
        
        #expect(binding.wrappedValue == 42)
    }
    
    @Test("Getter is executed when accessing wrappedValue")
    func getterExecution() throws {
        var value = "Hello"
        var getterCallCount = 0
        
        let binding = Binding(
            get: {
                getterCallCount += 1
                return value
            },
            set: { value = $0 }
        )
        
        #expect(getterCallCount == 0)
        
        let result = binding.wrappedValue
        #expect(result == "Hello")
        #expect(getterCallCount == 1)
        
        // Access again
        let result2 = binding.wrappedValue
        #expect(result2 == "Hello")
        #expect(getterCallCount == 2)
    }
    
    @Test("Setter is executed when modifying wrappedValue")
    func setterExecution() throws {
        var value = 100
        var setterCallCount = 0
        
        let binding = Binding(
            get: { value },
            set: { newValue in
                setterCallCount += 1
                value = newValue
            }
        )
        
        #expect(setterCallCount == 0)
        #expect(value == 100)
        
        binding.wrappedValue = 200
        
        #expect(setterCallCount == 1)
        #expect(value == 200)
        #expect(binding.wrappedValue == 200)
    }
    
    // MARK: - Projected Value Tests
    
    @Test("Projected value returns the binding itself")
    func projectedValue() throws {
        var value = "Test"
        let binding = Binding(
            get: { value },
            set: { value = $0 }
        )
        
        let projected = binding.projectedValue
        
        // Projected value should be the binding itself
        #expect(projected.wrappedValue == "Test")
        
        projected.wrappedValue = "Updated"
        #expect(value == "Updated")
        #expect(binding.wrappedValue == "Updated")
    }
    
    // MARK: - Different Data Types Tests
    
    @Test("Int binding works correctly")
    func intBinding() throws {
        var intValue = 5
        let binding = Binding(
            get: { intValue },
            set: { intValue = $0 }
        )
        
        #expect(binding.wrappedValue == 5)
        
        binding.wrappedValue = 10
        #expect(intValue == 10)
        #expect(binding.wrappedValue == 10)
    }
    
    @Test("Bool binding works correctly")
    func boolBinding() throws {
        var boolValue = false
        let binding = Binding(
            get: { boolValue },
            set: { boolValue = $0 }
        )
        
        #expect(!binding.wrappedValue)
        
        binding.wrappedValue = true
        #expect(boolValue)
        #expect(binding.wrappedValue)
    }
    
    @Test("String binding works correctly")
    func stringBinding() throws {
        var stringValue = "Initial"
        let binding = Binding(
            get: { stringValue },
            set: { stringValue = $0 }
        )
        
        #expect(binding.wrappedValue == "Initial")
        
        binding.wrappedValue = "Modified"
        #expect(stringValue == "Modified")
        #expect(binding.wrappedValue == "Modified")
    }
    
    @Test("Array binding works correctly")
    func arrayBinding() throws {
        var arrayValue = [1, 2, 3]
        let binding = Binding(
            get: { arrayValue },
            set: { arrayValue = $0 }
        )
        
        #expect(binding.wrappedValue == [1, 2, 3])
        
        binding.wrappedValue = [4, 5, 6]
        #expect(arrayValue == [4, 5, 6])
        #expect(binding.wrappedValue == [4, 5, 6])
    }
    
    @Test("Optional binding works correctly")
    func optionalBinding() throws {
        var optionalValue: Int? = nil
        let binding = Binding(
            get: { optionalValue },
            set: { optionalValue = $0 }
        )
        
        #expect(binding.wrappedValue == nil)
        
        binding.wrappedValue = 42
        #expect(optionalValue == 42)
        #expect(binding.wrappedValue == 42)
        
        binding.wrappedValue = nil
        #expect(optionalValue == nil)
        #expect(binding.wrappedValue == nil)
    }
    
    // MARK: - Complex Object Tests
    
    @Test("Struct binding works correctly")
    func structBinding() throws {
        struct TestStruct: Equatable {
            var name: String
            var age: Int
        }
        
        var structValue = TestStruct(name: "Alice", age: 30)
        let binding = Binding(
            get: { structValue },
            set: { structValue = $0 }
        )
        
        #expect(binding.wrappedValue.name == "Alice")
        #expect(binding.wrappedValue.age == 30)
        
        binding.wrappedValue = TestStruct(name: "Bob", age: 25)
        #expect(structValue.name == "Bob")
        #expect(structValue.age == 25)
    }
    
    // MARK: - Binding Chain Tests
    
    @Test("Binding chains work correctly")
    func bindingChain() throws {
        var originalValue = 10
        
        let firstBinding = Binding(
            get: { originalValue },
            set: { originalValue = $0 }
        )
        
        let secondBinding = Binding(
            get: { firstBinding.wrappedValue * 2 },
            set: { firstBinding.wrappedValue = $0 / 2 }
        )
        
        #expect(secondBinding.wrappedValue == 20) // 10 * 2
        
        secondBinding.wrappedValue = 40
        #expect(originalValue == 20) // 40 / 2
        #expect(firstBinding.wrappedValue == 20)
        #expect(secondBinding.wrappedValue == 40) // 20 * 2
    }
    
    // MARK: - Nonmutating Setter Tests
    
    @Test("Nonmutating setter allows modification through let binding")
    func nonmutatingSetterBehavior() throws {
        var value = "Original"
        let binding = Binding(
            get: { value },
            set: { value = $0 }
        )
        
        // The binding is declared as 'let' but we can still modify wrappedValue
        // because the setter is nonmutating
        binding.wrappedValue = "Modified"
        #expect(value == "Modified")
        #expect(binding.wrappedValue == "Modified")
    }
    
    // MARK: - Capture and Escape Tests
    
    @Test("Escaping closures work correctly")
    func escapingClosures() throws {
        var value = 100
        
        func createBinding() -> Binding<Int> {
            return Binding(
                get: { value },
                set: { value = $0 }
            )
        }
        
        let binding = createBinding()
        #expect(binding.wrappedValue == 100)
        
        binding.wrappedValue = 200
        #expect(value == 200)
    }
    
    @Test("Multiple bindings to same value work correctly")
    func multipleBindingsToSameValue() throws {
        var sharedValue = 42
        
        let binding1 = Binding(
            get: { sharedValue },
            set: { sharedValue = $0 }
        )
        
        let binding2 = Binding(
            get: { sharedValue },
            set: { sharedValue = $0 }
        )
        
        #expect(binding1.wrappedValue == 42)
        #expect(binding2.wrappedValue == 42)
        
        binding1.wrappedValue = 100
        #expect(binding2.wrappedValue == 100)
        
        binding2.wrappedValue = 200
        #expect(binding1.wrappedValue == 200)
        #expect(sharedValue == 200)
    }
}