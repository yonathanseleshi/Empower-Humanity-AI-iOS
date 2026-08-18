import Foundation
import Observation

@Observable
final class ChatViewModel {
    var conversations: [Conversation] = []
    var activeConversation: Conversation? = nil
    var isLoading: Bool = false
    var isSending: Bool = false
    var draftText: String = ""
    var error: String? = nil

    private let conversationRepo: any ConversationRepository
    private let userId: UUID

    init(userId: UUID, conversationRepo: any ConversationRepository = MockConversationRepository()) {
        self.userId = userId
        self.conversationRepo = conversationRepo
    }

    @MainActor
    func load() async {
        isLoading = true
        do {
            conversations = try await conversationRepo.getConversations(userId: userId)
            activeConversation = conversations.first
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func sendMessage() async {
        let text = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, let convId = activeConversation?.id else { return }
        draftText = ""
        isSending = true
        do {
            let message = try await conversationRepo.sendMessage(text, conversationId: convId)
            if let idx = conversations.firstIndex(where: { $0.id == convId }) {
                conversations[idx].messages.append(message)
            }
            activeConversation?.messages.append(message)
            // Simulate Alex response
            try? await Task.sleep(for: .seconds(1.5))
            let alexMsg = ConversationMessage(
                id: UUID(), conversationId: convId, senderType: .coIntelligence,
                messageType: .text,
                content: "I heard you. Let me look into that now.",
                createdAt: Date(), sequenceNumber: (activeConversation?.messages.count ?? 0) + 1, richCard: nil
            )
            activeConversation?.messages.append(alexMsg)
            if let idx = conversations.firstIndex(where: { $0.id == convId }) {
                conversations[idx].messages.append(alexMsg)
            }
        } catch {
            self.error = error.localizedDescription
        }
        isSending = false
    }

    @MainActor
    func selectConversation(_ conversation: Conversation) {
        activeConversation = conversation
    }
}
