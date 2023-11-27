//
//  NotificationModel.swift
//  Datify-iOS-Core
//
//  Created by Илья on 21.10.2023.
//

import Foundation

enum NotificationType: Equatable, CaseIterable {
    case visitedProfile
    case callForAction
    case newMessages
}

struct NotificationModel: Identifiable {
    let id: String = UUID().uuidString
    let notificationType: NotificationType
    let senderID: String
    let receiverID: String
    let date: Date
    private(set) var isNew: Bool = true

    func dateToTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    mutating func isViewed() {
        self.isNew = false
    }
}

extension NotificationModel {
    var shouldBlur: Bool {
        if case .newMessages = notificationType {
            return true
        }
        return false
    }
}

struct TempUserModel: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var age: Int
    var isOnline: Bool
    var photoURL: String
    var newMessages: Int = 0
    var likes: [LikeModel] = []
    var favouriteNotifications: Set<String> = []

    static let defaultUser: TempUserModel = TempUserModel(id: "0",
                                                          name: "User",
                                                          age: 24,
                                                          isOnline: true,
                                                          photoURL: "AvatarPhoto",
                                                          newMessages: 4,
                                                          likes: LikeModel.likeExamples,
                                                          favouriteNotifications: ["02"])

    static let defaultUserArray: [TempUserModel] = [
        TempUserModel(id: "3",
                      name: "Anna",
                      age: 24,
                      isOnline: false,
                      photoURL: "AvatarPhoto3"),
        TempUserModel(id: "2",
                      name: "Evgeniya",
                      age: 18,
                      isOnline: true,
                      photoURL: "AvatarPhoto2"),
        TempUserModel(id: "1",
                      name: "Alexandra",
                      age: 21,
                      isOnline: true,
                      photoURL: "AvatarPhoto")
    ]

    static let userNotFound: TempUserModel = TempUserModel(id: "0000", name: "User not found",
                                                           age: 0, isOnline: false, photoURL: "",
                                                           newMessages: 0, likes: [],
                                                           favouriteNotifications: [])
}
