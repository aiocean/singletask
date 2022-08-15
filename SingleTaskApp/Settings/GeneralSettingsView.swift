import SwiftUI
import Defaults

extension Color {
    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    static let background = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
}

struct NeumorphicStyleTextField: View {
    var textField: TextField<Text>
    var imageName: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.darkShadow)
            textField
            }
            .padding()
            .foregroundColor(.neumorphictextColor)
            .background(Color.background)
            .cornerRadius(6)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
            
        }
}

struct GeneralSettingsTab: View {
    @Default(.task) var task
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Search...", text: $task)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Font.system(size: 30, design: .default))
            }
        }
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsTab()
    }
}
