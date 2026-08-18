import Foundation

// MARK: - MockData
// Coherent demo dataset for Ben (user) and Alex (co-intelligence).
// Used in #if DEBUG builds to enable the flagship demo flow without a real API.

enum MockData {
    // MARK: - IDs (stable for cross-reference)
    static let benId = UUID(uuidString: "11111111-0000-0000-0000-000000000001")!
    static let alexId = UUID(uuidString: "22222222-0000-0000-0000-000000000002")!
    static let relId = UUID(uuidString: "33333333-0000-0000-0000-000000000003")!
    static let conv1Id = UUID(uuidString: "44444444-0000-0000-0000-000000000004")!
    static let aiWork1Id = UUID(uuidString: "55555555-0000-0000-0000-000000000005")!
    static let approval1Id = UUID(uuidString: "66666666-0000-0000-0000-000000000006")!
    static let macMiniId = UUID(uuidString: "77777777-0000-0000-0000-000000000007")!
    static let goal1Id = UUID(uuidString: "88888888-0000-0000-0000-000000000008")!

    // MARK: - User Account

    static var benAccount: UserAccount {
        UserAccount(
            id: benId,
            authSubjectId: "auth|ben_demo",
            email: "ben@example.com",
            emailVerified: true,
            accountStatus: "active",
            accessTier: .founderAccess,
            onboardingStatus: "complete",
            preferredLocale: "en-US",
            timezone: "America/Los_Angeles",
            createdAt: Date().addingTimeInterval(-60 * 60 * 24 * 90),
            updatedAt: Date().addingTimeInterval(-60 * 60 * 2),
            lastActiveAt: Date(),
            profile: benProfile
        )
    }

    static var benProfile: UserProfile {
        UserProfile(
            id: UUID(),
            userId: benId,
            displayName: "Ben",
            givenName: "Ben",
            familyName: "Carter",
            avatarUrl: nil,
            headline: "Founder at Empower Humanity AI",
            bio: "Building the future of human-AI co-intelligence.",
            locationDisplay: "San Francisco, CA",
            preferredName: "Ben",
            locale: "en-US",
            timezone: "America/Los_Angeles"
        )
    }

    static var alexCoIntelligence: PrimaryCoIntelligence {
        PrimaryCoIntelligence(
            id: alexId,
            userId: benId,
            ensolamBeingId: "being_alex_01",
            displayName: "Alex",
            avatarUrl: nil,
            relationshipStatus: "active",
            activationStatus: "active",
            createdAt: Date().addingTimeInterval(-60 * 60 * 24 * 90),
            updatedAt: Date()
        )
    }

    // MARK: - Goals

    static var goals: [Goal] {
        [
            Goal(
                id: goal1Id,
                userId: benId,
                title: "Ship Empower Humanity AI v1.0",
                description: "Launch the initial product to founders and design partners by Q3.",
                status: .active,
                progress: 0.65,
                horizon: "Q3 2026",
                createdAt: Date().addingTimeInterval(-60 * 60 * 24 * 45),
                updatedAt: Date().addingTimeInterval(-60 * 60 * 3),
                milestones: [
                    Milestone(id: UUID(), goalId: goal1Id, title: "iOS app complete", isCompleted: false, dueDate: Date().addingTimeInterval(60 * 60 * 24 * 7)),
                    Milestone(id: UUID(), goalId: goal1Id, title: "Backend API stable", isCompleted: true, dueDate: nil),
                    Milestone(id: UUID(), goalId: goal1Id, title: "Design system done", isCompleted: true, dueDate: nil)
                ],
                healthScore: 0.78,
                aiInsight: "Feature 0.2 completion is on the critical path. I recommend prioritising the deployment review today."
            ),
            Goal(
                id: UUID(),
                userId: benId,
                title: "Grow founding team to 5",
                description: "Hire 3 senior engineers with AI and iOS expertise.",
                status: .active,
                progress: 0.33,
                horizon: "Q4 2026",
                createdAt: Date().addingTimeInterval(-60 * 60 * 24 * 20),
                updatedAt: Date().addingTimeInterval(-60 * 60 * 24),
                milestones: [],
                healthScore: 0.60,
                aiInsight: "Two strong candidates from last week's interviews are ready for follow-up."
            ),
        ]
    }

