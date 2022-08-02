import SwiftUI
import Defaults
struct MenuBarPopup: View {
    @Default(.task) var task
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, World!")
            Button {
                AboutWindow.show()
            } label: {
                Text("About...")
            }
            Button {
                NSApp.activate(ignoringOtherApps: true)
                SettingsWindow.show()
            } label: {
                Text("Preferences...")
            }
        }
        .frame(minWidth: 200, minHeight: 200)
    }
}

struct MenuBarPopup_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarPopup()
    }
}
