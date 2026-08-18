import SwiftUI

struct NotificationsView: View {
    @Environment(AppState.self) private var appState
    @State private var notifications: [EHNotification] = []
    @State private var isLoading = false
    @State private var repo = MockNotificationRepository()

    private var unreadCount: Int { notifications.filter { !$0.isRead }.count }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: EHSpacing.xs) {
                if isLoading {
                    EHLoadingView().frame(height: 300)
                } else if notifications.isEmpty {
                    EHEmptyState(
                        systemImage: "bell",
                        title: "No notifications",
                        message: "Important updates from Alex and your account will appear here."
                    )
                } else {
                    ForEach(notifications) { notification in
                        notificationRow(notification)
                    }
                }
            }
            .padding(.horizontal, EHSpacing.screenHorizontal)
            .padding(.vertical, EHSpacing.md)
        }
        .background(EHColors.page)
        .navigationTitle("Notifications")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if unreadCount > 0 {
                    Button("Mark all read") {
                        Task { await markAllRead() }
                    }
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.trustBlue)
                }
            }
        }
        .task {
            guard let userId = appState.currentUser?.id else { return }
            isLoading = true
            notifications = (try? await MockNotificationRepository().getNotifications(userId: userId)) ?? []
            isLoading = false
        }
    }

    private func notificationRow(_ notification: EHNotification) -> some View {
        HStack(alignment: .top, spacing: EHSpacing.sm) {
            // Read indicator
            Circle()
                .fill(notification.isRead ? Color.clear : EHColors.trustBlue)
                .frame(width: 8, height: 8)
                .padding(.top, 5)

            // Icon
            EHIconContainer(systemName: iconName(for: notification.category), color: color(for: notification.category), size: 36)

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(notification.isRead ? EHTypography.bodySm : EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                Text(notification.body)
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.muted)
                    .lineLimit(2)
                Text(notification.createdAt.relativeString)
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.subtle)
            }

            Spacer()
        }
        .padding(EHSpacing.cardPadding)
        .background(notification.isRead ? EHColors.white : EHColors.trustBlue.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: EHRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: EHRadius.md)
                .strokeBorder(EHColors.border, lineWidth: 1)
        )
        .onTapGesture {
            Task { await markRead(notification) }
        }
    }

    private func markRead(_ notification: EHNotification) async {
        try? await repo.markAsRead(id: notification.id)
        if let idx = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[idx].isRead = true
        }
    }

    private func markAllRead() async {
        guard let userId = appState.currentUser?.id else { return }
        try? await repo.markAllAsRead(userId: userId)
        notifications = notifications.map { EHNotification(id: $0.id, userId: $0.userId, category: $0.category, title: $0.title, body: $0.body, isRead: true, priority: $0.priority, relatedEntityId: $0.relatedEntityId, relatedEntityType: $0.relatedEntityType, createdAt: $0.createdAt) }
    }

    private func iconName(for category: NotificationCategory) -> String {
        switch category {
        case .important: return "exclamationmark.circle.fill"
        case .approvals: return "shield.checkered"
        case .aiWork: return "bolt.fill"
        case .proactive: return "lightbulb.fill"
        case .device: return "laptopcomputer"
        case .goals: return "target"
        case .tasks: return "checkmark.square"
        case .system: return "gear"
        }
    }

    private func color(for category: NotificationCategory) -> Color {
        switch category {
        case .important: return EHColors.red
        case .approvals: return EHColors.amber
        case .aiWork: return EHColors.intelligenceCyan
        case .proactive: return EHColors.cognitionPurple
        case .device: return EHColors.trustBlue
        case .goals: return EHColors.progressGreen
        case .tasks: return EHColors.trustBlue
        case .system: return EHColors.Text.muted
        }
    }
}
