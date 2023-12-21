//
//  UserDataService.swift
//  Datify-iOS-Core
//
//  Created by Илья on 23.11.2023.
//

import Foundation
import Combine

class UserDataService {
    @Published var loadingState: LoadingState = .idle
    @Published var relatedUsers: [TempUserModel] = []
    @Published var currentUser: TempUserModel?
    private var userDataBase: [TempUserModel] = TempUserModel.defaultUserArray
    private var cancellables = Set<AnyCancellable>()

    func getUsers(for chats: [ChatModel]) {
        self.relatedUsers = chats.map({ fetchInterlocutor(for: $0) ?? TempUserModel.userNotFound })
    }

    func getUsers(for notifications: [NotificationModel]) {
        self.relatedUsers = notifications.map({ getUserForID(for: $0.senderID) ?? TempUserModel.userNotFound })
    }
    func getUserForID(for id: String) -> TempUserModel? {
        // TODO: Func to fetch user from database
        return self.userDataBase.first(where: { $0.id == id })
    }

    func getCurrentUser() async throws {
        do {
            self.loadingState = .loading
            try await Task.sleep(nanoseconds: 1_000_000_000)
            self.currentUser = TempUserModel.defaultUser
            self.loadingState = .success
        } catch {
            self.loadingState = .error
        }

    }

    func fetchInterlocutor(for chatModel: ChatModel) -> TempUserModel? {
        // TODO: Func to fetch user from database
        guard let currentUser else { return nil }
        let interlocutorID = chatModel.participantId1 == currentUser.id ? chatModel.participantId2 : chatModel.participantId1
        print(self.userDataBase.first(where: { $0.id == interlocutorID }))
        return self.userDataBase.first(where: { $0.id == interlocutorID })
    }
}
