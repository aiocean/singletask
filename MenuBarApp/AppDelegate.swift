//
//  AppDelegate.swift
//  MenuBarApp
//
//  Created by duocnguyen on 02/08/2022.
//

import Foundation
import SwiftUI
import Defaults
// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
    }
    func applicationWillResignActive(_ notification: Notification) {
        print("abc")
    }
}
