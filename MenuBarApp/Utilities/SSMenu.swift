import SwiftUI

final class SSMenu: NSMenu, NSMenuDelegate {
    var onUpdate: (() -> Void)?
    
    private(set) var isOpen = false
    
    override init(title: String) {
        super.init(title: title)
        self.delegate = self
        self.autoenablesItems = false
    }
    
    @available(*, unavailable)
    required init(coder decoder: NSCoder) {
        fatalError(because: .notYetImplemented)
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        isOpen = true
    }
    
    func menuDidClose(_ menu: NSMenu) {
        isOpen = false
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        onUpdate?()
    }
}

extension NSMenu {
    func addSeparator() {
        addItem(.separator())
    }
    
    @discardableResult
    func add(_ menuItem: NSMenuItem) -> NSMenuItem {
        addItem(menuItem)
        return menuItem
    }
    
    @discardableResult
    func addDisabled(_ title: String) -> NSMenuItem {
        let menuItem = NSMenuItem(title)
        menuItem.isEnabled = false
        addItem(menuItem)
        return menuItem
    }
    
    @discardableResult
    func addDisabled(_ attributedTitle: NSAttributedString) -> NSMenuItem {
        let menuItem = NSMenuItem(attributedTitle)
        menuItem.isEnabled = false
        addItem(menuItem)
        return menuItem
    }
    
    @discardableResult
    func addItem(
        _ title: String,
        key: String = "",
        keyModifiers: NSEvent.ModifierFlags? = nil,
        isEnabled: Bool = true,
        isChecked: Bool = false,
        isHidden: Bool = false
    ) -> NSMenuItem {
        let menuItem = NSMenuItem(
            title,
            key: key,
            keyModifiers: keyModifiers,
            isEnabled: isEnabled,
            isChecked: isChecked,
            isHidden: isHidden
        )
        addItem(menuItem)
        return menuItem
    }
    
    @discardableResult
    func addItem(
        _ attributedTitle: NSAttributedString,
        key: String = "",
        keyModifiers: NSEvent.ModifierFlags? = nil,
        isEnabled: Bool = true,
        isChecked: Bool = false,
        isHidden: Bool = false
    ) -> NSMenuItem {
        let menuItem = NSMenuItem(
            attributedTitle,
            key: key,
            keyModifiers: keyModifiers,
            isEnabled: isEnabled,
            isChecked: isChecked,
            isHidden: isHidden
        )
        addItem(menuItem)
        return menuItem
    }
    
    @discardableResult
    func addCallbackItem(
        _ title: String,
        key: String = "",
        keyModifiers: NSEvent.ModifierFlags? = nil,
        isEnabled: Bool = true,
        isChecked: Bool = false,
        isHidden: Bool = false,
        action: @escaping () -> Void
    ) -> NSMenuItem {
        let menuItem = CallbackMenuItem(
            title,
            key: key,
            keyModifiers: keyModifiers,
            isEnabled: isEnabled,
            isChecked: isChecked,
            isHidden: isHidden,
            action: action
        )
        addItem(menuItem)
        return menuItem
    }
    
    @discardableResult
    func addCallbackItem(
        _ title: NSAttributedString,
        key: String = "",
        keyModifiers: NSEvent.ModifierFlags? = nil,
        isEnabled: Bool = true,
        isChecked: Bool = false,
        isHidden: Bool = false,
        action: @escaping () -> Void
    ) -> NSMenuItem {
        let menuItem = CallbackMenuItem(
            "",
            key: key,
            keyModifiers: keyModifiers,
            isEnabled: isEnabled,
            isChecked: isChecked,
            isHidden: isHidden,
            action: action
        )
        menuItem.attributedTitle = title
        addItem(menuItem)
        return menuItem
    }
    
    @discardableResult
    func addSettingsItem() -> NSMenuItem {
        addCallbackItem(OS.isMacOS13OrLater ? "Settings…" : "Preferences…", key: ",") {
            SSApp.showSettingsWindow()
        }
    }
    
    @discardableResult
    func addLinkItem(_ title: String, destination: URL) -> NSMenuItem {
        addCallbackItem(title) {
            destination.open()
        }
    }
    
    @discardableResult
    func addLinkItem(_ title: NSAttributedString, destination: URL) -> NSMenuItem {
        addCallbackItem(title) {
            destination.open()
        }
    }
    
    @discardableResult
    func addMoreAppsItem() -> NSMenuItem {
        addLinkItem(
            "More Apps By Me",
            destination: "macappstore://apps.apple.com/developer/id328077650"
        )
    }
        
    @discardableResult
    func addQuitItem() -> NSMenuItem {
        addSeparator()
        
        return addCallbackItem("Quit \(SSApp.name)", key: "q") {
            SSApp.quit()
        }
    }
}


