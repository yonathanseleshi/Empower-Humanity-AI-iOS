import SwiftUI

// MARK: - AuthenticatedRootView
// Compact (iPhone): overlay drawer using ZStack + offset animation + dimmed backdrop.
// Regular (iPad): NavigationSplitView with persistent sidebar.

struct AuthenticatedRootView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedDestination: NavDestination = .today
    @State private var isDrawerOpen: Bool = false
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        if sizeClass == .compact {
            compactLayout
        } else {
            regularLayout
        }
    }

    // MARK: - Compact Layout (iPhone overlay drawer)

    private var compactLayout: some View {
        ZStack(alignment: .leading) {
            // Main content
            NavigationStack {
                destinationView(selectedDestination)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            menuButton
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            orbButton
                        }
                    }
            }
            .disabled(isDrawerOpen)

            // Dim backdrop
            if isDrawerOpen {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        closeDrawer()
                    }
                    .transition(.opacity)
                    .zIndex(1)
            }

            // Drawer panel
            SideMenuView(selectedDestination: $selectedDestination, isPresented: $isDrawerOpen)
                .shadow(color: .black.opacity(0.18), radius: 20, x: 4, y: 0)
                .offset(x: isDrawerOpen ? 0 : -320)
                .animation(.easeInOut(duration: 0.28), value: isDrawerOpen)
                .ignoresSafeArea()
                .zIndex(2)
        }
    }

    // MARK: - Regular Layout (iPad NavigationSplitView)

    private var regularLayout: some View {
        NavigationSplitView {
            SideMenuView(selectedDestination: $selectedDestination, isPresented: .constant(true))
                .navigationSplitViewColumnWidth(min: 240, ideal: 264, max: 300)
        } detail: {
            NavigationStack {
                destinationView(selectedDestination)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            orbButton
                        }
                    }
            }
        }
    }

    // MARK: - Toolbar Buttons

    private var menuButton: some View {
        Button {
            openDrawer()
        } label: {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(EHColors.Text.primary)
        }
    }

    private var orbButton: some View {
        CoIntelligenceOrb(state: appState.orbState, size: 30)
    }

    // MARK: - Destination Router

    @ViewBuilder
    private func destinationView(_ destination: NavDestination) -> some View {
        switch destination {
        case .today:       TodayView()
        case .chat:        ChatView()
        case .work:        WorkView()
        case .goals:       GoalsView()
        case .knowledge:   KnowledgeView()
        case .activity:    ActivityView()
        case .aiWork:      AIWorkView()
        case .approvals:   ApprovalsView()
        case .devices:     DevicesView()
        case .notifications: NotificationsView()
        case .integrations: IntegrationsView()
        case .settings:    SettingsView()
        }
    }

    // MARK: - Helpers

    private func openDrawer() {
        HapticService.shared.drawerOpened()
        withAnimation(.easeInOut(duration: 0.28)) {
            isDrawerOpen = true
        }
    }

    private func closeDrawer() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isDrawerOpen = false
        }
    }
}
