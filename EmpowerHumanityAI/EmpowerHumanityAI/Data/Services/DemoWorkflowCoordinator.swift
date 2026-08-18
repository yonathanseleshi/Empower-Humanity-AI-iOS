import Foundation
import Observation
import SwiftUI

// MARK: - DemoWorkflowCoordinator
// Simulates the flagship Ben/Alex workflow for demo/debug builds only.
// Drives state changes across Chat, AI Work, Approvals, Activity, and Notifications.
// Keep this explicitly #if DEBUG infrastructure — never runs in production.

#if DEBUG
@Observable
final class DemoWorkflowCoordinator {
    static let shared = DemoWorkflowCoordinator()

    var isRunning: Bool = false
    var currentStep: DemoStep = .idle

    private let aiWorkRepo = MockAIWorkRepository()
    private let approvalRepo = MockApprovalRepository()

    private init() {}

    enum DemoStep: String, CaseIterable {
        case idle = "Idle"
        case todayFlagged = "Today: Alex flags issue"
        case chatStarted = "Chat: User asks Alex to review"
        case workStarted = "AI Work: Started on Mac Mini"
        case approvalRequired = "Approval: Required"
        case approvalGiven = "Approval: Given"
        case workContinued = "AI Work: Continuing"
        case workCompleted = "AI Work: Completed"
        case notificationSent = "Notification: Result sent"
    }

    // MARK: - Run Full Demo Flow

    func runFullFlow(appState: AppState) async {
        guard !isRunning else { return }
        isRunning = true

        // Step 1: Today shows flagged issue (already in mock data)
        await step(.todayFlagged)
        try? await Task.sleep(for: .seconds(1))

        // Step 2: Chat — Alex has messaged about the issue
        await step(.chatStarted)
        try? await Task.sleep(for: .seconds(2))

        // Step 3: AI Work starts on Mac Mini
        await step(.workStarted)
        appState.orbState = .acting
        try? await Task.sleep(for: .seconds(3))

        // Step 4: Approval required
        await step(.approvalRequired)
        appState.orbState = .waiting
        PushNotificationService.shared.scheduleLocalNotification(
            title: "Approval required",
            body: "Alex needs your approval to apply a hotfix to Feature 0.2.",
            delay: 1.0
        )
        try? await Task.sleep(for: .seconds(2))

        // Demo pauses here — user navigates to Approvals
        // After user approves, call continueAfterApproval()
    }

    func continueAfterApproval(appState: AppState) async {
        await step(.approvalGiven)
        HapticService.shared.approvalConfirmed()
        try? await Task.sleep(for: .seconds(1))

        // Step 5: AI Work continues
        await step(.workContinued)
        appState.orbState = .acting
        try? await Task.sleep(for: .seconds(3))

        // Step 6: Work completed
        await step(.workCompleted)
        appState.orbState = .completed
        try? await Task.sleep(for: .seconds(0.5))

        // Step 7: Notification sent
        await step(.notificationSent)
        appState.orbState = .available
        PushNotificationService.shared.scheduleLocalNotification(
            title: "Work complete",
            body: "Alex applied the Feature 0.2 fix. Deployment is now running.",
            delay: 1.0
        )

        isRunning = false
    }

    func reset(appState: AppState) {
        currentStep = .idle
        isRunning = false
        appState.orbState = .available
    }

    // MARK: - Private

    @MainActor
    private func step(_ newStep: DemoStep) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = newStep
        }
    }
}
#endif
