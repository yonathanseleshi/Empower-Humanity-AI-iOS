import SwiftUI

struct WorkView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedSegment: WorkSegment = .tasks
    @State private var tasks: [EHTask] = []
    @State private var projects: [Project] = []
    @State private var decisions: [Decision] = []
    @State private var plans: [Plan] = []
    @State private var isLoading = false

    enum WorkSegment: String, CaseIterable {
        case tasks = "Tasks"
        case projects = "Projects"
        case decisions = "Decisions"
        case plans = "Plans"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Segment control
            Picker("Work", selection: $selectedSegment) {
                ForEach(WorkSegment.allCases, id: \.self) { seg in
                    Text(seg.rawValue).tag(seg)
                }
            }
            .pickerStyle(.segmented)
            .padding(EHSpacing.screenHorizontal)
            .padding(.top, EHSpacing.sm)
            .background(EHColors.white)

            EHDivider()

            ScrollView {
                LazyVStack(spacing: EHSpacing.sm) {
                    switch selectedSegment {
                    case .tasks:
                        if tasks.isEmpty && !isLoading {
                            EHEmptyState(systemImage: "checkmark.square", title: "No tasks yet", message: "Ask Alex to help you plan tasks aligned to your goals.")
                        } else {
                            ForEach(tasks) { task in taskCard(task) }
                        }
                    case .projects:
                        if projects.isEmpty {
                            EHEmptyState(systemImage: "folder", title: "No projects yet", message: "Create a project to organise related tasks and work.")
                        }
                    case .decisions:
                        if decisions.isEmpty {
                            EHEmptyState(systemImage: "arrow.triangle.branch", title: "No decisions yet", message: "Log decisions here to build institutional memory.")
                        }
                    case .plans:
                        if plans.isEmpty {
                            EHEmptyState(systemImage: "map", title: "No plans yet", message: "Ask Alex to help you create a structured plan for a goal.")
                        }
                    }
                }
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.md)
            }
        }
        .background(EHColors.page)
        .navigationTitle("Work")
        .task {
            await loadData()
        }
    }

    private func taskCard(_ task: EHTask) -> some View {
        HStack(alignment: .top, spacing: EHSpacing.sm) {
            Image(systemName: task.status == .completed ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.status == .completed ? EHColors.progressGreen : EHColors.border)
                .font(.system(size: 20))
                .padding(.top, 1)
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                    .strikethrough(task.status == .completed)
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(EHTypography.caption)
                        .foregroundStyle(EHColors.Text.muted)
                        .lineLimit(2)
                }
                HStack(spacing: EHSpacing.xs) {
                    EHStatusBadge(label: task.priority.displayName, color: task.priority == .high ? EHColors.orange : EHColors.Text.muted)
                    if let due = task.dueDate {
                        EHStatusBadge(label: due.dayLabel, color: EHColors.trustBlue)
                    }
                }
            }
            Spacer()
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }

    private func loadData() async {
        guard let userId = appState.currentUser?.id else { return }
        isLoading = true
        tasks = (try? await MockTasksRepository().getTasks(userId: userId)) ?? []
        projects = (try? await MockProjectsRepository().getProjects(userId: userId)) ?? []
        decisions = (try? await MockDecisionsRepository().getDecisions(userId: userId)) ?? []
        plans = (try? await MockPlansRepository().getPlans(userId: userId)) ?? []
        isLoading = false
    }
}
