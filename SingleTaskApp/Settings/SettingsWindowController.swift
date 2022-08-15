import Cocoa
import SwiftUI

class SettingsWindowController: NSWindowController {
    
    static func show() {
        var found: Bool = false
        NSApplication.shared.windows.forEach { NSWindow in
            if (NSWindow.title == "settings") {
                SSApp.activateIfAccessory()
                found = true
                return
            }
        }
        
        if !found {
            SSApp.activateIfAccessory()
            SettingsWindowController().window?.makeKeyAndOrderFront(nil)
        }
    }

    convenience init() {
        
        let window = Self.makeWindow()
                
        window.backgroundColor = NSColor.controlBackgroundColor
                
        self.init(window: window)

        let contentView = SettingsWindow()
            .frame(minWidth: 10, minHeight: 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.center()
        window.title = "settings"
        window.contentView = NSHostingView(rootView: contentView)
        window.alwaysOnTop = true
    }
    
    private static func makeWindow() -> NSWindow {
        let contentRect = NSRect(x: 0, y: 0, width: 500, height: 100)
        let styleMask: NSWindow.StyleMask = [
            .titled,
            .closable,
            .miniaturizable,
            .fullSizeContentView
        ]
        return NSWindow(contentRect: contentRect,
                        styleMask: styleMask,
                        backing: .buffered,
                        defer: false)
    }
}
