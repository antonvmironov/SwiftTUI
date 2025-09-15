import XCTest
@testable import SwiftTUI

final class BindingTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testBasicInitialization() throws {
        var value = 42
        let binding = Binding(
            get: { value },
            set: { value = $0 }
        )
        
        XCTAssertEqual(binding.wrappedValue, 42)
    }
    
    func testGetterExecution() throws {
        var value = "Hello"
        var getterCallCount = 0
        
        let binding = Binding(
            get: {
                getterCallCount += 1
                return value
            },
            set: { value = $0 }
        )
        
        XCTAssertEqual(getterCallCount, 0)
        
        let result = binding.wrappedValue
        XCTAssertEqual(result, "Hello")
        XCTAssertEqual(getterCallCount, 1)
        
        // Access again
        let result2 = binding.wrappedValue
        XCTAssertEqual(result2, "Hello")
        XCTAssertEqual(getterCallCount, 2)
    }
    
    func testSetterExecution() throws {
        var value = 100
        var setterCallCount = 0
        
        let binding = Binding(
            get: { value },
            set: { newValue in
                setterCallCount += 1
                value = newValue
            }
        )
        
        XCTAssertEqual(setterCallCount, 0)
        XCTAssertEqual(value, 100)
        
        binding.wrappedValue = 200
        
        XCTAssertEqual(setterCallCount, 1)
        XCTAssertEqual(value, 200)
        XCTAssertEqual(binding.wrappedValue, 200)
    }
    
    // MARK: - Projected Value Tests
    
    func testProjectedValue() throws {
        var value = "Test"
        let binding = Binding(
            get: { value },
            set: { value = $0 }
        )
        
        let projected = binding.projectedValue
        
        // Projected value should be the binding itself
        XCTAssertEqual(projected.wrappedValue, "Test")
        
        projected.wrappedValue = "Updated"
        XCTAssertEqual(value, "Updated")
        XCTAssertEqual(binding.wrappedValue, "Updated")
    }
    
    // MARK: - Different Data Types Tests
    
    func testIntBinding() throws {
        var intValue = 5
        let binding = Binding(
            get: { intValue },
            set: { intValue = $0 }
        )
        
        XCTAssertEqual(binding.wrappedValue, 5)
        
        binding.wrappedValue = 10
        XCTAssertEqual(intValue, 10)
        XCTAssertEqual(binding.wrappedValue, 10)
    }
    
    func testBoolBinding() throws {
        var boolValue = false
        let binding = Binding(
            get: { boolValue },
            set: { boolValue = $0 }
        )
        
        XCTAssertFalse(binding.wrappedValue)
        
        binding.wrappedValue = true
        XCTAssertTrue(boolValue)
        XCTAssertTrue(binding.wrappedValue)
    }
    
    func testStringBinding() throws {
        var stringValue = "Initial"
        let binding = Binding(
            get: { stringValue },
            set: { stringValue = $0 }
        )
        
        XCTAssertEqual(binding.wrappedValue, "Initial")
        
        binding.wrappedValue = "Modified"
        XCTAssertEqual(stringValue, "Modified")
        XCTAssertEqual(binding.wrappedValue, "Modified")
    }
    
    func testArrayBinding() throws {
        var arrayValue = [1, 2, 3]
        let binding = Binding(
            get: { arrayValue },
            set: { arrayValue = $0 }
        )
        
        XCTAssertEqual(binding.wrappedValue, [1, 2, 3])
        
        binding.wrappedValue = [4, 5, 6]
        XCTAssertEqual(arrayValue, [4, 5, 6])
        XCTAssertEqual(binding.wrappedValue, [4, 5, 6])
    }
    
    func testOptionalBinding() throws {
        var optionalValue: Int? = nil
        let binding = Binding(
            get: { optionalValue },
            set: { optionalValue = $0 }
        )
        
        XCTAssertNil(binding.wrappedValue)
        
        binding.wrappedValue = 42
        XCTAssertEqual(optionalValue, 42)
        XCTAssertEqual(binding.wrappedValue, 42)
        
        binding.wrappedValue = nil
        XCTAssertNil(optionalValue)
        XCTAssertNil(binding.wrappedValue)
    }
    
    // MARK: - Complex Object Tests
    
    func testStructBinding() throws {
        struct TestStruct: Equatable {
            var name: String
            var age: Int
        }
        
        var structValue = TestStruct(name: "Alice", age: 30)
        let binding = Binding(
            get: { structValue },
            set: { structValue = $0 }
        )
        
        XCTAssertEqual(binding.wrappedValue.name, "Alice")
        XCTAssertEqual(binding.wrappedValue.age, 30)
        
        binding.wrappedValue = TestStruct(name: "Bob", age: 25)
        XCTAssertEqual(structValue.name, "Bob")
        XCTAssertEqual(structValue.age, 25)
    }
    
    // MARK: - Binding Chain Tests
    
    func testBindingChain() throws {
        var originalValue = 10
        
        let firstBinding = Binding(
            get: { originalValue },
            set: { originalValue = $0 }
        )
        
        let secondBinding = Binding(
            get: { firstBinding.wrappedValue * 2 },
            set: { firstBinding.wrappedValue = $0 / 2 }
        )
        
        XCTAssertEqual(secondBinding.wrappedValue, 20) // 10 * 2
        
        secondBinding.wrappedValue = 40
        XCTAssertEqual(originalValue, 20) // 40 / 2
        XCTAssertEqual(firstBinding.wrappedValue, 20)
        XCTAssertEqual(secondBinding.wrappedValue, 40) // 20 * 2
    }
    
    // MARK: - Nonmutating Setter Tests
    
    func testNonmutatingSetterBehavior() throws {
        var value = "Original"
        let binding = Binding(
            get: { value },
            set: { value = $0 }
        )
        
        // The binding is declared as 'let' but we can still modify wrappedValue
        // because the setter is nonmutating
        binding.wrappedValue = "Modified"
        XCTAssertEqual(value, "Modified")
        XCTAssertEqual(binding.wrappedValue, "Modified")
    }
    
    // MARK: - Capture and Escape Tests
    
    func testEscapingClosures() throws {
        var value = 100
        
        func createBinding() -> Binding<Int> {
            return Binding(
                get: { value },
                set: { value = $0 }
            )
        }
        
        let binding = createBinding()
        XCTAssertEqual(binding.wrappedValue, 100)
        
        binding.wrappedValue = 200
        XCTAssertEqual(value, 200)
    }
    
    func testMultipleBindingsToSameValue() throws {
        var sharedValue = 42
        
        let binding1 = Binding(
            get: { sharedValue },
            set: { sharedValue = $0 }
        )
        
        let binding2 = Binding(
            get: { sharedValue },
            set: { sharedValue = $0 }
        )
        
        XCTAssertEqual(binding1.wrappedValue, 42)
        XCTAssertEqual(binding2.wrappedValue, 42)
        
        binding1.wrappedValue = 100
        XCTAssertEqual(binding2.wrappedValue, 100)
        
        binding2.wrappedValue = 200
        XCTAssertEqual(binding1.wrappedValue, 200)
        XCTAssertEqual(sharedValue, 200)
    }
}