    // MARK: - Tasks

    static var tasks: [EHTask] {
        [
            EHTask(id: UUID(), userId: benId, goalId: goal1Id, projectId: nil,
                   title: "Review Feature 0.2 deployment", description: "Check deployment logs and verify staging environment.", status: .inProgress, priority: .high,
                   dueDate: Date(), createdAt: Date().addingTimeInterval(-3600), updatedAt: Date()),
            EHTask(id: UUID(), userId: benId, goalId: nil, projectId: nil,
                   title: "Client proposal for Acme Corp", description: "Finish and send the partnership proposal.", status: .todo, priority: .high,
                   dueDate: Date().addingTimeInterval(60 * 60 * 4), createdAt: Date().addingTimeInterval(-7200), updatedAt: Date()),
            EHTask(id: UUID(), userId: benId, goalId: goal1Id, projectId: nil,
                   title: "Review iOS app design system", description: "Final design review before Xcode handoff.", status: .todo, priority: .medium,
                   dueDate: Date().addingTimeInterval(60 * 60 * 24 * 2), createdAt: Date().addingTimeInterval(-1800), updatedAt: Date())
        ]
    }

    // MARK: - AI Work

    static var aiWorkItems: [AIWorkItem] {
        [
            AIWorkItem(
                id: aiWork1Id,
                userId: benId,
                coIntelligenceId: alexId,
                title: "Reviewing deployment logs",
                objective: "Analyse Feature 0.2 deployment logs on Home Mac Mini and identify any issues before the release.",
                status: .waitingForApproval,
                currentStep: "Log analysis complete — found one critical issue. Requesting approval to apply fix.",
                deviceName: "Home Mac Mini",
                deviceId: macMiniId,
                goalId: goal1Id,
                taskId: nil,
                requiresApproval: true,
                approvalId: approval1Id,
                result: nil,
                artifacts: [],
                startedAt: Date().addingTimeInterval(-60 * 15),
                completedAt: nil,
                createdAt: Date().addingTimeInterval(-60 * 20),
                updatedAt: Date().addingTimeInterval(-60 * 2)
            ),
            AIWorkItem(
                id: UUID(),
                userId: benId,
                coIntelligenceId: alexId,
                title: "Researching payment processing options",
                objective: "Compare Stripe, RevenueCat, and direct App Store billing for the subscription model.",
                status: .working,
                currentStep: "Comparing pricing and integration complexity across three options.",
                deviceName: "Home Mac Mini",
                deviceId: macMiniId,
                goalId: goal1Id,
                taskId: nil,
                requiresApproval: false,
                approvalId: nil,
                result: nil,
                artifacts: [],
                startedAt: Date().addingTimeInterval(-60 * 45),
                completedAt: nil,
                createdAt: Date().addingTimeInterval(-60 * 50),
                updatedAt: Date().addingTimeInterval(-60 * 5)
            ),
            AIWorkItem(
                id: UUID(),
                userId: benId,
                coIntelligenceId: alexId,
                title: "Compiled weekly progress report",
                objective: "Summarise this week's product and engineering progress.",
                status: .completed,
                currentStep: nil,
                deviceName: "Home Mac Mini",
                deviceId: macMiniId,
                goalId: nil,
                taskId: nil,
                requiresApproval: false,
                approvalId: nil,
                result: "Report compiled and saved to Knowledge. Key highlights: Feature 0.2 is 85% complete, iOS design system approved, two candidates short-listed for engineering roles.",
                artifacts: [WorkArtifact(id: UUID(), name: "Weekly Progress Report", type: "document", description: "Q3 Week 7 progress summary", createdAt: Date().addingTimeInterval(-3600))],
                startedAt: Date().addingTimeInterval(-60 * 60 * 3),
                completedAt: Date().addingTimeInterval(-60 * 60 * 2),
                createdAt: Date().addingTimeInterval(-60 * 60 * 3.5),
                updatedAt: Date().addingTimeInterval(-60 * 60 * 2)
            )
        ]
    }

    // MARK: - Approvals

