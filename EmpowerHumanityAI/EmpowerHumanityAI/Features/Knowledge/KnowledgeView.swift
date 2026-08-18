import SwiftUI

struct KnowledgeView: View {
    @Environment(AppState.self) private var appState
    @State private var items: [KnowledgeItem] = []
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var selectedType: KnowledgeType? = nil

    private var filtered: [KnowledgeItem] {
        var result = items
        if let type = selectedType { result = result.filter { $0.type == type } }
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.summary.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        VStack(spacing: 0) {
            // Type filter chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: EHSpacing.xs) {
                    filterChip(title: "All", isSelected: selectedType == nil) { selectedType = nil }
                    ForEach(KnowledgeType.allCases, id: \.self) { type in
                        filterChip(title: type.displayName, isSelected: selectedType == type) { selectedType = type }
                    }
                }
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.sm)
            }
            .background(EHColors.white)

            EHDivider()

            ScrollView {
                LazyVStack(spacing: EHSpacing.sm) {
                    if isLoading {
                        EHLoadingView().frame(height: 300)
                    } else if filtered.isEmpty {
                        EHEmptyState(systemImage: "books.vertical", title: "Nothing found", message: "Knowledge grows as Alex works for you — research, reports, and documents land here.")
                    } else {
                        ForEach(filtered) { item in
                            knowledgeCard(item)
                        }
                    }
                }
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.md)
            }
        }
        .background(EHColors.page)
        .navigationTitle("Knowledge")
        .searchable(text: $searchText, prompt: "Search knowledge...")
        .task {
            guard let userId = appState.currentUser?.id else { return }
            isLoading = true
            items = (try? await MockKnowledgeRepository().getKnowledgeItems(userId: userId)) ?? []
            isLoading = false
        }
    }

    private func knowledgeCard(_ item: KnowledgeItem) -> some View {
        HStack(alignment: .top, spacing: EHSpacing.sm) {
            EHIconContainer(systemName: item.type.icon, color: EHColors.intelligenceIndigo, size: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                Text(item.summary)
                    .font(EHTypography.bodySm)
                    .foregroundStyle(EHColors.Text.muted)
                    .lineLimit(2)
                HStack(spacing: EHSpacing.xxs) {
                    ForEach(item.tags.prefix(3), id: \.self) { tag in
                        EHStatusBadge(label: tag, color: EHColors.trustBlue)
                    }
                }
            }
            Spacer()
        }
        .padding(EHSpacing.cardPadding)
        .ehCard(level: 1)
    }

    private func filterChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(EHTypography.label)
                .foregroundStyle(isSelected ? .white : EHColors.Text.secondary)
                .padding(.horizontal, EHSpacing.sm)
                .padding(.vertical, EHSpacing.xxs)
                .background(isSelected ? EHColors.trustBlue : EHColors.surfaceMuted)
                .clipShape(Capsule())
        }
    }
}
