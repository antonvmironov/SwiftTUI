import Testing
@testable import SwiftTUI

struct AlignmentTests {
    
    // MARK: - VerticalAlignment Tests
    
    @Test("VerticalAlignment has all expected cases")
    func verticalAlignmentCases() throws {
        let allCases = VerticalAlignment.allCases
        #expect(allCases.count == 3)
        #expect(allCases.contains(.top))
        #expect(allCases.contains(.center))
        #expect(allCases.contains(.bottom))
    }
    
    @Test("VerticalAlignment descriptions are correct")
    func verticalAlignmentDescription() throws {
        #expect(VerticalAlignment.top.description == "top")
        #expect(VerticalAlignment.center.description == "center")
        #expect(VerticalAlignment.bottom.description == "bottom")
    }
    
    @Test("VerticalAlignment equality works correctly")
    func verticalAlignmentEquality() throws {
        #expect(VerticalAlignment.top == VerticalAlignment.top)
        #expect(VerticalAlignment.center == VerticalAlignment.center)
        #expect(VerticalAlignment.bottom == VerticalAlignment.bottom)
        
        #expect(VerticalAlignment.top != VerticalAlignment.center)
        #expect(VerticalAlignment.center != VerticalAlignment.bottom)
        #expect(VerticalAlignment.top != VerticalAlignment.bottom)
    }
    
    @Test("VerticalAlignment implements Hashable correctly")
    func verticalAlignmentHashable() throws {
        let alignment1 = VerticalAlignment.top
        let alignment2 = VerticalAlignment.top
        let alignment3 = VerticalAlignment.center
        
        #expect(alignment1.hashValue == alignment2.hashValue)
        #expect(alignment1.hashValue != alignment3.hashValue)
        
        // Test that they can be used in sets
        let alignmentSet: Set<VerticalAlignment> = [.top, .center, .top]
        #expect(alignmentSet.count == 2)
    }
    
    // MARK: - HorizontalAlignment Tests
    
    @Test("HorizontalAlignment has all expected cases")
    func horizontalAlignmentCases() throws {
        let allCases = HorizontalAlignment.allCases
        #expect(allCases.count == 3)
        #expect(allCases.contains(.leading))
        #expect(allCases.contains(.center))
        #expect(allCases.contains(.trailing))
    }
    
    @Test("HorizontalAlignment descriptions are correct")
    func horizontalAlignmentDescription() throws {
        #expect(HorizontalAlignment.leading.description == "leading")
        #expect(HorizontalAlignment.center.description == "center")
        #expect(HorizontalAlignment.trailing.description == "trailing")
    }
    
    @Test("HorizontalAlignment equality works correctly")
    func horizontalAlignmentEquality() throws {
        #expect(HorizontalAlignment.leading == HorizontalAlignment.leading)
        #expect(HorizontalAlignment.center == HorizontalAlignment.center)
        #expect(HorizontalAlignment.trailing == HorizontalAlignment.trailing)
        
        #expect(HorizontalAlignment.leading != HorizontalAlignment.center)
        #expect(HorizontalAlignment.center != HorizontalAlignment.trailing)
        #expect(HorizontalAlignment.leading != HorizontalAlignment.trailing)
    }
    
    @Test("HorizontalAlignment implements Hashable correctly")
    func horizontalAlignmentHashable() throws {
        let alignment1 = HorizontalAlignment.leading
        let alignment2 = HorizontalAlignment.leading
        let alignment3 = HorizontalAlignment.center
        
        #expect(alignment1.hashValue == alignment2.hashValue)
        #expect(alignment1.hashValue != alignment3.hashValue)
        
        // Test that they can be used in sets
        let alignmentSet: Set<HorizontalAlignment> = [.leading, .center, .leading]
        #expect(alignmentSet.count == 2)
    }
    
    // MARK: - Alignment Tests
    
    @Test("Alignment initialization sets properties correctly")
    func alignmentInitialization() throws {
        let alignment = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        #expect(alignment.horizontalAlignment == .leading)
        #expect(alignment.verticalAlignment == .top)
    }
    
