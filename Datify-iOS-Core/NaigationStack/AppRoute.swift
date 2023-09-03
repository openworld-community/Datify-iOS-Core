//
//  AppRoute.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import Foundation

enum AppRoute {
    case temp
    case login
    case registrationSex
    case registrationEmail
    case registrationLocation
    case registrationRecord
    case registrationFinish
}

extension AppRoute: Hashable, Equatable {
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.temp, .temp): return true
        case (.login, .login): return true
        case (.registrationSex, .registrationSex): return true
        case (.registrationEmail, .registrationEmail): return true
        case (.registrationLocation, .registrationLocation): return true
        case (.registrationRecord, .registrationRecord): return true
        case (.registrationFinish, .registrationFinish): return true
        default: return false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
