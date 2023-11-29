//
//  ConstantsTF.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

enum CountryCodePhoneTF: CaseIterable {
    case russia
    case usa

    var stringValue: String {
        switch self {
        case .russia: return "+7"
        case .usa: return "+1"
        }
    }
}
