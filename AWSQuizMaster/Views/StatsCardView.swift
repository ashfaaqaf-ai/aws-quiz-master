import SwiftUI

/// Navy stats card on the home screen.
struct StatsCardView: View {
    let stats: QuizStats

    var body: some View {
        HStack(spacing: 0) {
            statColumn(value: "\(stats.totalAttempted)", label: "Attempted")
            divider
            statColumn(value: stats.accuracy.formatted(.percent.precision(.fractionLength(0))),
                       label: "Accuracy")
            divider
            statColumn(value: "\(stats.streak)", label: "Day Streak", icon: "flame.fill")
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.awsNavy, in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius))
    }

    private var divider: some View {
        Rectangle()
            .fill(.white.opacity(0.2))
            .frame(width: 1, height: 40)
    }

    private func statColumn(value: String, label: String, icon: String? = nil) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.awsOrange)
                }
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}
