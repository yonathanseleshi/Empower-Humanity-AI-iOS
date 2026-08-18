import SwiftUI

struct ApprovalsView: View {
    @Environment(AppState.self) private var appState
    @State private var vm: ApprovalsViewModel? = nil
    @State private var selectedApproval: ApprovalRequest? = nil

    var body: some View {
        ScrollView {
            if let vm {
                LazyVStack(spacing: EHSpacing.sm) {
                    if vm.isLoading {
                        EHLoadingView().frame(height: 300)
                    } else if vm.approvals.isEmpty {
                        EHEmptyState(
                            systemImage: "shield.checkered",
                            title: "No pending approvals",
                            message: "When Alex needs your authorisation to act, the request will appear here with full context.",
                            actionTitle: nil, action: nil
                        )
                    } else {
                        ForEach(vm.approvals) { approval in
                            Button { selectedApproval = approval } label: {
                                approvalCard(approval, vm: vm)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.md)
            }
        }
        .background(EHColors.page)
        .navigationTitle("Approvals")
        .badge(vm?.pendingCount ?? 0)
        .sheet(item: $selectedApproval) { approval in
            if let vm { ApprovalDetailView(approval: approval, vm: vm) }
        }
        .task {
            guard let userId = appState.currentUser?.id else { return }
            let viewModel = ApprovalsViewModel(userId: userId)
            vm = viewModel
            await viewModel.load()
        }
    }

    private func approvalCard(_ approval: ApprovalRequest, vm: ApprovalsViewModel) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.md) {
            HStack(alignment: .top) {
                EHIconContainer(systemName: "shield.fill", color: EHColors.amber, size: 40)
                VStack(alignment: .leading, spacing: 4) {
                    Text(approval.title)
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.Text.primary)
                    Text(approval.whatDescription)
                        .font(EHTypography.bodySm)
                        .foregroundStyle(EHColors.Text.secondary)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack(spacing: EHSpacing.xs) {
                EHStatusBadge(label: approval.riskLevel.displayName + " risk", color: riskColor(approval.riskLevel))
                EHStatusBadge(label: approval.whereDescription, color: EHColors.trustBlue)
            }
            HStack(spacing: EHSpacing.xs) {
                Button("Approve") {
                    Task { await vm.resolve(approval: approval, status: .approved) }
                }
                .font(EHTypography.buttonLabel)
                .foregroundStyle(.white)
                .padding(.horizontal, EHSpacing.lg)
                .padding(.vertical, EHSpacing.xs)
                .background(EHColors.progressGreen)
                .clipShape(Capsule())

                Button("Deny") {
                    Task { await vm.resolve(approval: approval, status: .denied) }
                }
                .font(EHTypography.buttonLabel)
                .foregroundStyle(EHColors.red)
                .padding(.horizontal, EHSpacing.lg)
                .padding(.vertical, EHSpacing.xs)
                .background(EHColors.red.opacity(0.1))
                .clipShape(Capsule())

                Spacer()
            }
        }
        .padding(EHSpacing.cardPaddingLg)
        .background(EHColors.amber.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: EHRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: EHRadius.xl)
                .strokeBorder(EHColors.amber.opacity(0.3), lineWidth: 1.5)
        )
        .ehShadow(EHShadow.card)
    }

    private func riskColor(_ level: RiskLevel) -> Color {
        switch level {
        case .low: return EHColors.progressGreen
        case .medium: return EHColors.amber
        case .high: return EHColors.red
        }
    }
}

// MARK: - ApprovalDetailView

struct ApprovalDetailView: View {
    let approval: ApprovalRequest
    let vm: ApprovalsViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: EHSpacing.sectionSpacing) {
                    // Header
                    VStack(alignment: .leading, spacing: EHSpacing.sm) {
                        HStack(spacing: EHSpacing.sm) {
                            EHStatusBadge(label: approval.riskLevel.displayName + " risk", color: riskColor(approval.riskLevel))
                            EHStatusBadge(label: approval.status.displayName, color: EHColors.amber)
                        }
                        Text(approval.title)
                            .font(EHTypography.h2)
                            .foregroundStyle(EHColors.Text.primary)
                    }

                    // What / Why / Where
                    detailSection(icon: "questionmark.circle", color: EHColors.intelligenceIndigo, title: "What", body: approval.whatDescription)
                    detailSection(icon: "lightbulb.fill", color: EHColors.cognitionPurple, title: "Why", body: approval.whyDescription)
                    detailSection(icon: "location.fill", color: EHColors.trustBlue, title: "Where", body: approval.whereDescription)
                    detailSection(icon: "doc.text", color: EHColors.Text.muted, title: "Resource", body: approval.resource)
                    detailSection(icon: "scope", color: EHColors.Text.muted, title: "Scope", body: approval.scope)
                    detailSection(icon: "exclamationmark.shield", color: riskColor(approval.riskLevel), title: "Risk", body: approval.riskDescription)

                    // Actions
                    VStack(spacing: EHSpacing.sm) {
                        EHPrimaryButton("Approve") {
                            Task {
                                await vm.resolve(approval: approval, status: .approved)
                                dismiss()
                            }
                        }
                        EHSecondaryButton(title: "Deny") {
                            Task {
                                await vm.resolve(approval: approval, status: .denied)
                                dismiss()
                            }
                        }
                        Button("Ask Alex for more context") {}
                            .font(EHTypography.bodySm)
                            .foregroundStyle(EHColors.trustBlue)
                    }
                    .padding(.top, EHSpacing.sm)
                }
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.md)
            }
            .background(EHColors.page)
            .navigationTitle("Approval Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func detailSection(icon: String, color: Color, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: EHSpacing.sm) {
            EHIconContainer(systemName: icon, color: color, size: 32)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(EHTypography.label)
                    .foregroundStyle(EHColors.Text.muted)
                Text(body)
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.secondary)
            }
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }

    private func riskColor(_ level: RiskLevel) -> Color {
        switch level {
        case .low: return EHColors.progressGreen
        case .medium: return EHColors.amber
        case .high: return EHColors.red
        }
    }
}
