import Foundation

/// Colors can be used as views. Certain modifiers and views may also take colors as parameters.
///
/// There are different types of colors that can be used, but not all of them are supported by all
/// terminal emulators.
///
/// The named colors are ANSI colors. In many terminal emulators they are user-defined or part of a
/// theme, and bold text automatically uses the bright color variant.
public struct Color: Hashable, Sendable {
    private let data: Data
    private let opacity: Double

    private enum Data: Hashable {
        case ansi(ANSIColor)
        case xterm(XTermColor)
        case trueColor(TrueColor)
        case clear
    }

    private init(data: Data, opacity: Double = 1.0) {
        self.data = data
        self.opacity = opacity
    }

    static func ansi(_ color: ANSIColor) -> Color {
        Color(data: .ansi(color))
    }

    /// Creates a clear/transparent color
    public static var clear: Color {
        Color(data: .clear)
    }

    /// A low-resolution color from a 6 by 6 by 6 color cube. The red, green and blue components
    /// must be numbers between 0 and 5.
    public static func xterm(red: Int, green: Int, blue: Int) -> Color {
        Color(data: .xterm(.color(red: red, green: green, blue: blue)))
    }

    /// A grayscale color with white value between 0 and 23.
    public static func xterm(white: Int) -> Color {
        Color(data: .xterm(.grayscale(white: white)))
    }

    /// A 24-bit color value. The red, green and blue components must be numbers between 0 and 255.
    /// Not all terminals support this.
    public static func trueColor(red: Int, green: Int, blue: Int) -> Color {
        Color(data: .trueColor(TrueColor(red: red, green: green, blue: blue)))
    }

    /// Creates a new color with the specified opacity.
    /// - Parameter opacity: The opacity value between 0.0 (transparent) and 1.0 (opaque)
    /// - Returns: A new color with the specified opacity
    public func opacity(_ opacity: Double) -> Color {
        Color(data: self.data, opacity: max(0.0, min(1.0, opacity)))
    }

    var foregroundEscapeSequence: String {
        switch data {
        case .ansi(let color):
            return applyOpacity(EscapeSequence.setForegroundColor(color))
        case .trueColor(let color):
            return applyOpacity(EscapeSequence.setForegroundColor(red: color.red, green: color.green, blue: color.blue))
        case .xterm(let color):
            return applyOpacity(EscapeSequence.setForegroundColor(xterm: color.value))
        case .clear:
            return "" // Clear color produces no output
        }
    }

    var backgroundEscapeSequence: String {
        switch data {
        case .ansi(let color):
            return applyOpacity(EscapeSequence.setBackgroundColor(color))
        case .trueColor(let color):
            return applyOpacity(EscapeSequence.setBackgroundColor(red: color.red, green: color.green, blue: color.blue))
        case .xterm(let color):
            return applyOpacity(EscapeSequence.setBackgroundColor(xterm: color.value))
        case .clear:
            return "" // Clear color produces no output
        }
    }

    private func applyOpacity(_ escapeSequence: String) -> String {
        if opacity < 1.0 {
            // For terminal environments, we can simulate opacity by using dim text
            // This is a simple approximation since true opacity isn't available in most terminals
            if opacity < 0.5 {
                return EscapeSequence.setDim + escapeSequence
            }
        }
        return escapeSequence
    }

    public static var `default`: Color { Color.ansi(.default) }

    // Semantic colors that adapt to terminal themes
    /// Primary text color - adapts to terminal theme
    public static var primary: Color { Color.ansi(.default) }
    /// Secondary text color - usually dimmer than primary
    public static var secondary: Color { Color.ansi(.brightBlack) }

    // Basic ANSI colors
    public static var black: Color { .ansi(.black) }
    public static var red: Color { .ansi(.red) }
    public static var green: Color { .ansi(.green) }
    public static var yellow: Color { .ansi(.yellow) }
    public static var blue: Color { .ansi(.blue) }
    public static var magenta: Color { .ansi(.magenta) }
    public static var cyan: Color { .ansi(.cyan) }
    public static var white: Color { .ansi(.white) }