    @Test("Alignment description format is correct")
    func alignmentDescription() throws {
        let alignment1 = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        #expect(alignment1.description == "leading-top")
        
        let alignment2 = Alignment(horizontalAlignment: .center, verticalAlignment: .bottom)
        #expect(alignment2.description == "center-bottom")
        
        let alignment3 = Alignment(horizontalAlignment: .trailing, verticalAlignment: .center)
        #expect(alignment3.description == "trailing-center")
    }
    
    @Test("Alignment equality works correctly")
    func alignmentEquality() throws {
        let alignment1 = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        let alignment2 = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        let alignment3 = Alignment(horizontalAlignment: .center, verticalAlignment: .top)
        let alignment4 = Alignment(horizontalAlignment: .leading, verticalAlignment: .center)
        
        #expect(alignment1 == alignment2)
        #expect(alignment1 != alignment3)
        #expect(alignment1 != alignment4)
        #expect(alignment3 != alignment4)
    }
    
    @Test("Alignment implements Hashable correctly")
    func alignmentHashable() throws {
        let alignment1 = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        let alignment2 = Alignment(horizontalAlignment: .leading, verticalAlignment: .top)
        let alignment3 = Alignment(horizontalAlignment: .center, verticalAlignment: .top)
        
        #expect(alignment1.hashValue == alignment2.hashValue)
        #expect(alignment1.hashValue != alignment3.hashValue)
        
        // Test that they can be used in sets
        let alignmentSet: Set<Alignment> = [alignment1, alignment2, alignment3]
        #expect(alignmentSet.count == 2)
    }
    
    // MARK: - Static Alignment Tests
    
    @Test("Static alignments have correct component values")
    func staticAlignments() throws {
        // Test all static alignments
        #expect(Alignment.top.horizontalAlignment == .center)
        #expect(Alignment.top.verticalAlignment == .top)
        
        #expect(Alignment.bottom.horizontalAlignment == .center)
        #expect(Alignment.bottom.verticalAlignment == .bottom)
        
        #expect(Alignment.center.horizontalAlignment == .center)
        #expect(Alignment.center.verticalAlignment == .center)
        
        #expect(Alignment.topLeading.horizontalAlignment == .leading)
        #expect(Alignment.topLeading.verticalAlignment == .top)
        
        #expect(Alignment.leading.horizontalAlignment == .leading)
        #expect(Alignment.leading.verticalAlignment == .center)
        
        #expect(Alignment.bottomLeading.horizontalAlignment == .leading)
        #expect(Alignment.bottomLeading.verticalAlignment == .bottom)
        
        #expect(Alignment.topTrailing.horizontalAlignment == .trailing)
        #expect(Alignment.topTrailing.verticalAlignment == .top)
        
        #expect(Alignment.trailing.horizontalAlignment == .trailing)
        #expect(Alignment.trailing.verticalAlignment == .center)
        
        #expect(Alignment.bottomTrailing.horizontalAlignment == .trailing)
        #expect(Alignment.bottomTrailing.verticalAlignment == .bottom)
    }
    
    @Test("Static alignment descriptions are correct")
    func staticAlignmentDescriptions() throws {
        #expect(Alignment.top.description == "center-top")
        #expect(Alignment.bottom.description == "center-bottom")
        #expect(Alignment.center.description == "center-center")
        #expect(Alignment.topLeading.description == "leading-top")
        #expect(Alignment.leading.description == "leading-center")
        #expect(Alignment.bottomLeading.description == "leading-bottom")
        #expect(Alignment.topTrailing.description == "trailing-top")
        #expect(Alignment.trailing.description == "trailing-center")
        #expect(Alignment.bottomTrailing.description == "trailing-bottom")
    }
    
    @Test("All static alignments are unique")
    func staticAlignmentUniqueness() throws {
        let alignments = [
            Alignment.top, Alignment.bottom, Alignment.center,
            Alignment.topLeading, Alignment.leading, Alignment.bottomLeading,
            Alignment.topTrailing, Alignment.trailing, Alignment.bottomTrailing
        ]
        
        // All static alignments should be unique
        let alignmentSet = Set(alignments)
        #expect(alignmentSet.count == alignments.count)
    }
}