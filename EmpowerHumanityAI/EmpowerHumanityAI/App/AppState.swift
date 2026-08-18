import Foundation
import Observation
import SwiftUI

enum AuthState: Equatable, Hashable {
    case unauthenticated
    case authenticated
}

@Observable
final class AppState {
    // MARK: - Auth
    var authState: AuthState = {
        #if DEBUG
        return .authenticated
        #else
        return .unauthenticated
        #endif
    }()

    var currentUser: UserAccount? = {
        #if DEBUG
        return MockData.benAccount
        #else
        return nil
        #endif
    }()

    var coIntelligence: PrimaryCoIntelligence? = {
        #if DEBUG
        return MockData.alexCoIntelligence
        #else
        return nil
        #endif
    }()

    var accessTier: AccessTier = {
        #if DEBUG
        return .founderAccess
        #else
        return .public
        #endif
    }()

    var orbState: OrbState = .available
    var isPausingAIActions: Bool = false

    // MARK: - Auth Actions
    func signIn(email: String, password: String) async {
        // Mock auth — replace with real implementation
        try? await Task.sleep(for: .seconds(1))
        currentUser = MockData.benAccount
        coIntelligence = MockData.alexCoIntelligence
        accessTier = .founderAccess
        withAnimation(.easeInOut(duration: 0.3)) {
            authState = .authenticated
        }
    }

    func signOut() {
        withAnimation(.easeInOut(duration: 0.3)) {
            authState = .unauthenticated
            currentUser = nil
            coIntelligence = nil
            accessTier = .public
        }
    }

    func signUp(name: String, email: String, password: String) async -> AccessTier {
        // Mock signup — replace with real implementation
        try? await Task.sleep(for: .seconds(1.5))
        currentUser = MockData.benAccount
        coIntelligence = MockData.alexCoIntelligence
        accessTier = .waitlist
        authState = .authenticated
        return .waitlist
    }
}
