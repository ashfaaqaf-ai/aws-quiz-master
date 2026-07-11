import SwiftUI
import SwiftData

struct QuizView: View {
    let config: QuizConfig
    @Binding var path: [Route]

    @Environment(\.modelContext) private var modelContext
    @State private var engine: QuizEngine?
    @State private var questionVisible = false
    @State private var explanationVisible = false

    var body: some View {
        Group {
            if let engine {
                if engine.questions.isEmpty {
                    emptyState
                } else {
                    quizContent(engine: engine)
                }
            } else {
                Color.awsBackground.ignoresSafeArea()
            }
        }
        .background(Color.awsBackground)
        .navigationTitle(config.displayCategory)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard engine == nil else { return }
            let missed = (try? modelContext.fetch(FetchDescriptor<MissedQuestion>())) ?? []
            engine = QuizEngine(config: config,
                                missedQuestionIDs: Set(missed.map(\.questionID)))
            withAnimation(.easeIn(duration: 0.25)) { questionVisible = true }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Nothing to Practice", systemImage: "checkmark.seal.fill")
        } description: {
            Text(config.mode == .practice
                 ? "You have no missed questions. Take a quiz and any wrong answers will show up here."
                 : "No questions match this category and difficulty yet.")
        } actions: {
            Button("Back to Home") {
                Haptics.tap()
                path.removeAll()
            }
            .buttonStyle(.borderedProminent)
            .tint(.awsOrange)
        }
    }

    private func quizContent(engine: QuizEngine) -> some View {
        VStack(spacing: AWSTheme.spacing) {
            QuizProgressBar(progress: engine.progress)

            Text("Question \(engine.currentIndex + 1) of \(engine.questions.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let question = engine.currentQuestion {
                ScrollView {
                    VStack(alignment: .leading, spacing: AWSTheme.spacing) {
                        Text(question.text)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color.awsInk)
                            .fixedSize(horizontal: false, vertical: true)

                        VStack(spacing: 10) {
                            ForEach(question.options.indices, id: \.self) { index in
                                AnswerButtonView(
                                    text: question.options[index],
                                    state: answerState(for: index, in: engine)
                                ) {
                                    select(index, engine: engine)
                                }
                            }
                        }

                        if explanationVisible {
                            explanationBox(question)
                                .transition(.opacity)
                        }
                    }
                    .padding(.bottom, 90)
                }
                .scrollIndicators(.hidden)
                .opacity(questionVisible ? 1 : 0)
                .id(question.id)
            }
        }
        .padding(AWSTheme.spacing)
        .safeAreaInset(edge: .bottom) {
            if engine.hasAnsweredCurrent {
                nextButton(engine: engine)
                    .padding(.horizontal, AWSTheme.spacing)
                    .padding(.bottom, 8)
                    .transition(.opacity)
            }
        }
    }

    private func explanationBox(_ question: Question) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Explanation", systemImage: "lightbulb.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.awsOrange)
            Text(question.explanation)
                .font(.system(size: 15))
                .foregroundStyle(Color.awsInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.awsCard, in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius))
    }

    private func nextButton(engine: QuizEngine) -> some View {
        Button {
            Haptics.tap()
            advance(engine: engine)
        } label: {
            PrimaryButtonLabel(title: engine.isLastQuestion ? "See Results" : "Next",
                               systemImage: engine.isLastQuestion ? "flag.checkered" : "arrow.right")
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private func answerState(for index: Int, in engine: QuizEngine) -> AnswerButtonView.AnswerState {
        guard let selected = engine.selectedAnswer,
              let question = engine.currentQuestion else { return .idle }
        if index == question.correctAnswer { return .correct }
        if index == selected { return .wrong }
        return .dimmed
    }

    private func select(_ index: Int, engine: QuizEngine) {
        guard !engine.hasAnsweredCurrent, let question = engine.currentQuestion else { return }
        withAnimation(.easeOut(duration: 0.3)) {
            engine.select(index)
        }
        if index == question.correctAnswer {
            Haptics.success()
        } else {
            Haptics.error()
        }
        withAnimation(.easeIn(duration: 0.4).delay(0.25)) {
            explanationVisible = true
        }
    }

    private func advance(engine: QuizEngine) {
        if let outcome = engine.advance() {
            engine.saveResults(outcome: outcome, context: modelContext)
            path.append(.results(outcome))
        } else {
            explanationVisible = false
            questionVisible = false
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(50))
                withAnimation(.easeIn(duration: 0.25)) {
                    questionVisible = true
                }
            }
        }
    }
}
