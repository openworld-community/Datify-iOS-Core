//
//  FilterModel.swift
//  Datify-iOS-Core
//
//  Created by Илья on 18.10.2023.
//

import Foundation

enum Sex: CaseIterable, Equatable, Codable {
    case male, female, all
    func title() -> String {
        switch self {
        case .male:
            return "Male".localize()
        case .female:
            return "Female".localize()
        case .all:
            return "All".localize()
        }
    }
}

struct FilterModel: Codable {
    private(set) var sex: Sex
    private(set) var purpose: Set<Occupation>
    private(set) var minimumAge: Int
    private(set) var maximumAge: Int
    private(set) var distance: Int
//    private(set) var location: LocationModel

    mutating func updateFilter(updatedFilter: FilterModel) {
        self.sex = updatedFilter.sex
        self.purpose = updatedFilter.purpose
        self.minimumAge = updatedFilter.minimumAge
        self.maximumAge = updatedFilter.maximumAge
        self.distance = updatedFilter.distance
//        self.location = updatedFilter.location
    }
}
