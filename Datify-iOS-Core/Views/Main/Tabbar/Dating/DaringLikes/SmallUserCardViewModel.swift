//
//  SmallUserCardViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import Foundation

class SmallUserCardViewModel: ObservableObject {
    @Published var user: UserModel?
    private var dataService: UserDataService

    init() {
        self.dataService = UserDataService.shared
    }

    func getUser(userId: String) {
//        Task {
            let userTemp =  dataService.getUserData(for: userId)!
//            await MainActor.run {
                user = userTemp
//            }
//        }
    }
}
