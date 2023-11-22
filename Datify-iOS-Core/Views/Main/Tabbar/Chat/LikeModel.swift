//
//  LikeModel.swift
//  Datify-iOS-Core
//
//  Created by Илья on 22.11.2023.
//

import Foundation

struct LikeModel: Identifiable, Codable {
    private(set) var id: String = UUID().uuidString
    let receiverId: String
    let senderId: String
    private(set) var isNew: Bool = false

    static let likeExamples: [LikeModel] = [
        LikeModel(id: "001", receiverId: "0", senderId: "1", isNew: true),
        LikeModel(id: "002", receiverId: "0", senderId: "2", isNew: true),
        LikeModel(id: "003", receiverId: "0", senderId: "3", isNew: false)
    ]
}
