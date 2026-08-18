import SwiftUI

struct AutonomySettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var pref: AutonomyPreference? = nil
    @State private var selectedLevel: AutonomyLevel = .actWithApproval
    @State private var isPaused: Bool = false
    @State private var isLoading = false
    @State private var showPauseConfirm = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: EHSpacing.sectionSpacing) {
                    // Pause / resume
                    pauseCard

                    // Level selector
                    VStack(alignment: .leading, spacing: EHSpacing.md) {
                        EHSectionHeader(title: "Autonomy level")
                        ForEach(AutonomyLevel.allCases, id: \.self) { level in
                            levelCard(level)
                        }
                    }

                    // Education
                    VStack(alignment: .leading, spacing: EHSpacing.sm) {
                        EHSectionHeader(title: "What this means")
                        HStack(alignment: .top, spacing: EHSpacing.sm) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(EHColors.trustBlue)
                            Text("Autonomy settings control how much Alex can do without explicitly asking you. You can change this at any time, and you can always review and stop any active work from the AI Work screen.")
                                .font(EHTypography.bodySm)
                                .foregroundStyle(EHColors.Text.secondary)
                        }
                        .padding(EHSpacing.cardPadding)
                        .ehCard(level: 1)
                    }
                }
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.md)
            }
            .background(EHColors.page)
            .navigationTitle("Autonomy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { Task { await save() } }
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.trustBlue)
                }
            }
        }
        .task {
            guard let userId = appState.currentUser?.id else { return }
            isLoading = true
            pref = try? await MockSettingsRepository().getAutonomyPreference(userId: userId)
            selectedLevel = pref?.level ?? .actWithApproval
            isPaused = pref?.isPaused ?? false
            isLoading = false
        }
    }

    // MARK: - Pause Card

    private var pauseCard: some View {
        HStack(spacing: EHSpacing.md) {
            EHIconContainer(
                systemName: isPaused ? "pause.circle.fill" : "bolt.fill",
                color: isPaused ? EHColors.amber : EHColors.progressGreen,
                size: 44
            )
            VStack(alignment: .leading, spacing: 4) {
                Text(isPaused ? "Alex is paused" : "Alex is active")
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                Text(isPaused ? "Alex will not take new actions until you resume." : "Alex can take actions within your autonomy level.")
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.muted)
                    .lineLimit(2)
            }
            Spacer()
            Toggle("", isOn: Binding(
                get: { !isPaused },
                set: { isPaused = !$0 }
            ))
            .labelsHidden()
            .tint(EHColors.progressGreen)
        }
        .padding(EHSpacing.cardPaddingLg)
        .ehCard(level: isPaused ? 1 : 2)
        .overlay(
            isPaused ?
            RoundedRectangle(cornerRadius: EHRadius.lg)
                .strokeBorder(EHColors.amber.opacity(0.3), lineWidth: 1) : nil
        )
    }

    // MARK: - Level Card

    private func levelCard(_ level: AutonomyLevel) -> some View {
        let isSelected = selectedLevel == level
        return Button { selectedLevel = level } label: {
            HStack(alignment: .top, spacing: EHSpacing.sm) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundStyle(isSelected ? EHColors.trustBlue : EHColors.border)
                    .font(.system(size: 20))
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.displayName)
                        .font(isSelected ? EHTypography.bodySmMedium : EHTypography.bodySm)
                        .foregroundStyle(EHColors.Text.primary)
                    Text(level.description)
                        .font(EHTypography.caption)
                        .foregroundStyle(EHColors.Text.muted)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .padding(EHSpacing.cardPadding)
            .background(isSelected ? EHColors.trustBlue.opacity(0.06) : EHColors.white)
            .clipShape(RoundedRectangle(cornerRadius: EHRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: EHRadius.md)
                    .strokeBorder(isSelected ? EHColors.trustBlue.opacity(0.4) : EHColors.border, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func save() async {
        guard let userId = appState.currentUser?.id, var pref = pref else { return }
        pref = AutonomyPreference(id: pref.id, userId: userId, level: selectedLevel, isPaused: isPaused, approvalRequiredFor: pref.approvalRequiredFor, updatedAt: Date())
        _ = try? await MockSettingsRepository().updateAutonomyPreference(pref)
        dismiss()
    }
}
