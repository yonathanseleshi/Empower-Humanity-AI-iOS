import SwiftUI

struct AIWorkView: View {
    @Environment(AppState.self) private var appState
    @State private var vm: AIWorkViewModel? = nil
    @State private var selectedItem: AIWorkItem? = nil

    var body: some View {
        ScrollView {
            if let vm {
                LazyVStack(spacing: EHSpacing.sectionSpacing) {
                    if vm.isLoading {
                        EHLoadingView().frame(height: 300)
                    } else {
                        if !vm.activeItems.isEmpty {
                            workSection(title: "Active", items: vm.activeItems)
                        }
                        if !vm.queuedItems.isEmpty {
                            workSection(title: "Queued", items: vm.queuedItems)
                        }
                        if !vm.completedItems.isEmpty {
                            workSection(title: "Recent", items: vm.completedItems)
                        }
                        if vm.workItems.isEmpty {
                            EHEmptyState(
                                systemImage: "bolt.fill",
                                title: "No AI work yet",
                                message: "When Alex takes action on your behalf, the work will appear here with full transparency.",
                                actionTitle: nil, action: nil
                            )
                        }
                    }
                }
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.md)
            }
        }
        .background(EHColors.page)
        .navigationTitle("AI Work")
        .sheet(item: $selectedItem) { item in
            AIWorkDetailView(workItem: item)
        }
        .task {
            guard let userId = appState.currentUser?.id else { return }
            let viewModel = AIWorkViewModel(userId: userId)
            vm = viewModel
            await viewModel.load()
        }
    }

    private func workSection(title: String, items: [AIWorkItem]) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            EHSectionHeader(title: title)
            ForEach(items) { item in
                Button { selectedItem = item } label: {
                    workCard(item)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func workCard(_ item: AIWorkItem) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.Text.primary)
                    if let device = item.deviceName {
                        HStack(spacing: 4) {
                            Image(systemName: "laptopcomputer")
                                .font(.caption)
                                .foregroundStyle(EHColors.Text.subtle)
                            Text(device)
                                .font(EHTypography.caption)
                                .foregroundStyle(EHColors.Text.muted)
                        }
                    }
                }
                Spacer()
                EHStatusBadge(label: item.status.displayName, color: EHColors.statusColor(for: item.status))
            }
            if let step = item.currentStep {
                Text(step)
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.secondary)
                    .lineLimit(2)
            }
            Text(item.createdAt.relativeString)
                .font(EHTypography.caption)
                .foregroundStyle(EHColors.Text.subtle)
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: item.status == .waitingForApproval ? 2 : 1)
        .overlay(
            item.status == .waitingForApproval ?
            RoundedRectangle(cornerRadius: EHRadius.lg)
                .strokeBorder(EHColors.amber.opacity(0.4), lineWidth: 1.5) : nil
        )
    }
}

// MARK: - AIWorkDetailView

struct AIWorkDetailView: View {
    let workItem: AIWorkItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: EHSpacing.sectionSpacing) {
                    // Status header
                    VStack(alignment: .leading, spacing: EHSpacing.sm) {
                        EHStatusBadge(label: workItem.status.displayName, color: EHColors.statusColor(for: workItem.status))
                        Text(workItem.title)
                            .font(EHTypography.h2)
                            .foregroundStyle(EHColors.Text.primary)
                        Text(workItem.objective)
                            .font(EHTypography.bodyMd)
                            .foregroundStyle(EHColors.Text.secondary)
                    }

                    // Current step
                    if let step = workItem.currentStep {
                        VStack(alignment: .leading, spacing: EHSpacing.sm) {
                            EHSectionHeader(title: "Current step")
                            HStack(spacing: EHSpacing.sm) {
                                if workItem.status == .working {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .tint(EHColors.intelligenceCyan)
                                }
                                Text(step)
                                    .font(EHTypography.bodySm)
                                    .foregroundStyle(EHColors.Text.secondary)
                            }
                        }
                        .padding(EHSpacing.cardPadding)
                        .ehCard(level: 1)
                    }

                    // Device
                    if let device = workItem.deviceName {
                        VStack(alignment: .leading, spacing: EHSpacing.sm) {
                            EHSectionHeader(title: "Running on")
                            HStack(spacing: EHSpacing.sm) {
                                EHIconContainer(systemName: "laptopcomputer", color: EHColors.trustBlue, size: 36)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(device)
                                        .font(EHTypography.bodySmMedium)
                                        .foregroundStyle(EHColors.Text.primary)
                                    Text("Dedicated AI compute")
                                        .font(EHTypography.caption)
                                        .foregroundStyle(EHColors.Text.muted)
                                }
                            }
                        }
                        .padding(EHSpacing.cardPadding)
                        .ehCard(level: 1)
                    }

                    // Result
                    if let result = workItem.result {
                        VStack(alignment: .leading, spacing: EHSpacing.sm) {
                            EHSectionHeader(title: "Result")
                            Text(result)
                                .font(EHTypography.bodySm)
                                .foregroundStyle(EHColors.Text.secondary)
                        }
                        .padding(EHSpacing.cardPadding)
                        .ehCard(level: 1)
                    }

                    // Artifacts
                    if !workItem.artifacts.isEmpty {
                        VStack(alignment: .leading, spacing: EHSpacing.sm) {
                            EHSectionHeader(title: "Artifacts")
                            ForEach(workItem.artifacts) { artifact in
                                HStack(spacing: EHSpacing.sm) {
                                    EHIconContainer(systemName: "doc.fill", color: EHColors.intelligenceIndigo, size: 32)
                                    Text(artifact.name)
                                        .font(EHTypography.bodySm)
                                        .foregroundStyle(EHColors.Text.primary)
                                    Spacer()
                                }
                            }
                        }
                        .padding(EHSpacing.cardPadding)
                        .ehCard(level: 1)
                    }

                    // Timestamps
                    VStack(alignment: .leading, spacing: EHSpacing.sm) {
                        EHSectionHeader(title: "Timeline")
                        timelineRow("Started", date: workItem.startedAt)
                        if let completed = workItem.completedAt {
                            timelineRow("Completed", date: completed)
                        }
                    }
                    .padding(EHSpacing.cardPadding)
                    .ehCard(level: 1)
                }
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.md)
            }
            .background(EHColors.page)
            .navigationTitle("AI Work")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func timelineRow(_ label: String, date: Date?) -> some View {
        HStack {
            Text(label)
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.Text.muted)
            Spacer()
            Text(date?.relativeString ?? "—")
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.Text.secondary)
        }
    }
}
