import AppKit
import SwiftUI

class MenuBarButton {
        
    private(set) lazy var statusItem = with(NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)) {
        $0.behavior = [.removalAllowed, .terminationOnRemoval]
        $0.button?.image = NSImage(systemSymbolName: "shield", accessibilityDescription: nil)
        $0.button?.imagePosition = NSControl.ImagePosition.imageLeft
        $0.button?.action = #selector(showMenu(_:))
        $0.button?.target = self
        $0.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
     
    private(set) lazy var statusItemButton = statusItem.button!

    // MARK: - Show Menu
    
    @objc
    func showMenu(_ sender: AnyObject?) {
        switch NSApp.currentEvent?.type {
        case .leftMouseUp:
            // showPrimaryMenu()
            AboutWindow.show()
        case .rightMouseUp:
            showSecondaryMenu()
        default:
            break
        }
    }
    
    func showPrimaryMenu() {
        let hostingView = NSHostingView(rootView: MenuBarPopup())
        hostingView.frame.size = hostingView.fittingSize
        
        let menu = NSMenu()
        let item = NSMenuItem()
        item.view = hostingView
        menu.addItem(item)
        showStatusItemMenu(menu)
    }
        
    func showSecondaryMenu() {
        let menu = NSMenu()
        addItem("About...", action: #selector(showAbout), key: "c", to: menu)
        addItem("Preferences...", action: #selector(showPreferences), key: "p", to: menu)
        addItem("Do Stuff", action: #selector(doStuff), key: "d", to: menu)
        menu.addItem(NSMenuItem.separator())
        addItem("Quit", action: #selector(quit), key: "q", to: menu)
        showStatusItemMenu(menu)
    }
    
    private func showStatusItemMenu(_ menu: NSMenu) {
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }
    
    private func addItem(_ title: String, action: Selector?, key: String, to menu: NSMenu) {
        let item = NSMenuItem()
        item.title = title
        item.target = self
        item.action = action
        item.keyEquivalent = key
        menu.addItem(item)
    }
    
    // MARK: - Actions
    
    @objc
    func showAbout() {
        AboutWindow.show()
    }
    
    @objc
    func showPreferences() {
        SSApp.showSettingsWindow()
    }
    
    @objc
    func quit() {
        NSApp.terminate(self)
    }

    @objc
    func doStuff() {
        print("Do stuff")
    }
}

