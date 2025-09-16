import SwiftTUI

/// Example demonstrating Grid Layout functionality in SwiftTUI
/// Shows LazyVGrid, LazyHGrid, and Grid with various configurations
struct GridLayoutExample: View {
    
    @State private var currentDemo = 0
    @State private var selectedGridItem: String? = nil
    
    let gridItems = Array(1...20).map { "Item \($0)" }
    let coloredItems = [
        ("🔴", "Red"),
        ("🟠", "Orange"),
        ("🟡", "Yellow"),
        ("🟢", "Green"),
        ("🔵", "Blue"),
        ("🟣", "Purple"),
        ("🟤", "Brown"),
        ("⚫", "Black"),
        ("⚪", "White"),
        ("🔘", "Gray")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Header and demo selector
            HStack {
                Text("🏗️ Grid Layout Demo")
                    .bold()
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button("Next Demo (\(currentDemo + 1)/6)") {
                    currentDemo = (currentDemo + 1) % 6
                }
                .foregroundColor(.green)
            }
            .padding(.bottom)
            
            // Demo content
            Group {
                switch currentDemo {
                case 0:
                    basicVGridDemo
                case 1:
                    adaptiveVGridDemo
                case 2:
                    hGridDemo
                case 3:
                    mixedGridDemo
                case 4:
                    interactiveGridDemo
                case 5:
                    complexLayoutDemo
                default:
                    basicVGridDemo
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var basicVGridDemo: some View {
        VStack(alignment: .leading) {
            Text("📱 Basic LazyVGrid (3 Columns)")
                .bold()
                .foregroundColor(.purple)
                .padding(.bottom, 1)
            
            Text("Fixed-width columns with equal spacing")
                .foregroundColor(.secondary)
                .italic()
                .padding(.bottom)
            
            LazyVGrid(
                columns: [
                    GridItem(.fixed(15)),
                    GridItem(.fixed(15)),
                    GridItem(.fixed(15))
                ],
                spacing: 2
            ) {
                ForEach(Array(gridItems.prefix(12).enumerated()), id: \.offset) { index, item in
                    Text(item)
                        .border()
                        .padding(.horizontal, 1)
                }
            }
            .gridBorder(.simple)
        }
    }
    
    @ViewBuilder
    private var adaptiveVGridDemo: some View {
        VStack(alignment: .leading) {
            Text("🔄 Adaptive LazyVGrid")
                .bold()
                .foregroundColor(.orange)
                .padding(.bottom, 1)
            
            Text("Flexible columns that adapt to content")
                .foregroundColor(.secondary)
                .italic()
                .padding(.bottom)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: 8, maximum: 20)),
                    GridItem(.adaptive(minimum: 6, maximum: 15)),
                    GridItem(.flexible(minimum: 10))
                ],
                spacing: 1
            ) {
                ForEach(coloredItems.prefix(9), id: \.1) { emoji, name in
                    HStack {
                        Text(emoji)
                        Text(name)
                            .foregroundColor(.blue)
                    }
                    .border()
                }
            }
        }
    }
    
    @ViewBuilder
    private var hGridDemo: some View {
        VStack(alignment: .leading) {
            Text("↔️ LazyHGrid (Horizontal Layout)")
                .bold()
                .foregroundColor(.green)
                .padding(.bottom, 1)
            
            Text("Arranges items in horizontal rows")
                .foregroundColor(.secondary)
                .italic()
                .padding(.bottom)
            
            LazyHGrid(
                rows: [
                    GridItem(.fixed(3)),
                    GridItem(.flexible(minimum: 2, maximum: 5))
                ],
                spacing: 3
            ) {
                ForEach(gridItems.prefix(8), id: \.self) { item in
                    Text(item)
                        .border()
                        .foregroundColor(.green)
                }
            }
            .gridBorder(.rounded)
        }
    }
    
    @ViewBuilder
    private var mixedGridDemo: some View {
        VStack(alignment: .leading) {
            Text("🎨 Mixed Content Grid")
                .bold()
                .foregroundColor(.cyan)
                .padding(.bottom, 1)
            
            Text("Different view types in grid cells")
                .foregroundColor(.secondary)
                .italic()
                .padding(.bottom)
            
            LazyVGrid(columns: 4, spacing: 1) {
                // Text items
                Text("📝 Text")
                    .border()
                
                // Button
                Button("🔘 Button") {
                    // Action
                }
                .border()
                
                // Loading indicator
                VStack {
                    LoadingSpinner()
                    Text("Loading")
                }
                .border()
                
                // Progress bar
                VStack {
                    ProgressBar(progress: 0.7)
                    Text("Progress")
                }
                .border()
                
                // More items
                ForEach(["⭐ Star", "❤️ Heart", "🔥 Fire", "💡 Idea"], id: \.self) { item in
                    Text(item)
                        .border()
                        .foregroundColor(.yellow)
                }
            }
        }
    }
    
    @ViewBuilder
    private var interactiveGridDemo: some View {
        VStack(alignment: .leading) {
            Text("🖱️ Interactive Grid")
                .bold()
                .foregroundColor(.red)
                .padding(.bottom, 1)
            
            if let selected = selectedGridItem {
                Text("Selected: \(selected)")
                    .foregroundColor(.blue)
                    .bold()
            } else {
                Text("Click any item to select it")
                    .foregroundColor(.secondary)
                    .italic()
            }
            
            LazyVGrid(columns: 5, spacing: 1) {
                ForEach(gridItems.prefix(15), id: \.self) { item in
                    Button(item) {
                        selectedGridItem = selectedGridItem == item ? nil : item
                    }
                    .foregroundColor(selectedGridItem == item ? .blue : .primary)
                    .border()
                }
            }
        }
    }
    
    @ViewBuilder
    private var complexLayoutDemo: some View {
        VStack(alignment: .leading) {
            Text("🏗️ Complex Layout")
                .bold()
                .foregroundColor(.purple)
                .padding(.bottom, 1)
            
            Text("Nested grids and custom layouts")
                .foregroundColor(.secondary)
                .italic()
                .padding(.bottom)
            
            VStack(spacing: 2) {
                // Header row
                LazyVGrid(
                    columns: [
                        GridItem(.fixed(20)),
                        GridItem(.flexible()),
                        GridItem(.fixed(15))
                    ]
                ) {
                    Text("ID")
                        .bold()
                        .border()
                    
                    Text("Description")
                        .bold()
                        .border()
                    
                    Text("Status")
                        .bold()
                        .border()
                }
                
                // Data rows
                ForEach(1...4, id: \.self) { row in
                    LazyVGrid(
                        columns: [
                            GridItem(.fixed(20)),
                            GridItem(.flexible()),
                            GridItem(.fixed(15))
                        ]
                    ) {
                        Text("\(row)")
                            .border()
                        
                        Text("Item description \(row)")
                            .border()
                        
                        Text(row % 2 == 0 ? "✅" : "⏳")
                            .border()
                    }
                }
            }
            .gridBorder(.double)
        }
    }
}

