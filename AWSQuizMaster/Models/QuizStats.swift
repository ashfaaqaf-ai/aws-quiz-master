import Foundation

/// Aggregate statistics derived from saved sessions.
struct QuizStats {
    var totalAttempted = 0
    var totalCorrect = 0
    var streak = 0
    var lastDate: Date?

    var accuracy: Double {
        totalAttempted == 0 ? 0 : Double(totalCorrect) / Double(totalAttempted)
    }

    init(sessions: [QuizSessionRecord]) {
        totalAttempted = sessions.reduce(0) { $0 + $1.total }
        totalCorrect = sessions.reduce(0) { $0 + $1.score }
        lastDate = sessions.map(\.date).max()
        streak = Self.dayStreak(dates: sessions.map(\.date))
    }

    /// Consecutive calendar days (ending today or yesterday) with at least one quiz.
    private static func dayStreak(dates: [Date]) -> Int {
        let calendar = Calendar.current
        let days = Set(dates.map { calendar.startOfDay(for: $0) }).sorted(by: >)
        guard var cursor = days.first else { return 0 }

        let today = calendar.startOfDay(for: .now)
        let gapToToday = calendar.dateComponents([.day], from: cursor, to: today).day ?? 0
        guard gapToToday <= 1 else { return 0 }

        var streak = 1
        for day in days.dropFirst() {
            let gap = calendar.dateComponents([.day], from: day, to: cursor).day ?? 0
            if gap == 1 {
                streak += 1
                cursor = day
            } else if gap > 1 {
                break
            }
        }
        return streak
    }
}
