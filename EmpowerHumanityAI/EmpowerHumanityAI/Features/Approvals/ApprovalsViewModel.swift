import Foundation
import Observation

@Observable
final class ApprovalsViewModel {
    var approvals: [ApprovalRequest] = []
    var isLoading: Bool = false
    var error: String? = nil

    private let repo: MockApprovalRepository
    private let userId: UUID

    init(userId: UUID) {
        self.userId = userId
        self.repo = MockApprovalRepository()
    }

    @MainActor
    func load() async {
        isLoading = true
        do {
            approvals = try await repo.getPendingApprovals(userId: userId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func resolve(approval: ApprovalRequest, status: ApprovalStatus) async {
        do {
            let resolved = try await repo.resolveApproval(id: approval.id, resolution: status)
            if let idx = approvals.firstIndex(where: { $0.id == resolved.id }) {
                approvals.remove(at: idx)
            }
            if status == .approved {
                HapticService.shared.approvalConfirmed()
            }
        } catch {
            self.error = error.localizedDescription
        }
    }

    var pendingCount: Int {
        approvals.filter { $0.status == .pending }.count
    }
}
