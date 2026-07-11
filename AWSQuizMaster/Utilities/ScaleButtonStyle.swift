import SwiftUI

/// Scales the button down to 0.95 while pressed (0.15s ease-out).
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

/// Solid orange call-to-action label used by the primary buttons.
struct PrimaryButtonLabel: View {
    let title: String
    var systemImage: String?

    var body: some View {
        HStack(spacing: 8) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 17, weight: .semibold))
            }
            Text(title)
                .font(.system(size: 17, weight: .semibold))
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.awsOrange, in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius))
    }
}
