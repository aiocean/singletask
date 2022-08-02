import SwiftUI

extension URL {
    /**
     Create a URL from a human string, gracefully.
     By default, it only accepts `localhost` as a TLD-less URL.
     ```
     URL(humanString: "sindresorhus.com")?.absoluteString
     //=> "https://sindresorhus.com"
     ```
     */
    init?(humanString: String) {
        let string = humanString.trimmed
        
        guard
            !string.isEmpty,
            !string.hasPrefix("."),
            !string.hasSuffix("."),
            string != "https://",
            string != "http://",
            string != "file://"
        else {
            return nil
        }
        
        let isValid = string.contains(".")
        || string.hasPrefix("localhost")
        || string.hasPrefix("http://localhost")
        || string.hasPrefix("https://localhost")
        || string.hasPrefix("file://")
        
        guard
            !string.hasPrefix("https://"),
            !string.hasPrefix("http://"),
            !string.hasPrefix("file://")
        else {
            guard isValid else {
                return nil
            }
            
            self.init(string: string)
            return
        }
        
        guard isValid else {
            return nil
        }
        
        let url = string.replacingOccurrences(of: #"^(?!(?:\w+:)?\/\/)"#, with: "https://", options: .regularExpression)
        
        self.init(string: url)
    }
}

extension URL: ExpressibleByStringLiteral {
    /**
     Example:
     ```
     let url: URL = "https://sindresorhus.com"
     ```
     */
    public init(stringLiteral value: StaticString) {
        self.init(string: "\(value)")!
    }
}

extension URL {
    func addingDictionaryAsQuery(_ dict: [String: String]) -> Self {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.addDictionaryAsQuery(dict)
        return components.url ?? self
    }
}

extension URLComponents {
    mutating func addDictionaryAsQuery(_ dict: [String: String]) {
        percentEncodedQuery = dict.toQueryString
    }
}

extension URLComponents {
    /**
     This correctly escapes items. See `escapeQueryComponent`.
     */
    var queryDictionary: [String: String] {
        get {
            queryItems?.toDictionary { ($0.name, $0.value) }.compactValues() ?? [:]
        }
        set {
            // Using `percentEncodedQueryItems` instead of `queryItems` since the query items are already custom-escaped. See `escapeQueryComponent`.
            percentEncodedQueryItems = newValue.toQueryItems
        }
    }
}

extension Dictionary where Key == String {
    /**
     This correctly escapes items. See `escapeQueryComponent`.
     */
    var toQueryItems: [URLQueryItem] {
        map {
            URLQueryItem(
                name: escapeQueryComponent($0),
                value: escapeQueryComponent("\($1)")
            )
        }
    }
    
    var toQueryString: String {
        var components = URLComponents()
        components.queryItems = toQueryItems
        return components.query!
    }
}

extension URL {
    /**
     Convenience for opening URLs.
     */
    func open() {
        NSWorkspace.shared.open(self)
    }
}
