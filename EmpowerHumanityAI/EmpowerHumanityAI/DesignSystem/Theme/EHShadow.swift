import SwiftUI

// MARK: - EHShadow

enum EHShadow {
    struct ShadowStyle {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    /// Subtle card shadow for Level 2 (elevated intelligence) surfaces
    static let card = ShadowStyle(
        color: Color.black.opacity(0.06),
        radius: 8,
        x: 0,
        y: 2
    )

    /// Stronger shadow for drawers, sheets, floating panels
    static let panel = ShadowStyle(
        color: Color.black.opacity(0.12),
        radius: 20,
        x: 0,
        y: 4
    )

    /// Orb glow — intelligence presence
    static let orb = ShadowStyle(
        color: Color(hex: "#7C3AED").opacity(0.25),
        radius: 16,
        x: 0,
        y: 0
    )
}

extension View {
    func ehShadow(_ shadow: EHShadow.ShadowStyle) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
