import SwiftUI
import Defaults
struct MenuBarPopup: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, World!")
            Button {
                AboutWindow.show()
            } label: {
                Text("Pause")
            }
            Button {
                AboutWindow.show()
            } label: {
                Text("Start")
            }
            Button {
                AboutWindow.show()
            } label: {
                Text("Preference")
            }
        }.padding(20)
    }
}

struct MenuBarPopup_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarPopup()
    }
}
