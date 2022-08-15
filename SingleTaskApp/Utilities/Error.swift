public struct FatalReason: CustomStringConvertible {
    public static let unreachable = Self("Should never be reached during execution.")
    public static let notYetImplemented = Self("Not yet implemented.")
    public static let subtypeMustOverride = Self("Must be overridden in subtype.")
    public static let mustNotBeCalled = Self("Should never be called.")
    
    public let reason: String
    
    public init(_ reason: String) {
        self.reason = reason
    }
    
    public var description: String { reason }
}

public func fatalError(
    because reason: FatalReason,
    function: StaticString = #function,
    file: StaticString = #fileID,
    line: Int = #line
) -> Never {
    fatalError("\(function): \(reason)", file: file, line: UInt(line))
}
