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

    @Published var currentUser: TempUserModel?
    @Published var allChats: [ChatModel] = []
    @Published var relatedUsers: [TempUserModel] = []

    private var cancellables = Set<AnyCancellable>()
    private var chatsDataService = ChatsDataService()
    var userDataService: UserDataService = UserDataService()

    init(router: Router<AppRoute>) {
        self.router = router
        addSubscribers()
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
