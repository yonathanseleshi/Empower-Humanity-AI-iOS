import SwiftUI

// MARK: - EHColors
// Intelligence Spectrum — the canonical six-color system for Empower Humanity AI.
// Light mode is canonical. Use these tokens everywhere; never hardcode hex values.

enum EHColors {
    // MARK: - Intelligence Spectrum
    static let trustBlue = Color(hex: "#2563EB")
    static let intelligenceIndigo = Color(hex: "#4F46E5")
    static let cognitionPurple = Color(hex: "#7C3AED")
    static let humanPink = Color(hex: "#EC4899")
    static let progressGreen = Color(hex: "#22C55E")
    static let intelligenceCyan = Color(hex: "#06B6D4")

    // MARK: - Extended Semantic Accents (use sparingly, for states only)
    static let amber = Color(hex: "#F59E0B")       // attention / waiting
    static let orange = Color(hex: "#F97316")       // high attention
    static let red = Color(hex: "#EF4444")          // risk / error
    static let teal = Color(hex: "#14B8A6")         // connectivity

    // MARK: - Neutrals & Surfaces (Light Mode Canonical)
    static let white = Color(hex: "#FFFFFF")
    static let softWhite = Color(hex: "#FAFBFD")
    static let page = Color(hex: "#F7F8FC")
    static let surfaceMuted = Color(hex: "#F1F5F9")
    static let border = Color(hex: "#E2E8F0")

    // MARK: - Text
    enum Text {
        static let primary = Color(hex: "#0F172A")
        static let secondary = Color(hex: "#334155")
        static let muted = Color(hex: "#64748B")
        static let subtle = Color(hex: "#94A3B8")
        static let inverse = Color.white
    }

    // MARK: - Surface Hierarchy (six levels)
    enum Surface {
        /// Level 0: Page background
        static let environment = Color(hex: "#F7F8FC")
        /// Level 1: Flat white card
        static let card = Color(hex: "#FFFFFF")
        /// Level 2: Elevated intelligence card (faint purple border in overlay)
        static let elevated = Color(hex: "#FFFFFF").opacity(0.9)
        /// Level 3: Low-saturation tinted context surface
        static let tinted = Color(hex: "#F1F5F9")
        /// Level 4: Restrained glass (composer/floating panels)
        static let glass = Color.white.opacity(0.85)
        /// Level 5: Signature gradient surface (onboarding/celebration only)
        static let gradient = Color(hex: "#2563EB")

        static func level(_ n: Int) -> Color {
            switch n {
            case 0: return environment
            case 1: return card
            case 2: return elevated
            case 3: return tinted
            case 4: return glass
            default: return environment
            }
        }
    }

    // MARK: - AI Work Status Colors

    static func statusColor(for status: AIWorkStatus) -> Color {
        switch status {
        case .queued: return Text.muted
        case .preparing: return intelligenceIndigo
        case .working: return intelligenceCyan
        case .waitingForApproval: return amber
        case .completed: return progressGreen
        case .failed: return red
        case .cancelled: return Text.subtle
        }
    }

    // MARK: - Card Family Colors

    enum CardFamily {
        static let relationship = (primary: cognitionPurple, secondary: humanPink)
        static let intelligence = (primary: intelligenceIndigo, secondary: cognitionPurple)
        static let planning = (primary: cognitionPurple, secondary: trustBlue)
        static let execution = (primary: trustBlue, secondary: intelligenceCyan)
        static let information = (primary: trustBlue, secondary: intelligenceCyan)
    }
}
