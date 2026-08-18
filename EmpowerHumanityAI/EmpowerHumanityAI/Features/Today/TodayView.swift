import SwiftUI

struct TodayView: View {
    @Environment(AppState.self) private var appState
    @State private var vm: TodayViewModel? = nil
    @State private var showAIWorkDetail: AIWorkItem? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: EHSpacing.sectionSpacing, pinnedViews: []) {
                if let vm {
                    if vm.isLoading && vm.brief == nil {
                        EHLoadingView(message: "Preparing your day...")
                            .frame(height: 300)
                    } else if let brief = vm.brief {
                        todayContent(brief: brief)
                    }
                }
            }
            .padding(.horizontal, EHSpacing.screenHorizontal)
            .padding(.vertical, EHSpacing.xl)
        }
        .background(EHColors.page)
        .navigationTitle("Today")
        .refreshable {
            await vm?.refresh()
        }
        .sheet(item: $showAIWorkDetail) { item in
            AIWorkDetailView(workItem: item)
        }
        .task {
            guard let userId = appState.currentUser?.id else { return }
            let viewModel = TodayViewModel(userId: userId)
            vm = viewModel
            await viewModel.load()
        }
    }

    // MARK: - Content

    @ViewBuilder
    private func todayContent(brief: TodayBrief) -> some View {
        // Hero greeting + intelligence summary
        heroCard(brief: brief)

        // Needs your attention
        if !brief.needsAttention.isEmpty {
            needsAttentionSection(items: brief.needsAttention)
        }

        // Today's priorities
        if !brief.priorities.isEmpty {
            prioritiesSection(tasks: brief.priorities)
        }

        // Active AI Work
        if !brief.activeWork.isEmpty {
            activeWorkSection(items: brief.activeWork)
        }

        // Upcoming
        if !brief.upcoming.isEmpty {
            upcomingSection(items: brief.upcoming)
        }

        // Recommendations
        if !brief.recommendations.isEmpty {
            recommendationsSection(items: brief.recommendations)
        }

        // Recent Outcomes
        if !brief.recentOutcomes.isEmpty {
            recentOutcomesSection(events: brief.recentOutcomes)
        }
    }

    // MARK: - Hero Card

    private func heroCard(brief: TodayBrief) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.md) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: EHSpacing.xs) {
                    Text(brief.greeting)
                        .font(EHTypography.h2)
                        .foregroundStyle(EHColors.Text.primary)
                    Text(brief.intelligenceSummary)
                        .font(EHTypography.bodyMd)
                        .foregroundStyle(EHColors.Text.secondary)
                        .lineSpacing(2)
                }
                Spacer()
                CoIntelligenceOrb(state: appState.orbState, size: 48)
            }
        }
        .padding(EHSpacing.cardPaddingLg)
        .background(EHColors.white)
        .clipShape(RoundedRectangle(cornerRadius: EHRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: EHRadius.xl)
                .strokeBorder(EHColors.cognitionPurple.opacity(0.12), lineWidth: 1)
        )
        .ehShadow(EHShadow.card)
    }

    // MARK: - Needs Attention

    private func needsAttentionSection(items: [NeedsAttentionItem]) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            EHSectionHeader(title: "Needs your attention")
            ForEach(items) { item in
                attentionCard(item: item)
            }
        }
    }

    private func attentionCard(item: NeedsAttentionItem) -> some View {
        HStack(alignment: .top, spacing: EHSpacing.sm) {
            EHIconContainer(
                systemName: item.type == "approval" ? "shield.fill" : "exclamationmark.circle.fill",
                color: item.urgency == "high" ? EHColors.amber : EHColors.intelligenceIndigo,
                size: 36
            )
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                Text(item.description)
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.muted)
            }
            Spacer()
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }

    // MARK: - Priorities

    private func prioritiesSection(tasks: [EHTask]) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            EHSectionHeader(title: "Today's priorities")
            ForEach(tasks.prefix(3)) { task in
                taskRow(task: task)
            }
        }
    }

    private func taskRow(task: EHTask) -> some View {
        HStack(spacing: EHSpacing.sm) {
            Image(systemName: task.status == .completed ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.status == .completed ? EHColors.progressGreen : EHColors.border)
                .font(.system(size: 20))
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.primary)
                    .strikethrough(task.status == .completed)
                if let due = task.dueDate {
                    Text(due.dayLabel)
                        .font(EHTypography.caption)
                        .foregroundStyle(EHColors.Text.subtle)
                }
            }
            Spacer()
            EHStatusBadge(label: task.priority.displayName, color: task.priority == .high ? EHColors.orange : EHColors.Text.muted)
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }

    // MARK: - Active AI Work

    private func activeWorkSection(items: [AIWorkItem]) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            EHSectionHeader(title: "Active AI work")
            ForEach(items) { item in
                Button { showAIWorkDetail = item } label: {
                    activeWorkCard(item: item)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func activeWorkCard(item: AIWorkItem) -> some View {
        HStack(spacing: EHSpacing.sm) {
            EHIconContainer(systemName: "bolt.fill", color: EHColors.statusColor(for: item.status), size: 36)
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                if let device = item.deviceName {
                    Text(device)
                        .font(EHTypography.caption)
                        .foregroundStyle(EHColors.Text.muted)
                }
                EHStatusBadge(label: item.status.displayName, color: EHColors.statusColor(for: item.status))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(EHColors.Text.subtle)
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }

    // MARK: - Upcoming

    private func upcomingSection(items: [UpcomingItem]) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            EHSectionHeader(title: "Upcoming")
            ForEach(items) { item in
                HStack(spacing: EHSpacing.sm) {
                    EHIconContainer(systemName: "calendar", color: EHColors.trustBlue, size: 36)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(EHTypography.bodySm)
                            .foregroundStyle(EHColors.Text.primary)
                        Text(item.scheduledAt.timeString)
                            .font(EHTypography.caption)
                            .foregroundStyle(EHColors.Text.muted)
                    }
                    Spacer()
                }
                .padding(EHSpacing.cardPadding)
                .ehCard(level: 1)
            }
        }
    }

    // MARK: - Recommendations

    private func recommendationsSection(items: [Recommendation]) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            EHSectionHeader(title: "Recommendations")
            ForEach(items) { item in
                HStack(alignment: .top, spacing: EHSpacing.sm) {
                    EHIconContainer(systemName: "lightbulb.fill", color: EHColors.cognitionPurple, size: 36)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(EHTypography.bodySmMedium)
                            .foregroundStyle(EHColors.Text.primary)
                        Text(item.rationale)
                            .font(EHTypography.bodySm)
                            .foregroundStyle(EHColors.Text.muted)
                    }
                    Spacer()
                }
                .padding(EHSpacing.cardPadding)
                .ehCard(level: 2)
            }
        }
    }

    // MARK: - Recent Outcomes

    private func recentOutcomesSection(events: [ActivityEvent]) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            EHSectionHeader(title: "Recent outcomes")
            ForEach(events.prefix(3)) { event in
                HStack(spacing: EHSpacing.sm) {
                    Image(systemName: event.eventType.icon)
                        .foregroundStyle(EHColors.progressGreen)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.title)
                            .font(EHTypography.bodySm)
                            .foregroundStyle(EHColors.Text.primary)
                        Text(event.occurredAt.relativeString)
                            .font(EHTypography.caption)
                            .foregroundStyle(EHColors.Text.subtle)
                    }
                    Spacer()
                }
                .padding(EHSpacing.cardPadding)
                .ehCard(level: 1)
            }
        }
    }
}
