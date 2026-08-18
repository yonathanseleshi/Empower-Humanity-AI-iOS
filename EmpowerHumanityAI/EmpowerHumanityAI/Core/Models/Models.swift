import Foundation

// MARK: - Access

enum AccessTier: String, Codable, Equatable, Hashable, CaseIterable {
    case `public` = "public"
    case waitlist = "waitlist"
    case approvedBeta = "approved_beta"
    case founderAccess = "founder_access"
    case designPartner = "design_partner"
    case subscriber = "subscriber"

    var displayName: String {
        switch self {
        case .public: return "Public"
        case .waitlist: return "Waitlist"
        case .approvedBeta: return "Approved Beta"
        case .founderAccess: return "Founder Access"
        case .designPartner: return "Design Partner"
        case .subscriber: return "Subscriber"
        }
    }

    var hasFullAccess: Bool {
        switch self {
        case .public, .waitlist: return false
        case .approvedBeta, .founderAccess, .designPartner, .subscriber: return true
        }
    }
}

// MARK: - Identity & Account

struct UserAccount: Identifiable, Codable {
    let id: UUID
    var authSubjectId: String
    var email: String
    var emailVerified: Bool
    var accountStatus: String
    var accessTier: AccessTier
    var onboardingStatus: String
    var preferredLocale: String
    var timezone: String
    var createdAt: Date
    var updatedAt: Date
    var lastActiveAt: Date
    var profile: UserProfile
}

struct UserProfile: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var displayName: String
    var givenName: String
    var familyName: String
    var avatarUrl: String?
    var headline: String?
    var bio: String?
    var locationDisplay: String?
    var preferredName: String?
    var locale: String
    var timezone: String
}

struct AccessEntitlement: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var entitlementType: String
    var status: String
    var source: String
    var startsAt: Date?
    var expiresAt: Date?
}

// MARK: - Co-Intelligence

struct PrimaryCoIntelligence: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var ensolamBeingId: String
    var displayName: String
    var avatarUrl: String?
    var relationshipStatus: String
    var activationStatus: String
    var createdAt: Date
    var updatedAt: Date
}

struct CoIntelligenceProfile: Identifiable, Codable {
    let id: UUID
    var coIntelligenceId: UUID
    var displayNameOverride: String?
    var communicationStyle: String
    var responseDepth: String
    var challengeLevel: String
    var proactivityLevel: String
    var notificationStyle: String
}

// MARK: - Orb State

enum OrbState: String, Codable, CaseIterable, Equatable, Hashable {
    case available, listening, thinking, acting, waiting, completed, attention, error
}

// MARK: - Conversation

struct Conversation: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var coIntelligenceId: UUID
    var title: String
    var conversationType: ConversationType
    var status: String
    var startedAt: Date
    var lastMessageAt: Date?
    var messages: [ConversationMessage]
}

enum ConversationType: String, Codable, CaseIterable, Equatable, Hashable {
    case general, project, goal, decision, planning, reflection, support
}

struct ConversationMessage: Identifiable, Codable {
    let id: UUID
    var conversationId: UUID
    var senderType: SenderType
    var messageType: MessageType
    var content: String
    var createdAt: Date
    var sequenceNumber: Int
    var richCard: RichCard?
}

enum SenderType: String, Codable, Equatable, Hashable {
    case human, coIntelligence, agent, system
}

enum MessageType: String, Codable, Equatable, Hashable {
    case text, richCard, action, system
}

enum RichCard: Codable {
    case task(EHTask)
    case goal(Goal)
    case plan(Plan)
    case decision(Decision)
    case aiWork(AIWorkItem)
    case approval(ApprovalRequest)
    case recommendation(Recommendation)
}

// MARK: - Goals

struct Goal: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var title: String
    var description: String?
    var status: GoalStatus
    var progress: Double
    var horizon: String?
    var createdAt: Date
    var updatedAt: Date
    var milestones: [Milestone]
    var healthScore: Double?
    var aiInsight: String?
}

enum GoalStatus: String, Codable, CaseIterable, Equatable, Hashable {
    case active, paused, completed, abandoned
    var displayName: String { rawValue.capitalized }
}

struct Milestone: Identifiable, Codable {
    let id: UUID
    var goalId: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
}

// MARK: - Plans

struct Plan: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var goalId: UUID?
    var title: String
    var description: String
    var status: String
    var steps: [PlanStep]
    var createdAt: Date
    var updatedAt: Date
}

struct PlanStep: Identifiable, Codable {
    let id: UUID
    var planId: UUID
    var title: String
    var isCompleted: Bool
    var order: Int
}

// MARK: - Tasks

struct EHTask: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var goalId: UUID?
    var projectId: UUID?
    var title: String
    var description: String
    var status: TaskStatus
    var priority: TaskPriority
    var dueDate: Date?
    var createdAt: Date
    var updatedAt: Date
}

enum TaskStatus: String, Codable, CaseIterable, Equatable, Hashable {
    case todo, inProgress, completed, blocked, cancelled
    var displayName: String {
        switch self {
        case .todo: return "To Do"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .blocked: return "Blocked"
        case .cancelled: return "Cancelled"
        }
    }
}

