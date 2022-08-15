import SwiftUI

extension NSColor {
    static let systemColors: Set<NSColor> = [
        .systemBlue,
        .systemBrown,
        .systemGray,
        .systemGreen,
        .systemIndigo,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemTeal,
        .systemYellow
    ]
    
    private static let uniqueRandomSystemColors = systemColors.infiniteUniformRandomSequence().makeIterator()
    
    static func uniqueRandomSystemColor() -> NSColor {
        uniqueRandomSystemColors.next()!
    }
}

extension NSStatusBarButton {
    /**
     Quickly cycles through random colors to make a rainbow animation so the user will notice it.
     - Note: It will do nothing if the user has enabled the “Reduce motion” accessibility settings.
     */
    func playRainbowAnimation(duration: TimeInterval = 5) {
        guard !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion else {
            return
        }
        
        let originalTintColor = contentTintColor
        
        Timer.scheduledRepeatingTimer(
            withTimeInterval: 0.1,
            totalDuration: duration,
            onRepeat: { [weak self] _ in
                self?.contentTintColor = .uniqueRandomSystemColor()
            },
            onFinish: { [weak self] in
                self?.contentTintColor = originalTintColor
            }
        )
    }
}
