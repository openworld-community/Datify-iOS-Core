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
    @Published var user: TempUserModel?
    @Published var allChats: [ChatModel] = []
    private var cancellables = Set<AnyCancellable>()
    private var chatsDataService: ChatsDataService?

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
            self.chatsDataService = ChatsDataService(userID: user.id)
            addSubscribers()
            // Fetching array of UserModels that appear in User's notifications
            allUsers = [alexandra, evgeniya, anna]
        }
    }

    private func fetchUser() async {
        // Func to fetch current user
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        self.user = TempUserModel.defaultUser
    }

    private func addSubscribers() {
        guard let chatsDataService else { return }
        chatsDataService.$allChats
            .sink { [weak self] chats in
                self?.allChats = chats ?? []
            }
            .store(in: &cancellables)
    }

    func fetchInterlocutor(for chatModel: ChatModel) -> TempUserModel? {
        // TODO: Func to fetch user from database
        guard let user else { return nil }
        let interlocutorID = chatModel.participantId1 == user.id ? chatModel.participantId2 : chatModel.participantId1
        return self.allUsers.first(where: { $0.id == interlocutorID })
    }

}
