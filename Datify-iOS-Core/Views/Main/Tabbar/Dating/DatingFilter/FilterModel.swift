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

enum Distances: String, Equatable, CaseIterable, Codable {
    case optionOne = "10"
    case optionTwo = "25"
    case optionThree = "50"
    case optionFour = "100"
    case optionFive = "150"

    func distance() -> Int {
        return Int(self.rawValue) ?? 0
    }

    func label() -> String {
        return self.rawValue + " km".localize()
    }

    static var allLabels: [String] {
        return Distances.allCases.map { $0.label() }
    }
}

struct FilterModel: Codable {
    private(set) var sex: Sex
    private(set) var purpose: Set<Occupation>
    private(set) var minimumAge: Int
    private(set) var maximumAge: Int
    private(set) var distance: Distances

    mutating func updateFilter(updatedFilter: FilterModel) {
        self.sex = updatedFilter.sex
        self.purpose = updatedFilter.purpose
        self.minimumAge = updatedFilter.minimumAge
        self.maximumAge = updatedFilter.maximumAge
        self.distance = updatedFilter.distance
    }
}
