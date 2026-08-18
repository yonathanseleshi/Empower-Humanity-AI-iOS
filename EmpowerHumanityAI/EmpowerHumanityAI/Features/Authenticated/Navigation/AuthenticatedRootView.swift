import SwiftUI

// MARK: - AuthenticatedRootView
// Compact (iPhone): overlay drawer using ZStack + offset animation + dimmed backdrop.
// Regular (iPad):   NavigationSplitView with persistent sidebar.
//
// Deep-link / notification routing:
//   Call navigate(to:) with a DetailDestination to push a detail view.
//   The nav section switches automatically via selectedDestination.

struct AuthenticatedRootView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedDestination: NavDestination = .today
    @State private var navigationPath = NavigationPath()
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
            // Main content with detail-route support
            NavigationStack(path: $navigationPath) {
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
                    .navigationDestination(for: DetailDestination.self) { destination in
                        detailView(destination)
                    }
            }
            .disabled(isDrawerOpen)

            // Dim backdrop
            if isDrawerOpen {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture { closeDrawer() }
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
                .onChange(of: selectedDestination) { _, _ in
                    // Reset detail stack when switching top-level sections
                    navigationPath = NavigationPath()
                    closeDrawer()
                }
        }
    }

    // MARK: - Regular Layout (iPad NavigationSplitView)

    private var regularLayout: some View {
        NavigationSplitView {
            SideMenuView(selectedDestination: $selectedDestination, isPresented: .constant(true))
                .navigationSplitViewColumnWidth(min: 240, ideal: 264, max: 300)
        } detail: {
            NavigationStack(path: $navigationPath) {
                destinationView(selectedDestination)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            orbButton
                        }
                    }
                    .navigationDestination(for: DetailDestination.self) { destination in
                        detailView(destination)
                    }
            }
            .onChange(of: selectedDestination) { _, _ in
                navigationPath = NavigationPath()
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

    // MARK: - Top-Level Destination Router

    @ViewBuilder
    private func destinationView(_ destination: NavDestination) -> some View {
        switch destination {
        case .today:         TodayView()
        case .chat:          ChatView()
        case .work:          WorkView()
        case .goals:         GoalsView()
        case .knowledge:     KnowledgeView()
        case .activity:      ActivityView()
        case .aiWork:        AIWorkView()
        case .approvals:     ApprovalsView()
        case .devices:       DevicesView()
        case .notifications: NotificationsView()
        case .integrations:  IntegrationsView()
        case .settings:      SettingsView()
        }
    }

    // MARK: - Detail View Router
    // Handles typed NavigationPath pushes (deep links, notification taps).
    // Extend each case when the corresponding detail screen is built.

    @ViewBuilder
    private func detailView(_ destination: DetailDestination) -> some View {
        switch destination {
        case .approval(let id):
            // TODO: replace placeholder with ApprovalDetailView(id: id) when built
            placeholderDetail(title: "Approval", id: id)
        case .aiWork(let id):
            placeholderDetail(title: "AI Work", id: id)
        case .goal(let id):
            placeholderDetail(title: "Goal", id: id)
        case .task(let id):
            placeholderDetail(title: "Task", id: id)
        case .project(let id):
            placeholderDetail(title: "Project", id: id)
        case .conversation(let id):
            placeholderDetail(title: "Conversation", id: id)
        case .device(let id):
            placeholderDetail(title: "Device", id: id)
        case .artifact(let id):
            placeholderDetail(title: "Artifact", id: id)
        }
    }

    private func placeholderDetail(title: String, id: UUID) -> some View {
        VStack(spacing: EHSpacing.md) {
            EHIconContainer(systemName: "arrow.forward.circle", color: EHColors.trustBlue, size: 52)
            Text(title)
                .font(EHTypography.h3)
                .foregroundStyle(EHColors.Text.primary)
            Text(id.uuidString)
                .font(EHTypography.caption)
                .foregroundStyle(EHColors.Text.subtle)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(EHColors.page)
        .navigationTitle(title)
    }

    // MARK: - Deep-Link / Notification Navigation
    // Call this to navigate to a specific detail from a push notification or activity tap.

    func navigate(deepLink: DeepLink) {
        let (navDest, detail) = DetailDestination.from(deepLink: deepLink)
        selectedDestination = navDest
        navigationPath = NavigationPath()
        if let detail {
            // Small delay so the section switch settles before pushing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                navigationPath.append(detail)
            }
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
