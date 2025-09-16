import SwiftTUI

/// Example demonstrating NavigationStack functionality in SwiftTUI
/// This shows how to create a multi-level navigation hierarchy with automatic keyboard support
struct NavigationStackExample: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
    }
}

struct HomeView: View {
    let menuItems = [
        ("📱 App Settings", "settings"),
        ("👤 User Profile", "profile"),
        ("📊 Analytics", "analytics"),
        ("🔧 Developer Tools", "tools")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("🏠 Main Menu")
                .bold()
                .foregroundColor(.blue)
                .padding(.bottom)
            
            Text("Navigate with arrow keys, select with Enter, go back with ESC")
                .foregroundColor(.secondary)
                .italic()
                .padding(.bottom)
            
            ForEach(Array(menuItems.enumerated()), id: \.offset) { index, item in
                NavigationLink(item.0, destination: destinationView(for: item.1))
                    .padding(.vertical, 1)
            }
            
            Divider()
                .padding(.vertical)
            
            Text("💡 Features:")
                .bold()
            Text("• Automatic breadcrumb navigation")
            Text("• ESC key to go back")
            Text("• Keyboard-only navigation")
            Text("• SwiftUI-compatible API")
        }
        .padding()
    }
    
    @ViewBuilder
    private func destinationView(for identifier: String) -> some View {
        switch identifier {
        case "settings":
            SettingsView()
        case "profile":
            ProfileView()
        case "analytics":
            AnalyticsView()
        case "tools":
            DeveloperToolsView()
        default:
            Text("Unknown destination: \(identifier)")
        }
    }
}

struct SettingsView: View {
    let settings = [
        ("🎨 Appearance", "appearance"),
        ("🔔 Notifications", "notifications"),
        ("🔐 Privacy", "privacy"),
        ("💾 Data & Storage", "storage")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("⚙️ Settings")
                .bold()
                .foregroundColor(.green)
                .padding(.bottom)
            
            ForEach(Array(settings.enumerated()), id: \.offset) { index, setting in
                NavigationLink(setting.0, destination: SettingDetailView(title: setting.0, key: setting.1))
            }
            
            Divider()
                .padding(.vertical)
            
            NavigationLink("🔧 Advanced Settings", destination: AdvancedSettingsView())
        }
        .padding()
    }
}

struct SettingDetailView: View {
    let title: String
    let key: String
    @State private var isEnabled = true
    @State private var value = "Default"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .bold()
                .foregroundColor(.yellow)
                .padding(.bottom)
            
            HStack {
                Text("Status:")
                Text(isEnabled ? "✅ Enabled" : "❌ Disabled")
                    .foregroundColor(isEnabled ? .green : .red)
            }
            
            HStack {
                Text("Value:")
                Text(value)
                    .foregroundColor(.blue)
            }
            
            Divider()
                .padding(.vertical)
            
            Text("This is a detailed view for \(key) settings.")
                .foregroundColor(.secondary)
            
            Text("In a real app, this would contain actual setting controls.")
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
    }
}

struct AdvancedSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("🔧 Advanced Settings")
                .bold()
                .foregroundColor(.red)
                .padding(.bottom)
            
            Text("⚠️ Warning: These settings are for advanced users only!")
                .foregroundColor(.red)
                .padding(.bottom)
            
            NavigationLink("🐛 Debug Mode", destination: DebugSettingsView())
            NavigationLink("🔍 Diagnostics", destination: DiagnosticsView())
            NavigationLink("📋 System Info", destination: SystemInfoView())
        }
        .padding()
    }
}

struct DebugSettingsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("🐛 Debug Settings")
                .bold()
                .foregroundColor(.purple)
                .padding(.bottom)
            
            Text("This is the deepest level of navigation in this example.")
                .foregroundColor(.secondary)
            
            Text("Notice how the breadcrumb shows: Home > Settings > Advanced > Debug")
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
    }
}

struct DiagnosticsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("🔍 Diagnostics")
                .bold()
                .foregroundColor(.orange)
            
            Text("System diagnostics would be displayed here...")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct SystemInfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("📋 System Information")
                .bold()
                .foregroundColor(.cyan)
            
            Text("System information would be displayed here...")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct ProfileView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("👤 User Profile")
                .bold()
                .foregroundColor(.blue)
                .padding(.bottom)
            
            Text("Name: John Doe")
            Text("Email: john.doe@example.com")
            Text("Role: Developer")
            
            Divider()
                .padding(.vertical)
            
            NavigationLink("✏️ Edit Profile", destination: EditProfileView())
            NavigationLink("🔒 Change Password", destination: ChangePasswordView())
        }
        .padding()
    }
}

struct EditProfileView: View {
    @State private var name = "John Doe"
    @State private var email = "john.doe@example.com"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("✏️ Edit Profile")
                .bold()
                .foregroundColor(.green)
                .padding(.bottom)
            
            TextField("Name", text: $name)
                .padding(.bottom)
            
            TextField("Email", text: $email)
                .padding(.bottom)
            
            Text("Profile editing functionality would be implemented here.")
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
    }
}

struct ChangePasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("🔒 Change Password")
                .bold()
                .foregroundColor(.red)
                .padding(.bottom)
            
            SecureField("Current Password", text: $currentPassword)
                .padding(.bottom)
            
            SecureField("New Password", text: $newPassword)
                .padding(.bottom)
            
            Text("Password change functionality would be implemented here.")
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
    }
}

struct AnalyticsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("📊 Analytics Dashboard")
                .bold()
                .foregroundColor(.purple)
                .padding(.bottom)
            
            Text("📈 User Engagement: 85%")
                .foregroundColor(.green)
            
            Text("📉 Error Rate: 2%")
                .foregroundColor(.yellow)
            
            Text("⏱️ Average Session: 12m 34s")
                .foregroundColor(.blue)
            
            Divider()
                .padding(.vertical)
            
            NavigationLink("📊 Detailed Reports", destination: DetailedReportsView())
        }
        .padding()
    }
}

struct DetailedReportsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("📊 Detailed Analytics Reports")
                .bold()
                .foregroundColor(.orange)
            
            Text("Detailed analytics data would be displayed here...")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct DeveloperToolsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("🔧 Developer Tools")
                .bold()
                .foregroundColor(.cyan)
                .padding(.bottom)
            
            NavigationLink("📝 Logs", destination: LogsView())
            NavigationLink("🧪 Testing", destination: TestingView())
            NavigationLink("📱 Device Info", destination: DeviceInfoView())
        }
        .padding()
    }
}

struct LogsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("📝 Application Logs")
                .bold()
                .foregroundColor(.green)
            
            Text("Application logs would be displayed here...")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct TestingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("🧪 Testing Tools")
                .bold()
                .foregroundColor(.yellow)
            
            Text("Testing tools and utilities would be displayed here...")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct DeviceInfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("📱 Device Information")
                .bold()
                .foregroundColor(.blue)
            
            Text("Device information would be displayed here...")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// Example of how to use the NavigationStack in a real application
struct NavigationStackApp: View {
    var body: some View {
        Window("Navigation Demo") {
            NavigationStackExample()
        }
    }
}

// Usage example:
// let app = NavigationStackApp()
// app.start()