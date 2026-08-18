import Foundation
import UserNotifications
import Observation

// MARK: - PushNotificationService
// APNs architecture prepared. No real APNs credentials required at this stage.

@Observable
final class PushNotificationService: NSObject {
    static let shared = PushNotificationService()

    var isAuthorized: Bool = false
    var deviceToken: String?

    private override init() {
        super.init()
    }

    // MARK: - Authorization

    func requestAuthorization() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            await MainActor.run {
                self.isAuthorized = granted
            }
            if granted {
                await registerForRemoteNotifications()
            }
        } catch {
            print("[PushNotificationService] Authorization failed: \(error)")
        }
    }

    @MainActor
    private func registerForRemoteNotifications() async {
        // Future: UIApplication.shared.registerForRemoteNotifications()
        // Device token received in AppDelegate/SceneDelegate
    }

    // MARK: - Token Registration

    func didRegisterForRemoteNotifications(deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        self.deviceToken = tokenString
        // Future: Send token to NestJS Core API
        print("[PushNotificationService] Device token: \(tokenString)")
    }

    func didFailToRegisterForRemoteNotifications(error: Error) {
        print("[PushNotificationService] Registration failed: \(error)")
    }

    // MARK: - Local Notification (for demo purposes)

    func scheduleLocalNotification(title: String, body: String, delay: TimeInterval = 1.0) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(delay, 0.1), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[PushNotificationService] Local notification error: \(error)")
            }
        }
    }
}
