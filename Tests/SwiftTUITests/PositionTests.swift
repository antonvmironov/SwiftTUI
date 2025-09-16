import Testing
@testable import SwiftTUI

struct PositionTests {
    @Test("Position addition works correctly")
    func add() throws {
        let pos1 = Position(column: 1, line: 2)
        let pos2 = Position(column: 5, line: 6)
        #expect(pos1 + pos2 == Position(column: 6, line: 8))
    }

    @Test("Position subtraction works correctly")
    func subtract() throws {
        let pos1 = Position(column: 1, line: 2)
        let pos2 = Position(column: 5, line: 6)
        #expect(pos2 - pos1 == Position(column: 4, line: 4))
    }
}
