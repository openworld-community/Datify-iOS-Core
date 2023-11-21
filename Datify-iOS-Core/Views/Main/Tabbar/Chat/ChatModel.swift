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
}

struct MessageModel: Identifiable {
    let id: String = UUID().uuidString
    let sender: String
    let message: String
    let date: Date
    let status: MessageStatus

    enum MessageStatus: CaseIterable {
        case sending, sent, received, read
    }

    func dateToTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
