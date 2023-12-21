//
//  NotificationsDataService.swift
//  Datify-iOS-Core
//
//  Created by Илья on 21.10.2023.
//

import Foundation
import Combine

final class NotificationsDataService {

    @Published var loadingState: LoadingState = .idle
    @Published var allNotifications: [NotificationModel]?

    private var cancellables: Set<AnyCancellable>?

    func getData(userID: String) async throws {
        // TODO: Func to get notifications data for current user from database via combine
        self.loadingState = .loading
        // Notifications examples
        guard userID != "" else { return }
        let senderIDs = ["1", "2", "3"]
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        let dates = [today, yesterday, dayBeforeYesterday]
        var notifications: [NotificationModel] = []
        try await Task.sleep(nanoseconds: 1_000_000_000)
        for _ in 1...30 {

            let randomType = NotificationType.allCases.randomElement()!
            let randomSenderID = senderIDs.randomElement()!
            let randomDate = dates.randomElement()!

            let notification = NotificationModel(notificationType: randomType,
                                                 senderID: randomSenderID,
                                                 receiverID: userID,
                                                 date: randomDate)
            notifications.append(notification)
        }
        self.allNotifications = notifications
        self.loadingState = .success
    }

    func notificationIsViewed(id: String) {
        // Function to send update to database 
        guard let allNotifications,
        var localNotification = allNotifications.first(where: { $0.id == id }) else { return }
        localNotification.isViewed()
        if let index = allNotifications.firstIndex(where: { $0.id == id }) {
            self.allNotifications?[index] = localNotification
        }
    }
}
