import XCTest
@testable import SwiftTUI

final class SizeTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testSizeInitialization() throws {
        let size = Size(width: 10, height: 20)
        XCTAssertEqual(size.width, Extended(10))
        XCTAssertEqual(size.height, Extended(20))
    }
    
    func testSizeWithExtended() throws {
        let size = Size(width: Extended(15), height: Extended.infinity)
        XCTAssertEqual(size.width, Extended(15))
        XCTAssertEqual(size.height, Extended.infinity)
    }
    
    // MARK: - Static Properties Tests
    
    func testZeroSize() throws {
        let zero = Size.zero
        XCTAssertEqual(zero.width, Extended(0))
        XCTAssertEqual(zero.height, Extended(0))
    }
    
    // MARK: - Equality Tests
    
    func testSizeEquality() throws {
        let size1 = Size(width: 10, height: 20)
        let size2 = Size(width: 10, height: 20)
        let size3 = Size(width: 15, height: 20)
        
        XCTAssertEqual(size1, size2)
        XCTAssertNotEqual(size1, size3)
    }
    
    func testSizeEqualityWithInfinity() throws {
        let size1 = Size(width: Extended.infinity, height: 20)
        let size2 = Size(width: Extended.infinity, height: 20)
        let size3 = Size(width: 10, height: 20)
        
        XCTAssertEqual(size1, size2)
        XCTAssertNotEqual(size1, size3)
    }
    
    // MARK: - Description Tests
    
    func testSizeDescription() throws {
        let size = Size(width: 10, height: 20)
        XCTAssertEqual(size.description, "10x20")
    }
    
    func testSizeDescriptionWithInfinity() throws {
        let size = Size(width: Extended.infinity, height: 20)
        XCTAssertEqual(size.description, "∞x20")
    }
    
    func testZeroSizeDescription() throws {
        let zero = Size.zero
        XCTAssertEqual(zero.description, "0x0")
    }
}