//
//  CountryAndCityView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 28.09.2023.
//

import SwiftUI

struct CountryAndCityView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: LocationViewModel

    var isCountrySelection: Bool

    init(viewModel: LocationViewModel, isCountrySelection: Bool) {
        self.viewModel = viewModel
        self.isCountrySelection = isCountrySelection
    }

    var body: some View {
        locationList()
            .onAppear {
                print("locationList")
            }
    }

    @ViewBuilder
    private func locationList() -> some View {
        if isCountrySelection {
            List {
                ForEach(Country.allCountries, id: \.self) { country in
                    Button {
                        print("selectedLocation: \(country.name)")
                        viewModel.selectedLocation = country.name
                        viewModel.location?.selectedCountry?.name = country.name
                        viewModel.selectCountry(country)
                        viewModel.isCountrySelection = true
                    } label: {
                        HStack {
                            Text(country.name)
                                .dtTypo(.p2Regular, color: .textPrimary)
                            Spacer()
                            if viewModel.location?.selectedCountry?.name == country.name {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentsBlue)
                            } else {
                                Spacer()
                            }
                        }
                    }
                }
            }
            .background(.secondary)
        } else {
            List {
                if let location = viewModel.location?.selectedCountry {
                    ForEach(location.cities, id: \.self) { city in
                        Button {
                            viewModel.selectedLocation = city
                            viewModel.location?.selectedCountry?.selectedCity = city
                            viewModel.selectCity(city)
                            viewModel.isCountrySelection = false
                        } label: {
                            HStack {
                                Text(city)
                                    .dtTypo(.p2Regular, color: .textPrimary)
                                Spacer()
                                if viewModel.location?.selectedCountry?.selectedCity == city {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.accentsBlue)
                                } else {
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
