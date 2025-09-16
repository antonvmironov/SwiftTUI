import Foundation

/// A simple animation system for terminal environments
/// Provides basic timing functions and a SwiftUI-compatible API

/// Represents an animation's timing and easing characteristics
public struct Animation: Equatable, Sendable {
    public let duration: TimeInterval
    public let easing: AnimationCurve
    public let delay: TimeInterval
    
    private init(duration: TimeInterval, easing: AnimationCurve, delay: TimeInterval = 0) {
        self.duration = duration
        self.easing = easing
        self.delay = delay
    }
    
    /// Default animation with ease-in-out timing
    public static let `default` = Animation(duration: 0.25, easing: .easeInOut)
    
    /// Linear animation (constant speed)
    public static func linear(duration: TimeInterval) -> Animation {
        Animation(duration: duration, easing: .linear)
    }
    
    /// Ease-in animation (starts slow, accelerates)
    public static func easeIn(duration: TimeInterval) -> Animation {
        Animation(duration: duration, easing: .easeIn)
    }
    
    /// Ease-out animation (starts fast, decelerates)
    public static func easeOut(duration: TimeInterval) -> Animation {
        Animation(duration: duration, easing: .easeOut)
    }
    
    /// Ease-in-out animation (smooth acceleration and deceleration)
    public static func easeInOut(duration: TimeInterval) -> Animation {
        Animation(duration: duration, easing: .easeInOut)
    }
    
    /// Adds a delay to the animation
    public func delay(_ delay: TimeInterval) -> Animation {
        Animation(duration: duration, easing: easing, delay: delay)
    }
}

/// Animation timing curves for terminal environments
public enum AnimationCurve: Equatable, Sendable {
    case linear
    case easeIn
    case easeOut
    case easeInOut
    
    /// Calculates the animation progress for a given time ratio (0.0 to 1.0)
    public func progress(for ratio: Double) -> Double {
        let clampedRatio = max(0.0, min(1.0, ratio))
        
        switch self {
        case .linear:
            return clampedRatio
        case .easeIn:
            return clampedRatio * clampedRatio
        case .easeOut:
            return 1.0 - (1.0 - clampedRatio) * (1.0 - clampedRatio)
        case .easeInOut:
            if clampedRatio < 0.5 {
                return 2.0 * clampedRatio * clampedRatio
            } else {
                return 1.0 - 2.0 * (1.0 - clampedRatio) * (1.0 - clampedRatio)
            }
        }
    }
}

/// Global function to create animations (SwiftUI-style API)
/// This is a simplified implementation that provides the API without complex concurrency
@MainActor
public func withAnimation<Result>(
    _ animation: Animation = .default,
    _ body: () throws -> Result
) rethrows -> Result {
    // For now, this simply executes the body
    // In a full implementation, this would coordinate with the animation system
    return try body()
}

/// Helper function to interpolate between Double values
public func interpolate(from start: Double, to end: Double, progress: Double) -> Double {
    return start + (end - start) * progress
}

/// Helper function to interpolate between Float values
public func interpolate(from start: Float, to end: Float, progress: Double) -> Float {
    return start + (end - start) * Float(progress)
}

/// Helper function to interpolate between integer values  
public func interpolate(from start: Int, to end: Int, progress: Double) -> Int {
    return Int(Double(start) + (Double(end) - Double(start)) * progress)
}