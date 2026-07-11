import SwiftUI

extension Color {
    /// AWS official primary orange.
    static let awsOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    /// AWS dark navy ("Squid Ink").
    static let awsNavy = Color(red: 0.14, green: 0.19, blue: 0.24)
    /// Light gray background.
    static let awsLightGray = Color(red: 0.91, green: 0.92, blue: 0.93)
    /// Correct-answer green.
    static let awsGreen = Color(red: 0.16, green: 0.65, blue: 0.27)
    /// Wrong-answer red.
    static let awsRed = Color(red: 0.86, green: 0.21, blue: 0.27)
}

enum AWSTheme {
    static let cornerRadius: CGFloat = 12
    static let spacing: CGFloat = 16
}
