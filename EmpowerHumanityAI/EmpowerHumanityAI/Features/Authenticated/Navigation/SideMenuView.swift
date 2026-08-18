import SwiftUI

// MARK: - SideMenuView
// Slide-in drawer for compact (iPhone) layouts.
// NavigationSplitView sidebar for regular (iPad) layouts.
// Drawer header: orb + Alex info + user name.

struct SideMenuView: View {
    @Environment(AppState.self) private var appState
    @Binding var selectedDestination: NavDestination
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: Header
            drawerHeader
                .padding(.horizontal, EHSpacing.lg)
                .padding(.top, EHSpacing.xxxl)
                .padding(.bottom, EHSpacing.xl)

            EHDivider()
                .padding(.horizontal, EHSpacing.md)

            // MARK: Navigation
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    navGroup("Primary", items: NavDestination.primaryGroup)
                    navGroup("More", items: NavDestination.additionalGroup)
                    navGroup("System", items: NavDestination.systemGroup)
                }
                .padding(.vertical, EHSpacing.sm)
            }

            Spacer()
        }
        .frame(width: 280)
        .background(EHColors.white)
    }

    // MARK: - Header

    private var drawerHeader: some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            // Orb
            CoIntelligenceOrb(state: appState.orbState, size: 56)

            VStack(alignment: .leading, spacing: 2) {
                Text(appState.coIntelligence?.displayName ?? "Alex")
                    .font(EHTypography.h4)
                    .foregroundStyle(EHColors.Text.primary)

                Text("Your co-intelligence")
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.muted)

                HStack(spacing: 4) {
                    Circle()
                        .fill(statusColor(for: appState.orbState))
                        .frame(width: 6, height: 6)
                    Text(orbStatusLabel(for: appState.orbState))
                        .font(EHTypography.caption)
                        .foregroundStyle(EHColors.Text.muted)
                }
                .padding(.top, 2)
            }

            EHDivider()
                .padding(.vertical, EHSpacing.xs)

            // User
            HStack(spacing: EHSpacing.xs) {
                Circle()
                    .fill(EHColors.intelligenceIndigo.opacity(0.15))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Text(appState.currentUser?.profile.displayName.initials ?? "B")
                            .font(EHTypography.micro)
                            .foregroundStyle(EHColors.intelligenceIndigo)
                    )
                Text(appState.currentUser?.profile.preferredName ?? "Ben")
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.secondary)
            }
        }
    }

    // MARK: - Nav Group

    private func navGroup(_ title: String, items: [NavDestination]) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.uppercased())
                .font(EHTypography.micro)
                .foregroundStyle(EHColors.Text.subtle)
                .padding(.horizontal, EHSpacing.lg)
                .padding(.top, EHSpacing.md)
                .padding(.bottom, EHSpacing.xxs)

            ForEach(items) { destination in
                navItem(destination)
            }
        }
    }

    private func navItem(_ destination: NavDestination) -> some View {
        let isSelected = selectedDestination == destination
        return Button {
            HapticService.shared.selection()
            selectedDestination = destination
            withAnimation(.easeInOut(duration: 0.25)) {
                isPresented = false
            }
        } label: {
            HStack(spacing: EHSpacing.sm) {
                Image(systemName: destination.icon)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? EHColors.trustBlue : EHColors.Text.secondary)
                    .frame(width: 20)

                Text(destination.title)
                    .font(isSelected ? EHTypography.bodySmMedium : EHTypography.bodySm)
                    .foregroundStyle(isSelected ? EHColors.trustBlue : EHColors.Text.secondary)

                Spacer()
            }
            .padding(.vertical, EHSpacing.xs)
            .padding(.horizontal, EHSpacing.md)
            .background(
                isSelected
                    ? EHColors.trustBlue.opacity(0.08)
                    : Color.clear,
                in: RoundedRectangle(cornerRadius: EHRadius.sm)
            )
            .padding(.horizontal, EHSpacing.sm)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    private func statusColor(for state: OrbState) -> Color {
        switch state {
        case .available: return EHColors.progressGreen
        case .listening, .thinking, .acting: return EHColors.intelligenceCyan
        case .waiting: return EHColors.amber
        case .completed: return EHColors.progressGreen
        case .attention: return EHColors.amber
        case .error: return EHColors.red
        }
    }

    private func orbStatusLabel(for state: OrbState) -> String {
        switch state {
        case .available: return "Available"
        case .listening: return "Listening"
        case .thinking: return "Thinking"
        case .acting: return "Working"
        case .waiting: return "Waiting for you"
        case .completed: return "Done"
        case .attention: return "Needs attention"
        case .error: return "Error"
        }
    }
}
