import Cocoa
import Defaults

extension AppState {
    
    private func createMoreMenu() -> SSMenu {
        let menu = SSMenu()
        
        menu.addAboutItem()
        
        menu.addSeparator()
        
        menu.addCallbackItem("Send Feedback…") {
            SSApp.openSendFeedbackPage()
        }
        
        menu.addSeparator()
        
        menu.addLinkItem(
            "Website",
            destination: "https://sindresorhus.com/plash"
        )
        
        menu.addLinkItem(
            "Examples",
            destination: "https://github.com/sindresorhus/Plash/issues/1"
        )
        
        menu.addLinkItem(
            "Scripting",
            destination: "https://github.com/sindresorhus/Plash#scripting"
        )
        
        menu.addSeparator()
        
        menu.addLinkItem(
            "Rate on the App Store",
            destination: "macappstore://apps.apple.com/app/id1494023538?action=write-review"
        )
        
        menu.addMoreAppsItem()
        
        return menu
    }
}