extension NSMenuItem {
    /**
     The menu is only created when it's enabled.
     ```
     menu.addItem("Foo")
     .withSubmenu(createCalendarEventMenu(with: event))
     ```
     */
    @discardableResult
    func withSubmenu(_ menu: @autoclosure () -> NSMenu) -> Self {
        submenu = isEnabled ? menu() : NSMenu()
        return self
    }
    
    /**
     The menu is only created when it's enabled.
     ```
     menu
     .addItem("Foo")
     .withSubmenu { menu in
     }
     ```
     */
    @discardableResult
    func withSubmenu(_ menuBuilder: (SSMenu) -> NSMenu) -> Self {
        withSubmenu(menuBuilder(SSMenu()))
    }
}

extension NSMenuItem {
    convenience init(
        _ title: String,
        key: String = "",
        keyModifiers: NSEvent.ModifierFlags? = nil,
        isEnabled: Bool = true,
        isChecked: Bool = false,
        isHidden: Bool = false
    ) {
        self.init(title: title, action: nil, keyEquivalent: key)
        self.isEnabled = isEnabled
        self.isChecked = isChecked
        self.isHidden = isHidden
        
        if let keyModifiers = keyModifiers {
            self.keyEquivalentModifierMask = keyModifiers
        }
    }
    
    convenience init(
        _ attributedTitle: NSAttributedString,
        key: String = "",
        keyModifiers: NSEvent.ModifierFlags? = nil,
        isEnabled: Bool = true,
        isChecked: Bool = false,
        isHidden: Bool = false
    ) {
        self.init(
            "",
            key: key,
            keyModifiers: keyModifiers,
            isEnabled: isEnabled,
            isChecked: isChecked,
            isHidden: isHidden
        )
        self.attributedTitle = attributedTitle
    }
    
    var isChecked: Bool {
        get { state == .on }
        set {
            state = newValue ? .on : .off
        }
    }
}

final class CallbackMenuItem: NSMenuItem {
    private static var validateCallback: ((NSMenuItem) -> Bool)?
    
    static func validate(_ callback: @escaping (NSMenuItem) -> Bool) {
        validateCallback = callback
    }
    
    private let callback: () -> Void
    
    init(
        _ title: String,
        key: String = "",
        keyModifiers: NSEvent.ModifierFlags? = nil,
        isEnabled: Bool = true,
        isChecked: Bool = false,
        isHidden: Bool = false,
        action: @escaping () -> Void
    ) {
        self.callback = action
        super.init(title: title, action: #selector(action(_:)), keyEquivalent: key)
        self.target = self
        self.isEnabled = isEnabled
        self.isChecked = isChecked
        self.isHidden = isHidden
        
        if let keyModifiers = keyModifiers {
            self.keyEquivalentModifierMask = keyModifiers
        }
    }
    
    @available(*, unavailable)
    required init(coder decoder: NSCoder) {
        fatalError(because: .notYetImplemented)
    }
    
    @objc
    private func action(_ sender: NSMenuItem) {
        callback()
    }
}

extension CallbackMenuItem: NSMenuItemValidation {
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        Self.validateCallback?(menuItem) ?? true
    }
}

private var controlActionClosureProtocolAssociatedObjectKey: UInt8 = 0

// TODO: When NSMenu conforms, otherwise it's too annoying.
//@MainActor
protocol ControlActionClosureProtocol: NSObjectProtocol {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
}

extension ControlActionClosureProtocol {
    var onAction: ((NSEvent) -> Void)? {
        get {
            guard
                let trampoline = objc_getAssociatedObject(self, &controlActionClosureProtocolAssociatedObjectKey) as? ActionTrampoline
            else {
                return nil
            }
            
            return trampoline.action
        }
        set {
            guard let action = newValue else {
                objc_setAssociatedObject(self, &controlActionClosureProtocolAssociatedObjectKey, nil, .OBJC_ASSOCIATION_RETAIN)
                return
            }
            
            let trampoline = ActionTrampoline(action: action)
            target = trampoline
            self.action = #selector(ActionTrampoline.handleAction)
            objc_setAssociatedObject(self, &controlActionClosureProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

//@MainActor
private final class ActionTrampoline {
    fileprivate let action: (NSEvent) -> Void
    
    init(action: @escaping (NSEvent) -> Void) {
        self.action = action
    }
    
    @objc
    fileprivate func handleAction(_ sender: AnyObject) {
        action(NSApp.currentEvent!)
    }
}

extension NSControl: ControlActionClosureProtocol {}
extension NSMenuItem: ControlActionClosureProtocol {}
extension NSToolbarItem: ControlActionClosureProtocol {}
extension NSGestureRecognizer: ControlActionClosureProtocol {}
