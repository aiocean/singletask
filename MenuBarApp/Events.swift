import Cocoa
import Defaults
import KeyboardShortcuts

extension AppState {
    func setUpEvents() {
    
        KeyboardShortcuts.onKeyUp(for: .toggleUnicornMode) {
            print("abc")
        }
        
        Defaults.publisher(.task)
            .sink { [self] change in
                menuBarButton.statusItemButton.title = change.newValue
            }
            .store(in: &cancellables)

    }
}
