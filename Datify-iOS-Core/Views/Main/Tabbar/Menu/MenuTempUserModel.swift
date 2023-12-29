//
//  MenuTempUserModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 27.12.2023.
//

import Foundation

struct MenuTempUserModel {
    var id: String = UUID().uuidString
    var photo: String
    var name: String
    var age: Int
    var phoneNumber: Int
    var googleGccount: String
    var appleAccount: String
}
