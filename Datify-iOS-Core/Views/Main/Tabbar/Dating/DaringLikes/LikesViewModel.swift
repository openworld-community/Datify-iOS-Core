//
//  LikesViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI
import Combine

struct UserTempModel {
    let userId: String
    let photos: [String]
    let label: String
    let colorLabel: Color
    let location: String
    let name: String
    let age: Int
    let star: Bool
    let description: String
    var liked: Bool
    var bookmarked: Bool
    let audiofile: String
    let online: Bool

    static let currentUser = UserTempModel(
        userId: "1000",
        photos: ["user1", "user1", "user1"],
        label: "Label1",
        colorLabel: .red,
        location: "New York",
        name: "Michael",
        age: 25,
        star: true,
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        liked: true,
        bookmarked: false,
        audiofile: "audio.mp3",
        online: true
    )
}

enum LikeSortOption: CaseIterable, FilterProtocol {
    case lastDay, lastWeek, lastMonth, allTime

    var title: String {
        switch self {
        case .lastDay: return "Last day".localize()
        case .lastWeek: return "Last week".localize()
        case .lastMonth: return "Last month".localize()
        case .allTime: return "All time".localize()
        }
    }
}

enum LikeTage: CaseIterable {
    case receivedLikes, mutualLikes, myLikes

    var title: String {
        switch self {
        case .mutualLikes: return "mutual".localize()
        case .myLikes: return "my".localize()
        case .receivedLikes: return "received".localize()
        }
    }
}

class LikesViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    @Published var allLikes: [LikeModel] = []
    @Published var receivedLikes: [LikeModel] = []
    @Published var mutualLikes: [LikeModel] = []
    @Published var myLikes: [LikeModel] = []
    @Published var sortOption: LikeSortOption = .allTime
    @Published var currentUser: UserTempModel?
    @Published var categories: LikeTage = .receivedLikes
    @Published var selectedReceivedLikesId: String?
    @Published var selectedMutualLikesId: String?
    @Published var selectedMyLikesId: String?
    private var likesDataService: LikesDataService?
    private var userDataService: UserDataService?
    private var cancellables = Set<AnyCancellable>()

    init(router: Router<AppRoute>, userDataService: UserDataService, likesDataService: LikesDataService) {
        self.router = router
        self.userDataService = userDataService
        self.likesDataService = likesDataService
    }

    func fecthData() async {
        await fetchCurrentUser()
        guard let currentUser = currentUser else {return}
        await likesDataService?.getData(userID: currentUser.userId)
            addSubscribers()
    }

    private func fetchCurrentUser() async {
        // TODO: Func to fetch current user from database
        await MainActor.run {
            self.currentUser = UserTempModel.currentUser
        }
    }

    private func addSubscribers() {
        guard let likesDataService else { return }
        likesDataService.$allLikes
            .receive(on: DispatchQueue.main)
            .combineLatest($sortOption)
            .map(sortAndFilterLikes)
            .sink { [weak self] allLikes in
                self?.allLikes = allLikes
                self?.splitLikesByCategory()
                self?.fetchSelectedUser()
            }
            .store(in: &cancellables)
    }

    private func sortAndFilterLikes(likes: [LikeModel]?, sortOption: LikeSortOption) -> [LikeModel] {
        guard let likes else { return [] }
        switch sortOption {
        case .lastDay:
            let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
            return  likes.filter({ $0.date > oneDayAgo}).sorted(by: { $0.date < $1.date })
        case .lastWeek:
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            return likes.filter({ $0.date > oneWeekAgo}).sorted(by: { $0.date < $1.date })
        case .lastMonth:
            let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            return likes.filter({ $0.date > oneMonthAgo}).sorted(by: { $0.date < $1.date })
        case .allTime:
            return likes.sorted(by: { $0.date < $1.date })
        }
    }

    private func splitLikesByCategory() {
        var receivedLikes: [LikeModel] = []
        var mutualLikes: [LikeModel] = []
        var myLikes: [LikeModel] = []
        for like in allLikes {
            if like.senderID == currentUser?.userId {
                myLikes.append(like)
            } else {
                receivedLikes.append(like)
            }
        }
        for myLike in myLikes {
            for receivedLike in receivedLikes where myLike.receiverID == receivedLike.senderID {
                mutualLikes.append(myLike)
            }
        }
        self.receivedLikes = receivedLikes
        self.mutualLikes = mutualLikes
        self.myLikes = myLikes

    }

    private func fetchSelectedUser() {
        selectedReceivedLikesId = receivedLikes.first?.senderID
        selectedMutualLikesId = mutualLikes.first?.receiverID
        selectedMyLikesId = myLikes.first?.receiverID
    }
}
