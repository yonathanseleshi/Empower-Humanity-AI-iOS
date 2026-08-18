import Foundation
import LocalAuthentication

// MARK: - BiometricType

enum BiometricType: Equatable, Hashable {
    case faceID, touchID, devicePasscode, none

    var displayName: String {
        switch self {
        case .faceID:          return "Face ID"
        case .touchID:         return "Touch ID"
        case .devicePasscode:  return "Device Passcode"
        case .none:            return "Not available"
        }
    }

    var isAvailable: Bool { self != .none }
}

// MARK: - BiometricApprovalService
// Provides device authentication using LocalAuthentication for sensitive
// approval actions that policy requires the human to explicitly confirm.
//
// Not all approval actions require biometric confirmation — only those
// where the system policy (set by the user in Autonomy Settings) mandates it.
//
// Full biometric prompting requires:
//   - NSFaceIDUsageDescription in Info.plist (present)
//   - A real device with Face ID / Touch ID enrolled
//   - A signed development team / provisioning profile
//
// On the Simulator, deviceOwnerAuthentication falls back to the Simulator
// PIN/password prompt. If no authentication is configured, authentication
// will fail and the caller must handle this gracefully.

final class BiometricApprovalService {
    static let shared = BiometricApprovalService()
    private init() {}

    // MARK: - Available Type

    var availableBiometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
                ? .devicePasscode
                : .none
        }
        switch context.biometryType {
        case .faceID:   return .faceID
        case .touchID:  return .touchID
        default:        return .devicePasscode
        }
    }

    var isBiometricAvailable: Bool {
        availableBiometricType.isAvailable
    }

    // MARK: - Authenticate

    /// Requests device owner authentication (biometric or passcode).
    /// Returns `false` if authentication is unavailable or the user cancels.
    /// Never returns `true` without real system authentication on a device
    /// or Simulator that has authentication configured.
    func authenticate(reason: String) async -> Bool {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            // Device has no authentication configured — cannot authenticate.
            // Do NOT silently approve; return false so the caller can decide.
            return false
        }
        do {
            return try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
        } catch {
            return false
        }
    }

    // MARK: - Approval Authentication

    /// Authenticate specifically to confirm an approval request.
    /// Only call this when the relevant autonomy policy requires confirmation.
    func authenticateForApproval(_ approval: ApprovalRequest) async -> Bool {
        let reason = "Confirm approval: \(approval.title)"
        return await authenticate(reason: reason)
    }
}