    // Bright ANSI colors
    public static var brightBlack: Color { .ansi(.brightBlack) }
    public static var brightRed: Color { .ansi(.brightRed) }
    public static var brightGreen: Color { .ansi(.brightGreen) }
    public static var brightYellow: Color { .ansi(.brightYellow) }
    public static var brightBlue: Color { .ansi(.brightBlue) }
    public static var brightMagenta: Color { .ansi(.brightMagenta) }
    public static var brightCyan: Color { .ansi(.brightCyan) }
    public static var brightWhite: Color { .ansi(.brightWhite) }

    public static var gray: Color { .brightBlack }
}

struct ANSIColor: Hashable {
    let foregroundCode: Int
    let backgroundCode: Int

    static var `default`: ANSIColor { ANSIColor(foregroundCode: 39, backgroundCode: 49) }

    static var black: ANSIColor { ANSIColor(foregroundCode: 30, backgroundCode: 40) }
    static var red: ANSIColor { ANSIColor(foregroundCode: 31, backgroundCode: 41) }
    static var green: ANSIColor { ANSIColor(foregroundCode: 32, backgroundCode: 42) }
    static var yellow: ANSIColor { ANSIColor(foregroundCode: 33, backgroundCode: 43) }
    static var blue: ANSIColor { ANSIColor(foregroundCode: 34, backgroundCode: 44) }
    static var magenta: ANSIColor { ANSIColor(foregroundCode: 35, backgroundCode: 45) }
    static var cyan: ANSIColor { ANSIColor(foregroundCode: 36, backgroundCode: 46) }
    static var white: ANSIColor { ANSIColor(foregroundCode: 37, backgroundCode: 47) }

    static var brightBlack: ANSIColor { ANSIColor(foregroundCode: 90, backgroundCode: 100) }
    static var brightRed: ANSIColor { ANSIColor(foregroundCode: 91, backgroundCode: 101) }
    static var brightGreen: ANSIColor { ANSIColor(foregroundCode: 92, backgroundCode: 102) }
    static var brightYellow: ANSIColor { ANSIColor(foregroundCode: 93, backgroundCode: 103) }
    static var brightBlue: ANSIColor { ANSIColor(foregroundCode: 94, backgroundCode: 104) }
    static var brightMagenta: ANSIColor { ANSIColor(foregroundCode: 95, backgroundCode: 105) }
    static var brightCyan: ANSIColor { ANSIColor(foregroundCode: 96, backgroundCode: 106) }
    static var brightWhite: ANSIColor { ANSIColor(foregroundCode: 97, backgroundCode: 107) }
}

struct XTermColor: Hashable {
    let value: Int

    static func color(red: Int, green: Int, blue: Int) -> XTermColor {
        guard red >= 0, red < 6, green >= 0, green < 6, blue >= 0, blue < 6 else {
            fatalError("Color values must lie between 1 and 5")
        }
        let offset = 16 // system colors
        return XTermColor(value: offset + (6 * 6 * red) + (6 * green) + blue)
    }

    static func grayscale(white: Int) -> XTermColor {
        guard white >= 0, white < 24 else {
            fatalError("Color value must lie between 1 and 24")
        }
        let offset = 16 + (6 * 6 * 6)
        return XTermColor(value: offset + white)
    }
}

/// A linear gradient for terminal environments using character patterns
public struct LinearGradient: View, Sendable {
    private let colors: [Color]
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint
    private let width: Int
    private let height: Int
    
    /// Creates a linear gradient
    /// - Parameters:
    ///   - colors: Array of colors to transition between
    ///   - startPoint: Starting point of the gradient
    ///   - endPoint: Ending point of the gradient
    ///   - width: Width in characters
    ///   - height: Height in lines (default: 1)
    public init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint, width: Int, height: Int = 1) {
        self.colors = colors.isEmpty ? [.clear] : colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.width = max(1, width)
        self.height = max(1, height)
    }
    
    /// Creates a horizontal gradient (left to right)
    public init(colors: [Color], width: Int, height: Int = 1) {
        self.init(colors: colors, startPoint: .leading, endPoint: .trailing, width: width, height: height)
    }
    
    public var body: some View {
        GradientView(colors: colors, startPoint: startPoint, endPoint: endPoint, width: width, height: height)
    }
}

