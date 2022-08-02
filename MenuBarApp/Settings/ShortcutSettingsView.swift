import SwiftUI
import KeyboardShortcuts

struct ShortcutSettingsTab: View {
    var body: some View {
        Form {
            Section{
                Form {
                    KeyboardShortcuts.Recorder("Toggle Unicorn Mode:", name: .toggleUnicornMode)
                }
            }
        }
    }}

struct ShortcutSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutSettingsTab()
    }
}
