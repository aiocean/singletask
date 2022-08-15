import SwiftUI
import Defaults

struct SettingsWindow: View {
    enum FocusField: Hashable {
        case field
      }
    
    @Default(.task) var task
    @FocusState private var focusedField: FocusField?
    var body: some View {
        TextField("Type your task then press Enter.", text: $task)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
                    self.focusedField = .field
               }
            }
            .onSubmit({
                SSApp.closeWindowByTitle(title: "settings")
            })
            .focused($focusedField, equals: .field)
            .textFieldStyle(PlainTextFieldStyle())
            .font(Font.system(size: 20, design: .default)).padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}

struct SettingsWindow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWindow()
    }
}
