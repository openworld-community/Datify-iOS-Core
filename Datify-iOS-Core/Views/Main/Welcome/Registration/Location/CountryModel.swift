//
//  CountriesAndCitiesModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 12.09.2023.
//

import Foundation

class Country {
    let name: String
    var cities: [String]

    init(name: String, cities: [String]) {
        self.name = name
        self.cities = cities
    }

    static var cities: [String: [String]] = [
        "USA": ["New York", "Los Angeles", "Chicago"],
        "Russia": ["Moscow", "Saint Petersburg", "Novosibirsk"],
        "Serbia": ["Belgrade", "Novi Sad", "Niš"],
        "Kazakhastan": ["Astana", "Almaty", "Shymkent"]
    ]

    static func defaultCountry(name: String) -> Country {
        if let cities = cities[name] {
            return Country(name: name, cities: cities)
        } else {
            return Country(name: name, cities: [])
        }
    }
}
