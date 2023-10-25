//
//  CountriesAndCitiesModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 12.09.2023.
//

import Foundation

struct Country: Hashable, Equatable {

    var name: String
    var cities: [String]
    var selectedCity: String?

    init(name: String, cities: [String], selectedCity: String? = nil) {
        self.name = name
        self.cities = cities
        self.selectedCity = selectedCity
    }

    static var allCountries: [Country] = [
        Country(
            name: String(localized: "Serbia"),
            cities: [
                String(localized: "Belgrade"),
                String(localized: "Novi Sad"),
                String(localized: "Niš")
            ]),
        Country(
            name: String(localized: "United States"),
            cities: [
                String(localized: "New York"),
                String(localized: "Los Angeles"),
                String(localized: "Chicago")
            ]),
        Country(
            name: String(localized: "Russia"),
            cities: [
                String(localized: "Moscow"),
                String(localized: "Saint Petersburg"),
                String(localized: "Novosibirsk")
            ]),
        Country(
            name: String(localized: "Kazakhstan"),
            cities: [
                String(localized: "Astana"),
                String(localized: "Almaty"),
                String(localized: "Shymkent")
            ])
    ]
}
