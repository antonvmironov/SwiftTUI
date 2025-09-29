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
    @State private var filteredData: [Data.Element] = []
    @State private var searchText: String = ""
    
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
            // Search bar for filtering
            if hasSearchCapability {
                searchBar
                    .padding(.bottom, 1)
            }
            
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
            
            // Data rows with enhanced selection and navigation
            ForEach(Array(displayData.enumerated()), id: \.offset) { rowIndex, item in
                tableRow(item: item, rowIndex: rowIndex)
                    .background(
                        selectedRowIndex == rowIndex ? 
                        Color.blue.opacity(0.2) : Color.clear
                    )
            }
            
            // Status bar showing filtered count
            if hasSearchCapability && !searchText.isEmpty {
                HStack {
                    Text("Showing \(displayData.count) of \(data.count) items")
                        .foregroundColor(.secondary)
                        .italic()
                    Spacer()
                }
                .padding(.top, 1)
            }
        }
        // Note: onAppear functionality will be added without concurrency issues in a future enhancement
    }
    
    private var searchBar: some View {
        HStack {
            Text("🔍")
            TextField("Search...", text: $searchText)
        }
    }
    
    private func tableRow(item: Data.Element, rowIndex: Int) -> some View {
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
    }
    
    private var hasSearchCapability: Bool {
        // Enable search for tables with text-searchable content
        true
    }
    
    private var displayData: [Data.Element] {
        if !searchText.isEmpty {
            return filteredData
        }
        return sortedData
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
    
    // Enhanced keyboard navigation with proper arrow key support
    @MainActor
    private func navigateUp() {
        let currentData = displayData
        guard !currentData.isEmpty else { return }
        
        if let currentIndex = selectedRowIndex {
            selectedRowIndex = max(0, currentIndex - 1)
        } else {
            selectedRowIndex = currentData.count - 1
        }
    }
    
    @MainActor
    private func navigateDown() {
        let currentData = displayData
        guard !currentData.isEmpty else { return }
        
        if let currentIndex = selectedRowIndex {
            selectedRowIndex = min(currentData.count - 1, currentIndex + 1)
        } else {
            selectedRowIndex = 0
        }
    }
    
    // Enhanced selection with proper handling
    @MainActor
    private func toggleSelection() {
        guard let selectionBinding = selection,
              let rowIndex = selectedRowIndex,
              rowIndex < displayData.count else { return }
        
        let item = displayData[rowIndex]
        var currentSelection = selectionBinding.wrappedValue
        
        if currentSelection.contains(item.id) {
            currentSelection.remove(item.id)
        } else {
            currentSelection.insert(item.id)
        }
        
        selectionBinding.wrappedValue = currentSelection
    }
    
    // Filtering functionality
    @MainActor
    private func initializeFilteredData() {
        filteredData = Array(data)
    }
    
    @MainActor
    private func filterData() {
        if searchText.isEmpty {
            filteredData = Array(data)
        } else {
            filteredData = Array(data).filter { item in
                // Search across all column content
                columns.contains { column in
                    column.content(item).localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        // Reset selection to first item after filtering
        if !filteredData.isEmpty {
            selectedRowIndex = 0
        } else {
            selectedRowIndex = nil
        }
    }
}

/// A table column definition
public struct TableColumn<RowValue> {
    let id: String
    let title: String
    let content: (RowValue) -> String
    
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
    
    /// Creates a column using a closure for custom value extraction
    public init(_ title: String, content: @escaping (RowValue) -> String) {
        self.id = title
        self.title = title
        self.content = content
    }
}
