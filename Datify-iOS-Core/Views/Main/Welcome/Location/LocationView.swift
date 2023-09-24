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
    @State private var selectedCountryAndCity: Country?

    var body: some View {
        VStack {
            Spacer()
            titleLabel
            LocationChooseButtonView(
                location: $selectedCountryAndCity,
                label: "country",
                viewModel: viewModel,
                isCountrySelection: true
            )
            LocationChooseButtonView(
                location: $selectedCountryAndCity,
                label: "city",
                viewModel: viewModel,
                isCountrySelection: false
            )
            Spacer()
            bottomButtons
        }
        .onAppear {
            // TODO: when screen has appeared
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isLoading = false
            }
            viewModel.setupLocationManager()
        }
        .onChange(of: viewModel.location) { newLocation in
            if let countryName = newLocation?.selectedCountryAndCity?.name,
               let cityName = newLocation?.selectedCountryAndCity?.cities.first {
                print("Selected Country: \(countryName)")
                print("Selected City: \(cityName)")
                print("$selectedCountryAndCity: \($selectedCountryAndCity)")

                selectedCountryAndCity = newLocation?.selectedCountryAndCity
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
}

 struct LocationChooseButtonView: View {
    @Binding var location: Country?
    @State private var isPopoverVisible = false

    let label: String
    var viewModel: LocationViewModel
    @State var isCountrySelection: Bool

    var body: some View {
        VStack {
            Button(action: {
                isPopoverVisible.toggle()
            }) {
                HStack {
                    Text("\(label.capitalized):")
                        .dtTypo(.p2Regular, color: .textSecondary)
                        .textInputAutocapitalization(.sentences)
                    if isCountrySelection {
                        Text(location?.name ?? String(localized: "Loading..."))
                            .dtTypo(.p2Regular, color: .textPrimary)
                    } else {
                        Text(location?.cities.first ?? String(localized: "Loading..."))
                            .dtTypo(.p2Regular, color: .textPrimary)
                    }
                    Spacer()
                    Image("iconArrowBottom")
                        .frame(width: 24, height: 24)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(height: AppConstants.Visual.buttonHeight)
                .background(
                    RoundedRectangle(
                        cornerRadius: AppConstants.Visual.cornerRadius
                    )
                    .foregroundColor(.backgroundSecondary)
                )
            }
            .padding(.horizontal)
            .popover(isPresented: $isPopoverVisible, arrowEdge: .bottom) {
                Text(String(localized: "Choose your \(label)"))
                    .dtTypo(.p2Regular, color: .textPrimary)
                    .padding(.top, 20)
                if isCountrySelection {
                    List {
                        ForEach(Country.allCountries, id: \.self) { country in
                            Button(action: {
                                viewModel.location?.selectedCountryAndCity = country
                                isPopoverVisible.toggle()
                            }) {
                                Text(country.name)
                                    .dtTypo(.p2Regular, color: .textPrimary)
                            }
                        }
                    }.background(.secondary)
                } else {
                    List {
                        if let location = viewModel.location?.selectedCountryAndCity {
                            ForEach(location.cities, id: \.self) { city in
                                Button(action: {
                                    print("1viewModel.location?.selectedCity: \(viewModel.location?.selectedCountryAndCity?.cities)")

                                    viewModel.location?.selectedCountryAndCity?.cities = [city]
                                    print("viewModel.location?.selectedCity: \(viewModel.location?.selectedCountryAndCity?.cities)")

                                    print("city: \(city)")
                                    isPopoverVisible.toggle()
                                }) {
                                    Text(city)
                                        .dtTypo(.p2Regular, color: .textPrimary)
                                }
                            }
                        }
                    }
                }
            }
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
