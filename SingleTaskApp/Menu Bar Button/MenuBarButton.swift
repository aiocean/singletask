import AppKit
import SwiftUI

class MenuBarButton {
        
    private(set) lazy var statusItem = with(NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)) {
        $0.behavior = [.removalAllowed, .terminationOnRemoval]
        //$0.button?.image = NSImage(named: "MenuBarIcon")
        $0.button?.imagePosition = NSControl.ImagePosition.noImage
        $0.button?.action = #selector(showMenu(_:))
        $0.button?.target = self
        $0.button?.sendAction(on: [.leftMouseUp])
    }
     
    private(set) lazy var statusItemButton = statusItem.button!

    // MARK: - Show Menu
    
    @objc
    func showMenu(_ sender: AnyObject?) {
        switch NSApp.currentEvent?.type {
        case .leftMouseUp:
            SettingsWindowController.show()
        default:
            break
        }
    }
    
    @objc
    func quit() {
        NSApp.terminate(self)
    }
}

