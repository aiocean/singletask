import SwiftUI

struct SettingsWindow: View {

    private enum Tabs: Hashable {
        case general
        case shortcut
    }

    var body: some View {
        TabView {
            GeneralSettingsTab()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            ShortcutSettingsTab()
                .tabItem {
                    Label("Shortcut", systemImage: "gear")
                }
                .tag(Tabs.shortcut)
        }
        .padding(20)
        .frame(minWidth: 450, minHeight: 150)
    }
    
    /// Show settings programmatically
    static func show() {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
    }
}

struct SettingsWindow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWindow()
    }
}
