import UIKit

/// Centralized haptic feedback used across the app.
enum Haptics {
    /// Heavy impact for primary button taps.
    static func tap() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    /// Medium impact for answer selection.
    static func select() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    /// Notification success for a correct answer.
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    /// Notification error for a wrong answer.
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    /// Light tick used while the score counts up.
    static func tick() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
