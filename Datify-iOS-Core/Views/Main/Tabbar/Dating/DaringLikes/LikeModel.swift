//
//  LikeModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import Foundation

struct LikeModel: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let senderID: String
    let receiverID: String
    let date: Date
    private(set) var isNew: Bool = true

    mutating func isViewed() {
        self.isNew = false
    }
}
