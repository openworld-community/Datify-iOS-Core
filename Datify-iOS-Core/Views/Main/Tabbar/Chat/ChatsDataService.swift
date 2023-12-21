//
//  ChatsDataService.swift
//  Datify-iOS-Core
//
//  Created by Илья on 21.11.2023.
//

import Foundation
import Combine

final class ChatsDataService: ObservableObject {
    @Published var allChats: [ChatModel] = []
    @Published var loadingState: LoadingState = .idle
    private var cancellables: Set<AnyCancellable>?

    func getData(userID: String) async throws {
        self.loadingState = .loading
        if userID != "" {
            generateChatModels()
        }
        self.loadingState = .success
        // TODO: Func to fetch all chats where participants.contains(userID)
    }

    private func createChatExamples(userID: String) {
        let chat1 = ChatModel(participantId1: userID, participantId2: "1", messages: createSampleMessages(for: ["0", "1"]))
        let chat2 = ChatModel(participantId1: userID, participantId2: "2", messages: createSampleMessages(for: ["0", "2"]))
        let chat3 = ChatModel(participantId1: userID, participantId2: "3", messages: createSampleMessages(for: ["0", "3"]))

        allChats = [chat1, chat2, chat3]
    }

    private func createSampleMessages(for participants: [String]) -> [MessageModel] {
        let message1 = MessageModel(sender: participants[0],
                                    message: "A simple test message 1", date: Date(), status: .received)
        let message2 = MessageModel(sender: participants[1],
                                    message: "Another simple test message", date: Date(), status: .sent)

        return [message1, message2]
    }

    // Function to generate 20 chat models
    private func generateChatModels() {
        var chatModels = [ChatModel]()

        for _ in 1...20 {
            let randomParticipantId = ["1", "2", "3"].randomElement()!
            let randomMessageStatus = MessageModel.MessageStatus.allCases.randomElement()!
            let randomMessageModel = MessageModel(sender: [randomParticipantId, "0"].randomElement()!,
                                                  message: "Some random message Some random message Some random message ",
                                                  date: Date(),
                                                  status: randomMessageStatus)
            let chatModel = ChatModel(participantId1: "0", participantId2: randomParticipantId, messages: [randomMessageModel])
            chatModels.append(chatModel)
        }

        self.allChats = chatModels
    }
}
