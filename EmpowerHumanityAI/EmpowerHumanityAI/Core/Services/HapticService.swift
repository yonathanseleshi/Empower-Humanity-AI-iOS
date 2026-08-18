import UIKit

final class HapticService {
    static let shared = HapticService()
    private init() {}

    // MARK: - Impact

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    // MARK: - Notification

    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    // MARK: - Selection

    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    // MARK: - Semantic Helpers

    func approvalConfirmed() {
        notification(.success)
    }

    func taskCompleted() {
        notification(.success)
    }

    func error() {
        notification(.error)
    }

    func keyStateTransition() {
        impact(.light)
    }

    func drawerOpened() {
        impact(.light)
    }

    func buttonTapped() {
        impact(.light)
    }
}
