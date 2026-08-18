import SwiftUI

struct ActivityView: View {
    @Environment(AppState.self) private var appState
    @State private var events: [ActivityEvent] = []
    @State private var isLoading = false
    @State private var filterActor: ActivityActor? = nil

    private var filtered: [ActivityEvent] {
        guard let actor = filterActor else { return events }
        return events.filter { $0.actor == actor }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Actor filter
            Picker("Activity", selection: $filterActor) {
                Text("All").tag(ActivityActor?.none)
                Text("You").tag(ActivityActor?.some(.human))
                Text("Alex").tag(ActivityActor?.some(.coIntelligence))
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, EHSpacing.screenHorizontal)
            .padding(.vertical, EHSpacing.sm)
            .background(EHColors.white)

            EHDivider()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    if isLoading {
                        EHLoadingView().frame(height: 300)
                    } else if filtered.isEmpty {
                        EHEmptyState(systemImage: "chart.xyaxis.line", title: "No activity yet", message: "Your combined activity with Alex will appear here.")
                    } else {
                        ForEach(filtered) { event in
                            eventRow(event)
                            if event.id != filtered.last?.id {
                                HStack {
                                    Rectangle()
                                        .fill(EHColors.border)
                                        .frame(width: 1)
                                        .frame(height: 20)
                                        .padding(.leading, EHSpacing.screenHorizontal + 16)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, EHSpacing.md)
            }
        }
        .background(EHColors.page)
        .navigationTitle("Activity")
        .task {
            guard let userId = appState.currentUser?.id else { return }
            isLoading = true
            events = (try? await MockActivityRepository().getActivity(userId: userId)) ?? []
            isLoading = false
        }
    }

    private func eventRow(_ event: ActivityEvent) -> some View {
        HStack(alignment: .top, spacing: EHSpacing.sm) {
            // Timeline dot
            ZStack {
                Circle()
                    .fill(event.actor == .coIntelligence ? EHColors.intelligenceIndigo : EHColors.trustBlue)
                    .frame(width: 32, height: 32)
                Image(systemName: event.eventType.icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                if !event.description.isEmpty {
                    Text(event.description)
                        .font(EHTypography.bodySm)
                        .foregroundStyle(EHColors.Text.muted)
                        .lineLimit(2)
                }
                Text(event.occurredAt.relativeString)
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.subtle)
            }

            Spacer()
        }
        .padding(.horizontal, EHSpacing.screenHorizontal)
        .padding(.vertical, EHSpacing.sm)
    }
}
