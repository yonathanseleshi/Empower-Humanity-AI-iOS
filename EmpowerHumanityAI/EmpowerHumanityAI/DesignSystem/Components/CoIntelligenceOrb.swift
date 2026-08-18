import SwiftUI

// MARK: - CoIntelligenceOrb
// The signature visual identity of the Co-Intelligence.
// 8 states with subtle native SwiftUI animation.
// Never turn the whole orb red — use corner dot for attention/error states.

struct CoIntelligenceOrb: View {
    let state: OrbState
    var size: CGFloat = 60
    var showStateLabel: Bool = false

    @State private var pulseScale: CGFloat = 1.0
    @State private var colorPhase: CGFloat = 0
    @State private var gradientOffset: CGFloat = 0
    @State private var resolutionScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Base orb
            Circle()
                .fill(EHGradients.orbGradient(for: state))
                .frame(width: size, height: size)
                .scaleEffect(pulseScale)
                .shadow(
                    color: EHColors.cognitionPurple.opacity(0.30),
                    radius: size * 0.25,
                    x: 0, y: 0
                )

            // Pulse ring (listening state)
            if state == .listening {
                Circle()
                    .strokeBorder(EHColors.cognitionPurple.opacity(0.25), lineWidth: 2)
                    .frame(width: size * 1.5, height: size * 1.5)
                    .scaleEffect(pulseScale)
                    .opacity(2.0 - pulseScale)
            }

            // Corner dot (attention / error — never full orb colour change)
            if state == .attention || state == .error {
                Circle()
                    .fill(state == .error ? EHColors.red : EHColors.amber)
                    .frame(width: size * 0.22, height: size * 0.22)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 1.5)
                    )
                    .offset(x: size * 0.32, y: -(size * 0.32))
            }

            // Amber ring (waiting state)
            if state == .waiting {
                Circle()
                    .strokeBorder(EHColors.amber.opacity(0.6), lineWidth: 3)
                    .frame(width: size, height: size)
            }
        }
        .onChange(of: state, initial: true) { _, newState in
            stopAnimations()
            startAnimation(for: newState)
        }
        .onDisappear { stopAnimations() }
    }

    // MARK: - Animation

    private func startAnimation(for state: OrbState) {
        switch state {
        case .available:
            // Subtle slow drift
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                pulseScale = 1.04
            }

        case .listening:
            // Outward pulse
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: false)) {
                pulseScale = 1.6
            }

        case .thinking:
            // Slow internal colour drift — simulated by gentle scale oscillation
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.06
            }

        case .acting:
            // Directional gradient movement — faster pulse
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                pulseScale = 1.1
            }

        case .waiting:
            // Amber edge — minimal animation
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulseScale = 1.02
            }

        case .completed:
            // One-shot resolution pulse
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                resolutionScale = 1.3
            }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.2)) {
                resolutionScale = 1.0
            }

        case .attention, .error:
            // Subtle gentle pulse — identity stays intact
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.03
            }
        }
    }

    private func stopAnimations() {
        pulseScale = 1.0
        resolutionScale = 1.0
        colorPhase = 0
        gradientOffset = 0
    }
}

// MARK: - Orb Size Variants

extension CoIntelligenceOrb {
    static func small(state: OrbState) -> CoIntelligenceOrb {
        CoIntelligenceOrb(state: state, size: 32)
    }
    static func medium(state: OrbState) -> CoIntelligenceOrb {
        CoIntelligenceOrb(state: state, size: 48)
    }
    static func large(state: OrbState) -> CoIntelligenceOrb {
        CoIntelligenceOrb(state: state, size: 80)
    }
    static func hero(state: OrbState) -> CoIntelligenceOrb {
        CoIntelligenceOrb(state: state, size: 120)
    }
}

// MARK: - Preview

#Preview("Orb States") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
            ForEach(OrbState.allCases, id: \.self) { state in
                VStack(spacing: 8) {
                    CoIntelligenceOrb(state: state, size: 64)
                    Text(state.rawValue.capitalized)
                        .font(EHTypography.caption)
                        .foregroundStyle(EHColors.Text.muted)
                }
                .padding()
            }
        }
    }
    .padding()
    .background(EHColors.page)
}
