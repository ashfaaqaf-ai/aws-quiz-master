import Foundation
import SwiftData

/// A question the user answered incorrectly. Feeds Practice Mode
/// (spaced repetition: answering it correctly removes it again).
@Model
final class MissedQuestion {
    @Attribute(.unique) var questionID: String
    var timesMissed: Int
    var lastMissed: Date

    init(questionID: String, timesMissed: Int = 1, lastMissed: Date = .now) {
        self.questionID = questionID
        self.timesMissed = timesMissed
        self.lastMissed = lastMissed
    }
}
