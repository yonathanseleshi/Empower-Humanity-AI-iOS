import SwiftUI

struct ChatView: View {
    @Environment(AppState.self) private var appState
    @State private var vm: ChatViewModel? = nil

    var body: some View {
        VStack(spacing: 0) {
            if let vm {
                if let conversation = vm.activeConversation {
                    conversationView(conversation: conversation, vm: vm)
                } else if vm.isLoading {
                    EHLoadingView()
                } else {
                    EHEmptyState(
                        systemImage: "message.circle",
                        title: "Start a conversation",
                        message: "Ask Alex anything — planning, decisions, research, or just thinking out loud.",
                        actionTitle: "Start conversation",
                        action: { Task { await startNewConversation(vm: vm) } }
                    )
                }
            }
        }
        .background(EHColors.page)
        .navigationTitle("Chat")
        .task {
            guard let userId = appState.currentUser?.id else { return }
            let viewModel = ChatViewModel(userId: userId)
            vm = viewModel
            await viewModel.load()
        }
    }

    // MARK: - Conversation View

    private func conversationView(conversation: Conversation, vm: ChatViewModel) -> some View {
        VStack(spacing: 0) {
            // Alex presence header
            alexHeader
                .padding(.horizontal, EHSpacing.screenHorizontal)
                .padding(.vertical, EHSpacing.sm)
                .background(EHColors.white)
                .overlay(alignment: .bottom) {
                    EHDivider()
                }

            // Message list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: EHSpacing.md) {
                        ForEach(conversation.messages) { message in
                            MessageRow(message: message)
                                .id(message.id)
                        }
                        if vm.isSending {
                            alexTypingIndicator
                        }
                    }
                    .padding(.horizontal, EHSpacing.screenHorizontal)
                    .padding(.vertical, EHSpacing.md)
                }
                .onChange(of: conversation.messages.count) { _, _ in
                    if let lastId = conversation.messages.last?.id {
                        withAnimation { proxy.scrollTo(lastId, anchor: .bottom) }
                    }
                }
            }

            // Composer
            composerBar(vm: vm)
        }
    }

    // MARK: - Alex Header

    private var alexHeader: some View {
        HStack(spacing: EHSpacing.sm) {
            CoIntelligenceOrb(state: appState.orbState, size: 36)
            VStack(alignment: .leading, spacing: 1) {
                Text(appState.coIntelligence?.displayName ?? "Alex")
                    .font(EHTypography.bodySmMedium)
                    .foregroundStyle(EHColors.Text.primary)
                Text("Your co-intelligence")
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.muted)
            }
            Spacer()
        }
    }

    // MARK: - Typing Indicator

    private var alexTypingIndicator: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(EHColors.Text.subtle)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(EHColors.surfaceMuted)
            .clipShape(RoundedRectangle(cornerRadius: EHRadius.lg))
            Spacer()
        }
    }

    // MARK: - Composer

    private func composerBar(vm: ChatViewModel) -> some View {
        HStack(spacing: EHSpacing.sm) {
            // Attachment
            Button { } label: {
                Image(systemName: "paperclip")
                    .font(.system(size: 17))
                    .foregroundStyle(EHColors.Text.muted)
            }

            // Text field
            TextField("Message Alex...", text: Binding(
                get: { vm.draftText },
                set: { vm.draftText = $0 }
            ), axis: .vertical)
            .font(EHTypography.bodyMd)
            .lineLimit(1...5)
            .padding(.horizontal, EHSpacing.sm)
            .padding(.vertical, EHSpacing.xs)
            .background(EHColors.surfaceMuted)
            .clipShape(RoundedRectangle(cornerRadius: EHRadius.pill))

            // Voice
            Button { } label: {
                Image(systemName: "mic")
                    .font(.system(size: 17))
                    .foregroundStyle(EHColors.Text.muted)
            }

            // Send
            Button {
                Task { await vm.sendMessage() }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(vm.draftText.isEmpty ? EHColors.border : EHColors.trustBlue)
            }
            .disabled(vm.draftText.isEmpty || vm.isSending)
        }
        .padding(.horizontal, EHSpacing.screenHorizontal)
        .padding(.vertical, EHSpacing.sm)
        .background(EHColors.white)
        .overlay(alignment: .top) { EHDivider() }
    }

    // MARK: - Helpers

    private func startNewConversation(vm: ChatViewModel) async {
        guard let userId = appState.currentUser?.id else { return }
        _ = try? await MockConversationRepository().startConversation(userId: userId, type: .general)
        await vm.load()
    }
}

// MARK: - MessageRow

struct MessageRow: View {
    let message: ConversationMessage

    var body: some View {
        if message.senderType == .human {
            humanBubble
        } else {
            alexMessage
        }
    }

    // MARK: Human — compact tinted bubble

    private var humanBubble: some View {
        HStack {
            Spacer(minLength: 60)
            Text(message.content)
                .font(EHTypography.bodyMd)
                .foregroundStyle(.white)
                .padding(.horizontal, EHSpacing.md)
                .padding(.vertical, EHSpacing.sm)
                .background(EHColors.trustBlue)
                .clipShape(RoundedRectangle(cornerRadius: EHRadius.xl))
        }
    }

    // MARK: Alex — open layout with optional rich card

    private var alexMessage: some View {
        HStack(alignment: .top, spacing: EHSpacing.xs) {
            VStack(alignment: .leading, spacing: EHSpacing.sm) {
                if !message.content.isEmpty && message.messageType == .text {
                    Text(message.content)
                        .font(EHTypography.bodyMd)
                        .foregroundStyle(EHColors.Text.primary)
                }
                if let card = message.richCard {
                    richCardView(card)
                }
                Text(message.createdAt.timeString)
                    .font(EHTypography.caption)
                    .foregroundStyle(EHColors.Text.subtle)
            }
            Spacer(minLength: 40)
        }
    }

    @ViewBuilder
    private func richCardView(_ card: RichCard) -> some View {
        switch card {
        case .approval(let approval):
            ApprovalResponseCard(approval: approval)
        case .aiWork(let work):
            AIWorkResponseCard(work: work)
        case .goal(let goal):
            GoalResponseCard(goal: goal)
        case .task(let task):
            TaskResponseCard(task: task)
        case .plan(let plan):
            PlanResponseCard(plan: plan)
        case .decision(let decision):
            DecisionResponseCard(decision: decision)
        case .recommendation(let recommendation):
            RecommendationResponseCard(recommendation: recommendation)
        }
    }
}
