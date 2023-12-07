//
//  SmallUserViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 07.12.2023.
//

import Foundation

class SmallUserViewModel: ObservableObject {
    @Published var user: UserModel?
    private var dataService: UserDataService
    private var likeServise: LikesDataService

    init(dataServise: UserDataService, likeServise: LikesDataService) {
        self.dataService = dataServise
        self.likeServise = likeServise
    }

    func getUser(userId: String) {
        let userTemp = dataService.getUserData(for: userId)!
        //  await MainActor.run {
        user = userTemp
        //  }
    }
}
