import SwiftTUI

struct Item: Identifiable {
    let id: Int
    let name: String
    let description: String
}

struct ListExampleView: View {
    @State private var selectedItem: Int? = nil
    
    let items = [
        Item(id: 1, name: "Apple", description: "A red fruit"),
        Item(id: 2, name: "Banana", description: "A yellow fruit"),
        Item(id: 3, name: "Cherry", description: "A small red fruit"),
        Item(id: 4, name: "Date", description: "A sweet brown fruit"),
        Item(id: 5, name: "Elderberry", description: "A dark purple berry")
    ]
    
    var body: some View {
        VStack {
            Text("SwiftTUI List Example")
                .bold()
                .padding()
            
            Text("Use arrow keys to navigate, Enter/Space to select")
                .foregroundColor(.secondary)
                .padding()
            
            List(items, selection: $selectedItem) { item in
                HStack {
                    Text(item.name)
                        .bold()
                    Spacer()
                    Text(item.description)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            
            if let selectedItem = selectedItem,
               let selectedItemData = items.first(where: { $0.id == selectedItem }) {
                Text("Selected: \(selectedItemData.name)")
                    .foregroundColor(.green)
                    .padding()
            } else {
                Text("No item selected")
                    .foregroundColor(.brightBlack)
                    .padding()
            }
        }
    }
}

Application(rootView: ListExampleView())
    .run()