/// Example of dashboard-style grid layout
struct DashboardGridExample: View {
    
    struct DashboardCard {
        let title: String
        let value: String
        let change: String
        let icon: String
        let color: Color
    }
    
    let cards = [
        DashboardCard(title: "Revenue", value: "$125,430", change: "+12.5%", icon: "💰", color: .green),
        DashboardCard(title: "Users", value: "8,451", change: "+8.2%", icon: "👥", color: .blue),
        DashboardCard(title: "Orders", value: "1,203", change: "-2.1%", icon: "📦", color: .orange),
        DashboardCard(title: "Conversion", value: "3.4%", change: "+0.3%", icon: "📈", color: .purple),
        DashboardCard(title: "Support", value: "45", change: "-5.2%", icon: "🎧", color: .cyan),
        DashboardCard(title: "Bounce Rate", value: "35.2%", change: "-1.2%", icon: "🚪", color: .yellow)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("📊 Dashboard Grid")
                .bold()
                .foregroundColor(.blue)
                .padding(.bottom)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(minimum: 20, maximum: 25)),
                    GridItem(.flexible(minimum: 20, maximum: 25)),
                    GridItem(.flexible(minimum: 20, maximum: 25))
                ],
                spacing: 2
            ) {
                ForEach(Array(cards.enumerated()), id: \.offset) { index, card in
                    VStack(alignment: .leading, spacing: 1) {
                        HStack {
                            Text(card.icon)
                            Text(card.title)
                                .bold()
                                .foregroundColor(card.color)
                        }
                        
                        Text(card.value)
                            .bold()
                            .foregroundColor(.primary)
                        
                        Text(card.change)
                            .foregroundColor(card.change.hasPrefix("+") ? .green : .red)
                    }
                    .padding(1)
                    .border()
                }
            }
        }
        .padding()
    }
}

/// Example of photo gallery grid
struct PhotoGalleryGridExample: View {
    
    let photos = [
        ("🌅", "Sunrise"),
        ("🏔️", "Mountains"),
        ("🌊", "Ocean"),
        ("🌲", "Forest"),
        ("🏙️", "City"),
        ("🌺", "Flowers"),
        ("🦋", "Butterfly"),
        ("🌈", "Rainbow"),
        ("⭐", "Stars"),
        ("🌙", "Moon"),
        ("🔥", "Fire"),
        ("❄️", "Snow")
    ]
    
    @State private var selectedPhoto: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("📸 Photo Gallery Grid")
                .bold()
                .foregroundColor(.purple)
                .padding(.bottom)
            
            if let selected = selectedPhoto {
                HStack {
                    Text("Selected:")
                    Text(selected)
                        .bold()
                        .foregroundColor(.blue)
                }
                .padding(.bottom)
            }
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.adaptive(minimum: 12, maximum: 15)), count: 4),
                spacing: 1
            ) {
                ForEach(photos, id: \.1) { emoji, name in
                    Button(action: {
                        selectedPhoto = selectedPhoto == name ? nil : name
                    }) {
                        VStack {
                            Text(emoji)
                                .font(.title)
                            Text(name)
                                .font(.caption)
                        }
                    }
                    .foregroundColor(selectedPhoto == name ? .blue : .primary)
                    .border()
                    .padding(1)
                }
            }
            .gridBorder(.rounded)
        }
        .padding()
    }
}

/// Main application combining all grid examples
struct GridDemoApp: View {
    @State private var currentExample = 0
    
    let examples = [
        ("Grid Layouts", AnyView(GridLayoutExample())),
        ("Dashboard", AnyView(DashboardGridExample())),
        ("Photo Gallery", AnyView(PhotoGalleryGridExample()))
    ]
    
    var body: some View {
        Window("Grid Layout Demo") {
            VStack {
                // Example selector
                HStack {
                    ForEach(Array(examples.enumerated()), id: \.offset) { index, example in
                        Button(example.0) {
                            currentExample = index
                        }
                        .foregroundColor(currentExample == index ? .blue : .secondary)
                    }
                }
                .padding(.bottom)
                
                // Current example
                examples[currentExample].1
            }
        }
    }
}

// Usage:
// let app = GridDemoApp()
// app.start()