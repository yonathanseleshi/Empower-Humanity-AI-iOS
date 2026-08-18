import Foundation

// MARK: - NavDestination
// Primary navigation items for the authenticated drawer/sidebar.

enum NavDestination: String, CaseIterable, Identifiable, Equatable, Hashable {
    // Primary
    case today, chat, work, goals, knowledge, activity
    // Additional
    case aiWork, approvals, devices, notifications
    // System
    case integrations, settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today:         return "Today"
        case .chat:          return "Chat"
        case .work:          return "Work"
        case .goals:         return "Goals"
        case .knowledge:     return "Knowledge"
        case .activity:      return "Activity"
        case .aiWork:        return "AI Work"
        case .approvals:     return "Approvals"
        case .devices:       return "Devices"
        case .notifications: return "Notifications"
        case .integrations:  return "Integrations"
        case .settings:      return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .today:         return "sun.max"
        case .chat:          return "message.circle"
        case .work:          return "square.and.pencil"
        case .goals:         return "target"
        case .knowledge:     return "books.vertical"
        case .activity:      return "chart.xyaxis.line"
        case .aiWork:        return "bolt.fill"
        case .approvals:     return "shield.checkered"
        case .devices:       return "laptopcomputer.and.iphone"
        case .notifications: return "bell"
        case .integrations:  return "puzzlepiece.extension"
        case .settings:      return "gear"
        }
    }

    // MARK: - Grouped Structure

    static var primaryGroup: [NavDestination] {
        [.today, .chat, .work, .goals, .knowledge, .activity]
    }

    static var additionalGroup: [NavDestination] {
        [.aiWork, .approvals, .devices, .notifications]
    }

    static var systemGroup: [NavDestination] {
        [.integrations, .settings]
    }
}

// MARK: - DetailDestination
// Typed navigation destinations for detail routes inside the authenticated
// NavigationStack. Use NavigationPath to push these onto the stack.
//
// This enables future deep-link flows such as:
//   notification → approval detail
//   notification → AI Work detail
//   activity     → relevant artifact/work item
//
// Add a `navigationDestination(for: DetailDestination.self)` handler
// in AuthenticatedRootView to present the appropriate detail view.

enum DetailDestination: Hashable {
    case conversation(id: UUID)
    case goal(id: UUID)
    case task(id: UUID)
    case project(id: UUID)
    case aiWork(id: UUID)
    case approval(id: UUID)
    case device(id: UUID)
    case artifact(id: UUID)

    // MARK: - Deep Link Bridging

    /// Convert a DeepLink push-notification route into a (primary destination,
    /// optional detail push) pair so the router can select the right section
    /// and push the detail in one step.
    static func from(deepLink: DeepLink) -> (nav: NavDestination, detail: DetailDestination?) {
        switch deepLink {
        case .chat(let id):      return (.chat,      .conversation(id: id))
        case .goal(let id):      return (.goals,     .goal(id: id))
        case .task(let id):      return (.work,      .task(id: id))
        case .project(let id):   return (.work,      .project(id: id))
        case .aiWork(let id):    return (.aiWork,    .aiWork(id: id))
        case .approval(let id):  return (.approvals, .approval(id: id))
        case .device(let id):    return (.devices,   .device(id: id))
        case .artifact(let id):  return (.today,     .artifact(id: id))
        case .today:             return (.today,     nil)
        case .notifications:     return (.notifications, nil)
        }
    }
}
