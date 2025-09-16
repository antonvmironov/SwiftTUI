import Foundation

/// A responsive view that adapts its content based on terminal size
public struct ResponsiveView<Content: View>: View {
    private let content: (ResponsiveContext) -> Content
    
    public init(@ViewBuilder content: @escaping (ResponsiveContext) -> Content) {
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { size in
            content(ResponsiveContext(size: size))
        }
    }
}

/// Context information for responsive design
public struct ResponsiveContext {
    public let size: Size
    
    /// Terminal size categories for responsive design
    public var sizeClass: TerminalSizeClass {
        if size.width < 60 { return .compact }
        else if size.width < 120 { return .regular }
        else { return .large }
    }
    
    /// Whether the terminal is in a narrow layout
    public var isNarrow: Bool {
        size.width < 80
    }
    
    /// Whether the terminal is in a wide layout
    public var isWide: Bool {
        size.width >= 120
    }
    
    /// Whether the terminal is short (limited vertical space)
    public var isShort: Bool {
        size.height < 24
    }
    
    /// Whether the terminal is tall (ample vertical space)
    public var isTall: Bool {
        size.height >= 40
    }
    
    /// Suggests maximum content width for readability
    public var maxContentWidth: Extended {
        min(size.width, Extended(120)) // Cap at 120 characters for readability
    }
    
    /// Suggests appropriate number of columns for layouts
    public var suggestedColumns: Int {
        switch sizeClass {
        case .compact: return 1
        case .regular: return 2
        case .large: return 3
        }
    }
}

/// Terminal size classification for responsive design
public enum TerminalSizeClass {
    case compact   // < 60 columns
    case regular   // 60-119 columns  
    case large     // >= 120 columns
}

/// View modifier for size-adaptive behavior
public struct SizeAdaptive<Content: View>: View {
    private let content: Content
    private let compact: (() -> Content)?
    private let regular: (() -> Content)?
    private let large: (() -> Content)?
    
    public init(
        content: Content,
        compact: (() -> Content)? = nil,
        regular: (() -> Content)? = nil,
        large: (() -> Content)? = nil
    ) {
        self.content = content
        self.compact = compact
        self.regular = regular
        self.large = large
    }
    
    public var body: some View {
        ResponsiveView { context in
            switch context.sizeClass {
            case .compact:
                if let compactView = compact {
                    compactView()
                } else {
                    content
                }
            case .regular:
                if let regularView = regular {
                    regularView()
                } else {
                    content
                }
            case .large:
                if let largeView = large {
                    largeView()
                } else {
                    content
                }
            }
        }
    }
}

extension View {
    /// Makes a view size-adaptive with different layouts for different terminal sizes
    public func sizeAdaptive<CompactContent: View, RegularContent: View, LargeContent: View>(
        compact: @escaping () -> CompactContent,
        regular: @escaping () -> RegularContent,
        large: @escaping () -> LargeContent
    ) -> some View {
        ResponsiveView { context in
            switch context.sizeClass {
            case .compact: compact()
            case .regular: regular()
            case .large: large()
            }
        }
    }
    
    /// Makes a view responsive to terminal size changes
    public func responsive() -> some View {
        ResponsiveView { _ in self }
    }
    
    /// Hides the view when terminal is too narrow
    public func hideWhenNarrow() -> some View {
        ResponsiveView { context in
            if context.isNarrow {
                EmptyView()
            } else {
                self
            }
        }
    }
    
    /// Hides the view when terminal is too short
    public func hideWhenShort() -> some View {
        ResponsiveView { context in
            if context.isShort {
                EmptyView()
            } else {
                self
            }
        }
    }
    
    /// Shows the view only when there's ample space
    public func showOnlyWhenSpacious() -> some View {
        ResponsiveView { context in
            if context.isWide && context.isTall {
                self
            } else {
                EmptyView()
            }
        }
    }
}