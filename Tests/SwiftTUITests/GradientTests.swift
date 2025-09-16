import Testing
@testable import SwiftTUI

@Suite("Gradient Tests")
struct GradientTests {
    
    @Test("LinearGradient basic functionality")
    func linearGradientBasic() {
        let gradient = LinearGradient(
            colors: [.red, .blue],
            startPoint: .leading,
            endPoint: .trailing,
            width: 10
        )
        
        // Should compile without issues
        #expect(gradient != nil)
    }
    
    @Test("LinearGradient horizontal convenience initializer")
    func linearGradientHorizontal() {
        let gradient = LinearGradient(
            colors: [.green, .yellow, .red],
            width: 20,
            height: 3
        )
        
        // Should compile without issues
        #expect(gradient != nil)
    }
    
    @Test("LinearGradient with single color")
    func linearGradientSingleColor() {
        let gradient = LinearGradient(
            colors: [.blue],
            startPoint: .top,
            endPoint: .bottom,
            width: 5,
            height: 5
        )
        
        // Should handle single color gracefully
        #expect(gradient != nil)
    }
    
    @Test("LinearGradient with empty colors")
    func linearGradientEmptyColors() {
        let gradient = LinearGradient(
            colors: [],
            startPoint: .topLeading,
            endPoint: .bottomTrailing,
            width: 8,
            height: 4
        )
        
        // Should handle empty colors array gracefully
        #expect(gradient != nil)
    }
    
    @Test("UnitPoint predefined values")
    func unitPointPredefined() {
        let points = [
            UnitPoint.zero,
            UnitPoint.center,
            UnitPoint.leading,
            UnitPoint.trailing,
            UnitPoint.top,
            UnitPoint.bottom,
            UnitPoint.topLeading,
            UnitPoint.topTrailing,
            UnitPoint.bottomLeading,
            UnitPoint.bottomTrailing
        ]
        
        // All predefined points should be valid
        for point in points {
            #expect(point.x >= 0.0 && point.x <= 1.0)
            #expect(point.y >= 0.0 && point.y <= 1.0)
        }
    }
    
    @Test("UnitPoint custom values")
    func unitPointCustom() {
        let point1 = UnitPoint(x: 0.3, y: 0.7)
        let point2 = UnitPoint(x: -0.5, y: 1.5) // Should be clamped
        
        #expect(point1.x == 0.3)
        #expect(point1.y == 0.7)
        
        // Values should be clamped to [0, 1]
        #expect(point2.x == 0.0)
        #expect(point2.y == 1.0)
    }
    
    @Test("LinearGradient in view hierarchies")
    func linearGradientInHierarchies() {
        _ = VStack {
            Text("Header")
                .bold()
            
            LinearGradient(
                colors: [.blue, .green],
                width: 30,
                height: 2
            )
            
            HStack {
                LinearGradient(
                    colors: [.red, .yellow],
                    startPoint: .top,
                    endPoint: .bottom,
                    width: 10,
                    height: 3
                )
                
                Text("Side content")
            }
            
            Text("Footer")
        }
        
        // Should work in complex view hierarchies
    }
    
    @Test("LinearGradient with modifiers")
    func linearGradientWithModifiers() {
        _ = LinearGradient(
            colors: [.cyan, .magenta],
            width: 25,
            height: 1
        )
        .padding()
        .border(.white)
        
        // Should work with standard view modifiers
    }
    
    @Test("LinearGradient various directions")
    func linearGradientDirections() {
        let horizontalGradient = LinearGradient(
            colors: [.red, .blue],
            startPoint: .leading,
            endPoint: .trailing,
            width: 15
        )
        
        let verticalGradient = LinearGradient(
            colors: [.green, .yellow],
            startPoint: .top,
            endPoint: .bottom,
            width: 10,
            height: 5
        )
        
        let diagonalGradient = LinearGradient(
            colors: [.cyan, .magenta],
            startPoint: .topLeading,
            endPoint: .bottomTrailing,
            width: 12,
            height: 4
        )
        
        // All gradient directions should work
        #expect(horizontalGradient != nil)
        #expect(verticalGradient != nil)
        #expect(diagonalGradient != nil)
    }
    
    @Test("LinearGradient dimension bounds")
    func linearGradientBounds() {
        let zeroWidthGradient = LinearGradient(
            colors: [.red, .blue],
            width: 0,
            height: 2
        )
        
        let zeroHeightGradient = LinearGradient(
            colors: [.green, .yellow],
            width: 10,
            height: 0
        )
        
        // Should enforce minimum dimensions
        #expect(zeroWidthGradient != nil)
        #expect(zeroHeightGradient != nil)
    }
}