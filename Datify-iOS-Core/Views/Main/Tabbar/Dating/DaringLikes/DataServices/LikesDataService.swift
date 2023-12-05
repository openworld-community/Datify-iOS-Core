//
//  LikesDataService.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import Foundation
import Combine

class LikesDataService: ObservableObject {
    static var shared = LikesDataService()
    @Published var allLikes: [LikeModel]?

    func getData(userID: String) async {
        // TODO: Func of receiving user likes from the server where the user is the sender and recipient
        createTempLikes(userID: userID)
    }

    func deleteLike(likeId: String) {
        // TODO: Func delete like
        if let allLikes {
            for index in allLikes.indices {
                if allLikes[index].id == likeId {
                    self.allLikes?.remove(at: index)
               }
           }
        }
    }

    func createLike(senderID: String, receiverID: String) {
        // TODO: Func create like
        var newLike = LikeModel(senderID: senderID, receiverID: receiverID, date: Date())
        allLikes?.append(newLike)
    }

    func likeIsViewed(likeId: String) {
        // TODO: Func changes like to viewed
        if let allLikes {
            for index in allLikes.indices {
                if allLikes[index].id == likeId {
                    self.allLikes?[index].isViewed()
               }
           }
        }
    }
}

private extension LikesDataService {
    func createTempLikes(userID: String) {
        createReceivedLikes(userID: userID)
        createMyLikes(userID: userID)
    }

    func createReceivedLikes(userID: String) {
        var receivedLikes: [LikeModel] = []
        for id in 1...10 {
            let like = LikeModel(
                senderID: String(id),
                receiverID: userID,
                date: randomDate())
            receivedLikes.append(like)
        }
        allLikes = receivedLikes
    }

    func createMyLikes(userID: String) {
        var myLike: [LikeModel] = []
        for id in 8...20 {
            let like = LikeModel(
                senderID: userID,
                receiverID: String(id),
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
