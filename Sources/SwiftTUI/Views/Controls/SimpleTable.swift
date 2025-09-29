import Foundation

/// A simple table view for displaying tabular data
public struct SimpleTable<Data>: View where Data: RandomAccessCollection {
    private let data: Data
    private let columns: [String]
    private let rowContent: (Data.Element) -> [String]
    
    /// Static size property for test compatibility
    public static var size: Size? { nil }
    
    public init(_ data: Data, columns: [String], rowContent: @escaping (Data.Element) -> [String]) {
        self.data = data
        self.columns = columns
        self.rowContent = rowContent
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            // Header row
            HStack {
                ForEach(Array(columns.enumerated()), id: \.offset) { _, column in
                    Text(column)
                        .bold()
                        .padding(.right, 2)
                }
            }
            
            // Data rows
            ForEach(Array(data.enumerated()), id: \.offset) { _, item in
                HStack {
                    ForEach(Array(rowContent(item).enumerated()), id: \.offset) { _, cellData in
                        Text(cellData)
                            .padding(.right, 2)
                    }
                }
            }
        }
    }
}