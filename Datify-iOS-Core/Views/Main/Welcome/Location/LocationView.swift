//
//  LocationView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import SwiftUI

struct LocationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: LocationViewModel
    @State private var isLoading = true

    var body: some View {
        VStack {
            Spacer()
            titleLabel
            locationChooseButton(label: "Country", isCountrySelection: true)
            locationChooseButton(label: "City", isCountrySelection: false)
            Spacer()
            bottomButtons
        }
        .onAppear {
            // TODO: when screen has appeared
            Task {
                try await Task.sleep(nanoseconds: UInt64(0.8))
                isLoading = false
            }
        }
        .overlay(
            Group {
                if isLoading {
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
    @State private var isPopoverVisible = false

    let label: String
    var viewModel: LocationViewModel
    @State var isCountrySelection: Bool
    @State private var selectedLocation: String?

    var body: some View {
        NavigationLink(
            destination: locationList,
            label: {
                HStack {
                    Text("\(label.capitalized):")
                        .dtTypo(.p2Regular, color: .textSecondary)
                        .textInputAutocapitalization(.sentences)
                    Text(locationValue)
                        .dtTypo(.p2Regular, color: .textPrimary)
                    Spacer()
                    Image("iconArrowBottom")
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
        )
        .padding(.horizontal)
    }

    private var locationValue: String {
        if isCountrySelection {
            return location?.selectedCountry?.name ?? String(localized: "Loading...")
        } else {
            return location?.selectedCountry?.selectedCity ?? String(localized: "Loading...")
        }
    }

    private var locationList: some View {
            if isCountrySelection {
                return AnyView(
                    List {
                        ForEach(Country.allCountries, id: \.self) { country in
                            Button {
                                selectedLocation = country.name
                                print("selectedLocation \(selectedLocation)")
                                viewModel.selectCountry(country)
                            } label: {
                                HStack {
                                    Text(country.name)
                                        .dtTypo(.p2Regular, color: .textPrimary)
                                    Spacer()
                                    if selectedLocation == country.name {
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
                    .navigationBarTitle(String(localized: "Choose your \(label)"))
                    .navigationBarTitleDisplayMode(.inline)
                )
            } else {
                return AnyView(
                    List {
                        if let location = viewModel.location?.selectedCountry {
                            ForEach(location.cities, id: \.self) { city in
                                Button {
                                    selectedLocation = city
                                    viewModel.selectCity(city)
                                } label: {
                                    HStack {
                                        Text(city)
                                            .dtTypo(.p2Regular, color: .textPrimary)
                                        Spacer()
                                        if selectedLocation == city {
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
                    .navigationBarTitle(String(localized: "Choose your \(label)"))
                    .navigationBarTitleDisplayMode(.inline)
                )
            }
    }
}

extension LocationView {
    private var titleLabel: some View {
        VStack(spacing: 8) {
            Text(String(localized: "Where are you located?"))
                .dtTypo(.h3Medium, color: .textPrimary)
            Text(String(
                localized: "Choose your city of residence; this will help us find people around you more accurately"
            ))
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
            DtButton( title: String(localized: "Next"), style: .main) {
                // TODO: Next button
                print("next tapped")
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(viewModel: LocationViewModel(router: Router()))
    }
}
