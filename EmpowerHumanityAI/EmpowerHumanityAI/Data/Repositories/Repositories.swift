import Foundation

// MARK: - Repository Protocols
// Protocol-first design enables clean mock/real swap without changing View code.

protocol AuthRepository {
    func signIn(email: String, password: String) async throws -> UserAccount
    func signUp(name: String, email: String, password: String) async throws -> UserAccount
    func signOut() async throws
    func refreshSession() async throws -> String
    func currentUser() async throws -> UserAccount?
}

protocol AccessRepository {
    func getAccessTier(userId: UUID) async throws -> AccessTier
    func getEntitlements(userId: UUID) async throws -> [AccessEntitlement]
    func getWaitlistPosition(userId: UUID) async throws -> Int?
}

protocol CoIntelligenceRepository {
    func getCoIntelligence(userId: UUID) async throws -> PrimaryCoIntelligence?
    func updateOrbState(_ state: OrbState, coIntelligenceId: UUID) async throws
    func getResponsibilities(coIntelligenceId: UUID) async throws -> [CoIntelligenceResponsibility]
}

struct CoIntelligenceResponsibility: Identifiable, Codable {
    let id: UUID
    var coIntelligenceId: UUID
    var title: String
    var description: String
    var status: String
}

protocol TodayRepository {
    func getTodayBrief(userId: UUID) async throws -> TodayBrief
    func getNeedsAttention(userId: UUID) async throws -> [NeedsAttentionItem]
}

protocol ConversationRepository {
    func getConversations(userId: UUID) async throws -> [Conversation]
    func getConversation(id: UUID) async throws -> Conversation?
    func sendMessage(_ content: String, conversationId: UUID) async throws -> ConversationMessage
    func startConversation(userId: UUID, type: ConversationType) async throws -> Conversation
}

protocol GoalsRepository {
    func getGoals(userId: UUID) async throws -> [Goal]
    func getGoal(id: UUID) async throws -> Goal?
    func createGoal(_ goal: Goal) async throws -> Goal
    func updateGoal(_ goal: Goal) async throws -> Goal
    func deleteGoal(id: UUID) async throws
}

protocol PlansRepository {
    func getPlans(userId: UUID) async throws -> [Plan]
    func getPlan(id: UUID) async throws -> Plan?
    func createPlan(_ plan: Plan) async throws -> Plan
    func updatePlan(_ plan: Plan) async throws -> Plan
}

protocol TasksRepository {
    func getTasks(userId: UUID) async throws -> [EHTask]
    func getTask(id: UUID) async throws -> EHTask?
    func createTask(_ task: EHTask) async throws -> EHTask
    func updateTask(_ task: EHTask) async throws -> EHTask
    func deleteTask(id: UUID) async throws
}

protocol ProjectsRepository {
    func getProjects(userId: UUID) async throws -> [Project]
    func getProject(id: UUID) async throws -> Project?
    func createProject(_ project: Project) async throws -> Project
}

protocol DecisionsRepository {
    func getDecisions(userId: UUID) async throws -> [Decision]
    func getDecision(id: UUID) async throws -> Decision?
    func createDecision(_ decision: Decision) async throws -> Decision
    func updateDecision(_ decision: Decision) async throws -> Decision
}

protocol AIWorkRepository {
    func getAIWorkItems(userId: UUID) async throws -> [AIWorkItem]
    func getAIWorkItem(id: UUID) async throws -> AIWorkItem?
    func updateAIWorkItem(_ item: AIWorkItem) async throws -> AIWorkItem
}

protocol ApprovalRepository {
    func getPendingApprovals(userId: UUID) async throws -> [ApprovalRequest]
    func getApproval(id: UUID) async throws -> ApprovalRequest?
    func resolveApproval(id: UUID, resolution: ApprovalStatus) async throws -> ApprovalRequest
}

protocol DeviceRepository {
    func getDevices(userId: UUID) async throws -> [ConnectedDevice]
    func getDevice(id: UUID) async throws -> ConnectedDevice?
    func updateDevice(_ device: ConnectedDevice) async throws -> ConnectedDevice
}

protocol ActivityRepository {
    func getActivity(userId: UUID) async throws -> [ActivityEvent]
    func getActivity(userId: UUID, limit: Int) async throws -> [ActivityEvent]
}

protocol NotificationRepository {
    func getNotifications(userId: UUID) async throws -> [EHNotification]
    func markAsRead(id: UUID) async throws
    func markAllAsRead(userId: UUID) async throws
}

protocol KnowledgeRepository {
    func getKnowledgeItems(userId: UUID) async throws -> [KnowledgeItem]
    func getKnowledgeItem(id: UUID) async throws -> KnowledgeItem?
    func createKnowledgeItem(_ item: KnowledgeItem) async throws -> KnowledgeItem
    func searchKnowledge(query: String, userId: UUID) async throws -> [KnowledgeItem]
}

protocol IntegrationRepository {
    func getIntegrations(userId: UUID) async throws -> [Integration]
    func connectIntegration(id: UUID) async throws -> Integration
    func disconnectIntegration(id: UUID) async throws -> Integration
}

protocol SettingsRepository {
    func getAutonomyPreference(userId: UUID) async throws -> AutonomyPreference
    func updateAutonomyPreference(_ pref: AutonomyPreference) async throws -> AutonomyPreference
}
