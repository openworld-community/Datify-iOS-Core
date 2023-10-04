//
//  LocationView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import SwiftUI

struct LocationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LocationViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: LocationViewModel(router: router))
    }

    var body: some View {
        VStack {
            Spacer()
            titleLabel
            locationChooseButton(label: "Country".localize(), isCountrySelection: true)
            locationChooseButton(label: "City".localize(), isCountrySelection: false)
            Spacer()
            bottomButtons
        }
        .onAppear {
            // TODO: when screen has appeared. 
            // Upload data to CountryModel from server via API
            // Find geolocation in data in CountryModel
            Task {
                try await Task.sleep(nanoseconds: UInt64(0.8))
                viewModel.locationManager.isLoading = false
            }
        }
        .onReceive(viewModel.$error) { error in
            if let error = error {
                viewModel.showErrorAlert(message: error.localizedDescription)
            }
        }
        .overlay(
            Group {
                if viewModel.locationManager.isLoading {
                    DtSpinnerView(size: 56)
                }
            }
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
    }

    private func locationChooseButton(label: String, isCountrySelection: Bool) -> some View {
        LocationChooseButtonView(
            location: $viewModel.location,
            label: label,
            viewModel: viewModel,
            isCountrySelection: isCountrySelection
        )
    }
}

struct LocationChooseButtonView: View {
    @Binding var location: LocationModel?

    let label: String
    @State var viewModel: LocationViewModel
    @State var isCountrySelection: Bool

//    var body: some View {
//        NavigationLink(
//            destination: locationList,
//            label: {
//                HStack {
//                    Text("\(label.capitalized):")
//                        .dtTypo(.p2Regular, color: .textSecondary)
//                        .textInputAutocapitalization(.sentences)
//                    Text(locationValue)
//                        .dtTypo(.p2Regular, color: .textPrimary)
//                    Spacer()
//                    Image(DtImage.arrowBottom)
//                        .frame(width: 24, height: 24)
//                        .foregroundColor(.secondary)
//                }
//                .padding(.horizontal)
//                .frame(height: AppConstants.Visual.buttonHeight)
//                .background(
//                    RoundedRectangle(
//                        cornerRadius: AppConstants.Visual.cornerRadius
//                    )
//                    .foregroundColor(.backgroundSecondary)
//                )
//            }
//        )
//        .padding(.horizontal)
//    }
//
//    private var locationValue: String {
//        if isCountrySelection {
//            return location?.selectedCountry?.name ?? "Loading...".localize()
//        } else {
//            return location?.selectedCountry?.selectedCity ?? "Loading...".localize()
//        }
//    }
//
//    @ViewBuilder
//    private func locationList() -> some View {
//        if isCountrySelection {
//            List {
//                ForEach(Country.allCountries, id: \.self) { country in
//                    Button {
//                        selectedLocation = country.name
//                        viewModel.selectCountry(country)
//                    } label: {
//                        HStack {
//                            Text(country.name)
//                                .dtTypo(.p2Regular, color: .textPrimary)
//                            Spacer()
//                            if selectedLocation == country.name {
//                                Image(systemName: "checkmark.circle.fill")
//                                    .foregroundColor(.accentsBlue)
//                            } else {
//                                Spacer()
//                            }
//                        }
//                    }
//                }
//            }
//            .background(.secondary)
//            .navigationBarTitle("Choose your \(label)".localize())
//            .navigationBarTitleDisplayMode(.inline)
//        } else {
//            List {
//                if let location = viewModel.location?.selectedCountry {
//                    ForEach(location.cities, id: \.self) { city in
//                        Button {
//                            selectedLocation = city
//                            viewModel.selectCity(city)
//                        } label: {
//                            HStack {
//                                Text(city)
//                                    .dtTypo(.p2Regular, color: .textPrimary)
//                                Spacer()
//                                if selectedLocation == city {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(.accentsBlue)
//                                } else {
//                                    Spacer()
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Choose your \(label)".localize())
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }

    var body: some View {
        Button {
            viewModel.isCountrySelection = isCountrySelection
            viewModel.chooseCountryAndCity()
        } label: {
            HStack {
                Text("\(label.capitalized):")
                    .dtTypo(.p2Regular, color: .textSecondary)
                    .textInputAutocapitalization(.sentences)
                Text(locationValue)
                    .dtTypo(.p2Regular, color: .textPrimary)
                Spacer()
                Image(DtImage.arrowBottom)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .frame(height: AppConstants.Visual.buttonHeight)
            .background(
                RoundedRectangle(
                    cornerRadius: AppConstants.Visual.cornerRadius
                )
                .foregroundColor(.backgroundSecondary)
            )
        }
    }

    private var locationValue: String {
        if isCountrySelection {
            return location?.selectedCountry?.name ?? "Loading...".localize()
        } else {
            return location?.selectedCountry?.selectedCity ?? "Loading...".localize()
        }
    }
}

extension LocationView {
    private var titleLabel: some View {
        VStack(spacing: 8) {
            Text("Where are you located?".localize())
                .dtTypo(.h3Medium, color: .textPrimary)
            Text("Choose your city of residence; this will help us find people around you more accurately".localize())
                .dtTypo(.p2Regular, color: .textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.bottom, 40)
    }

    private var bottomButtons: some View {
        HStack {
            DtBackButton {
                // TODO: Back button
            }
            DtButton(title: "Next".localize(), style: .main) {
                // TODO: Next button
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

// struct LocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationView(viewModel: LocationViewModel(router: Router()))
//    }
// }
