import SwiftUI
import UIKit

extension Color {
    /// AWS official primary orange — identical in both appearances.
    static let awsOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    /// Correct-answer green.
    static let awsGreen = Color(red: 0.16, green: 0.65, blue: 0.27)
    /// Wrong-answer red.
    static let awsRed = Color(red: 0.86, green: 0.21, blue: 0.27)
    /// AWS dark navy ("Squid Ink") — used for surfaces that stay navy in both appearances.
    static let awsNavySolid = Color(red: 0.14, green: 0.19, blue: 0.24)

    /// Primary text: navy in light mode, soft off-white in dark mode.
    static let awsInk = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.93, green: 0.95, blue: 0.97, alpha: 1)
            : UIColor(red: 0.14, green: 0.19, blue: 0.24, alpha: 1)
    })

    /// Screen background: light gray in light mode, deep navy-black in dark mode.
    static let awsBackground = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.055, green: 0.08, blue: 0.11, alpha: 1)
            : UIColor(red: 0.91, green: 0.92, blue: 0.93, alpha: 1)
    })

    /// Card surface: white in light mode, elevated navy in dark mode.
    static let awsCard = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.15, blue: 0.20, alpha: 1)
            : .white
    })
}

enum AWSTheme {
    static let cornerRadius: CGFloat = 12
    static let spacing: CGFloat = 16
}
