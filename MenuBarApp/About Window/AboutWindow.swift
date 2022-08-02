import AppKit
import SwiftUI

class AboutWindow: NSWindowController, NSWindowDelegate {
    
    static let window = makeWindow()
    
    static func show() {
        AboutWindow().window?.makeKeyAndOrderFront(nil)
    }

    convenience init() {
        print("init about windows")
        let window = Self.window
        window.backgroundColor = NSColor.controlBackgroundColor
        self.init(window: window)
        let contentView = makeAboutView()
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.center()
        window.title = "About Bootstrapp"
        window.contentView = NSHostingView(rootView: contentView)
        window.alwaysOnTop = true
    }
    
    private static func makeWindow() -> NSWindow {
        let contentRect = NSRect(x: 0, y: 0, width: 500, height: 260)
        let styleMask: NSWindow.StyleMask = [
            .titled,
            .closable,
            .fullSizeContentView
        ]
        return NSWindow(
            contentRect: contentRect,
            styleMask: styleMask,
            backing: .buffered,
            defer: false
        )
    }

    private func makeAboutView() -> some View {
        AboutView(
            icon: NSApp.applicationIconImage ?? NSImage(),
            name: SSApp.name,
            version: SSApp.version,
            build: SSApp.build,
            copyright: SSApp.copyright,
            developerName: "AI Ocean")
            .frame(width: 500, height: 260)
    }
}
