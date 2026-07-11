import SwiftUI

/// Flip through every answered question with Previous/Next navigation.
struct ReviewView: View {
    let outcome: QuizOutcome
    @State private var index = 0

    private var current: AnsweredQuestion { outcome.answers[index] }

    var body: some View {
        VStack(spacing: AWSTheme.spacing) {
            Text("Question \(index + 1) of \(outcome.answers.count)")
                .font(.caption)
                .foregroundStyle(.secondary)

            ScrollView {
                VStack(alignment: .leading, spacing: AWSTheme.spacing) {
                    HStack {
                        Image(systemName: current.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(current.isCorrect ? Color.awsGreen : Color.awsRed)
                        Text(current.isCorrect ? "Correct" : "Incorrect")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(current.isCorrect ? Color.awsGreen : Color.awsRed)
                        Spacer()
                        Text(current.question.difficulty)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Text(current.question.text)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.awsInk)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(spacing: 10) {
                        ForEach(current.question.options.indices, id: \.self) { optionIndex in
                            reviewOption(optionIndex)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Label("Explanation", systemImage: "lightbulb.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.awsOrange)
                        Text(current.question.explanation)
                            .font(.system(size: 15))
                            .foregroundStyle(Color.awsInk)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.awsCard, in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius))
                }
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
            .id(index)
            .transition(.opacity)

            navigationButtons
        }
        .padding(AWSTheme.spacing)
        .background(Color.awsBackground)
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func reviewOption(_ optionIndex: Int) -> some View {
        let isCorrectAnswer = optionIndex == current.question.correctAnswer
        let isUserPick = optionIndex == current.selectedIndex

        return HStack(spacing: 10) {
            Text(current.question.options[optionIndex])
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(isCorrectAnswer || (isUserPick && !isCorrectAnswer) ? .white : Color.awsInk)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            if isCorrectAnswer {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.white)
            } else if isUserPick {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.white)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            isCorrectAnswer ? Color.awsGreen : (isUserPick ? Color.awsRed : Color.awsCard),
            in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius)
        )
        .overlay(alignment: .topTrailing) {
            if isUserPick {
                Text("Your answer")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.awsNavySolid, in: Capsule())
                    .offset(x: -8, y: -8)
            }
        }
    }

    private var navigationButtons: some View {
        HStack(spacing: 12) {
            Button {
                Haptics.select()
                withAnimation(.easeInOut(duration: 0.25)) { index -= 1 }
            } label: {
                Label("Previous", systemImage: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(index > 0 ? Color.awsInk : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.awsCard, in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius))
            }
            .buttonStyle(ScaleButtonStyle())
            .disabled(index == 0)

            Button {
                Haptics.select()
                withAnimation(.easeInOut(duration: 0.25)) { index += 1 }
            } label: {
                HStack {
                    Text("Next")
                    Image(systemName: "chevron.right")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(
                    index < outcome.answers.count - 1 ? Color.awsOrange : Color.awsOrange.opacity(0.4),
                    in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius)
                )
            }
            .buttonStyle(ScaleButtonStyle())
            .disabled(index >= outcome.answers.count - 1)
        }
    }
}
