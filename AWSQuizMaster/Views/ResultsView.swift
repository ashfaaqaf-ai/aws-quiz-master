import SwiftUI

struct ResultsView: View {
    let outcome: QuizOutcome
    @Binding var path: [Route]

    @State private var displayedScore = 0
    @State private var displayedAccuracy = 0.0

    var body: some View {
        VStack(spacing: AWSTheme.spacing) {
            Spacer()

            Text(headline)
                .font(.title2.bold())
                .foregroundStyle(Color.awsNavy)

            Text("\(displayedScore)/\(outcome.total)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundStyle(Color.awsNavy)
                .contentTransition(.numericText(value: Double(displayedScore)))
                .accessibilityLabel("Score \(outcome.score) out of \(outcome.total)")

            Text(displayedAccuracy.formatted(.percent.precision(.fractionLength(0))) + " accuracy")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(accuracyColor)
                .contentTransition(.numericText(value: displayedAccuracy))

            HStack(spacing: 20) {
                infoChip(icon: "folder.fill", text: outcome.config.displayCategory)
                infoChip(icon: "clock.fill", text: timeText)
            }
            .padding(.top, 4)

            Spacer()

            VStack(spacing: 12) {
                Button {
                    Haptics.tap()
                    path.append(.review(outcome))
                } label: {
                    PrimaryButtonLabel(title: "Review Answers", systemImage: "list.bullet.clipboard")
                }
                .buttonStyle(ScaleButtonStyle())

                Button {
                    Haptics.tap()
                    path.removeLast()
                    path.append(.quiz(outcome.config))
                } label: {
                    PrimaryButtonLabel(title: "Try Again", systemImage: "arrow.clockwise")
                }
                .buttonStyle(ScaleButtonStyle())

                Button {
                    Haptics.tap()
                    path.removeAll()
                } label: {
                    PrimaryButtonLabel(title: "Home", systemImage: "house.fill")
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(AWSTheme.spacing)
        .background(Color.awsLightGray)
        .navigationBarBackButtonHidden(true)
        .task { await animateScore() }
    }

    private var headline: String {
        switch outcome.accuracy {
        case 0.9...: return "Outstanding! 🏆"
        case 0.7..<0.9: return "Great job! 🎉"
        case 0.5..<0.7: return "Good effort! 💪"
        default: return "Keep practicing! 📚"
        }
    }

    private var accuracyColor: Color {
        if outcome.accuracy >= 0.7 { return .awsGreen }
        if outcome.accuracy >= 0.4 { return .awsOrange }
        return .awsRed
    }

    private var timeText: String {
        let minutes = outcome.timeSpent / 60
        let seconds = outcome.timeSpent % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func infoChip(icon: String, text: String) -> some View {
        Label(text, systemImage: icon)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(Color.awsNavy)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.white, in: Capsule())
    }

    /// Counts the score up from 0 over ~0.8s with a haptic tick per step.
    private func animateScore() async {
        guard outcome.score > 0 else {
            displayedAccuracy = outcome.accuracy
            return
        }
        let stepDuration = 0.8 / Double(outcome.score)
        for step in 1...outcome.score {
            try? await Task.sleep(for: .seconds(stepDuration))
            withAnimation(.easeOut(duration: stepDuration)) {
                displayedScore = step
                displayedAccuracy = Double(step) / Double(outcome.total)
            }
            Haptics.tick()
        }
    }
}
