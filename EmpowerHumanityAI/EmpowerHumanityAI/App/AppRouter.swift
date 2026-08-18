import SwiftUI

// MARK: - AppRouter
// Centralized routing based on auth state and access tier.
// No access checks should be scattered through feature Views.
//
// Canonical routing table:
//   Unauthenticated              → PublicNavigationRoot (Landing)
//   Authenticated + Public       → RestrictedNavigationRoot (AccessStatusView)
//   Authenticated + Waitlist     → RestrictedNavigationRoot (AccessStatusView)
//   Authenticated + ApprovedBeta → AuthenticatedRootView
//   Authenticated + FounderAccess → AuthenticatedRootView
//   Authenticated + DesignPartner → AuthenticatedRootView
//   Authenticated + Subscriber   → AuthenticatedRootView

struct AppRouter: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        switch appState.authState {
        case .unauthenticated:
            PublicNavigationRoot()

        case .authenticated:
            if appState.accessTier.hasFullAccess {
                AuthenticatedRootView()
            } else {
                RestrictedNavigationRoot()
            }
        }
    }
}

// MARK: - PublicNavigationRoot

struct PublicNavigationRoot: View {
    var body: some View {
        NavigationStack {
            LandingView()
        }
    }
}

// MARK: - RestrictedNavigationRoot
// Shown to authenticated users without full access (Public / Waitlist tiers).
// Provides sign-out and, in Debug builds, a shortcut to the full demo.

struct RestrictedNavigationRoot: View {
    var body: some View {
        NavigationStack {
            AccessStatusView()
        }
    }
}
