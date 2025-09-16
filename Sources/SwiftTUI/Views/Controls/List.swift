import Foundation

/// A container that presents rows of data arranged in a single column, with automatic keyboard navigation
public struct List<Data, ID, Content>: View, PrimitiveView where Data: RandomAccessCollection, ID: Hashable, Content: View {
    private let data: Data
    private let content: (Data.Element) -> Content
    private let id: KeyPath<Data.Element, ID>
    private let selection: Binding<ID?>?
    
    /// Creates a list with no selection
    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) where Data.Element: Identifiable, ID == Data.Element.ID {
        self.data = data
        self.content = content
        self.id = \.id
        self.selection = nil
    }
    
    /// Creates a list with no selection and custom ID
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
        self.selection = nil
    }
    
    /// Creates a list with selection binding
    public init(_ data: Data, selection: Binding<ID?>, @ViewBuilder content: @escaping (Data.Element) -> Content) where Data.Element: Identifiable, ID == Data.Element.ID {
        self.data = data
        self.content = content
        self.id = \.id
        self.selection = selection
    }
    
    /// Creates a list with selection binding and custom ID
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<ID?>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
        self.selection = selection
    }
    
    static var size: Int? { nil }
    
    func buildNode(_ node: Node) {
        let listControl = ListControl<Data, ID, Content>(
            data: data,
            id: id,
            content: content,
            selection: selection
        )
        node.control = listControl
        listControl.buildContent()
    }
    
    func updateNode(_ node: Node) {
        let listControl = node.control as! ListControl<Data, ID, Content>
        node.view = self
        listControl.updateContent(data: data, id: id, content: content, selection: selection)
    }
    
    private class ListControl<DataType, IDType, ContentType>: Control where DataType: RandomAccessCollection, IDType: Hashable, ContentType: View {
        private var data: DataType
        private var id: KeyPath<DataType.Element, IDType>
        private var content: (DataType.Element) -> ContentType
        fileprivate var selection: Binding<IDType?>?
        fileprivate var selectedIndex: Int? = nil
        
        init(data: DataType, id: KeyPath<DataType.Element, IDType>, content: @escaping (DataType.Element) -> ContentType, selection: Binding<IDType?>?) {
            self.data = data
            self.id = id
            self.content = content
            self.selection = selection
            super.init()
        }
        
        override func size(proposedSize: Size) -> Size {
            let totalRows = data.count
            let width = proposedSize.width
            return Size(width: width, height: Extended(totalRows))
        }
        
        override func layout(size: Size) {
            super.layout(size: size)
            
            for (index, child) in children.enumerated() {
                let childSize = Size(width: size.width, height: 1)
                child.layout(size: childSize)
                child.layer.frame.position = Position(column: 0, line: Extended(index))
            }
        }
        
        func buildContent() {
            for (index, element) in data.enumerated() {
                let itemNode = Node(view: content(element).view)
                let itemControl = ListItemControl<DataType, IDType, ContentType>(
                    index: index,
                    elementId: element[keyPath: id],
                    parent: self
                )
                itemControl.addSubview(itemNode.control(at: 0), at: 0)
                addSubview(itemControl, at: index)
            }
            
            // Set initial selection if available
            if let selection = selection, let selectedId = selection.wrappedValue {
                if let index = data.firstIndex(where: { $0[keyPath: id] == selectedId }) {
                    selectedIndex = data.distance(from: data.startIndex, to: index)
                }
            }
        }
        
        func updateContent(data: DataType, id: KeyPath<DataType.Element, IDType>, content: @escaping (DataType.Element) -> ContentType, selection: Binding<IDType?>?) {
            let _ = self.data
            self.data = data
            self.id = id
            self.content = content
            self.selection = selection
            
            // Simple update - clear and rebuild for now
            // A more sophisticated implementation would use diffing
            while !children.isEmpty {
                removeSubview(at: 0)
            }
            buildContent()
            layer.invalidate()
        }
        
        override func selectableElement(below index: Int) -> Control? {
            if index + 1 < children.count {
                return children[index + 1].firstSelectableElement
            }
            return super.selectableElement(below: index)
        }
        
        override func selectableElement(above index: Int) -> Control? {
            if index > 0 {
                return children[index - 1].firstSelectableElement
            }
            return super.selectableElement(above: index)
        }
        
        func selectItem(at index: Int) {
            selectedIndex = index
            if let selection = selection {
                let element = data[data.index(data.startIndex, offsetBy: index)]
                selection.wrappedValue = element[keyPath: id]
            }
            layer.invalidate()
        }
    }
    
    private class ListItemControl<DataType, IDType, ContentType>: Control where DataType: RandomAccessCollection, IDType: Hashable, ContentType: View {
        private let index: Int
        private let elementId: IDType
        private weak var listParent: ListControl<DataType, IDType, ContentType>?
        
        init(index: Int, elementId: IDType, parent: ListControl<DataType, IDType, ContentType>) {
            self.index = index
            self.elementId = elementId
            self.listParent = parent
            super.init()
        }
        
        override var selectable: Bool { true }
        
        override func size(proposedSize: Size) -> Size {
            guard let child = children.first else { return Size(width: proposedSize.width, height: 1) }
            return child.size(proposedSize: proposedSize)
        }
        
        override func layout(size: Size) {
            super.layout(size: size)
            if let child = children.first {
                child.layout(size: size)
            }
        }
        
        override func handleEvent(_ char: Character) {
            if char == "\n" || char == " " {
                listParent?.selectItem(at: index)
                return
            }
            super.handleEvent(char)
        }
        
        override func becomeFirstResponder() {
            super.becomeFirstResponder()
            listParent?.selectedIndex = index
            if let selection = listParent?.selection {
                selection.wrappedValue = elementId
            }
            layer.invalidate()
        }
        
        override func cell(at position: Position) -> Cell? {
            var cell = super.cell(at: position)
            
            // Highlight selected item
            if let listParent = listParent, listParent.selectedIndex == index || isFirstResponder {
                cell?.attributes.inverted.toggle()
            }
            
            return cell
        }
        
        override func makeLayer() -> Layer {
            let layer = HighlightLayer()
            return layer
        }
    }
    
    private class HighlightLayer: Layer {
        override func cell(at position: Position) -> Cell? {
            let cell = super.cell(at: position)
            // The highlighting is handled in the ListItemControl
            return cell
        }
    }
}