//
//  UserDataService.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

class UserDataService {
    static var shared = UserDataService()
    private var tempUsers: [UserTempModel] = []

    init() {
        createTempRandomUser()
    }

    func getUserData(for userId: String) -> UserTempModel? {
        // TODO: Func to get user data
        var user: UserTempModel?
        for tempUser in tempUsers where tempUser.userId == userId {
            user = tempUser
        }
        return user
    }
}

private extension UserDataService {
    func createTempRandomUser() {
        let userPhotos: [[String]] = [["user2", "user2", "user2"],
                                     ["user3", "user3", "user3"],
                                     ["user4", "user4", "user4"],
                                     ["user5", "user5", "user5"],
                                     ["user7", "user7", "user7"],
                                     ["user8", "user8", "user8"]]
        let userLabel: [String] = ["looking for love",
                                   "go on dates",
                                   "looking for a friend"]
        let userLocation: [String] = ["New York",
                                      "Los Angeles",
                                      "Chicago",
                                      "Houston",
                                      "Phoenix",
                                      "Philadelphia",
                                      "San Antonio",
                                      "San Diego"]
        let userName: [String] = ["Michael", "Sarah", "David", "Emily", "William", "Olivia", "John", "Sophia"]
        let userColor: [Color] = [.red, .green, .blue, .yellow, .pink, .purple]

        for id in 1...20 {
            let user = UserTempModel(
                userId: String(id),
                photos: userPhotos.randomElement() ?? ["user2", "user2", "user2"],
                label: userLabel.randomElement() ?? "Label1",
                colorLabel: userColor.randomElement() ?? .red,
                location: userLocation.randomElement() ?? "New York",
                name: userName.randomElement() ?? "Michael",
                age: Int.random(in: 18...45),
                star: true,
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                liked: true,
                bookmarked: false,
                audiofile: "audio.mp3",
                online: Bool.random())
            self.tempUsers.append(user)
        }
    }
}
