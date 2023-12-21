//
//  NotificationsViewModel.swift
//  Datify-iOS-Core
//
//  Created by Илья on 21.10.2023.
//

import Foundation
import Combine

enum LoadingState {
    case idle, loading, success, error
}

@MainActor
final class NotificationsViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    @Published var loadingState: LoadingState = .idle
    @Published var isError: Bool = false

    @Published var allNotifications: [NotificationModel] = []
    @Published var todayNotifications: [NotificationModel] = []
    @Published var yesterdayNotifications: [NotificationModel] = []
    @Published var earlierNotifications: [NotificationModel] = []
    @Published var sortOption: SortOption = .earliest

    @Published var currentUser: TempUserModel?
    @Published var relatedUsers: [TempUserModel] = []
    @Published var viewedNotifications: Set<String> = []
    @Published var minYUpdateTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var notificationsDataService: NotificationsDataService = NotificationsDataService()
    private var userDataService: UserDataService = UserDataService()

    enum SortOption: String, CaseIterable, Equatable {
        case earliest, unread, visitors, favourite

        var title: String {
            return self.rawValue
                .capitalized
                .localize()
        }
    }

    init(router: Router<AppRoute>) {
        self.router = router
        self.addSubscribers()
    }

    // MARK: Private

    private func addSubscribers() {
        userDataService.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userModel in
                self?.currentUser = userModel
            }
            .store(in: &cancellables)

        userDataService.$relatedUsers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] relatedUsers in
                self?.relatedUsers = relatedUsers
            }
            .store(in: &cancellables)

        notificationsDataService.$allNotifications
            .combineLatest($sortOption)
            .receive(on: DispatchQueue.main)
            .map(sortAndFilterNotifications)
            .sink { [weak self] notifications in
                self?.userDataService.getUsers(for: notifications)
                self?.allNotifications = notifications
                self?.splitNotificationsByDate()
            }
            .store(in: &cancellables)

        userDataService.$loadingState
            .combineLatest(notificationsDataService.$loadingState)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] usersState, notificationsState in
                switch (usersState, notificationsState) {
                case (.success, .success):
                    self?.loadingState = .success
                case (.error, _), (_, .error):
                    self?.loadingState = .error
                    self?.isError = true
                case (.idle, .idle):
                    self?.loadingState = .idle
                default:
                    self?.loadingState = .loading
                }
            }
            .store(in: &cancellables)
    }

    private func sortAndFilterNotifications(notifications: [NotificationModel]?,
                                            sortOption: SortOption) -> [NotificationModel] {
        guard let currentUser, let notifications else { return [] }
        switch sortOption {
        case .earliest:
            return notifications.sorted(by: { $0.date < $1.date })
        case .unread:
            return notifications.filter({ $0.isNew })
        case .visitors:
            return notifications.filter({ $0.notificationType == .visitedProfile })
        case .favourite:
            return notifications.filter({ currentUser.favouriteNotifications.contains($0.id) })
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

    func loadData() async throws {
        do {
            try await userDataService.getCurrentUser()
            guard let currentUser else { return }
            try await notificationsDataService.getData(userID: currentUser.id)
        } catch {
            self.isError = true
        }
    }

    func toggleFavourite(id: String) {
        // TODO: Func to add notification to User's favourites
        guard let currentUser else { return }
        if currentUser.favouriteNotifications.contains(id) {
            self.currentUser?.favouriteNotifications.remove(id)
        } else {
            self.currentUser?.favouriteNotifications.insert(id)
        }
    }

    func getLastLikeUsers() -> (last: TempUserModel?, penult: TempUserModel?) {
        guard let currentUser, currentUser.likes.count > 0 else { return (nil, nil) }
        let lastUser = userDataService.getUserForID(for: currentUser.likes.last?.senderId ?? "")
        let penultUser = userDataService.getUserForID(for: currentUser.likes.penultimate?.senderId ?? "")
        return (lastUser, penultUser)
    }

    func viewNotifications() {
        // TODO: Func to change "isNew" on viewed notifications to false
        for id in viewedNotifications {
            notificationsDataService.notificationIsViewed(id: id)
        }
        self.viewedNotifications.removeAll()
    }

    func resetState() {
        userDataService.loadingState = .idle
        notificationsDataService.loadingState = .idle
    }

    func fetchUserForID(userID: String) -> TempUserModel? {
        userDataService.getUserForID(for: userID)
    }
 }

private extension Array {
    var penultimate: Element? {
        guard count >= 2 else { return nil }
        return self[count - 2]
    }
}
