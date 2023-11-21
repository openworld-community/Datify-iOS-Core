//
//  NotificationsViewModel.swift
//  Datify-iOS-Core
//
//  Created by Илья on 21.10.2023.
//

import Foundation
import Combine

@MainActor
final class NotificationsViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    @Published var allNotifications: [NotificationModel] = []
    @Published var todayNotifications: [NotificationModel] = []
    @Published var yesterdayNotifications: [NotificationModel] = []
    @Published var earlierNotifications: [NotificationModel] = []
    @Published var sortOption: SortOption = .earliest
    @Published var user: TempUserModel?
    @Published var viewedNotifications: Set<String> = []
    @Published var minYUpdateTimer: Timer?
    @Published var isLoading: Bool = true
    private var cancellables = Set<AnyCancellable>()
    private var notificationsDataService: NotificationsDataService?

    enum SortOption: String, CaseIterable, Equatable {
        case earliest, unread, visitors, favourite

        var title: String {
            return self.rawValue
                .capitalized
                .localize()
        }
    }

    // Temporary allUsers database
    @Published var allUsers: [TempUserModel] = []

    private let alexandra = TempUserModel(id: "1",
                                  name: "Alexandra",
                                  age: 21,
                                  isOnline: true,
                                  photoURL: "AvatarPhoto")
    private let evgeniya = TempUserModel(id: "2",
                                 name: "Evgeniya",
                                 age: 18,
                                 isOnline: true,
                                 photoURL: "AvatarPhoto2")
    private let anna = TempUserModel(id: "3",
                             name: "Anna",
                             age: 24,
                             isOnline: false,
                             photoURL: "AvatarPhoto3")

    init(router: Router<AppRoute>) {
        self.router = router
        // TODO: Func to fetch current user
        Task {
            // Fetching current user
            await fetchUser()
            guard let user = user else { return }
            // Fetching notifications for current user
            self.notificationsDataService = NotificationsDataService(userID: user.id)
            addSubscribers()
            // Fetching array of UserModels that appear in User's notifications
            allUsers = [alexandra, evgeniya, anna]
            self.isLoading = false
        }
    }

    // MARK: Private
    private func addSubscribers() {
        guard let dataService = notificationsDataService else { return }
        dataService.$allNotifications
            .combineLatest($sortOption)
            .map(sortAndFilterNotifications)
            .sink { [weak self] notifications in
                self?.allNotifications = notifications
                self?.splitNotificationsByDate()
            }
            .store(in: &cancellables)
    }

    private func fetchUser() async {
        // Func to fetch current user
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        self.user = TempUserModel.defaultUser
    }

    private func sortAndFilterNotifications(notifications: [NotificationModel]?,
                                            sortOption: SortOption) -> [NotificationModel] {
        guard let user = user, let notifications = notifications else { return [] }
        switch sortOption {
        case .earliest:
            return notifications.sorted(by: { $0.date < $1.date })
        case .unread:
            return notifications.filter({ $0.isNew })
        case .visitors:
            return notifications.filter({ $0.notificationType == .visitedProfile })
        case .favourite:
            return notifications.filter({ user.favouriteNotifications.contains($0.id) })
        }
    }

    private func splitNotificationsByDate() {
        let today = Date()
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today),
              let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: today) else {
            return
        }

        var todayNotifications: [NotificationModel] = []
        var yesterdayNotifications: [NotificationModel] = []
        var earlierNotifications: [NotificationModel] = []

        for notification in allNotifications {
            if Calendar.current.isDate(notification.date, inSameDayAs: today) {
                todayNotifications.append(notification)
            } else if Calendar.current.isDate(notification.date, inSameDayAs: yesterday) {
                yesterdayNotifications.append(notification)
            } else if notification.date <= dayBeforeYesterday {
                earlierNotifications.append(notification)
            }
        }

        self.todayNotifications = todayNotifications
        self.yesterdayNotifications = yesterdayNotifications
        self.earlierNotifications = earlierNotifications
    }

    // MARK: Public
    func toggleFavourite(id: String) {
        // TODO: Func to add notification to User's favourites
        guard let user = user else { return }
        if user.favouriteNotifications.contains(id) == true {
            self.user?.favouriteNotifications.remove(id)
        } else {
            self.user?.favouriteNotifications.insert(id)
        }
    }

    func fetchUserForID(for id: String) -> TempUserModel? {
        // TODO: Func to fetch user from database
        return self.allUsers.first(where: { $0.id == id })
    }

    func getLastLikeUsers() -> (last: TempUserModel?, penult: TempUserModel?) {
        guard let localUser = user, localUser.newLikes.count > 0 else { return (nil, nil) }
        let lastUser = fetchUserForID(for: localUser.newLikes.last ?? "")
        let penultUser = fetchUserForID(for: localUser.newLikes.penultimate ?? "")
        return (lastUser, penultUser)
    }

    func viewNotifications() {
        // TODO: Func to change "isNew" on viewed notifications to false
        guard let dataService = notificationsDataService else { return }
        for id in viewedNotifications {
            dataService.notificationIsViewed(id: id)
        }
        self.viewedNotifications.removeAll()
    }
}

private extension Array {
    var penultimate: Element? {
        guard count >= 2 else { return nil }
        return self[count - 2]
    }
}
