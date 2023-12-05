//
//  LikesDataService.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import Foundation
import Combine

class LikesDataService: ObservableObject {
    @Published var allLikes: [LikeModel]?
    private var cancellables: Set<AnyCancellable>?

    init(userID: String) {
        Task {
            await getData(userID: userID)
        }
    }

    func getData(userID: String) async {
        // TODO: Func of receiving user likes from the server where the user is the sender and recipient
        getReceivedLikes(userID: userID)
        getMyLikes(userID: userID)
    }

    func getReceivedLikes(userID: String) {
        var receivedLikes: [LikeModel] = []
        for i in 1...10 {
            let like = LikeModel(
                senderID: String(i),
                receiverID: userID,
                date: randomDate())
            receivedLikes.append(like)
        }
        allLikes = receivedLikes
    }

    func getMyLikes(userID: String) {
        var myLike: [LikeModel] = []
        for i in 1...20 {
            let like = LikeModel(
                senderID: userID,
                receiverID: String(i),
                date: randomDate())
            myLike.append(like)
        }
        allLikes?.append(contentsOf: myLike)
    }

    func randomDate() -> Date {
        let startDate = Date().addingTimeInterval(-60 * 60 * 24 * 60) // 2 months ago
        let endDate = Date() // now
        let randomTime = TimeInterval.random(in: startDate.timeIntervalSince1970...endDate.timeIntervalSince1970)
        return Date(timeIntervalSince1970: randomTime)
    }
}
