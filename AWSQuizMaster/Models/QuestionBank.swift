import Foundation

struct QuestionBankFile: Codable {
    let categories: [String]
    let questions: [Question]
}

/// Loads and serves the bundled offline question bank.
enum QuestionBank {
    static let file: QuestionBankFile = {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(QuestionBankFile.self, from: data)
        else {
            assertionFailure("questions.json missing or malformed")
            return QuestionBankFile(categories: [], questions: [])
        }
        return decoded
    }()

    static var categories: [String] { file.categories }
    static var questions: [Question] { file.questions }

    static func questions(category: String?, difficulty: String?) -> [Question] {
        questions.filter { question in
            (category == nil || question.category == category)
                && (difficulty == nil || question.difficulty == difficulty)
        }
    }

    static func questions(ids: Set<String>) -> [Question] {
        questions.filter { ids.contains($0.id) }
    }

    /// Returns a copy with the answer options in random order, so users
    /// can't memorize answer positions across attempts.
    static func shufflingOptions(of question: Question) -> Question {
        let order = Array(question.options.indices).shuffled()
        return Question(id: question.id,
                        text: question.text,
                        options: order.map { question.options[$0] },
                        correctAnswer: order.firstIndex(of: question.correctAnswer) ?? question.correctAnswer,
                        explanation: question.explanation,
                        category: question.category,
                        difficulty: question.difficulty)
    }
}
