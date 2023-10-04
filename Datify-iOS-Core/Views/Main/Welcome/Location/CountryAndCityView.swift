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
//    var viewModel: LocationViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LocationViewModel
//    @Binding var isCountrySelection: Bool

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: LocationViewModel(router: router))
    }

    var body: some View {
        locationList()
            .onAppear {
                print("locationList")
                print("viewModel.isCountrySelection2: \(viewModel.isCountrySelection)")
//                viewModel.isCountrySelection = true
            }
    }

    @ViewBuilder
    private func locationList() -> some View {
        if viewModel.isCountrySelection ?? true {
            List {
                ForEach(Country.allCountries, id: \.self) { country in
                    Button {
                        print("selectedLocation: \(country.name)")
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
