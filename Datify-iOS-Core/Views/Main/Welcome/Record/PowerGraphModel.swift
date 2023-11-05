//
//  PowerGraphModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.11.2023.
//

import Foundation

struct PowerGraphModel {
    var statePlayer: StatePlayerEnum
    var arrayHeight: [BarModel]
    var fileExistsBool: Bool
    var filePath: URL?
}
