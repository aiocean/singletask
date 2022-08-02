import SwiftUI
import WebKit
import SwiftUI

extension Bundle {
    
    var copyright: String {
        func string(for key: String) -> String? {
            object(forInfoDictionaryKey: key) as? String
        }
        return string(for: "NSHumanReadableCopyright") ?? "N/A"
    }
}


enum SSApp {
    static let idString = Bundle.main.bundleIdentifier!
    static let name = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    static let versionWithBuild = "\(version) (\(build))"
    static let icon = NSApp.applicationIconImage!
    static let url = Bundle.main.bundleURL
    static let copyright = Bundle.main.copyright
    
    //    @MainActor // TODO: When targeting macOS 13.
    static func quit() {
        NSApp.terminate(nil)
    }
    
    static let isFirstLaunch: Bool = {
        let key = "SS_hasLaunched"
        
        if UserDefaults.standard.bool(forKey: key) {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: key)
            return true
        }
    }()
    
    static func openSendFeedbackPage() {
        let metadata =
            """
            \(name) \(versionWithBuild) - \(idString)
            macOS \(Device.osVersion)
            \(Device.hardwareModel)
            """
        
        let query: [String: String] = [
            "product": name,
            "metadata": metadata
        ]
        
        URL("https://sindresorhus.com/feedback/")
            .addingDictionaryAsQuery(query)
            .open()
    }
    
    //    @MainActor // TODO: When targeting macOS 13.
    static func activateIfAccessory() {
        guard NSApp.activationPolicy() == .accessory else {
            return
        }
        
        NSApp.activate(ignoringOtherApps: true)
    }
}


extension SSApp {
    /**
     Manually show the SwiftUI settings window.
     */
    //    @MainActor // TODO: When targeting macOS 13.
    static func showSettingsWindow() {
        // Run in the next runloop so it doesn't conflict with SwiftUI if run at startup.
        DispatchQueue.main.async {
            activateIfAccessory()
            if #available(macOS 13, *) {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            } else {
                NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
            }
        }
    }
}


extension SSApp {
    /**
     This is like `SSApp.runOnce()` but let's you have an else-statement too.
     ```
     if SSApp.runOnceShouldRun(identifier: "foo") {
     // True only the first time and only once.
     } else {
     }
     ```
     */
    static func runOnceShouldRun(identifier: String) -> Bool {
        let key = "SS_App_runOnce__\(identifier)"
        
        guard !UserDefaults.standard.bool(forKey: key) else {
            return false
        }
        
        UserDefaults.standard.set(true, forKey: key)
        return true
    }
    
    /**
     Run a closure only once ever, even between relaunches of the app.
     */
    static func runOnce(identifier: String, _ execute: () -> Void) {
        guard runOnceShouldRun(identifier: identifier) else {
            return
        }
        
        execute()
    }
}
