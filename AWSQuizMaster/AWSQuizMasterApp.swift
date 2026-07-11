import SwiftUI
import SwiftData

@main
struct AWSQuizMasterApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [QuizSessionRecord.self, MissedQuestion.self])
    }
}
