//
//  CountriesAndCitiesModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 12.09.2023.
//

import Foundation

class Country: Hashable, Equatable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name && lhs.cities == rhs.cities
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(cities)
    }

    let name: String
    var cities: [String]

    init(name: String, cities: [String]) {
        self.name = name
        self.cities = cities
    }

    static var allCountries: [Country] = [
        Country(name: "USA", cities: ["New York", "Los Angeles", "Chicago"]),
        Country(name: "Russia", cities: ["Moscow", "Saint Petersburg", "Novosibirsk"]),
        Country(name: "Serbia", cities: ["Belgrade", "Novi Sad", "Niš"]),
        Country(name: "Kazakhstan", cities: ["Astana", "Almaty", "Shymkent"])
    ]

    static func defaultCountry(name: String) -> Country? {
        return allCountries.first { $0.name == name }
    }
}
