import SwiftUI

struct AccessStatusView: View {
    @Environment(AppState.self) private var appState
    private let accessService = AccessService.shared

    var body: some View {
        ScrollView {
            VStack(spacing: EHSpacing.xl) {
                // Header
                VStack(spacing: EHSpacing.md) {
                    CoIntelligenceOrb(state: .waiting, size: 72)
                    Text("Your access status")
                        .font(EHTypography.h2)
                        .foregroundStyle(EHColors.Text.primary)
                    EHStatusBadge(
                        label: appState.accessTier.displayName,
                        color: EHColors.intelligenceIndigo
                    )
                }
                .padding(.top, EHSpacing.xxxl)

                // Current access card
                VStack(alignment: .leading, spacing: EHSpacing.md) {
                    EHSectionHeader(title: "What you can access")
                    ForEach(accessService.availableFeatures, id: \.self) { feature in
                        featureRow(icon: "checkmark.circle.fill", text: feature, color: EHColors.progressGreen)
                    }
                }
                .padding(EHSpacing.cardPadding)
                .ehCard(level: 2)

                // Coming soon
                if !accessService.upcomingFeatures.isEmpty {
                    VStack(alignment: .leading, spacing: EHSpacing.md) {
                        EHSectionHeader(title: "Coming soon")
                        ForEach(accessService.upcomingFeatures, id: \.self) { feature in
                            featureRow(icon: "clock", text: feature, color: EHColors.Text.subtle)
                        }
                    }
                    .padding(EHSpacing.cardPadding)
                    .ehCard(level: 1)
                }

                // Waitlist note
                if appState.accessTier == .waitlist {
                    VStack(spacing: EHSpacing.sm) {
                        Text("You're on the list")
                            .font(EHTypography.h4)
                            .foregroundStyle(EHColors.Text.primary)
                        Text("We're inviting people in carefully to ensure the experience is everything it should be. You'll hear from us when your access is ready.")
                            .font(EHTypography.bodySm)
                            .foregroundStyle(EHColors.Text.muted)
                            .multilineTextAlignment(.center)
                    }
                    .padding(EHSpacing.cardPaddingLg)
                    .ehCard(level: 1)
                }
            }
            .padding(.horizontal, EHSpacing.screenHorizontal)
            .padding(.bottom, EHSpacing.section)
        }
        .background(EHColors.page)
        .navigationTitle("Access")
        .onAppear {
            accessService.updateTier(appState.accessTier)
        }
    }

    private func featureRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: EHSpacing.sm) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 20)
            Text(text)
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.Text.secondary)
            Spacer()
        }
    }
}