enum TaskPriority: String, Codable, CaseIterable, Equatable, Hashable {
    case low, medium, high, urgent
    var displayName: String { rawValue.capitalized }
}

// MARK: - Projects

struct Project: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var title: String
    var description: String
    var status: String
    var createdAt: Date
    var updatedAt: Date
}

// MARK: - Decisions

struct Decision: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var title: String
    var description: String
    var options: [String]
    var chosenOption: String?
    var rationale: String?
    var confidence: Double?
    var status: DecisionStatus
    var createdAt: Date
    var updatedAt: Date
}

enum DecisionStatus: String, Codable, CaseIterable, Equatable, Hashable {
    case open, made, revisiting
    var displayName: String { rawValue.capitalized }
}

// MARK: - AI Work

struct AIWorkItem: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var coIntelligenceId: UUID
    var title: String
    var objective: String
    var status: AIWorkStatus
    var currentStep: String?
    var deviceName: String?
    var deviceId: UUID?
    var goalId: UUID?
    var taskId: UUID?
    var requiresApproval: Bool
    var approvalId: UUID?
    var result: String?
    var artifacts: [WorkArtifact]
    var startedAt: Date?
    var completedAt: Date?
    var createdAt: Date
    var updatedAt: Date
}

enum AIWorkStatus: String, Codable, CaseIterable, Equatable, Hashable {
    case queued, preparing, working, waitingForApproval, completed, failed, cancelled
    var displayName: String {
        switch self {
        case .queued: return "Queued"
        case .preparing: return "Preparing"
        case .working: return "Working"
        case .waitingForApproval: return "Waiting for You"
        case .completed: return "Completed"
        case .failed: return "Failed"
        case .cancelled: return "Cancelled"
        }
    }
}

struct WorkArtifact: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: String
    var description: String
    var createdAt: Date
}

// MARK: - Approvals

struct ApprovalRequest: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var aiWorkItemId: UUID?
    var title: String
    var whatDescription: String
    var whyDescription: String
    var whereDescription: String
    var resource: String
    var riskLevel: RiskLevel
    var riskDescription: String
    var scope: String
    var status: ApprovalStatus
    var createdAt: Date
    var updatedAt: Date
}

enum ApprovalStatus: String, Codable, CaseIterable, Equatable, Hashable {
    case pending, approved, approvedOnce, approvedForSession, denied, expired
    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .approved: return "Approved"
        case .approvedOnce: return "Approved Once"
        case .approvedForSession: return "Allowed for Session"
        case .denied: return "Denied"
        case .expired: return "Expired"
        }
    }
}

enum RiskLevel: String, Codable, CaseIterable, Equatable, Hashable {
    case low, medium, high
    var displayName: String { rawValue.capitalized }
}

// MARK: - Devices

struct ConnectedDevice: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var name: String
    var deviceType: DeviceType
    var status: DeviceStatus
    var role: DeviceRole
    var activeWork: String?
    var hasLocalAI: Bool
    var lastSeenAt: Date?
    var isCurrentDevice: Bool
}

enum DeviceType: String, Codable, CaseIterable, Equatable, Hashable {
    case iPhone, iPad, macBook, macMini, windowsPC, linux
    var iconName: String {
        switch self {
        case .iPhone: return "iphone"
        case .iPad: return "ipad"
        case .macBook: return "laptopcomputer"
        case .macMini: return "desktopcomputer"
        case .windowsPC: return "desktopcomputer"
        case .linux: return "server.rack"
        }
    }
    var displayName: String {
        switch self {
        case .iPhone: return "iPhone"
        case .iPad: return "iPad"
        case .macBook: return "MacBook"
        case .macMini: return "Mac Mini"
        case .windowsPC: return "Windows PC"
        case .linux: return "Linux Server"
        }
    }
}

enum DeviceStatus: String, Codable, CaseIterable, Equatable, Hashable {
    case online, offline, working, idle, error
    var displayName: String { rawValue.capitalized }
}

enum DeviceRole: String, Codable, CaseIterable, Equatable, Hashable {
    case personal, dedicatedAICompute, workstation
    var displayName: String {
        switch self {
        case .personal: return "Personal Device"
        case .dedicatedAICompute: return "Dedicated AI Compute"
        case .workstation: return "Workstation"
        }
    }
}

// MARK: - Activity

struct ActivityEvent: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var eventType: ActivityEventType
    var title: String
    var description: String
    var actor: ActivityActor
    var relatedGoalId: UUID?
    var relatedTaskId: UUID?
    var relatedWorkId: UUID?
    var occurredAt: Date
}

enum ActivityEventType: String, Codable, CaseIterable, Equatable, Hashable {
    case goalCreated, taskCreated, taskCompleted, workStarted, workCompleted, approvalRequired, approvalGiven, fileCreated, recommendationAccepted, decisionMade
    var icon: String {
        switch self {
        case .goalCreated: return "target"
        case .taskCreated: return "plus.square"
        case .taskCompleted: return "checkmark.square.fill"
        case .workStarted: return "bolt.fill"
        case .workCompleted: return "checkmark.circle.fill"
        case .approvalRequired: return "shield"
        case .approvalGiven: return "shield.fill"
        case .fileCreated: return "doc.fill"
        case .recommendationAccepted: return "lightbulb.fill"
        case .decisionMade: return "arrow.triangle.branch"
        }
    }
}

