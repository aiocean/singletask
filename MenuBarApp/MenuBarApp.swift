import SwiftUI
import KeyboardShortcuts
import Defaults
import Foundation

@main
struct MenuBarApp: App {
    
    /// Legacy app delegate.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        MainScene()
    }
}

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var menuBarButton: MenuBarButton?
    var defaultObserve: DefaultsObservation?
    func applicationDidFinishLaunching(_ notification: Notification) {
        menuBarButton = MenuBarButton()
        
        defaultObserve = Defaults.observe(.task) { change in
            self.menuBarButton?.statusItem.button?.title = change.newValue
        }
        
        KeyboardShortcuts.onKeyUp(for: .toggleUnicornMode) {
            // NSApp.activate(ignoringOtherApps: true)
            // SettingsWindow.show()
            self.menuBarButton?.statusItem.button?.image = NSImage(systemSymbolName: "play", accessibilityDescription: nil)
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        defaultObserve?.invalidate()
    }
}
