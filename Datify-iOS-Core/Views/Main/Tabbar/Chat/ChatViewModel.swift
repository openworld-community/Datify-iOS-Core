//
//  ChatViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import Foundation
import Combine

final class ChatViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    @Published var currentUser: TempUserModel?
    @Published var allChats: [ChatModel] = []
    @Published var relatedUsers: [TempUserModel] = []
    private var cancellables = Set<AnyCancellable>()
    private var chatsDataService: ChatsDataService
    var userDataService: UserDataService = UserDataService()
    var currentUserId: String = ""

    init(router: Router<AppRoute>) {
        self.router = router
        self.chatsDataService = ChatsDataService(userID: currentUserId)
        // TODO: Func to fetch current user
        Task {
            addSubscribers()
        }
    }

    private func addSubscribers() {
        userDataService.$currentUser
            .sink { [weak self] userModel in
                self?.currentUser = userModel
                self?.currentUserId = userModel?.id ?? ""
                guard let userModel else { return }
                self?.chatsDataService = ChatsDataService(userID: userModel.id)

            }
            .store(in: &cancellables)

        userDataService.$relatedUsers
            .sink { [weak self] relatedUsers in
                self?.relatedUsers = relatedUsers
            }
            .store(in: &cancellables)

        chatsDataService.$allChats
            .sink { [weak self] chats in
                self?.userDataService.getUsers(for: chats ?? [])
                self?.allChats = chats ?? []
                print("Inited")
            }
            .store(in: &cancellables)
    }

}
