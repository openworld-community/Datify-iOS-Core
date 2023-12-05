//
//  SmallUserCardViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import Foundation

class UserCardViewModel: ObservableObject {
    @Published var user: UserModel?
    private var dataService: UserDataService
    private var likeServise: LikesDataService

    init(dataServise: UserDataService, likeServise: LikesDataService) {
        self.dataService = dataServise
        self.likeServise = likeServise
    }

    func getUser(userId: String) {
        let userTemp = dataService.getUserData(for: userId)!
        //  await MainActor.run {
        user = userTemp
        //  }
    }

    func deleteLike(likeId: String?) {
        if let likeId {
            likeServise.deleteLike(likeId: likeId)
        }
    }

    func createNewLike(senderID: String) {
        if let user {
            likeServise.createLike(senderID: senderID, receiverID: user.userId)
        }
    }

    func likeIsViewed(likeId: String) {
        likeServise.likeIsViewed(likeId: likeId)
    }
}
