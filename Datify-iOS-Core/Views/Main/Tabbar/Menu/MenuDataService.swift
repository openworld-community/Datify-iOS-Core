//
//  MenuDataService.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 27.12.2023.
//

import Foundation

final class MenuDataService {
    func getCurrentUser() -> MenuTempUserModel {
        let tempCurrentUser = MenuTempUserModel(photo: "AvatarPhoto",
                                                name: "Alexandra",
                                                age: 29,
                                                phoneNumber: 9457348273,
                                                googleGccount: "Alexandra94@gmail.com",
                                                appleAccount: "Alexandra94@icloud.com")
        return tempCurrentUser
    }
}
