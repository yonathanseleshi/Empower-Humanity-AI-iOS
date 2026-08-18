import SwiftUI

// MARK: - Response Cards
// Rich AI response cards embedded in chat messages.
// Card anatomy: context marker → title → summary → state → optional explanation → actions.
// Color lives in icon containers and status badges — never a saturated card background.

// MARK: - ApprovalResponseCard

struct ApprovalResponseCard: View {
    let approval: ApprovalRequest
    @State private var isResolved = false

    var body: some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            HStack(spacing: EHSpacing.sm) {
                EHIconContainer(systemName: "shield.checkered", color: EHColors.amber, size: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Approval required")
                        .font(EHTypography.label)
                        .foregroundStyle(EHColors.Text.muted)
                    Text(approval.title)
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.Text.primary)
                }
            }
            Text(approval.whatDescription)
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.Text.secondary)
            HStack(spacing: EHSpacing.xs) {
                EHStatusBadge(label: approval.riskLevel.displayName + " risk", color: riskColor(approval.riskLevel))
                EHStatusBadge(label: approval.whereDescription, color: EHColors.trustBlue)
            }
            if !isResolved {
                HStack(spacing: EHSpacing.xs) {
                    Button("Approve") { isResolved = true }
                        .font(EHTypography.buttonLabel)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(EHColors.progressGreen)
                        .clipShape(Capsule())
                    Button("Deny") { isResolved = true }
                        .font(EHTypography.buttonLabel)
                        .foregroundStyle(EHColors.red)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(EHColors.red.opacity(0.1))
                        .clipShape(Capsule())
                }
            } else {
                EHStatusBadge(label: "Responded", color: EHColors.progressGreen)
            }
        }
        .padding(EHSpacing.cardPadding)
        .background(EHColors.amber.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: EHRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: EHRadius.lg)
                .strokeBorder(EHColors.amber.opacity(0.25), lineWidth: 1)
        )
    }

    private func riskColor(_ level: RiskLevel) -> Color {
        switch level {
        case .low: return EHColors.progressGreen
        case .medium: return EHColors.amber
        case .high: return EHColors.red
        }
    }
}

// MARK: - AIWorkResponseCard

struct AIWorkResponseCard: View {
    let work: AIWorkItem

    var body: some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            HStack(spacing: EHSpacing.sm) {
                EHIconContainer(systemName: "bolt.fill", color: EHColors.statusColor(for: work.status), size: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text("AI Work")
                        .font(EHTypography.label)
                        .foregroundStyle(EHColors.Text.muted)
                    Text(work.title)
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.Text.primary)
                }
            }
            if let step = work.currentStep {
                Text(step)
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.secondary)
            }
            HStack(spacing: EHSpacing.xs) {
                EHStatusBadge(label: work.status.displayName, color: EHColors.statusColor(for: work.status))
                if let device = work.deviceName {
                    EHStatusBadge(label: device, color: EHColors.Text.muted)
                }
            }
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }
}

// MARK: - GoalResponseCard

struct GoalResponseCard: View {
    let goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            HStack(spacing: EHSpacing.sm) {
                EHIconContainer(systemName: "target", color: EHColors.cognitionPurple, size: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Goal")
                        .font(EHTypography.label)
                        .foregroundStyle(EHColors.Text.muted)
                    Text(goal.title)
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.Text.primary)
                }
            }
            ProgressView(value: goal.progress)
                .tint(EHColors.progressGreen)
            HStack {
                Text("\(Int(goal.progress * 100))% complete")
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.muted)
                Spacer()
                EHStatusBadge(label: goal.status.displayName, color: EHColors.cognitionPurple)
            }
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }
}

// MARK: - TaskResponseCard

struct TaskResponseCard: View {
    let task: EHTask

    var body: some View {
        HStack(spacing: EHSpacing.sm) {
            EHIconContainer(systemName: "checkmark.square", color: EHColors.trustBlue, size: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text("Task")
                    .font(EHTypography.label)
                    .foregroundStyle(EHColors.Text.muted)
                Text(task.title)
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                EHStatusBadge(label: task.status.displayName, color: EHColors.trustBlue)
            }
            Spacer()
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }
}

// MARK: - PlanResponseCard

struct PlanResponseCard: View {
    let plan: Plan

    var body: some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            HStack(spacing: EHSpacing.sm) {
                EHIconContainer(systemName: "map", color: EHColors.intelligenceIndigo, size: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Plan")
                        .font(EHTypography.label)
                        .foregroundStyle(EHColors.Text.muted)
                    Text(plan.title)
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.Text.primary)
                }
            }
            Text(plan.description)
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.Text.secondary)
                .lineLimit(2)
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }
}

// MARK: - DecisionResponseCard

struct DecisionResponseCard: View {
    let decision: Decision

    var body: some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            HStack(spacing: EHSpacing.sm) {
                EHIconContainer(systemName: "arrow.triangle.branch", color: EHColors.intelligenceIndigo, size: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Decision")
                        .font(EHTypography.label)
                        .foregroundStyle(EHColors.Text.muted)
                    Text(decision.title)
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.Text.primary)
                }
            }
            EHStatusBadge(label: decision.status.displayName, color: EHColors.intelligenceIndigo)
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }
}

// MARK: - RecommendationResponseCard

struct RecommendationResponseCard: View {
    let recommendation: Recommendation

    var body: some View {
        VStack(alignment: .leading, spacing: EHSpacing.sm) {
            HStack(spacing: EHSpacing.sm) {
                EHIconContainer(systemName: "lightbulb.fill", color: EHColors.cognitionPurple, size: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Recommendation")
                        .font(EHTypography.label)
                        .foregroundStyle(EHColors.Text.muted)
                    Text(recommendation.title)
                        .font(EHTypography.bodySmMedium)
                        .foregroundStyle(EHColors.Text.primary)
                }
            }
            Text(recommendation.description)
                .font(EHTypography.bodySm)
                .foregroundStyle(EHColors.Text.secondary)
                .lineLimit(3)
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 2)
    }
}

// MARK: - DeviceResponseCard

struct DeviceResponseCard: View {
    let device: ConnectedDevice

    var body: some View {
        HStack(spacing: EHSpacing.sm) {
            EHIconContainer(systemName: device.deviceType.iconName, color: EHColors.trustBlue, size: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(device.name)
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                Text(device.role.displayName)
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.muted)
                EHStatusBadge(label: device.status.displayName, color: device.status == .online ? EHColors.progressGreen : EHColors.Text.subtle)
            }
            Spacer()
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }
}
