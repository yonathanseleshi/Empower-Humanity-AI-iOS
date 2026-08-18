import Foundation
import Observation

@Observable
final class TodayViewModel {
    var brief: TodayBrief? = nil
    var isLoading: Bool = false
    var error: String? = nil

    private let todayRepo: any TodayRepository
    private let userId: UUID

    init(userId: UUID, todayRepo: any TodayRepository = MockTodayRepository()) {
        self.userId = userId
        self.todayRepo = todayRepo
    }

    @MainActor
    func load() async {
        guard brief == nil else { return }
        isLoading = true
        error = nil
        do {
            brief = try await todayRepo.getTodayBrief(userId: userId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func refresh() async {
        isLoading = true
        error = nil
        do {
            brief = try await todayRepo.getTodayBrief(userId: userId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
