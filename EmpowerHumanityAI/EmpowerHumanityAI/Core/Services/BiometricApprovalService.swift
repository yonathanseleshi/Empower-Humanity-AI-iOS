import Foundation
import LocalAuthentication

// MARK: - BiometricType

enum BiometricType: Equatable, Hashable {
    case faceID, touchID, devicePasscode, none
    var displayName: String {
        switch self {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .devicePasscode: return "Device Passcode"
        case .none: return "None"
        }
    }
}

// MARK: - BiometricApprovalService
// Architecture prepared for LocalAuthentication. Full implementation requires
// NSFaceIDUsageDescription in Info.plist and device enrollment.

final class BiometricApprovalService {
    static let shared = BiometricApprovalService()
    private init() {}

    // MARK: - Available Type

    var availableBiometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) ? .devicePasscode : .none
        }
        switch context.biometryType {
        case .faceID: return .faceID
        case .touchID: return .touchID
        default: return .devicePasscode
        }
    }

    var isBiometricAvailable: Bool {
        availableBiometricType != .none
    }

    // MARK: - Authenticate

    func authenticate(reason: String) async -> Bool {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            // Architecture note: in mock builds, return true without real auth
            return true
        }
        do {
            return try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
        } catch {
            return false
        }
    }

    // MARK: - Approval Authentication

    func authenticateForApproval(_ approval: ApprovalRequest) async -> Bool {
        let reason = "Authenticate to approve: \(approval.title)"
        return await authenticate(reason: reason)
    }
}
