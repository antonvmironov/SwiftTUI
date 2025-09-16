import Testing
@testable import SwiftTUI

struct SizeTests {
    
    // MARK: - Initialization Tests
    
    @Test("Size initialization with width and height")
    func sizeInitialization() throws {
        let size = Size(width: 10, height: 20)
        #expect(size.width == Extended(10))
        #expect(size.height == Extended(20))
    }
    
    @Test("Size initialization with Extended values")
    func sizeWithExtended() throws {
        let size = Size(width: Extended(15), height: Extended.infinity)
        #expect(size.width == Extended(15))
        #expect(size.height == Extended.infinity)
    }
    
    // MARK: - Static Properties Tests
    
    @Test("Zero size has correct dimensions")
    func zeroSize() throws {
        let zero = Size.zero
        #expect(zero.width == Extended(0))
        #expect(zero.height == Extended(0))
    }
    
    // MARK: - Equality Tests
    
    @Test("Size equality works correctly")
    func sizeEquality() throws {
        let size1 = Size(width: 10, height: 20)
        let size2 = Size(width: 10, height: 20)
        let size3 = Size(width: 15, height: 20)
        
        #expect(size1 == size2)
        #expect(size1 != size3)
    }
    
    @Test("Size equality works with infinity")
    func sizeEqualityWithInfinity() throws {
        let size1 = Size(width: Extended.infinity, height: 20)
        let size2 = Size(width: Extended.infinity, height: 20)
        let size3 = Size(width: 10, height: 20)
        
        #expect(size1 == size2)
        #expect(size1 != size3)
    }
    
    // MARK: - Description Tests
    
    @Test("Size description format is correct")
    func sizeDescription() throws {
        let size = Size(width: 10, height: 20)
        #expect(size.description == "10x20")
    }
    
    @Test("Size description works with infinity")
    func sizeDescriptionWithInfinity() throws {
        let size = Size(width: Extended.infinity, height: 20)
        #expect(size.description == "∞x20")
    }
    
    @Test("Zero size description is correct")
    func zeroSizeDescription() throws {
        let zero = Size.zero
        #expect(zero.description == "0x0")
    }
}