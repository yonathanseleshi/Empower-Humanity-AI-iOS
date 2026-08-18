import SwiftUI

@main
struct EmpowerHumanityAIApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            AppRouter()
                .environment(appState)
                .preferredColorScheme(.light)
        }
    }
}
