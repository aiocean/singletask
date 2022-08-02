import SwiftUI
extension Timer {
    /**
     Creates a repeating timer that runs for the given `duration`.
     */
    @discardableResult
    static func scheduledRepeatingTimer(
        withTimeInterval interval: TimeInterval,
        totalDuration: TimeInterval,
        onRepeat: ((Timer) -> Void)? = nil,
        onFinish: (() -> Void)? = nil
    ) -> Timer {
        let startDate = Date()
        
        return scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            guard Date() <= startDate.addingTimeInterval(totalDuration) else {
                timer.invalidate()
                onFinish?()
                return
            }
            
            onRepeat?(timer)
        }
    }
}
