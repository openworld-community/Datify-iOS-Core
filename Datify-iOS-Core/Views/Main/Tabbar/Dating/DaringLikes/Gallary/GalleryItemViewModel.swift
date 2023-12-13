//
//  SmallUserCardViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import Foundation

class GalleryItemViewModel: ObservableObject {
    @Published var user: UserTempModel?
    private var dataService: UserDataService
    private var likeServise: LikesDataService
    private var myLikes: [LikeModel]
    var like: LikeModel
    var currentUser: UserTempModel

    init(dataServise: UserDataService,
         likeServise: LikesDataService,
         myLikes: [LikeModel],
         like: LikeModel,
         currentUser: UserTempModel) {
        self.dataService = dataServise
        self.likeServise = likeServise
        self.myLikes = myLikes
        self.like = like
        self.currentUser = currentUser
    }

    func getUser() {
        let userTemp = dataService.getUserData(for: isThisMyLike() ? like.receiverID : like.senderID)
        user = userTemp
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

    func isLiked() -> (bool: Bool, myLike: LikeModel?) {
        var result: (bool: Bool, myLike: LikeModel?) = (bool: false, myLike: nil)
        for myLike in myLikes where myLike.receiverID == user?.userId {
            result = (bool: true, myLike: myLike)
        }
        return result
    }

    private func isThisMyLike() -> Bool {
        currentUser.userId == like.senderID
    }

}