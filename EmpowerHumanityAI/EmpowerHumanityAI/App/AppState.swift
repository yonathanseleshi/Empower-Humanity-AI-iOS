import Foundation
import Observation
import SwiftUI

// MARK: - Auth State

enum AuthState: Equatable, Hashable {
    case unauthenticated
    case authenticated
}

// MARK: - AppState
// Global concerns only: authentication, access tier, current user,
// primary co-intelligence identity, AI pause state, and routing state.
// Feature data belongs in repositories and ViewModels.

@Observable
final class AppState {

    // MARK: - Auth

    /// Always starts unauthenticated. Use the "Explore Demo" action in
    /// Debug builds (LandingView) or sign in normally.
    var authState: AuthState = .unauthenticated
    var currentUser: UserAccount? = nil
    var coIntelligence: PrimaryCoIntelligence? = nil

    // MARK: - Access

    /// Routing is determined by this tier (see AppRouter).
    /// Public and Waitlist → AccessStatusView.
    /// ApprovedBeta, FounderAccess, DesignPartner, Subscriber → AuthenticatedRootView.
    var accessTier: AccessTier = .public

    // MARK: - Co-Intelligence State

    var orbState: OrbState = .available
    var isPausingAIActions: Bool = false

    // MARK: - Auth Actions

    /// Sign in with email/password. Mock implementation — replace with real API call.
    func signIn(email: String, password: String) async {
        try? await Task.sleep(for: .seconds(1))
        currentUser = MockData.benAccount
        coIntelligence = MockData.alexCoIntelligence
        accessTier = .founderAccess
        withAnimation(.easeInOut(duration: 0.3)) {
            authState = .authenticated
        }
    }

    /// Sign up. New accounts land on Waitlist by default → AccessStatusView.
    func signUp(name: String, email: String, password: String) async -> AccessTier {
        try? await Task.sleep(for: .seconds(1.5))
        currentUser = MockData.benAccount
        coIntelligence = MockData.alexCoIntelligence
        accessTier = .waitlist
        withAnimation(.easeInOut(duration: 0.3)) {
            authState = .authenticated
        }
        return .waitlist
    }

    func signOut() {
        withAnimation(.easeInOut(duration: 0.3)) {
            authState = .unauthenticated
            currentUser = nil
            coIntelligence = nil
            accessTier = .public
        }
    }

    // MARK: - Debug Demo

    #if DEBUG
    /// Load the Ben/Alex demo session. Only available in Debug builds.
    func loadDemoSession() async {
        try? await Task.sleep(for: .milliseconds(600))
        currentUser = MockData.benAccount
        coIntelligence = MockData.alexCoIntelligence
        accessTier = .founderAccess
        withAnimation(.easeInOut(duration: 0.3)) {
            authState = .authenticated
        }
    }
    #endif
}
