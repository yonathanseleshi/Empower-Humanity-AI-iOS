import SwiftUI

struct AppRouter: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        switch appState.authState {
        case .unauthenticated:
            PublicNavigationRoot()
        case .authenticated:
            AuthenticatedRootView()
        }
    }
}

struct PublicNavigationRoot: View {
    var body: some View {
        NavigationStack {
            LandingView()
        }
    }
}
