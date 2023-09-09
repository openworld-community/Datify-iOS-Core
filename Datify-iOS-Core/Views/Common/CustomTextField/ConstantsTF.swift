//
//  ConstantsTF.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

enum ConstantsTF {

    // PhoneEmailTF
    case phoneAndEmailPlaceholder
    // EmailTF
    case emailPlaceholder
    // PasswordTF
    case passwordPlaceholder
    // TextTF
    case namePlaceholder
    case textPlaceholder
    // PhoneTF
    case phonePlaceholder

    var stringValue: String {
        switch self {
        case .phoneAndEmailPlaceholder: return "Phone or Email"
        case .emailPlaceholder: return "Email"
        case .passwordPlaceholder: return "Password"
        case .namePlaceholder: return "Your Name"
        case .textPlaceholder: return "Compose a response"
        case .phonePlaceholder: return "(000) 000-00-00"
        }
    }
}

enum CountryCodePhoneTF {
    case russia

    var stringValue: String {
        switch self {
        case .russia: return "RU +7"
        }
    }
}

// name
//
