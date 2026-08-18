import SwiftUI

struct GoalsView: View {
    @Environment(AppState.self) private var appState
    @State private var goals: [Goal] = []
    @State private var isLoading = false
    @State private var selectedGoal: Goal? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: EHSpacing.sm) {
                if isLoading {
                    EHLoadingView()
                        .frame(height: 300)
                } else if goals.isEmpty {
                    EHEmptyState(
                        systemImage: "target",
                        title: "No goals yet",
                        message: "Goals give Alex context and direction. Start by describing something you want to achieve.",
                        actionTitle: "Create a goal",
                        action: {}
                    )
                } else {
                    ForEach(goals) { goal in
                        Button { selectedGoal = goal } label: {
                            goalCard(goal)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, EHSpacing.screenHorizontal)
            .padding(.vertical, EHSpacing.md)
        }
        .background(EHColors.page)
        .navigationTitle("Goals")
        .sheet(item: $selectedGoal) { goal in
            GoalDetailView(goal: goal)
        }
        .task {
            guard let userId = appState.currentUser?.id else { return }
            isLoading = true
            goals = (try? await MockGoalsRepository().getGoals(userId: userId)) ?? []
            isLoading = false
        }
    }

    private func goalCard(_ goal: Goal) -> some View {
        VStack(alignment: .leading, spacing: EHSpacing.md) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.Text.primary)
                    if let horizon = goal.horizon {
                        Text(horizon)
                            .font(EHTypography.caption)
                            .foregroundStyle(EHColors.Text.muted)
                    }
                }
                Spacer()
                EHStatusBadge(label: goal.status.displayName, color: EHColors.cognitionPurple)
            }

            // Progress bar
            VStack(alignment: .leading, spacing: 4) {
                ProgressView(value: goal.progress)
                    .tint(EHColors.progressGreen)
                HStack {
                    Text("\(Int(goal.progress * 100))% complete")
                        .font(EHTypography.caption)
                        .foregroundStyle(EHColors.Text.muted)
                    Spacer()
                    if let score = goal.healthScore {
                        Text("Health: \(Int(score * 100))%")
                            .font(EHTypography.caption)
                            .foregroundStyle(EHColors.progressGreen)
                    }
                }
            }

            // AI insight
            if let insight = goal.aiInsight {
                HStack(alignment: .top, spacing: EHSpacing.xs) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(EHColors.cognitionPurple)
                    Text(insight)
                        .font(EHTypography.caption)
                        .foregroundStyle(EHColors.Text.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(EHSpacing.cardPaddingLg)
        .ehCard(level: 2)
    }
}

// MARK: - GoalDetailView

struct GoalDetailView: View {
    let goal: Goal
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: EHSpacing.sectionSpacing) {
                    // Header
                    VStack(alignment: .leading, spacing: EHSpacing.sm) {
                        EHStatusBadge(label: goal.status.displayName, color: EHColors.cognitionPurple)
                        Text(goal.title)
                            .font(EHTypography.h2)
                            .foregroundStyle(EHColors.Text.primary)
                        if let desc = goal.description {
                            Text(desc)
                                .font(EHTypography.bodyMd)
                                .foregroundStyle(EHColors.Text.secondary)
                        }
                    }

                    // Progress
                    VStack(alignment: .leading, spacing: EHSpacing.sm) {
                        EHSectionHeader(title: "Progress")
                        ProgressView(value: goal.progress)
                            .tint(EHColors.progressGreen)
                            .scaleEffect(y: 1.5)
                        Text("\(Int(goal.progress * 100))% complete")
                            .font(EHTypography.bodySm)
                            .foregroundStyle(EHColors.Text.muted)
                    }
                    .padding(EHSpacing.cardPadding)
                    .ehCard(level: 1)

                    // Milestones
                    if !goal.milestones.isEmpty {
                        VStack(alignment: .leading, spacing: EHSpacing.sm) {
                            EHSectionHeader(title: "Milestones")
                            ForEach(goal.milestones) { milestone in
                                HStack(spacing: EHSpacing.sm) {
                                    Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(milestone.isCompleted ? EHColors.progressGreen : EHColors.border)
                                    Text(milestone.title)
                                        .font(EHTypography.bodySm)
                                        .foregroundStyle(EHColors.Text.primary)
                                        .strikethrough(milestone.isCompleted)
                                    Spacer()
                                }
                            }
                        }
                        .padding(EHSpacing.cardPadding)
                        .ehCard(level: 1)
                    }

                    // AI Insight
                    if let insight = goal.aiInsight {
                        VStack(alignment: .leading, spacing: EHSpacing.sm) {
                            EHSectionHeader(title: "Alex's insight")
                            HStack(alignment: .top, spacing: EHSpacing.sm) {
                                CoIntelligenceOrb.small(state: .available)
                                Text(insight)
                                    .font(EHTypography.bodySm)
                                    .foregroundStyle(EHColors.Text.secondary)
                            }
                        }
                        .padding(EHSpacing.cardPadding)
                        .ehCard(level: 2)
                    }
                }
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.md)
            }
            .background(EHColors.page)
            .navigationTitle("Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
