import SwiftUI

struct SettingsWindow: View {
    private enum Tabs: Hashable {
        case general
        case shortcut
    }

    var body: some View {
        GeneralSettingsTab()
        .padding(20)
        .frame(minWidth: 450, minHeight: 150)
    }
}

struct SettingsWindow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWindow()
    }
}
