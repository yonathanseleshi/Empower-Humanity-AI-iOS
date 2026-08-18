import SwiftUI

// MARK: - EHGradients
// Signature gradient for hero/identity moments only — never on every surface.
// Five semantic secondary gradients for specific meaning contexts.

enum EHGradients {
    // MARK: - Signature Co-Intelligence Identity Gradient
    // Trust Blue → Intelligence Indigo → Cognition Purple → Human Pink → Intelligence Cyan
    static let coIntelligence = LinearGradient(
        colors: [
            Color(hex: "#2563EB"),
            Color(hex: "#4F46E5"),
            Color(hex: "#7C3AED"),
            Color(hex: "#EC4899"),
            Color(hex: "#06B6D4")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Secondary Semantic Gradients

    /// Relationship — purple → pink (human bond, co-intelligence relationship)
    static let relationship = LinearGradient(
        colors: [Color(hex: "#7C3AED"), Color(hex: "#EC4899")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Action — blue → green (agency, execution, progress)
    static let action = LinearGradient(
        colors: [Color(hex: "#2563EB"), Color(hex: "#22C55E")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Intelligence — indigo → purple → cyan (reasoning, AI cognition)
    static let intelligence = LinearGradient(
        colors: [Color(hex: "#4F46E5"), Color(hex: "#7C3AED"), Color(hex: "#06B6D4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Progress — green → cyan (completion, momentum, data)
    static let progress = LinearGradient(
        colors: [Color(hex: "#22C55E"), Color(hex: "#06B6D4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Possibility — pink → purple → blue (creativity, potential)
    static let possibility = LinearGradient(
        colors: [Color(hex: "#EC4899"), Color(hex: "#7C3AED"), Color(hex: "#2563EB")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Orb Gradients per State

    static func orbGradient(for state: OrbState) -> LinearGradient {
        switch state {
        case .available:
            return coIntelligence
        case .listening:
            return LinearGradient(
                colors: [Color(hex: "#7C3AED"), Color(hex: "#EC4899")],
                startPoint: .top, endPoint: .bottom
            )
        case .thinking:
            return intelligence
        case .acting:
            return action
        case .waiting:
            return LinearGradient(
                colors: [Color(hex: "#F59E0B"), Color(hex: "#4F46E5")],
                startPoint: .top, endPoint: .bottom
            )
        case .completed:
            return progress
        case .attention:
            return LinearGradient(
                colors: [Color(hex: "#F59E0B"), Color(hex: "#EC4899")],
                startPoint: .top, endPoint: .bottom
            )
        case .error:
            return LinearGradient(
                colors: [Color(hex: "#EF4444"), Color(hex: "#7C3AED")],
                startPoint: .top, endPoint: .bottom
            )
        }
    }
}
