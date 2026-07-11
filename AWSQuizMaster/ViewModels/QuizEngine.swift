import Foundation
import Observation
import SwiftData

/// Drives one quiz session: question order, answer state, and final outcome.
@Observable
final class QuizEngine {
    let config: QuizConfig
    private(set) var questions: [Question]
    private(set) var currentIndex = 0
    private(set) var selectedAnswer: Int?
    private(set) var answers: [AnsweredQuestion] = []
    private let startDate = Date.now

    init(config: QuizConfig, missedQuestionIDs: Set<String>) {
        self.config = config
        let pool: [Question]
        switch config.mode {
        case .standard:
            pool = QuestionBank.questions(category: config.category,
                                          difficulty: config.difficulty)
        case .practice:
            pool = QuestionBank.questions(ids: missedQuestionIDs)
        }
        questions = pool.shuffled()
            .prefix(config.questionCount)
            .map(QuestionBank.shufflingOptions(of:))
    }

    var currentQuestion: Question? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    var hasAnsweredCurrent: Bool { selectedAnswer != nil }
    var isLastQuestion: Bool { currentIndex == questions.count - 1 }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(answers.count) / Double(questions.count)
    }

    /// Records the answer for the current question. Ignores repeat taps.
    func select(_ index: Int) {
        guard selectedAnswer == nil, let question = currentQuestion else { return }
        selectedAnswer = index
        answers.append(AnsweredQuestion(question: question, selectedIndex: index))
    }

    /// Moves to the next question. Returns the outcome when the quiz is over.
    func advance() -> QuizOutcome? {
        guard hasAnsweredCurrent else { return nil }
        if isLastQuestion {
            return QuizOutcome(config: config,
                               answers: answers,
                               timeSpent: Int(Date.now.timeIntervalSince(startDate)))
        }
        currentIndex += 1
        selectedAnswer = nil
        return nil
    }

    /// Persists the session and updates the missed-question pool.
    func saveResults(outcome: QuizOutcome, context: ModelContext) {
        let record = QuizSessionRecord(category: outcome.config.displayCategory,
                                       score: outcome.score,
                                       total: outcome.total,
                                       timeSpent: outcome.timeSpent,
                                       difficulty: outcome.config.displayDifficulty)
        context.insert(record)

        let answeredIDs = Set(outcome.answers.map(\.question.id))
        let all = (try? context.fetch(FetchDescriptor<MissedQuestion>())) ?? []
        let existing = all.filter { answeredIDs.contains($0.questionID) }
        var existingByID = Dictionary(uniqueKeysWithValues: existing.map { ($0.questionID, $0) })

        for answer in outcome.answers {
            if answer.isCorrect {
                // Correct answer graduates the question out of practice.
                if let missed = existingByID[answer.question.id] {
                    context.delete(missed)
                }
            } else if let missed = existingByID[answer.question.id] {
                missed.timesMissed += 1
                missed.lastMissed = .now
            } else {
                let missed = MissedQuestion(questionID: answer.question.id)
                context.insert(missed)
                existingByID[answer.question.id] = missed
            }
        }
    }
}
