import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \QuizSessionRecord.date, order: .reverse)
    private var sessions: [QuizSessionRecord]
    @Query private var missedQuestions: [MissedQuestion]

    @State private var path: [Route] = []

    private var stats: QuizStats { QuizStats(sessions: sessions) }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: AWSTheme.spacing) {
                    header
                    StatsCardView(stats: stats)
                    actionButtons
                    recentQuizzes
                }
                .padding(AWSTheme.spacing)
            }
            .background(Color.awsBackground)
            .navigationDestination(for: Route.self) { route in
                destination(for: route)
            }
        }
        .tint(.awsOrange)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "cloud.fill")
                .font(.system(size: 44))
                .foregroundStyle(Color.awsOrange)
            Text("AWS Quiz Master")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.awsInk)
            Text("Cloud Practitioner → Developer Associate")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                Haptics.tap()
                path.append(.quiz(QuizConfig()))
            } label: {
                PrimaryButtonLabel(title: "Start Quiz", systemImage: "play.fill")
            }
            .buttonStyle(ScaleButtonStyle())

            Button {
                Haptics.tap()
                path.append(.quiz(QuizConfig(mode: .practice, questionCount: 20)))
            } label: {
                PrimaryButtonLabel(title: "Practice Mode", systemImage: "arrow.counterclockwise")
            }
            .buttonStyle(ScaleButtonStyle())

            Button {
                Haptics.tap()
                path.append(.categorySelect)
            } label: {
                PrimaryButtonLabel(title: "Browse Categories", systemImage: "square.grid.2x2.fill")
            }
            .buttonStyle(ScaleButtonStyle())

            if !missedQuestions.isEmpty {
                Text("\(missedQuestions.count) question\(missedQuestions.count == 1 ? "" : "s") waiting in Practice Mode")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var recentQuizzes: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Quizzes")
                .font(.headline)
                .foregroundStyle(Color.awsInk)

            if sessions.isEmpty {
                Text("No quizzes yet — start one above!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else {
                ForEach(sessions.prefix(5)) { session in
                    RecentSessionRow(session: session)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .categorySelect:
            CategorySelectView(path: $path)
        case .quiz(let config):
            QuizView(config: config, path: $path)
        case .results(let outcome):
            ResultsView(outcome: outcome, path: $path)
        case .review(let outcome):
            ReviewView(outcome: outcome)
        }
    }
}

private struct RecentSessionRow: View {
    let session: QuizSessionRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.category)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.awsInk)
                Text("\(session.difficulty) • \(session.date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(session.score)/\(session.total)")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(scoreColor)
        }
        .padding(12)
        .background(Color.awsCard, in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius))
    }

    private var scoreColor: Color {
        guard session.total > 0 else { return .secondary }
        let ratio = Double(session.score) / Double(session.total)
        if ratio >= 0.7 { return .awsGreen }
        if ratio >= 0.4 { return .awsOrange }
        return .awsRed
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [QuizSessionRecord.self, MissedQuestion.self], inMemory: true)
}
