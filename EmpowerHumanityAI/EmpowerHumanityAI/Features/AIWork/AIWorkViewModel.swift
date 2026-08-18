import Foundation
import Observation

@Observable
final class AIWorkViewModel {
    var workItems: [AIWorkItem] = []
    var isLoading: Bool = false
    var error: String? = nil

    private let repo: any AIWorkRepository
    private let userId: UUID

    init(userId: UUID, repo: any AIWorkRepository = MockAIWorkRepository()) {
        self.userId = userId
        self.repo = repo
    }

    @MainActor
    func load() async {
        isLoading = true
        error = nil
        do {
            workItems = try await repo.getAIWorkItems(userId: userId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    var activeItems: [AIWorkItem] {
        workItems.filter { $0.status == .working || $0.status == .preparing || $0.status == .waitingForApproval }
    }

    var queuedItems: [AIWorkItem] {
        workItems.filter { $0.status == .queued }
    }

    var completedItems: [AIWorkItem] {
        workItems.filter { $0.status == .completed || $0.status == .failed || $0.status == .cancelled }
    }
}
