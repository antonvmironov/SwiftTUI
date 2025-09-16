import Foundation

/// An advanced table component with sorting and selection capabilities
/// Similar to SwiftUI's Table but optimized for terminal environments
public struct Table<Data: RandomAccessCollection>: View 
where Data.Element: Identifiable {
    
    private let data: Data
    private let columns: [TableColumn<Data.Element>]
    private let selection: Binding<Set<Data.Element.ID>>?
    @State private var sortOrder: [TableSortDescriptor] = []
    @State private var selectedRowIndex: Int? = nil
    
    /// Creates a table without selection
    public init(_ data: Data, @TableColumnBuilder<Data.Element> columns: () -> [TableColumn<Data.Element>]) {
        self.data = data
        self.columns = columns()
        self.selection = nil
    }
    
    /// Creates a table with selection
    public init(
        _ data: Data,
        selection: Binding<Set<Data.Element.ID>>,
        @TableColumnBuilder<Data.Element> columns: () -> [TableColumn<Data.Element>]
    ) {
        self.data = data
        self.columns = columns()
        self.selection = selection
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row with sorting indicators
            HStack {
                if selection != nil {
                    Text("  ") // Space for selection indicator
                }
                
                ForEach(Array(columns.enumerated()), id: \.offset) { index, column in
                    Button(action: {
                        toggleSort(for: column)
                    }) {
                        HStack {
                            Text(column.title)
                                .bold()
                            
                            if let sortDesc = sortOrder.first(where: { $0.columnId == column.id }) {
                                Text(sortDesc.order == .ascending ? "▲" : "▼")
                                    .foregroundColor(.blue)
                            } else {
                                Text(" ")
                            }
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.right, 2)
                }
            }
            .padding(.bottom, 1)
            
            // Separator line
            HStack {
                ForEach(0..<(columns.count + (selection != nil ? 1 : 0)), id: \.self) { _ in
                    Text("─").foregroundColor(.secondary)
                }
            }
            
            // Data rows
            ForEach(Array(sortedData.enumerated()), id: \.offset) { rowIndex, item in
                HStack {
                    if let selectionBinding = selection {
                        // Selection indicator
                        Text(selectionBinding.wrappedValue.contains(item.id) ? "●" : "○")
                            .foregroundColor(selectionBinding.wrappedValue.contains(item.id) ? .blue : .secondary)
                    }
                    
                    ForEach(Array(columns.enumerated()), id: \.offset) { columnIndex, column in
                        Text(column.content(item))
                            .padding(.right, 2)
                    }
                }
                .background(
                    selectedRowIndex == rowIndex ? 
                    Color.blue.opacity(0.2) : Color.clear
                )
            }
        }
    }
    
    private var sortedData: [Data.Element] {
        guard !sortOrder.isEmpty else { return Array(data) }
        
        return Array(data).sorted { lhs, rhs in
            for sortDesc in sortOrder {
                if let column = columns.first(where: { $0.id == sortDesc.columnId }) {
                    let lhsValue = column.content(lhs)
                    let rhsValue = column.content(rhs)
                    
                    let comparison = lhsValue.localizedStandardCompare(rhsValue)
                    
                    if comparison != .orderedSame {
                        return sortDesc.order == .ascending ? 
                            comparison == .orderedAscending : 
                            comparison == .orderedDescending
                    }
                }
            }
            return false
        }
    }
    
    private func toggleSort(for column: TableColumn<Data.Element>) {
        if let existingIndex = sortOrder.firstIndex(where: { $0.columnId == column.id }) {
            // Toggle existing sort order
            let currentOrder = sortOrder[existingIndex].order
            sortOrder[existingIndex] = TableSortDescriptor(
                columnId: column.id,
                order: currentOrder == .ascending ? .descending : .ascending
            )
        } else {
            // Add new sort order
            sortOrder.insert(TableSortDescriptor(columnId: column.id, order: .ascending), at: 0)
        }
    }
    
    // Note: Arrow key navigation will be implemented in a future enhancement
    // when the underlying control system supports it
    private func navigateUp() {
        // TODO: Implement when arrow key support is available
    }
    
    private func navigateDown() {
        // TODO: Implement when arrow key support is available
    }
    
    // Note: Selection will be enhanced in future versions with proper event handling
    private func toggleSelection() {
        // TODO: Implement selection toggle when proper event handling is available
        // This is a placeholder for the selection logic
    }
}

/// A table column definition
public struct TableColumn<RowValue> {
    let id: String
    let title: String
    let content: (RowValue) -> String
    
    /// Creates a table column with a title and content extractor
    public init(_ title: String, value: @escaping (RowValue) -> String) {
        self.id = title
        self.title = title
        self.content = value
    }
    
    /// Creates a table column with a custom ID
    public init(id: String, title: String, value: @escaping (RowValue) -> String) {
        self.id = id
        self.title = title
        self.content = value
    }
}

/// Sort descriptor for table columns
public struct TableSortDescriptor {
    let columnId: String
    let order: SortOrder
}

/// Sort order enumeration
public enum SortOrder {
    case ascending
    case descending
}

/// Result builder for table columns
@resultBuilder
public struct TableColumnBuilder<RowValue> {
    public static func buildBlock(_ components: TableColumn<RowValue>...) -> [TableColumn<RowValue>] {
        components
    }
}

/// Extension for working with KeyPath-based columns (more SwiftUI-like)
extension TableColumn {
    /// Creates a column using a KeyPath for automatic value extraction
    public init<Value: CustomStringConvertible>(
        _ title: String,
        value keyPath: KeyPath<RowValue, Value>
    ) {
        self.id = title
        self.title = title
        self.content = { row in
            String(describing: row[keyPath: keyPath])
        }
    }
}