import Cocoa
import Defaults

extension AppState {
    func setUpEvents() {
        Defaults.publisher(.task)
            .sink { [self] change in
                DispatchQueue.main.async {
                    if change.newValue.isEmpty {
                        self.menuBarButton.statusItemButton.title = "Type your task"
                    } else {
                        self.menuBarButton.statusItemButton.title = change.newValue
                    }
                }
            }
            .store(in: &cancellables)

    }
}
