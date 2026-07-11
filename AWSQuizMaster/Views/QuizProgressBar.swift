import SwiftUI

/// Orange progress bar that fills left-to-right with a smooth 0.3s animation.
struct QuizProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.awsCard)
                Capsule()
                    .fill(Color.awsOrange)
                    .frame(width: max(8, proxy.size.width * progress))
                    .animation(.easeOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 8)
        .accessibilityElement()
        .accessibilityLabel("Quiz progress")
        .accessibilityValue(progress.formatted(.percent.precision(.fractionLength(0))))
    }
}
