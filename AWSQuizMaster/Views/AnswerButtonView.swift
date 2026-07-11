import SwiftUI

/// A single answer option. Fills green/red after selection, slides in a
/// checkmark on the correct answer, and shakes when wrong.
struct AnswerButtonView: View {
    enum AnswerState {
        case idle      // not yet answered
        case correct   // this is the right answer (revealed)
        case wrong     // user picked this and it's wrong
        case dimmed    // another option was picked
    }

    let text: String
    let state: AnswerState
    let action: () -> Void

    @State private var shakePhase: CGFloat = 0
    @State private var checkmarkShown = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(textColor)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
                if state == .correct && checkmarkShown {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .transition(.scale.combined(with: .opacity))
                }
                if state == .wrong {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius))
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(state != .idle)
        .opacity(state == .dimmed ? 0.55 : 1)
        .modifier(ShakeEffect(animatableData: shakePhase))
        .onChange(of: state) { _, newState in
            switch newState {
            case .correct:
                withAnimation(.spring(duration: 0.3)) { checkmarkShown = true }
            case .wrong:
                withAnimation(.linear(duration: 0.2)) { shakePhase = 1 }
            case .idle:
                checkmarkShown = false
                shakePhase = 0
            case .dimmed:
                break
            }
        }
        .accessibilityLabel(accessibilityText)
    }

    private var backgroundColor: Color {
        switch state {
        case .idle, .dimmed: return .awsCard
        case .correct: return .awsGreen
        case .wrong: return .awsRed
        }
    }

    private var textColor: Color {
        switch state {
        case .idle, .dimmed: return .awsInk
        case .correct, .wrong: return .white
        }
    }

    private var accessibilityText: String {
        switch state {
        case .idle, .dimmed: return text
        case .correct: return "\(text), correct answer"
        case .wrong: return "\(text), incorrect"
        }
    }
}
