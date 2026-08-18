import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @State private var showAutonomy = false
    @State private var showSignOutAlert = false

    var body: some View {
        List {
            // Profile
            Section {
                HStack(spacing: EHSpacing.md) {
                    Circle()
                        .fill(EHColors.intelligenceIndigo.opacity(0.15))
                        .frame(width: 52, height: 52)
                        .overlay(
                            Text(appState.currentUser?.profile.displayName.initials ?? "B")
                                .font(EHTypography.h4)
                                .foregroundStyle(EHColors.intelligenceIndigo)
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text(appState.currentUser?.profile.displayName ?? "Ben Carter")
                            .font(EHTypography.bodySmMedium)
                            .foregroundStyle(EHColors.Text.primary)
                        Text(appState.currentUser?.email ?? "")
                            .font(EHTypography.bodySm)
                            .foregroundStyle(EHColors.Text.muted)
                        EHStatusBadge(label: appState.accessTier.displayName, color: EHColors.intelligenceIndigo)
                    }
                }
                .padding(.vertical, EHSpacing.xs)
            }

            // Co-Intelligence
            Section("Co-Intelligence") {
                settingsRow(icon: "slider.horizontal.3", title: "Autonomy settings", color: EHColors.cognitionPurple) {
                    showAutonomy = true
                }
                settingsRow(icon: "person.circle", title: "About Alex", color: EHColors.intelligenceIndigo) {}
                settingsRow(icon: "bell", title: "Notification preferences", color: EHColors.amber) {}
            }

            // Devices & Integrations
            Section("Connectivity") {
                settingsRow(icon: "laptopcomputer.and.iphone", title: "Connected devices", color: EHColors.trustBlue) {}
                settingsRow(icon: "puzzlepiece.extension", title: "Integrations", color: EHColors.progressGreen) {}
            }

            // Privacy & Security
            Section("Privacy & Security") {
                settingsRow(icon: "faceid", title: "Biometric authentication", color: EHColors.trustBlue) {}
                settingsRow(icon: "hand.raised", title: "Data & privacy", color: EHColors.Text.muted) {}
                settingsRow(icon: "arrow.down.to.line", title: "Export my data", color: EHColors.Text.muted) {}
            }

            // Support
            Section("Support") {
                settingsRow(icon: "questionmark.circle", title: "Help & support", color: EHColors.Text.muted) {}
                settingsRow(icon: "envelope", title: "Send feedback", color: EHColors.Text.muted) {}
                HStack {
                    Text("Version")
                        .font(EHTypography.bodySm)
                        .foregroundStyle(EHColors.Text.muted)
                    Spacer()
                    Text("0.1.0 (debug)")
                        .font(EHTypography.bodySm)
                        .foregroundStyle(EHColors.Text.subtle)
                }
            }

            // Sign Out
            Section {
                Button("Sign out", role: .destructive) {
                    showSignOutAlert = true
                }
                .font(EHTypography.bodySm)
            }
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $showAutonomy) {
            AutonomySettingsView()
        }
        .alert("Sign out?", isPresented: $showSignOutAlert) {
            Button("Sign out", role: .destructive) {
                appState.signOut()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You'll need to sign in again to access your account.")
        }
    }

    private func settingsRow(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: EHSpacing.sm) {
                RoundedRectangle(cornerRadius: 7)
                    .fill(color)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white)
                    )
                Text(title)
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(EHColors.Text.subtle)
            }
        }
    }
}