    static var pendingApprovals: [ApprovalRequest] {
        [
            ApprovalRequest(
                id: approval1Id,
                userId: benId,
                aiWorkItemId: aiWork1Id,
                title: "Apply hotfix to Feature 0.2",
                whatDescription: "Apply a one-line configuration fix to resolve the deployment failure on the production environment.",
                whyDescription: "The deployment log shows a missing environment variable that is blocking the Feature 0.2 release. The fix is low-risk and reversible.",
                whereDescription: "Home Mac Mini — Production deployment pipeline",
                resource: "Production environment configuration file",
                riskLevel: .low,
                riskDescription: "The change is a single environment variable addition. Rollback requires removing that variable. No data is affected.",
                scope: "One file modification, one deployment restart",
                status: .pending,
                createdAt: Date().addingTimeInterval(-60 * 10),
                updatedAt: Date().addingTimeInterval(-60 * 10)
            )
        ]
    }

    // MARK: - Devices

    static var devices: [ConnectedDevice] {
        [
            ConnectedDevice(id: UUID(), userId: benId, name: "iPhone", deviceType: .iPhone, status: .online, role: .personal, activeWork: nil, hasLocalAI: false, lastSeenAt: Date(), isCurrentDevice: true),
            ConnectedDevice(id: UUID(), userId: benId, name: "MacBook Pro", deviceType: .macBook, status: .online, role: .personal, activeWork: nil, hasLocalAI: false, lastSeenAt: Date().addingTimeInterval(-60 * 5), isCurrentDevice: false),
            ConnectedDevice(id: macMiniId, userId: benId, name: "Home Mac Mini", deviceType: .macMini, status: .working, role: .dedicatedAICompute, activeWork: "Reviewing deployment logs", hasLocalAI: true, lastSeenAt: Date().addingTimeInterval(-60), isCurrentDevice: false),
            ConnectedDevice(id: UUID(), userId: benId, name: "Windows Workstation", deviceType: .windowsPC, status: .offline, role: .workstation, activeWork: nil, hasLocalAI: false, lastSeenAt: Date().addingTimeInterval(-60 * 60 * 8), isCurrentDevice: false)
        ]
    }

    // MARK: - Activity

    static var activityEvents: [ActivityEvent] {
        [
            ActivityEvent(id: UUID(), userId: benId, eventType: .workStarted, title: "Alex started reviewing deployment logs", description: "Reviewing Feature 0.2 deployment on Home Mac Mini.", actor: .coIntelligence, relatedGoalId: goal1Id, relatedTaskId: nil, relatedWorkId: aiWork1Id, occurredAt: Date().addingTimeInterval(-60 * 15)),
            ActivityEvent(id: UUID(), userId: benId, eventType: .approvalRequired, title: "Approval required", description: "Alex needs your approval to apply a hotfix.", actor: .coIntelligence, relatedGoalId: nil, relatedTaskId: nil, relatedWorkId: aiWork1Id, occurredAt: Date().addingTimeInterval(-60 * 10)),
            ActivityEvent(id: UUID(), userId: benId, eventType: .workCompleted, title: "Weekly report compiled", description: "Alex compiled and saved the weekly progress report.", actor: .coIntelligence, relatedGoalId: nil, relatedTaskId: nil, relatedWorkId: nil, occurredAt: Date().addingTimeInterval(-60 * 60 * 2)),
            ActivityEvent(id: UUID(), userId: benId, eventType: .goalCreated, title: "You created a goal", description: "Ship Empower Humanity AI v1.0", actor: .human, relatedGoalId: goal1Id, relatedTaskId: nil, relatedWorkId: nil, occurredAt: Date().addingTimeInterval(-60 * 60 * 24 * 45)),
            ActivityEvent(id: UUID(), userId: benId, eventType: .taskCompleted, title: "Alex completed a task", description: "Backend API stabilisation verified and documented.", actor: .coIntelligence, relatedGoalId: goal1Id, relatedTaskId: nil, relatedWorkId: nil, occurredAt: Date().addingTimeInterval(-60 * 60 * 24 * 2))
        ]
    }

    // MARK: - Notifications

