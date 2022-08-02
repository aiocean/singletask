import SwiftUI
extension String {
    var toNSAttributedString: NSAttributedString { .init(string: self) }
}

extension String {
    var trimmed: Self {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var trimmedLeading: Self {
        replacingOccurrences(of: #"^\s+"#, with: "", options: .regularExpression)
    }
    
    var trimmedTrailing: Self {
        replacingOccurrences(of: #"\s+$"#, with: "", options: .regularExpression)
    }
    
    func removingPrefix(_ prefix: Self) -> Self {
        guard hasPrefix(prefix) else {
            return self
        }
        
        return Self(dropFirst(prefix.count))
    }
    
    // TODO: Remove this when targeting a Swift version with native regex support.
    /**
     Returns a string with the matches of the given regex replaced with the given replacement string.
     */
    func replacingOccurrences(matchingRegex regex: Self, with replacement: Self) -> Self {
        replacingOccurrences(of: regex, with: replacement, options: .regularExpression)
    }
    
    /**
     ```
     "Unicorn".truncated(to: 4)
     //=> "Uni…"
     ```
     */
    func truncating(to number: Int, truncationIndicator: Self = "…") -> Self {
        if number <= 0 {
            return ""
        } else if count > number {
            return Self(prefix(number - truncationIndicator.count)).trimmedTrailing + truncationIndicator
        } else {
            return self
        }
    }
}
