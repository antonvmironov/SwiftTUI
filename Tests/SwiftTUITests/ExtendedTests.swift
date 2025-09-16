import Testing
@testable import SwiftTUI

struct ExtendedTests {
    
    // MARK: - Initialization Tests
    
    @Test("Int initialization sets correct value")
    func intInitialization() throws {
        let extended = Extended(42)
        #expect(extended.intValue == 42)
    }
    
    @Test("Integer literal initialization works correctly")
    func integerLiteralInitialization() throws {
        let extended: Extended = 100
        #expect(extended.intValue == 100)
    }
    
    @Test("Infinity initialization creates correct instance")
    func infinityInitialization() throws {
        let infinity = Extended.infinity
        // infinity.intValue should crash with fatalError, so we won't test it directly
        // We can test that infinity was created successfully by comparing with another infinity
        #expect(infinity == Extended.infinity)
    }
    
    // MARK: - Equality Tests
    
    @Test("Number equality works correctly")
    func numberEquality() throws {
        let a: Extended = 5
        let b: Extended = 5
        let c: Extended = 10
        
        #expect(a == b)
        #expect(a != c)
    }
    
    @Test("Infinity equality works correctly")
    func infinityEquality() throws {
        let inf1 = Extended.infinity
        let inf2 = Extended.infinity
        let finite: Extended = 100
        
        #expect(inf1 == inf2)
        #expect(inf1 != finite)
    }
    
    // MARK: - Addition Tests
    
    @Test("Finite addition produces correct results")
    func finiteAddition() throws {
        let a: Extended = 5
        let b: Extended = 3
        let result = a + b
        
        #expect(result.intValue == 8)
    }
    
    @Test("Infinity addition behaves correctly")
    func infinityAddition() throws {
        let inf = Extended.infinity
        let finite: Extended = 100
        
        let result1 = inf + finite
        let result2 = finite + inf
        
        #expect(result1 == Extended.infinity)
        #expect(result2 == Extended.infinity)
        
        // Test that adding two positive infinities works
        let result3 = inf + inf
        #expect(result3 == Extended.infinity)
        
        // Test that adding two negative infinities works
        let negInf = -Extended.infinity
        let result4 = negInf + negInf
        #expect(result4 == negInf)
    }
    
    // MARK: - Subtraction Tests
    
    @Test("Finite subtraction produces correct results")
    func finiteSubtraction() throws {
        let a: Extended = 10
        let b: Extended = 3
        let result = a - b
        
        #expect(result.intValue == 7)
    }
    
    @Test("Infinity subtraction behaves correctly")
    func infinitySubtraction() throws {
        let inf = Extended.infinity
        let finite: Extended = 100
        
        let result1 = inf - finite
        let result2 = finite - inf
        
        #expect(result1 == Extended.infinity)
        #expect(result2 == -Extended.infinity)
        
        // Test subtraction between positive and negative infinity
        let negInf = -Extended.infinity
        let result3 = inf - negInf
        let result4 = negInf - inf
        
        #expect(result3 == Extended.infinity)
        #expect(result4 == -Extended.infinity)
    }
    
    // MARK: - Multiplication Tests
    
    @Test("Finite multiplication produces correct results")
    func finiteMultiplication() throws {
        let a: Extended = 4
        let b: Extended = 3
        let result = a * b
        
        #expect(result.intValue == 12)
    }
    
    @Test("Infinity multiplication behaves correctly")
    func infinityMultiplication() throws {
        let inf = Extended.infinity
        let positive: Extended = 5
        let negative: Extended = -3
        
        let result1 = inf * positive
        let result2 = inf * negative
        
        #expect(result1 == Extended.infinity)
        #expect(result2 == -Extended.infinity)
    }
    
    // MARK: - Division Tests
    
    @Test("Finite division produces correct results")
    func finiteDivision() throws {
        let a: Extended = 12
        let b: Extended = 3
        let result = a / b
        
        #expect(result.intValue == 4)
    }
    
    @Test("Division by zero returns infinity")
    func divisionByZero() throws {
        let a: Extended = 10
        let zero: Extended = 0
        let result = a / zero
        
        #expect(result == Extended.infinity)
    }
    
    @Test("Infinity division behaves correctly")
    func infinityDivision() throws {
        let inf = Extended.infinity
        let finite: Extended = 100
        
        let result1 = inf / finite
        let result2 = finite / inf
        
        #expect(result1 == Extended.infinity)
        #expect(result2 == Extended(0))
    }
    
    // MARK: - Comparison Tests
    
    @Test("Finite comparison works correctly")
    func finiteComparison() throws {
        let a: Extended = 5
        let b: Extended = 10
        let c: Extended = 5
        
        #expect(a < b)
        #expect(!(b < a))
        #expect(!(a < c))
        #expect(!(c < a))
    }
    
    @Test("Infinity comparison works correctly")
    func infinityComparison() throws {
        let inf = Extended.infinity
        let negInf = -Extended.infinity
        let finite: Extended = 100
        
        #expect(finite < inf)
        #expect(!(inf < finite))
        #expect(negInf < finite)
        #expect(!(finite < negInf))
        #expect(negInf < inf)
        #expect(!(inf < negInf))
    }
    
    // MARK: - Negation Tests
    
    @Test("Finite negation produces correct results")
    func finiteNegation() throws {
        let a: Extended = 5
        let result = -a
        
        #expect(result.intValue == -5)
    }
    
    @Test("Infinity negation works correctly")
    func infinityNegation() throws {
        let inf = Extended.infinity
        let negInf = -inf
        let posInf = -negInf
        
        #expect(posInf == Extended.infinity)
    }
    
    // MARK: - Max Function Tests
    
    @Test("Max function works for finite values")
    func maxFinite() throws {
        let a: Extended = 5
        let b: Extended = 10
        let result = max(a, b)
        
        #expect(result.intValue == 10)
    }
    
    @Test("Max function works with infinity")
    func maxWithInfinity() throws {
        let inf = Extended.infinity
        let finite: Extended = 100
        
        let result1 = max(inf, finite)
        let result2 = max(finite, inf)
        
        #expect(result1 == Extended.infinity)
        #expect(result2 == Extended.infinity)
    }
    
    // MARK: - Description Tests
    
    @Test("Finite description returns correct string")
    func finiteDescription() throws {
        let a: Extended = 42
        #expect(a.description == "42")
    }
    
    @Test("Infinity description returns correct symbols")
    func infinityDescription() throws {
        let inf = Extended.infinity
        let negInf = -Extended.infinity
        
        #expect(inf.description == "∞")
        #expect(negInf.description == "-∞")
    }
}