//
//  MessangerViewModel.swift
//  Datify-iOS-Core
//
//  Created by Илья on 14.12.2023.
//

import Foundation
import Combine

enum ActionType {
    case reply, edit
}

class MessengerViewModel: ObservableObject {
    @Published var currentUser: TempUserModel? = TempUserModel.defaultUser
    @Published var interlocutor: TempUserModel?
    @Published var chat: ChatModel?
    @Published var messages: [MessageModel] = [
        MessageModel(id: "replyMe", sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read, replyMessage: "replyMe"),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Adfsfsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "You are my special ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Adfsfsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "You are my special ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Adfsfsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "You are my special ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Adfsfsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "You are my special ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Adfsfsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "You are my special ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Adfsfsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d  gfasd as d", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "You are my special ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd ", date: Date(), status: .read, replyMessage: "replyMe"),
        MessageModel(sender: "0", message: "Afsdf as d  gfasd Afsdf as d  gfasd as d  gfasd as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read),
        MessageModel(sender: "1", message: "Afsdf as d  gfasd ", date: Date(), status: .read, replyMessage: "replyMe")
    ]

    @Published var textfieldMessage: String = ""
    @Published var actionMessageText: String = ""
    @Published var actionType: ActionType?
    @Published var actionMessage: MessageModel?

    @Published var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }

    func addSubscribers() {
        $actionMessage
            .sink { message in
                print(message?.id ?? "No action message")
            }
            .store(in: &cancellables)
    }

    func groupMessagesByUser() -> [[MessageModel]] {
        let sortedMessages = messages.sorted { $0.date < $1.date }

        var groupedMessages: [[MessageModel]] = []
        var currentGroup: [MessageModel] = []

        for message in sortedMessages {
            if currentGroup.isEmpty || currentGroup.last?.sender == message.sender {
                currentGroup.append(message)
            } else {
                groupedMessages.append(currentGroup)
                currentGroup = [message]
            }
        }

        if !currentGroup.isEmpty {
            groupedMessages.append(currentGroup)
        }

        return groupedMessages
    }
}