    static var notifications: [EHNotification] {
        [
            EHNotification(id: UUID(), userId: benId, category: .approvals, title: "Approval required", body: "Alex needs your approval to apply a hotfix to Feature 0.2.", isRead: false, priority: .important, relatedEntityId: approval1Id, relatedEntityType: "approval", createdAt: Date().addingTimeInterval(-60 * 10)),
            EHNotification(id: UUID(), userId: benId, category: .aiWork, title: "Work started", body: "Alex is reviewing deployment logs on Home Mac Mini.", isRead: true, priority: .informational, relatedEntityId: aiWork1Id, relatedEntityType: "ai_work", createdAt: Date().addingTimeInterval(-60 * 20)),
            EHNotification(id: UUID(), userId: benId, category: .proactive, title: "Good morning, Ben", body: "You have three priorities today. I flagged one deployment issue that needs your attention.", isRead: true, priority: .informational, relatedEntityId: nil, relatedEntityType: nil, createdAt: Date().addingTimeInterval(-60 * 60 * 7))
        ]
    }

    // MARK: - Knowledge

    static var knowledgeItems: [KnowledgeItem] {
        [
            KnowledgeItem(id: UUID(), userId: benId, type: .document, title: "Weekly Progress Report — Week 7", summary: "Q3 Week 7 progress summary: Feature 0.2 at 85%, iOS design system approved.", content: nil, tags: ["progress", "q3", "feature-0.2"], createdAt: Date().addingTimeInterval(-60 * 60 * 2), updatedAt: Date().addingTimeInterval(-60 * 60 * 2)),
            KnowledgeItem(id: UUID(), userId: benId, type: .research, title: "Payment processing comparison", summary: "Stripe vs RevenueCat vs direct App Store billing — analysis in progress.", content: nil, tags: ["payments", "ios", "research"], createdAt: Date().addingTimeInterval(-60 * 45), updatedAt: Date().addingTimeInterval(-60 * 45)),
            KnowledgeItem(id: UUID(), userId: benId, type: .note, title: "iOS app architecture notes", summary: "SwiftUI + @Observable, repository pattern, no third-party dependencies.", content: nil, tags: ["ios", "architecture", "swiftui"], createdAt: Date().addingTimeInterval(-60 * 60 * 24 * 3), updatedAt: Date().addingTimeInterval(-60 * 60 * 24 * 3))
        ]
    }

    // MARK: - Integrations

    static var integrations: [Integration] {
        [
            Integration(id: UUID(), userId: benId, name: "Apple Calendar", category: .calendar, status: .connected, description: "Read calendar events to help plan your day.", iconName: "calendar", connectedAt: Date().addingTimeInterval(-60 * 60 * 24 * 30)),
            Integration(id: UUID(), userId: benId, name: "Gmail", category: .email, status: .needsAttention, description: "Read and draft emails on your behalf.", iconName: "envelope", connectedAt: Date().addingTimeInterval(-60 * 60 * 24 * 15)),
            Integration(id: UUID(), userId: benId, name: "iCloud Drive", category: .files, status: .connected, description: "Access files and documents.", iconName: "icloud", connectedAt: Date().addingTimeInterval(-60 * 60 * 24 * 30)),
            Integration(id: UUID(), userId: benId, name: "Notion", category: .productivity, status: .disconnected, description: "Sync with your Notion workspace.", iconName: "doc.text", connectedAt: nil),
            Integration(id: UUID(), userId: benId, name: "Somuleco", category: .empowerHumanityEcosystem, status: .connected, description: "Personal development and life context.", iconName: "person.circle", connectedAt: Date().addingTimeInterval(-60 * 60 * 24 * 90))
        ]
    }

    // MARK: - Conversation (Demo)

    static var demoConversation: Conversation {
        Conversation(
            id: conv1Id,
            userId: benId,
            coIntelligenceId: alexId,
            title: "Deployment review",
            conversationType: .general,
            status: "active",
            startedAt: Date().addingTimeInterval(-60 * 30),
            lastMessageAt: Date().addingTimeInterval(-60 * 5),
            messages: demoMessages
        )
    }

