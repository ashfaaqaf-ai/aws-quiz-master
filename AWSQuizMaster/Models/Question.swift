import Foundation

struct Question: Codable, Identifiable, Hashable {
    let id: String
    let text: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let category: String
    let difficulty: String
}
