//
//  MenuViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import Foundation

final class MenuViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    @Published var currentUser: MenuTempUserModel?
    var dataService = MenuDataService()

    init(router: Router<AppRoute>) {
        self.router = router
        getCurentUser()
    }

    func getCurentUser() {
        currentUser = dataService.getCurrentUser()
    }
}
