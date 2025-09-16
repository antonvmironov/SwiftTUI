import Foundation

/// An adaptive grid that adjusts its column count based on terminal size
public struct AdaptiveGrid<Content: View>: View {
    private let content: Content
    private let minItemWidth: Extended
    private let spacing: Int
    
    public init(
        minItemWidth: Extended = 20,
        spacing: Int = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.minItemWidth = minItemWidth
        self.spacing = spacing
        self.content = content()
    }
    
    public var body: some View {
        ResponsiveView { context in
            let availableWidth = context.size.width
            let maxColumns = max(1, (availableWidth + Extended(spacing)) / (minItemWidth + Extended(spacing)))
            let actualColumns = min(maxColumns.intValue, context.suggestedColumns)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: actualColumns),
                spacing: spacing
            ) {
                content
            }
        }
    }
}

/// An adaptive list that switches between single and multi-column layouts
public struct AdaptiveList<Data: RandomAccessCollection, Content: View>: View 
    where Data.Element: Identifiable {
    
    private let data: Data
    private let content: (Data.Element) -> Content
    
    public init(
        _ data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
    }
    
    public var body: some View {
        ResponsiveView { context in
            if context.isNarrow {
                // Single column for narrow terminals
                VStack(spacing: 0) {
                    ForEach(data) { item in
                        content(item)
                    }
                }
            } else {
                // Multi-column for wider terminals
                AdaptiveGrid(minItemWidth: 30) {
                    ForEach(data) { item in
                        content(item)
                    }
                }
            }
        }
    }
}

/// A responsive table that adapts its display based on terminal width
public struct ResponsiveTable<Data: RandomAccessCollection>: View 
    where Data.Element: Identifiable {
    
    private let data: Data
    private let columns: [ResponsiveTableColumn<Data.Element>]
    
    public init(
        _ data: Data,
        @ResponsiveTableColumnBuilder<Data.Element> columns: () -> [ResponsiveTableColumn<Data.Element>]
    ) {
        self.data = data
        self.columns = columns()
    }
    
    public var body: some View {
        ResponsiveView { context in
            if context.isNarrow {
                // Card view for narrow terminals
                VStack(spacing: 1) {
                    ForEach(data) { item in
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(visibleColumns(for: context), id: \.title) { column in
                                HStack {
                                    Text(column.title + ":")
                                        .frame(width: 12, alignment: .leading)
                                    Text(column.content(item))
                                    Spacer()
                                }
                            }
                        }
                        .padding(.vertical, 1)
                    }
                }
            } else {
                // Use a simplified table display for wider terminals
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    HStack {
                        let visibleCols = visibleColumns(for: context)
                        ForEach(visibleCols, id: \.title) { column in
                            Text(column.title)
                                .bold()
                                .frame(width: 20, alignment: .leading)
                        }
                    }
                    
                    // Data rows
                    ForEach(data) { item in
                        HStack {
                            let visibleCols = visibleColumns(for: context)
                            ForEach(visibleCols, id: \.title) { column in
                                Text(column.content(item))
                                    .frame(width: 20, alignment: .leading)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func visibleColumns(for context: ResponsiveContext) -> [ResponsiveTableColumn<Data.Element>] {
        let maxColumns = context.isNarrow ? 2 : (context.isWide ? columns.count : min(4, columns.count))
        return Array(columns.prefix(maxColumns))
    }
}

/// A column definition for responsive tables
public struct ResponsiveTableColumn<RowValue> {
    let title: String
    let content: (RowValue) -> String
    let priority: Int // Higher priority columns are shown first
    
    public init(
        _ title: String,
        priority: Int = 0,
        content: @escaping (RowValue) -> String
    ) {
        self.title = title
        self.priority = priority
        self.content = content
    }
}

/// Result builder for responsive table columns
@resultBuilder
public struct ResponsiveTableColumnBuilder<RowValue> {
    public static func buildBlock(_ components: ResponsiveTableColumn<RowValue>...) -> [ResponsiveTableColumn<RowValue>] {
        components.sorted { $0.priority > $1.priority }
    }
}

/// A responsive form that adjusts its layout based on terminal size
public struct ResponsiveForm<Content: View>: View {
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ResponsiveView { context in
            VStack(alignment: .leading, spacing: 1) {
                content
            }
            .frame(maxWidth: context.maxContentWidth)
            .padding(.horizontal, context.isNarrow ? 1 : 4)
        }
    }
}

/// A responsive navigation bar that adapts to terminal width
public struct ResponsiveNavigationBar<Content: View>: View {
    private let title: String
    private let content: Content
    
    public init(
        title: String,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        ResponsiveView { context in
            if context.isNarrow {
                // Stacked layout for narrow terminals
                VStack(spacing: 0) {
                    HStack {
                        Text(title)
                            .bold()
                        Spacer()
                    }
                    if !(content is EmptyView) {
                        HStack {
                            content
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, 1)
                .border(.gray)
            } else {
                // Horizontal layout for wider terminals
                HStack {
                    Text(title)
                        .bold()
                    Spacer()
                    content
                }
                .padding(.bottom, 1)
                .border(.gray)
            }
        }
    }
}