    static var demoMessages: [ConversationMessage] {
        [
            ConversationMessage(id: UUID(), conversationId: conv1Id, senderType: .coIntelligence, messageType: .text, content: "Good morning, Ben. I noticed the Feature 0.2 deployment is showing errors in the staging environment. I flagged it in Today. Would you like me to review the logs?", createdAt: Date().addingTimeInterval(-60 * 25), sequenceNumber: 1, richCard: nil),
            ConversationMessage(id: UUID(), conversationId: conv1Id, senderType: .human, messageType: .text, content: "Yes, please review the logs and let me know what you find.", createdAt: Date().addingTimeInterval(-60 * 20), sequenceNumber: 2, richCard: nil),
            ConversationMessage(id: UUID(), conversationId: conv1Id, senderType: .coIntelligence, messageType: .text, content: "I started reviewing on your Home Mac Mini. I found the issue — a missing environment variable in the production configuration. I can apply a simple fix, but I need your approval before I modify production.", createdAt: Date().addingTimeInterval(-60 * 10), sequenceNumber: 3, richCard: nil),
            ConversationMessage(id: UUID(), conversationId: conv1Id, senderType: .coIntelligence, messageType: .richCard, content: "Approval request", createdAt: Date().addingTimeInterval(-60 * 9), sequenceNumber: 4, richCard: .approval(pendingApprovals[0]))
        ]
    }

    // MARK: - Today Brief

    static var todayBrief: TodayBrief {
        TodayBrief(
            id: UUID(),
            userId: benId,
            greeting: "Good morning, Ben.",
            intelligenceSummary: "You have three priorities today. I moved the deployment review ahead of your afternoon meeting and flagged one decision that could block the Feature 0.2 release.",
            priorities: tasks,
            needsAttention: [
                NeedsAttentionItem(id: UUID(), title: "Approval required", description: "Alex needs your approval to apply a hotfix to the Feature 0.2 deployment.", urgency: "high", type: "approval", relatedEntityId: approval1Id),
                NeedsAttentionItem(id: UUID(), title: "Homepage direction decision", description: "The design team is waiting on your decision for homepage direction.", urgency: "medium", type: "decision", relatedEntityId: nil)
            ],
            activeWork: Array(aiWorkItems.filter { $0.status == .working || $0.status == .waitingForApproval }),
            upcoming: [
                UpcomingItem(id: UUID(), title: "Team standup", scheduledAt: Date().addingTimeInterval(60 * 90), type: "meeting", description: nil),
                UpcomingItem(id: UUID(), title: "Dinner with Marie", scheduledAt: Date().addingTimeInterval(60 * 60 * 9), type: "personal", description: "Leave at 6:30 PM")
            ],
            recommendations: [
                Recommendation(id: UUID(), userId: benId, title: "Review Feature 0.2 deployment first", description: "The deployment issue is on the critical path for the Q3 release.", rationale: "Blocking the release by 3+ days if unresolved today.", type: .action, priority: "high", createdAt: Date())
            ],
            recentOutcomes: Array(activityEvents.prefix(3)),
            generatedAt: Date()
        )
    }

    // MARK: - Autonomy

    static var autonomyPreference: AutonomyPreference {
        AutonomyPreference(
            id: UUID(),
            userId: benId,
            level: .actWithApproval,
            isPaused: false,
            approvalRequiredFor: ["production deployments", "file deletions", "external communications"],
            updatedAt: Date().addingTimeInterval(-60 * 60 * 24 * 7)
        )
    }
}

// MARK: - Mock Repository Implementations

final class MockAuthRepository: AuthRepository {
    func signIn(email: String, password: String) async throws -> UserAccount { MockData.benAccount }
    func signUp(name: String, email: String, password: String) async throws -> UserAccount { MockData.benAccount }
    func signOut() async throws {}
    func refreshSession() async throws -> String { "mock_token_\(UUID())" }
    func currentUser() async throws -> UserAccount? { MockData.benAccount }
}

final class MockAccessRepository: AccessRepository {
    func getAccessTier(userId: UUID) async throws -> AccessTier { .founderAccess }
    func getEntitlements(userId: UUID) async throws -> [AccessEntitlement] { [] }
    func getWaitlistPosition(userId: UUID) async throws -> Int? { nil }
}

