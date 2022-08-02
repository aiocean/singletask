import SwiftUI
import Defaults

struct GeneralSettingsTab: View {
    @Default(.task) var task
    var body: some View {
        Form {
            Section {
                TextField("Name:", text: $task, onCommit: {
                    print("On commit!")
                })
            }
        }
    }}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsTab()
    }
}
