import Foundation
import SwiftData

/// A completed quiz, persisted with SwiftData.
@Model
final class QuizSessionRecord {
    var id: UUID
    var date: Date
    var category: String
    var score: Int
    var total: Int
    var timeSpent: Int
    var difficulty: String

    init(id: UUID = UUID(),
         date: Date = .now,
         category: String,
         score: Int,
         total: Int,
         timeSpent: Int,
         difficulty: String) {
        self.id = id
        self.date = date
        self.category = category
        self.score = score
        self.total = total
        self.timeSpent = timeSpent
        self.difficulty = difficulty
    }
}
