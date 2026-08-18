import SwiftUI

struct IntegrationsView: View {
    @Environment(AppState.self) private var appState
    @State private var integrations: [Integration] = []
    @State private var isLoading = false
    @State private var repo = MockIntegrationRepository()

    private let categories: [IntegrationCategory] = IntegrationCategory.allCases

    var body: some View {
        ScrollView {
            LazyVStack(spacing: EHSpacing.sectionSpacing) {
                if isLoading {
                    EHLoadingView().frame(height: 300)
                } else {
                    ForEach(categories, id: \.self) { category in
                        let items = integrations.filter { $0.category == category }
                        if !items.isEmpty {
                            categorySection(category: category, items: items)
                        }
                    }
                }
            }
            .padding(.horizontal, EHSpacing.screenHorizontal)
            .padding(.vertical, EHSpacing.md)
        }
        .background(EHColors.page)
        .navigationTitle("Integrations")
        .task {
            guard let userId = appState.currentUser?.id else { return }
            isLoading = true
            integrations = (try? await MockIntegrationRepository().getIntegrations(userId: userId)) ?? []
            isLoading = false
        }
    }

    private func categorySection(category: IntegrationCategory, items: [Integration]) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            EHSectionHeader(title: category.displayName)
            ForEach(items) { integration in
                integrationRow(integration)
            }
        }
    }

    private func integrationRow(_ integration: Integration) -> some View {
        HStack(spacing: EHSpacing.sm) {
            EHIconContainer(systemName: integration.iconName, color: EHColors.intelligenceIndigo, size: 40)
            VStack(alignment: .leading, spacing: 3) {
                Text(integration.name)
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                Text(integration.description)
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.muted)
                    .lineLimit(1)
            }
            Spacer()
            integrationStatusView(integration)
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }

    @ViewBuilder
    private func integrationStatusView(_ integration: Integration) -> some View {
        switch integration.status {
        case .connected:
            EHStatusBadge(label: "Connected", color: EHColors.progressGreen)
        case .disconnected:
            Button("Connect") {
                Task { await connect(integration) }
            }
            .font(EHTypography.buttonLabel)
            .foregroundStyle(EHColors.trustBlue)
        case .needsAttention:
            EHStatusBadge(label: "Action needed", color: EHColors.amber)
        }
    }

    private func connect(_ integration: Integration) async {
        let updated = try? await repo.connectIntegration(id: integration.id)
        if let updated, let idx = integrations.firstIndex(where: { $0.id == updated.id }) {
            integrations[idx] = updated
        }
    }
}
