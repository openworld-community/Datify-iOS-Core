//
//  ChatViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    @Published var loadingState: LoadingState = .idle
    @Published var isError: Bool = false
    @Published var sortOption: SortOption = .recent

    @Published var currentUser: TempUserModel?
    @Published var allChats: [ChatModel] = []
    @Published var sortedChats: [ChatModel] = []
    @Published var relatedUsers: [TempUserModel] = []

    private var cancellables = Set<AnyCancellable>()
    private var chatsDataService = ChatsDataService()
    var userDataService: UserDataService = UserDataService()

    init(router: Router<AppRoute>) {
        self.router = router
        addSubscribers()
    }

    enum SortOption: CaseIterable {
        case recent, unread, online, favourites, toRespond

        var title: String {
            switch self {
            case .recent:
                return "Recent".localize()
            case .unread:
                return "Unread".localize()
            case .online:
                return "Online".localize()
            case .favourites:
                return "Favourites".localize()
            case .toRespond:
                return "Wait for respond".localize()
            }
        }
    }

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

        chatsDataService.$allChats
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chats in
                self?.userDataService.getUsers(for: chats)
                self?.allChats = chats
            }
            .store(in: &cancellables)

        userDataService.$loadingState
            .combineLatest(chatsDataService.$loadingState)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] usersState, chatsState in
                switch (usersState, chatsState) {
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

        $allChats
            .combineLatest($sortOption)
            .receive(on: DispatchQueue.main)
            .map(sortChats)
            .sink { [weak self] chats in
                self?.sortedChats = chats
            }
            .store(in: &cancellables)
    }

    private func sortChats(allChats: [ChatModel], sortOption: SortOption) -> [ChatModel] {
        guard let currentUser else { return [] }
        switch sortOption {
        case .recent:
            return allChats.sorted(by: { $0.lastMessage?.date ?? Date() < $1.lastMessage?.date ?? Date() })
        case .unread:
            return allChats.filter({ $0.lastMessage?.sender != currentUser.id && $0.lastMessage?.status != .read })
        case .online:
            return allChats.filter({ userDataService.fetchInterlocutor(for: $0)?.isOnline ?? false })
        case .favourites:
            return allChats
        case .toRespond:
            return allChats.filter({ $0.messages.isNotEmpty && $0.messages.filter({ $0.sender == currentUser.id }).isEmpty })
        }
    }

    func loadData() async throws {
        do {
            try await userDataService.getCurrentUser()
            guard let currentUser else { return }
            try await chatsDataService.getData(userID: currentUser.id)
        } catch {
            self.isError = true
        }
    }

    func resetState() {
        userDataService.loadingState = .idle
        chatsDataService.loadingState = .idle
    }
}