enum ActivityActor: String, Codable, Equatable, Hashable, CaseIterable {
    case human, coIntelligence
    var displayName: String {
        switch self {
        case .human: return "You"
        case .coIntelligence: return "Alex"
        }
    }
}

// MARK: - Notifications

struct EHNotification: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var category: NotificationCategory
    var title: String
    var body: String
    var isRead: Bool
    var priority: NotificationPriority
    var relatedEntityId: UUID?
    var relatedEntityType: String?
    var createdAt: Date
}

enum NotificationCategory: String, Codable, CaseIterable, Equatable, Hashable {
    case important, proactive, goals, tasks, aiWork, approvals, device, system
    var displayName: String {
        switch self {
        case .important: return "Important"
        case .proactive: return "Proactive"
        case .goals: return "Goals"
        case .tasks: return "Tasks"
        case .aiWork: return "AI Work"
        case .approvals: return "Approvals"
        case .device: return "Device"
        case .system: return "System"
        }
    }
    var icon: String {
        switch self {
        case .important: return "exclamationmark.circle.fill"
        case .proactive: return "sparkles"
        case .goals: return "target"
        case .tasks: return "checkmark.square"
        case .aiWork: return "bolt.fill"
        case .approvals: return "shield.fill"
        case .device: return "laptopcomputer"
        case .system: return "gear"
        }
    }
}

enum NotificationPriority: String, Codable, CaseIterable, Equatable, Hashable {
    case critical, important, informational, silent
}

// MARK: - Knowledge

struct KnowledgeItem: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var type: KnowledgeType
    var title: String
    var summary: String
    var content: String?
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
}

enum KnowledgeType: String, Codable, CaseIterable, Equatable, Hashable {
    case note, document, research, artifact, collection
    var displayName: String { rawValue.capitalized }
    var icon: String {
        switch self {
        case .note: return "note.text"
        case .document: return "doc.text"
        case .research: return "magnifyingglass"
        case .artifact: return "cube"
        case .collection: return "folder"
        }
    }
}

// MARK: - Integrations

struct Integration: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var name: String
    var category: IntegrationCategory
    var status: IntegrationStatus
    var description: String
    var iconName: String
    var connectedAt: Date?
}

enum IntegrationCategory: String, Codable, CaseIterable, Equatable, Hashable {
    case calendar, email, files, productivity, empowerHumanityEcosystem
    var displayName: String {
        switch self {
        case .calendar: return "Calendar"
        case .email: return "Email"
        case .files: return "Files"
        case .productivity: return "Productivity"
        case .empowerHumanityEcosystem: return "Empower Humanity"
        }
    }
}

enum IntegrationStatus: String, Codable, CaseIterable, Equatable, Hashable {
    case connected, disconnected, needsAttention
    var displayName: String {
        switch self {
        case .connected: return "Connected"
        case .disconnected: return "Not Connected"
        case .needsAttention: return "Needs Attention"
        }
    }
}

// MARK: - Recommendations

struct Recommendation: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var title: String
    var description: String
    var rationale: String
    var type: RecommendationType
    var priority: String
    var createdAt: Date
}

enum RecommendationType: String, Codable, CaseIterable, Equatable, Hashable {
    case action, insight, risk, opportunity
    var displayName: String { rawValue.capitalized }
}

// MARK: - Today

struct TodayBrief: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var greeting: String
    var intelligenceSummary: String
    var priorities: [EHTask]
    var needsAttention: [NeedsAttentionItem]
    var activeWork: [AIWorkItem]
    var upcoming: [UpcomingItem]
    var recommendations: [Recommendation]
    var recentOutcomes: [ActivityEvent]
    var generatedAt: Date
}

struct NeedsAttentionItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var urgency: String
    var type: String
    var relatedEntityId: UUID?
}

struct UpcomingItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var scheduledAt: Date
    var type: String
    var description: String?
}

// MARK: - Autonomy

struct AutonomyPreference: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var level: AutonomyLevel
    var isPaused: Bool
    var approvalRequiredFor: [String]
    var updatedAt: Date
}

enum AutonomyLevel: String, Codable, CaseIterable, Equatable, Hashable {
    case suggestOnly = "suggest_only"
    case actWithApproval = "act_with_approval"
    case actWithinRules = "act_within_rules"

    var displayName: String {
        switch self {
        case .suggestOnly: return "Suggest actions"
        case .actWithApproval: return "Act with approval"
        case .actWithinRules: return "Act within my rules"
        }
    }

    var description: String {
        switch self {
        case .suggestOnly: return "Alex will suggest what to do, but always wait for you to take action."
        case .actWithApproval: return "Alex will ask for your approval before taking any action."
        case .actWithinRules: return "Alex can act autonomously within the boundaries you've defined."
        }
    }
}
