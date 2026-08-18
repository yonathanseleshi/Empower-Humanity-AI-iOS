import Foundation

// MARK: - NavDestination
// The primary navigation items for the authenticated drawer/sidebar.

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
        case .today: return "Today"
        case .chat: return "Chat"
        case .work: return "Work"
        case .goals: return "Goals"
        case .knowledge: return "Knowledge"
        case .activity: return "Activity"
        case .aiWork: return "AI Work"
        case .approvals: return "Approvals"
        case .devices: return "Devices"
        case .notifications: return "Notifications"
        case .integrations: return "Integrations"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .today: return "sun.max"
        case .chat: return "message.circle"
        case .work: return "square.and.pencil"
        case .goals: return "target"
        case .knowledge: return "books.vertical"
        case .activity: return "chart.xyaxis.line"
        case .aiWork: return "bolt.fill"
        case .approvals: return "shield.checkered"
        case .devices: return "laptopcomputer.and.iphone"
        case .notifications: return "bell"
        case .integrations: return "puzzlepiece.extension"
        case .settings: return "gear"
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
