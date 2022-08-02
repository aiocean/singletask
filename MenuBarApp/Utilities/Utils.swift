import Combine
import SwiftUI
/**
 Convenience function for initializing an object and modifying its properties.
 ```
 let label = with(NSTextField()) {
 $0.stringValue = "Foo"
 $0.textColor = .systemBlue
 view.addSubview($0)
 }
 ```
 */
@discardableResult
func with<T>(_ item: T, update: (inout T) throws -> Void) rethrows -> T {
    var this = item
    try update(&this)
    return this
}

func delay(seconds: TimeInterval, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}

func escapeQueryComponent(_ query: String) -> String {
    query.addingPercentEncoding(withAllowedCharacters: .urlUnreservedRFC3986)!
}


extension CharacterSet {
    /**
     Characters allowed to be unescaped in an URL.
     https://tools.ietf.org/html/rfc3986#section-2.3
     */
    static let urlUnreservedRFC3986 = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
}

enum OperatingSystem {
    case macOS
    case iOS
    case tvOS
    case watchOS
    
#if os(macOS)
    static let current = macOS
#elseif os(iOS)
    static let current = iOS
#elseif os(tvOS)
    static let current = tvOS
#elseif os(watchOS)
    static let current = watchOS
#else
#error("Unsupported platform")
#endif
}

extension OperatingSystem {
    /**
     - Note: Only use this when you cannot use an `if #available` check. For example, inline in function calls.
     */
    static let isMacOS14OrLater: Bool = {
#if os(macOS)
        if #available(macOS 14, *) {
            return true
        } else {
            return false
        }
#else
        return false
#endif
    }()
    
    /**
     - Note: Only use this when you cannot use an `if #available` check. For example, inline in function calls.
     */
    static let isMacOS13OrLater: Bool = {
#if os(macOS)
        if #available(macOS 13, *) {
            return true
        } else {
            return false
        }
#else
        return false
#endif
    }()
}

typealias OS = OperatingSystem
