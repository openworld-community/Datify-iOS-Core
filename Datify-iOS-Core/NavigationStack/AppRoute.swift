//
//  AppRoute.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import Foundation
import SwiftUI

enum AppRoute {
    case temp
    case login
    case tabbar
    case registrationSex
    case registrationEmail
    case registrationPhoto
    case registrationLocation
    case registrationRecord
    case registrationFinish
    case location
    case countryAndCity(isCountrySelection: Bool, viewModel: LocationViewModel)
    case registrationName
    case registrationBirthday
}

extension AppRoute: Hashable, Equatable {
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.temp, .temp): return true
        case (.login, .login): return true
        case (.tabbar, .tabbar): return true
        case (.registrationSex, .registrationSex): return true
        case (.registrationEmail, .registrationEmail): return true
        case (.registrationPhoto, .registrationPhoto): return true
        case (.registrationLocation, .registrationLocation): return true
        case (.registrationRecord, .registrationRecord): return true
        case (.registrationFinish, .registrationFinish): return true
        case (.location, .location): return true
        case (.countryAndCity, .countryAndCity): return true
        case (.registrationName, .registrationName): return true
        case (.registrationBirthday, .registrationBirthday): return true
        default: return false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
