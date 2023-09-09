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
        case .russia: return "Ru +7"
        case .usa: return "US +1"
        }
    }
}
    case smsPlaceholder

    var stringValue: String {
        switch self {
        case .phoneAndEmailPlaceholder: return "Phone or Email"
        case .emailPlaceholder: return "Email"
        case .passwordPlaceholder: return "Password"
        case .phonePlaceholder: return "(000) 000-00-00"
        case .smsPlaceholder: return "00 00 00"
        }
    }
}

enum CountryCodePhoneTF: CaseIterable {
    case russia
    case usa

    var stringValue: String {
        switch self {
        case .russia: return "Ru +7"
        case .usa: return "US +1"
        }
    }
}