final class MockCoIntelligenceRepository: CoIntelligenceRepository {
    func getCoIntelligence(userId: UUID) async throws -> PrimaryCoIntelligence? { MockData.alexCoIntelligence }
    func updateOrbState(_ state: OrbState, coIntelligenceId: UUID) async throws {}
    func getResponsibilities(coIntelligenceId: UUID) async throws -> [CoIntelligenceResponsibility] { [] }
}

final class MockTodayRepository: TodayRepository {
    func getTodayBrief(userId: UUID) async throws -> TodayBrief { MockData.todayBrief }
    func getNeedsAttention(userId: UUID) async throws -> [NeedsAttentionItem] { MockData.todayBrief.needsAttention }
}

final class MockConversationRepository: ConversationRepository {
    private var conversations: [Conversation] = [MockData.demoConversation]

    func getConversations(userId: UUID) async throws -> [Conversation] { conversations }
    func getConversation(id: UUID) async throws -> Conversation? { conversations.first { $0.id == id } }

    func sendMessage(_ content: String, conversationId: UUID) async throws -> ConversationMessage {
        let msg = ConversationMessage(id: UUID(), conversationId: conversationId, senderType: .human, messageType: .text, content: content, createdAt: Date(), sequenceNumber: 99, richCard: nil)
        return msg
    }

    func startConversation(userId: UUID, type: ConversationType) async throws -> Conversation {
        Conversation(id: UUID(), userId: userId, coIntelligenceId: MockData.alexId, title: "New conversation", conversationType: type, status: "active", startedAt: Date(), lastMessageAt: nil, messages: [])
    }
}

final class MockGoalsRepository: GoalsRepository {
    private var goals = MockData.goals
    func getGoals(userId: UUID) async throws -> [Goal] { goals }
    func getGoal(id: UUID) async throws -> Goal? { goals.first { $0.id == id } }
    func createGoal(_ goal: Goal) async throws -> Goal { goal }
    func updateGoal(_ goal: Goal) async throws -> Goal { goal }
    func deleteGoal(id: UUID) async throws { goals.removeAll { $0.id == id } }
}

final class MockTasksRepository: TasksRepository {
    private var tasks = MockData.tasks
    func getTasks(userId: UUID) async throws -> [EHTask] { tasks }
    func getTask(id: UUID) async throws -> EHTask? { tasks.first { $0.id == id } }
    func createTask(_ task: EHTask) async throws -> EHTask { task }
    func updateTask(_ task: EHTask) async throws -> EHTask { task }
    func deleteTask(id: UUID) async throws { tasks.removeAll { $0.id == id } }
}

final class MockPlansRepository: PlansRepository {
    func getPlans(userId: UUID) async throws -> [Plan] { [] }
    func getPlan(id: UUID) async throws -> Plan? { nil }
    func createPlan(_ plan: Plan) async throws -> Plan { plan }
    func updatePlan(_ plan: Plan) async throws -> Plan { plan }
}

final class MockProjectsRepository: ProjectsRepository {
    func getProjects(userId: UUID) async throws -> [Project] { [] }
    func getProject(id: UUID) async throws -> Project? { nil }
    func createProject(_ project: Project) async throws -> Project { project }
}

final class MockDecisionsRepository: DecisionsRepository {
    func getDecisions(userId: UUID) async throws -> [Decision] { [] }
    func getDecision(id: UUID) async throws -> Decision? { nil }
    func createDecision(_ decision: Decision) async throws -> Decision { decision }
    func updateDecision(_ decision: Decision) async throws -> Decision { decision }
}

final class MockAIWorkRepository: AIWorkRepository {
    var items = MockData.aiWorkItems

    func getAIWorkItems(userId: UUID) async throws -> [AIWorkItem] { items }
    func getAIWorkItem(id: UUID) async throws -> AIWorkItem? { items.first { $0.id == id } }
    func updateAIWorkItem(_ item: AIWorkItem) async throws -> AIWorkItem {
        if let idx = items.firstIndex(where: { $0.id == item.id }) { items[idx] = item }
        return item
    }
}

final class MockApprovalRepository: ApprovalRepository {
    var approvals = MockData.pendingApprovals