/// Unit point for gradient positioning
public struct UnitPoint: Sendable {
    public let x: Double
    public let y: Double
    
    public init(x: Double, y: Double) {
        self.x = max(0.0, min(1.0, x))
        self.y = max(0.0, min(1.0, y))
    }
    
    public static let zero = UnitPoint(x: 0, y: 0)
    public static let center = UnitPoint(x: 0.5, y: 0.5)
    public static let leading = UnitPoint(x: 0, y: 0.5)
    public static let trailing = UnitPoint(x: 1, y: 0.5)
    public static let top = UnitPoint(x: 0.5, y: 0)
    public static let bottom = UnitPoint(x: 0.5, y: 1)
    public static let topLeading = UnitPoint(x: 0, y: 0)
    public static let topTrailing = UnitPoint(x: 1, y: 0)
    public static let bottomLeading = UnitPoint(x: 0, y: 1)
    public static let bottomTrailing = UnitPoint(x: 1, y: 1)
}

private struct GradientView: View, PrimitiveNodeViewBuilder {
    let colors: [Color]
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    let width: Int
    let height: Int
    
    static var size: Int? { nil }
    
    func buildNode(_ node: Node) {
        node.control = GradientControl(colors: colors, startPoint: startPoint, endPoint: endPoint, width: width, height: height)
    }
    
    func updateNode(_ node: Node) {
        node.view = self
        let control = node.control as! GradientControl
        control.updateGradient(colors: colors, startPoint: startPoint, endPoint: endPoint, width: width, height: height)
    }
    
    private class GradientControl: Control {
        private var colors: [Color]
        private var startPoint: UnitPoint
        private var endPoint: UnitPoint
        private var width: Int
        private var height: Int
        
        init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint, width: Int, height: Int) {
            self.colors = colors
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.width = width
            self.height = height
        }
        
        func updateGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint, width: Int, height: Int) {
            self.colors = colors
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.width = width
            self.height = height
        }
        
        override func size(proposedSize: Size) -> Size {
            Size(width: Extended(width), height: Extended(height))
        }
        
        override func cell(at position: Position) -> Cell? {
            guard position.line.intValue < height && position.column.intValue < width else { return nil }
            
            // Calculate gradient position
            let normalizedX = Double(position.column.intValue) / Double(max(1, width - 1))
            let normalizedY = Double(position.line.intValue) / Double(max(1, height - 1))
            
            // Calculate gradient progress based on start and end points
            let deltaX = endPoint.x - startPoint.x
            let deltaY = endPoint.y - startPoint.y
            
            let progress: Double
            if abs(deltaX) > abs(deltaY) {
                // Primarily horizontal gradient
                progress = (normalizedX - startPoint.x) / deltaX
            } else {
                // Primarily vertical gradient
                progress = (normalizedY - startPoint.y) / deltaY
            }
            
            let clampedProgress = max(0.0, min(1.0, progress))
            let color = interpolateColor(at: clampedProgress)
            
            // Use different characters for visual variety in gradients
            let gradientChars = ["░", "▒", "▓", "█"]
            let charIndex = Int(clampedProgress * Double(gradientChars.count - 1))
            let char = gradientChars[min(charIndex, gradientChars.count - 1)]
            
            return Cell(char: Character(char), foregroundColor: color)
        }
        
        private func interpolateColor(at progress: Double) -> Color {
            guard colors.count > 1 else { return colors.first ?? .clear }
            
            if progress <= 0 { return colors.first! }
            if progress >= 1 { return colors.last! }
            
            let segmentCount = colors.count - 1
            let segmentProgress = progress * Double(segmentCount)
            let segmentIndex = min(Int(segmentProgress), segmentCount - 1)
            let localProgress = segmentProgress - Double(segmentIndex)
            
            let startColor = colors[segmentIndex]
            let endColor = colors[min(segmentIndex + 1, colors.count - 1)]
            
            // For simplicity, just return the start color of the segment
            // A full implementation would interpolate between colors
            return localProgress < 0.5 ? startColor : endColor
        }
    }
}

struct TrueColor: Hashable {
    let red: Int
    let green: Int
    let blue: Int
}
