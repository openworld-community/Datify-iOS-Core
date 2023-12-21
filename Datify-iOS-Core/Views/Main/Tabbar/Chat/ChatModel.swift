//
//  ChatModel.swift
//  Datify-iOS-Core
//
//  Created by Илья on 20.11.2023.
//

import Foundation

struct ChatModel: Identifiable {
    let id: String = UUID().uuidString
    let participantId1: String
    let participantId2: String
    let messages: [MessageModel]
    let lastMessage: MessageModel?

    init(participantId1: String, participantId2: String, messages: [MessageModel]) {
        self.participantId1 = participantId1
        self.participantId2 = participantId2
        self.messages = messages
        self.lastMessage = messages.last
    }
}

struct MessageModel: Identifiable, Hashable {
    let id: String
    let sender: String
    let message: String
    let date: Date
    let status: MessageStatus
    let replyMessage: String?

    init(id: String = UUID().uuidString, sender: String, message: String, date: Date, status: MessageStatus, replyMessage: String? = nil) {
        self.id = id
        self.sender = sender
        self.message = message
        self.date = date
        self.status = status
        self.replyMessage = replyMessage
    }

    enum MessageStatus: CaseIterable {
        case sending, sent, received, read
    }
}
