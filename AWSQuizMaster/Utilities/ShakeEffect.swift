import SwiftUI

/// Horizontal shake used when a wrong answer is selected.
/// Animate `animatableData` from 0 to 1 to produce three shakes.
struct ShakeEffect: GeometryEffect {
    var travel: CGFloat = 8
    var shakes: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = travel * sin(animatableData * .pi * shakes * 2)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
