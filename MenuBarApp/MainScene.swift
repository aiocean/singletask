import SwiftUI

struct MainScene: Scene {
    
    var body: some Scene {
        WindowGroup {
            if false {}
        }
        .commands {
            AboutCommand()
        }
        Settings {
            SettingsWindow()
        }
    }
}
