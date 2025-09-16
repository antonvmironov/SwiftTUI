import Foundation

/// A control for selecting from a set of mutually exclusive values
/// Similar to SwiftUI's Picker but optimized for terminal environments
public struct Picker<Label: View, SelectionValue: Hashable, Content: View>: View {
    private let title: String
    private let selection: Binding<SelectionValue>
    private let content: Content
    private let label: Label
    
    @State private var isExpanded: Bool = false
    @State private var options: [PickerOption<SelectionValue>] = []
    
    /// Creates a picker with a text label
    public init(
        _ title: String,
        selection: Binding<SelectionValue>,
        @ViewBuilder content: () -> Content
    ) where Label == Text {
        self.title = title
        self.selection = selection
        self.content = content()
        self.label = Text(title)
    }
    
    /// Creates a picker with a custom label
    public init(
        selection: Binding<SelectionValue>,
        @ViewBuilder label: () -> Label,
        @ViewBuilder content: () -> Content
    ) {
        self.title = ""
        self.selection = selection
        self.content = content()
        self.label = label()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Picker button/header
            Button(action: {
                isExpanded.toggle()
            }) {
                HStack {
                    label
                    Spacer()
                    Text(currentSelectionText)
                        .foregroundColor(Color.blue)
                    Text(isExpanded ? "▲" : "▼")
                        .foregroundColor(Color.gray)
                }
            }
            .border()
            
            // Dropdown options (when expanded)
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                        Button(action: {
                            selection.wrappedValue = option.value
                            isExpanded = false
                        }) {
                            HStack {
                                Text(option.isSelected(selection.wrappedValue) ? "● " : "○ ")
                                    .foregroundColor(option.isSelected(selection.wrappedValue) ? Color.blue : Color.gray)
                                Text(option.label)
                                Spacer()
                            }
                        }
                        .padding(.left, 2)
                        .background(option.isSelected(selection.wrappedValue) ? Color.blue.opacity(0.2) : Color.clear)
                    }
                }
                .border()
                .padding(.top, 0)
            }
        }
        // .onAppear {
        //     extractOptions()
        // }
        // Keyboard navigation removed due to concurrency issues
        // .onKeyPress(.escape) { @MainActor in
        //     if isExpanded {
        //         isExpanded = false
        //     }
        // }
        // .onKeyPress(.enter) { @MainActor in
        //     isExpanded.toggle()
        // }
    }
    
    private var currentSelectionText: String {
        options.first { $0.isSelected(selection.wrappedValue) }?.label ?? "Select..."
    }
    
    private func extractOptions() {
        // This is a simplified implementation
        // In a full implementation, this would extract options from the Content
        // For now, we'll provide a basic interface
    }
}

/// A picker option data structure
struct PickerOption<T: Hashable> {
    let label: String
    let value: T
    
    func isSelected(_ currentValue: T) -> Bool {
        return value == currentValue
    }
}

/// Text view extension to support picker tag
extension Text {
    /// Assigns a tag value to this picker option
    public func tag<V: Hashable>(_ tag: V) -> PickerOptionView<V> {
        PickerOptionView(label: self, tag: tag)
    }
}

/// A view that represents a picker option
public struct PickerOptionView<Tag: Hashable>: View {
    let label: Text
    let tag: Tag
    
    public var body: some View {
        label
    }
}