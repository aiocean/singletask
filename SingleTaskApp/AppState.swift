import SwiftUI
import Combine
import Defaults

@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()
    var cancellables = Set<AnyCancellable>()
    
    private(set) lazy var menuBarButton = MenuBarButton()
    
    init() {
        setUpConfig()
        DispatchQueue.main.async { [self] in
            didLaunch()
        }
    }

    private func didLaunch() {
        setUpEvents()
    }
    
    private func setUpConfig() {
        UserDefaults.standard.register(defaults: [
            "NSApplicationCrashOnExceptions": true
        ])
        // TODO: Remove in 2023.
        SSApp.runOnce(identifier: "firstRunV2") {
            SettingsWindowController.show()
        }
    }
}
