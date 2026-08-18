import SwiftUI

struct LandingView: View {
    @Environment(AppState.self) private var appState
    @State private var navigateToLogin = false
    @State private var navigateToSignup = false
    @State private var navigateToDemo = false
    @State private var orbState: OrbState = .available

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: Hero
                    heroSection

                    // MARK: Benefits
                    benefitsSection
                        .padding(.top, EHSpacing.xxxl)

                    // MARK: Human Control
                    humanControlSection
                        .padding(.top, EHSpacing.sectionSpacing)

                    // MARK: CTAs
                    ctaSection
                        .padding(.top, EHSpacing.xxxl)
                        .padding(.bottom, EHSpacing.section)
                }
            }
            .background(EHColors.page)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
            .navigationDestination(isPresented: $navigateToSignup) {
                SignupView()
            }
            #if DEBUG
            .navigationDestination(isPresented: $navigateToDemo) {
                Text("Demo Mode")
                    .onAppear {
                        Task {
                            await appState.signIn(email: "ben@example.com", password: "demo")
                            navigateToDemo = false
                        }
                    }
            }
            #endif
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: EHSpacing.xl) {
            // Brand name
            Text("Empower Humanity AI")
                .font(EHTypography.label)
                .foregroundStyle(EHColors.Text.muted)
                .tracking(1.5)
                .padding(.top, EHSpacing.xxxl)

            // Orb — hero size
            CoIntelligenceOrb(state: orbState, size: 120)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).delay(0.5)) {
                        orbState = .thinking
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation { orbState = .available }
                    }
                }

            // Headline
            VStack(spacing: EHSpacing.sm) {
                Text("An intelligence that knows you,\ngrows with you,\nand helps you act.")
                    .font(EHTypography.h1)
                    .foregroundStyle(EHColors.Text.primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)

                Text("Empower Humanity AI gives you one persistent co-intelligence that understands what matters, helps you think and plan, and can responsibly act across your digital world.")
                    .font(EHTypography.bodyMd)
                    .foregroundStyle(EHColors.Text.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, EHSpacing.screenHorizontal)
            }
            .padding(.horizontal, EHSpacing.screenHorizontal)
        }
    }

    // MARK: - Benefits Section

    private var benefitsSection: some View {
        VStack(spacing: EHSpacing.md) {
            benefitRow(
                icon: "brain",
                color: EHColors.cognitionPurple,
                title: "Persistent intelligence",
                body: "Alex remembers context, goals, and decisions across every session and device."
            )
            benefitRow(
                icon: "bolt.fill",
                color: EHColors.intelligenceCyan,
                title: "Responsible action",
                body: "Alex can work on your behalf — always within the boundaries you define."
            )
            benefitRow(
                icon: "shield.checkered",
                color: EHColors.trustBlue,
                title: "You remain in control",
                body: "Review, approve, pause, or stop AI actions at any time from any device."
            )
        }
        .padding(.horizontal, EHSpacing.screenHorizontal)
    }

    private func benefitRow(icon: String, color: Color, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: EHSpacing.md) {
            EHIconContainer(systemName: icon, color: color, size: 44)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                Text(body)
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.muted)
            }
            Spacer()
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }

    // MARK: - Human Control Section

    private var humanControlSection: some View {
        VStack(spacing: EHSpacing.sm) {
            Text("You are always in control")
                .font(EHTypography.h3)
                .foregroundStyle(EHColors.Text.primary)
                .multilineTextAlignment(.center)
            Text("AI that acts without your understanding or approval is a liability, not a tool. We built Empower Humanity AI to be transparent, governable, and genuinely in service of you.")
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.Text.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, EHSpacing.screenHorizontal)
        }
        .padding(.horizontal, EHSpacing.screenHorizontal)
    }

    // MARK: - CTA Section

    private var ctaSection: some View {
        VStack(spacing: EHSpacing.sm) {
            EHPrimaryButton("Create Account") {
                navigateToSignup = true
            }
            EHSecondaryButton("Sign In") {
                navigateToLogin = true
            }
            #if DEBUG
            Button("Explore Demo") {
                Task { await appState.signIn(email: "ben@example.com", password: "demo") }
            }
            .font(EHTypography.bodySm)
            .foregroundStyle(EHColors.Text.muted)
            .padding(.top, EHSpacing.xs)
            #endif
        }
        .padding(.horizontal, EHSpacing.screenHorizontal)
    }
}