    func getPendingApprovals(userId: UUID) async throws -> [ApprovalRequest] { approvals.filter { $0.status == .pending } }
    func getApproval(id: UUID) async throws -> ApprovalRequest? { approvals.first { $0.id == id } }
    func resolveApproval(id: UUID, resolution: ApprovalStatus) async throws -> ApprovalRequest {
        guard let idx = approvals.firstIndex(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        approvals[idx] = ApprovalRequest(
            id: approvals[idx].id, userId: approvals[idx].userId, aiWorkItemId: approvals[idx].aiWorkItemId,
            title: approvals[idx].title, whatDescription: approvals[idx].whatDescription, whyDescription: approvals[idx].whyDescription,
            whereDescription: approvals[idx].whereDescription, resource: approvals[idx].resource, riskLevel: approvals[idx].riskLevel,
            riskDescription: approvals[idx].riskDescription, scope: approvals[idx].scope, status: resolution,
            createdAt: approvals[idx].createdAt, updatedAt: Date()
        )
        return approvals[idx]
    }
}

final class MockDeviceRepository: DeviceRepository {
    private var devices = MockData.devices
    func getDevices(userId: UUID) async throws -> [ConnectedDevice] { devices }
    func getDevice(id: UUID) async throws -> ConnectedDevice? { devices.first { $0.id == id } }
    func updateDevice(_ device: ConnectedDevice) async throws -> ConnectedDevice { device }
}

final class MockActivityRepository: ActivityRepository {
    func getActivity(userId: UUID) async throws -> [ActivityEvent] { MockData.activityEvents }
    func getActivity(userId: UUID, limit: Int) async throws -> [ActivityEvent] { Array(MockData.activityEvents.prefix(limit)) }
}

final class MockNotificationRepository: NotificationRepository {
    private var notifications = MockData.notifications
    func getNotifications(userId: UUID) async throws -> [EHNotification] { notifications }
    func markAsRead(id: UUID) async throws { if let i = notifications.firstIndex(where: { $0.id == id }) { notifications[i].isRead = true } }
    func markAllAsRead(userId: UUID) async throws { for i in notifications.indices { notifications[i].isRead = true } }
}

final class MockKnowledgeRepository: KnowledgeRepository {
    private var items = MockData.knowledgeItems
    func getKnowledgeItems(userId: UUID) async throws -> [KnowledgeItem] { items }
    func getKnowledgeItem(id: UUID) async throws -> KnowledgeItem? { items.first { $0.id == id } }
    func createKnowledgeItem(_ item: KnowledgeItem) async throws -> KnowledgeItem { item }
    func searchKnowledge(query: String, userId: UUID) async throws -> [KnowledgeItem] {
        items.filter { $0.title.localizedCaseInsensitiveContains(query) || $0.summary.localizedCaseInsensitiveContains(query) }
    }
}

final class MockIntegrationRepository: IntegrationRepository {
    private var integrations = MockData.integrations
    func getIntegrations(userId: UUID) async throws -> [Integration] { integrations }
    func connectIntegration(id: UUID) async throws -> Integration {
        guard let i = integrations.firstIndex(where: { $0.id == id }) else { throw APIError.notFound }
        integrations[i] = Integration(id: integrations[i].id, userId: integrations[i].userId, name: integrations[i].name, category: integrations[i].category, status: .connected, description: integrations[i].description, iconName: integrations[i].iconName, connectedAt: Date())
        return integrations[i]
    }
    func disconnectIntegration(id: UUID) async throws -> Integration {
        guard let i = integrations.firstIndex(where: { $0.id == id }) else { throw APIError.notFound }
        integrations[i] = Integration(id: integrations[i].id, userId: integrations[i].userId, name: integrations[i].name, category: integrations[i].category, status: .disconnected, description: integrations[i].description, iconName: integrations[i].iconName, connectedAt: nil)
        return integrations[i]
    }
}

final class MockSettingsRepository: SettingsRepository {
    private var pref = MockData.autonomyPreference
    func getAutonomyPreference(userId: UUID) async throws -> AutonomyPreference { pref }
    func updateAutonomyPreference(_ p: AutonomyPreference) async throws -> AutonomyPreference { pref = p; return p }
}
