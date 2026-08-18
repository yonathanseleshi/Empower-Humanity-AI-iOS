import Foundation
import Observation

// MARK: - AccessService

/// Centralized access tier management — never scatter tier checks through SwiftUI Views.
@Observable
final class AccessService {
    static let shared = AccessService()

    var currentTier: AccessTier = .public

    private init() {}

    func updateTier(_ tier: AccessTier) {
        currentTier = tier
    }

    // MARK: - Feature Gates

    var canUseChat: Bool { currentTier.hasFullAccess }
    var canUseGoals: Bool { currentTier.hasFullAccess }
    var canUseAIWork: Bool { currentTier.hasFullAccess }
    var canUseApprovals: Bool { currentTier.hasFullAccess }
    var canUseDevices: Bool { currentTier.hasFullAccess }
    var canUseKnowledge: Bool { currentTier.hasFullAccess }
    var canUseIntegrations: Bool { currentTier.hasFullAccess }
    var canUseVoice: Bool { currentTier == .founderAccess || currentTier == .designPartner }

    // MARK: - Access Description

    var availableFeatures: [String] {
        switch currentTier {
        case .public:
            return ["Public landing page", "Create account"]
        case .waitlist:
            return ["Waitlist status", "Basic profile", "Expected access date"]
        case .approvedBeta:
            return ["Today", "Chat with Alex", "Goals", "Work", "Knowledge", "Activity"]
        case .founderAccess, .designPartner:
            return ["Full access", "AI Work", "Approvals", "Devices", "Integrations", "Voice (beta)", "Priority support"]
        case .subscriber:
            return ["Full access", "AI Work", "Approvals", "Devices", "Integrations"]
        }
    }

    var upcomingFeatures: [String] {
        switch currentTier {
        case .public, .waitlist:
            return ["Chat with Alex", "Goals", "AI Work", "Approvals", "Devices"]
        case .approvedBeta:
            return ["AI Work (coming soon)", "Approvals (coming soon)", "Devices (coming soon)"]
        default:
            return ["Voice enhancements", "iOS widgets", "macOS companion app"]
        }
    }
}
