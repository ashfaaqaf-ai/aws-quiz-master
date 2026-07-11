import Foundation

enum QuizMode: Hashable {
    /// Regular quiz drawn from a category + difficulty.
    case standard
    /// Practice Mode: only previously missed questions.
    case practice
}

/// Everything needed to start a quiz.
struct QuizConfig: Hashable {
    var mode: QuizMode = .standard
    /// nil means all categories (quick start / practice).
    var category: String?
    /// nil means all difficulties.
    var difficulty: String?
    var questionCount: Int = 10

    var displayCategory: String {
        switch mode {
        case .practice: return "Practice"
        case .standard: return category ?? "All Categories"
        }
    }

    var displayDifficulty: String { difficulty ?? "Mixed" }
}

/// One answered question, kept for the results/review screens.
struct AnsweredQuestion: Hashable, Identifiable {
    let question: Question
    let selectedIndex: Int

    var id: String { question.id }
    var isCorrect: Bool { selectedIndex == question.correctAnswer }
}

/// The result of a finished quiz, passed to the results/review screens.
struct QuizOutcome: Hashable {
    let config: QuizConfig
    let answers: [AnsweredQuestion]
    let timeSpent: Int

    var score: Int { answers.filter(\.isCorrect).count }
    var total: Int { answers.count }
    var accuracy: Double { total == 0 ? 0 : Double(score) / Double(total) }
}

/// Navigation destinations for the app's single NavigationStack.
enum Route: Hashable {
    case categorySelect
    case quiz(QuizConfig)
    case results(QuizOutcome)
    case review(QuizOutcome)
}
