//
//  Int+extension.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import Foundation

extension Int {
    var minutes: Int {
        self / 60
    }

    var seconds: Int {
        self % 60
    }
}
