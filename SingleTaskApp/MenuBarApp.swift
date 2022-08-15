import SwiftUI
import Defaults
import Foundation

@main
struct MenuBarApp: App {
    
    @StateObject private var appState = AppState.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        MainScene()
    }
}
