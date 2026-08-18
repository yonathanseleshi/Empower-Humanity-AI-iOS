import Foundation

// MARK: - DeepLink
// Typed deep-link destinations produced from push notification payloads
// and universal links. Bridging to (NavDestination, DetailDestination?) is
// handled by DetailDestination.from(deepLink:) in NavigationDestination.swift.

enum DeepLink: Equatable, Hashable {
    case chat(conversationId: UUID)
    case goal(goalId: UUID)
    case task(taskId: UUID)
    case project(projectId: UUID)
    case aiWork(workId: UUID)
    case approval(approvalId: UUID)
    case device(deviceId: UUID)
    case artifact(artifactId: UUID)
    case today
    case notifications

    // MARK: - URL Parsing (future universal links)
    // Scheme: empowerhumanityai://
    // Paths: chat/{id}, goals/{id}, tasks/{id}, projects/{id},
    //        ai-work/{id}, approvals/{id}, devices/{id}, artifacts/{id}

    static func from(url: URL) -> DeepLink? {
        guard url.scheme == "empowerhumanityai" else { return nil }
        let components = url.pathComponents.filter { $0 != "/" }
        guard !components.isEmpty else {
            return components.first == "notifications" ? .notifications : .today
        }
        let entityId = components.count >= 2 ? UUID(uuidString: components[1]) : nil
        switch components[0] {
        case "chat":
            if let id = entityId { return .chat(conversationId: id) }
        case "goals":
            if let id = entityId { return .goal(goalId: id) }
        case "tasks":
            if let id = entityId { return .task(taskId: id) }
        case "projects":
            if let id = entityId { return .project(projectId: id) }
        case "ai-work":
            if let id = entityId { return .aiWork(workId: id) }
        case "approvals":
            if let id = entityId { return .approval(approvalId: id) }
        case "devices":
            if let id = entityId { return .device(deviceId: id) }
        case "artifacts":
            if let id = entityId { return .artifact(artifactId: id) }
        case "notifications":
            return .notifications
        default:
            break
        }
        return nil
    }
}

// MARK: - NotificationRouter
// Converts push notification payloads into typed DeepLink values.
// APNs registration and real push handling belong in PushNotificationService.

final class NotificationRouter {
    static let shared = NotificationRouter()
    private init() {}

    /// Parse a push notification userInfo dictionary into a typed DeepLink.
    /// Expected payload keys: "type" (String), "entity_id" (UUID string).
    func route(from userInfo: [AnyHashable: Any]) -> DeepLink? {
        guard let type = userInfo["type"] as? String else { return nil }

        // Handle navigation-only routes that don't need an entity ID
        switch type {
        case "today":         return .today
        case "notifications": return .notifications
        default: break
        }

        // Entity routes require a valid UUID
        guard let idString = userInfo["entity_id"] as? String,
              let entityId = UUID(uuidString: idString) else { return nil }

        switch type {
        case "chat":        return .chat(conversationId: entityId)
        case "goal":        return .goal(goalId: entityId)
        case "task":        return .task(taskId: entityId)
        case "project":     return .project(projectId: entityId)
        case "ai_work":     return .aiWork(workId: entityId)
        case "approval":    return .approval(approvalId: entityId)
        case "device":      return .device(deviceId: entityId)
        case "artifact":    return .artifact(artifactId: entityId)
        default:            return nil
        }
    }
}
