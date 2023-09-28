//
//  CountryAndCityView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 28.09.2023.
//

import SwiftUI

struct CountryAndCityView: View {
//    @Binding var location: LocationModel?
//    @State private var isPopoverVisible = false
//
//    let label: String
    var viewModel: LocationViewModel
//    @State var isCountrySelection: Bool

    var body: some View {
        locationList()
    }

    @ViewBuilder
    private func locationList() -> some View {
        if viewModel.isCountrySelection ?? false {
            List {
                ForEach(Country.allCountries, id: \.self) { country in
                    Button {
                        viewModel.selectedLocation = country.name
                        viewModel.selectCountry(country)
                    } label: {
                        HStack {
                            Text(country.name)
                                .dtTypo(.p2Regular, color: .textPrimary)
                            Spacer()
                            if viewModel.selectedLocation == country.name {
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
                            viewModel.selectCity(city)
                        } label: {
                            HStack {
                                Text(city)
                                    .dtTypo(.p2Regular, color: .textPrimary)
                                Spacer()
                                if viewModel.selectedLocation == city {
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
