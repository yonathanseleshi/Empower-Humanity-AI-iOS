import Foundation

// MARK: - Deep Link Routes

enum DeepLink: Equatable {
    case chat(conversationId: UUID)
    case goal(goalId: UUID)
    case aiWork(workId: UUID)
    case approval(approvalId: UUID)
    case device(deviceId: UUID)
    case artifact(artifactId: UUID)
    case today
    case notifications

    // MARK: - URL Parsing (future universal links)
    static func from(url: URL) -> DeepLink? {
        guard url.scheme == "empowerhumanityai" else { return nil }
        let components = url.pathComponents.filter { $0 != "/" }
        guard components.count >= 2 else { return nil }
        let entityId = UUID(uuidString: components[1])
        switch components[0] {
        case "chat":
            if let id = entityId { return .chat(conversationId: id) }
        case "goals":
            if let id = entityId { return .goal(goalId: id) }
        case "ai-work":
            if let id = entityId { return .aiWork(workId: id) }
        case "approvals":
            if let id = entityId { return .approval(approvalId: id) }
        case "devices":
            if let id = entityId { return .device(deviceId: id) }
        case "artifacts":
            if let id = entityId { return .artifact(artifactId: id) }
        default: break
        }
        return nil
    }
}

// MARK: - NotificationRouter

final class NotificationRouter {
    static let shared = NotificationRouter()
    private init() {}

    // Future: Route push notification payloads to appropriate deep links
    func route(from userInfo: [AnyHashable: Any]) -> DeepLink? {
        guard let type = userInfo["type"] as? String,
              let idString = userInfo["entity_id"] as? String,
              let entityId = UUID(uuidString: idString) else { return nil }
        switch type {
        case "chat": return .chat(conversationId: entityId)
        case "goal": return .goal(goalId: entityId)
        case "ai_work": return .aiWork(workId: entityId)
        case "approval": return .approval(approvalId: entityId)
        case "device": return .device(deviceId: entityId)
        default: return nil
        }
    }
}
