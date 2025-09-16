import SwiftTUI

struct SimpleTestApp: View {
    let items = ["Apple", "Banana", "Cherry"]
    
    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
        }
    }
}

print("Creating simple list...")
let app = SimpleTestApp()
print("List created successfully!")