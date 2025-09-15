import XCTest
@testable import SwiftTUI

final class ExtendedTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testIntInitialization() throws {
        let extended = Extended(42)
        XCTAssertEqual(extended.intValue, 42)
    }
    
    func testIntegerLiteralInitialization() throws {
        let extended: Extended = 100
        XCTAssertEqual(extended.intValue, 100)
    }
    
    func testInfinityInitialization() throws {
        let infinity = Extended.infinity
        // infinity.intValue should crash with fatalError, so we won't test it directly
        // We can test that infinity was created successfully by comparing with another infinity
        XCTAssertEqual(infinity, Extended.infinity)
    }
    
    // MARK: - Equality Tests
    
    func testNumberEquality() throws {
        let a: Extended = 5
        let b: Extended = 5
        let c: Extended = 10
        
        XCTAssertEqual(a, b)
        XCTAssertNotEqual(a, c)
    }
    
    func testInfinityEquality() throws {
        let inf1 = Extended.infinity
        let inf2 = Extended.infinity
        let finite: Extended = 100
        
        XCTAssertEqual(inf1, inf2)
        XCTAssertNotEqual(inf1, finite)
    }
    
    // MARK: - Addition Tests
    
    func testFiniteAddition() throws {
        let a: Extended = 5
        let b: Extended = 3
        let result = a + b
        
        XCTAssertEqual(result.intValue, 8)
    }
    
    func testInfinityAddition() throws {
        let inf = Extended.infinity
        let finite: Extended = 100
        
        let result1 = inf + finite
        let result2 = finite + inf
        
        XCTAssertEqual(result1, Extended.infinity)
        XCTAssertEqual(result2, Extended.infinity)
        
        // Test that adding two positive infinities works
        let result3 = inf + inf
        XCTAssertEqual(result3, Extended.infinity)
        
        // Test that adding two negative infinities works
        let negInf = -Extended.infinity
        let result4 = negInf + negInf
        XCTAssertEqual(result4, negInf)
    }
    
    // MARK: - Subtraction Tests
    
    func testFiniteSubtraction() throws {
        let a: Extended = 10
        let b: Extended = 3
        let result = a - b
        
        XCTAssertEqual(result.intValue, 7)
    }
    
    func testInfinitySubtraction() throws {
        let inf = Extended.infinity
        let finite: Extended = 100
        
        let result1 = inf - finite
        let result2 = finite - inf
        
        XCTAssertEqual(result1, Extended.infinity)
        XCTAssertEqual(result2, -Extended.infinity)
        
        // Test subtraction between positive and negative infinity
        let negInf = -Extended.infinity
        let result3 = inf - negInf
        let result4 = negInf - inf
        
        XCTAssertEqual(result3, Extended.infinity)
        XCTAssertEqual(result4, -Extended.infinity)
    }
    
    // MARK: - Multiplication Tests
    
    func testFiniteMultiplication() throws {
        let a: Extended = 4
        let b: Extended = 3
        let result = a * b
        
        XCTAssertEqual(result.intValue, 12)
    }
    
    func testInfinityMultiplication() throws {
        let inf = Extended.infinity
        let positive: Extended = 5
        let negative: Extended = -3
        
        let result1 = inf * positive
        let result2 = inf * negative
        
        XCTAssertEqual(result1, Extended.infinity)
        XCTAssertEqual(result2, -Extended.infinity)
    }
    
    // MARK: - Division Tests
    
    func testFiniteDivision() throws {
        let a: Extended = 12
        let b: Extended = 3
        let result = a / b
        
        XCTAssertEqual(result.intValue, 4)
    }
    
    func testDivisionByZero() throws {
        let a: Extended = 10
        let zero: Extended = 0
        let result = a / zero
        
        XCTAssertEqual(result, Extended.infinity)
    }
    
    func testInfinityDivision() throws {
        let inf = Extended.infinity
        let finite: Extended = 100
        
        let result1 = inf / finite
        let result2 = finite / inf
        
        XCTAssertEqual(result1, Extended.infinity)
        XCTAssertEqual(result2, Extended(0))
    }
    
    // MARK: - Comparison Tests
    
    func testFiniteComparison() throws {
        let a: Extended = 5
        let b: Extended = 10
        let c: Extended = 5
        
        XCTAssertTrue(a < b)
        XCTAssertFalse(b < a)
        XCTAssertFalse(a < c)
        XCTAssertFalse(c < a)
    }
    
    func testInfinityComparison() throws {
        let inf = Extended.infinity
        let negInf = -Extended.infinity
        let finite: Extended = 100
        
        XCTAssertTrue(finite < inf)
        XCTAssertFalse(inf < finite)
        XCTAssertTrue(negInf < finite)
        XCTAssertFalse(finite < negInf)
        XCTAssertTrue(negInf < inf)
        XCTAssertFalse(inf < negInf)
    }
    
    // MARK: - Negation Tests
    
    func testFiniteNegation() throws {
        let a: Extended = 5
        let result = -a
        
        XCTAssertEqual(result.intValue, -5)
    }
    
    func testInfinityNegation() throws {
        let inf = Extended.infinity
        let negInf = -inf
        let posInf = -negInf
        
        XCTAssertEqual(posInf, Extended.infinity)
    }
    
    // MARK: - Max Function Tests
    
    func testMaxFinite() throws {
        let a: Extended = 5
        let b: Extended = 10
        let result = max(a, b)
        
        XCTAssertEqual(result.intValue, 10)
    }
    
    func testMaxWithInfinity() throws {
        let inf = Extended.infinity
        let finite: Extended = 100
        
        let result1 = max(inf, finite)
        let result2 = max(finite, inf)
        
        XCTAssertEqual(result1, Extended.infinity)
        XCTAssertEqual(result2, Extended.infinity)
    }
    
    // MARK: - Description Tests
    
    func testFiniteDescription() throws {
        let a: Extended = 42
        XCTAssertEqual(a.description, "42")
    }
    
    func testInfinityDescription() throws {
        let inf = Extended.infinity
        let negInf = -Extended.infinity
        
        XCTAssertEqual(inf.description, "∞")
        XCTAssertEqual(negInf.description, "-∞")
    }
}