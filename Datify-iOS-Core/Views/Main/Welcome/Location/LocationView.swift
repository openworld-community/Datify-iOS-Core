//
//  LocationView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import SwiftUI

enum LabelOfButton {
    case country
    case city

    var stringValue: [String] {
        switch self {
        case .country: return [
            String(localized: "Country: "),
            String(localized: "country")
        ]
        case .city: return [
            String(localized: "City: "),
            String(localized: "city")
        ]
        }
    }
}

struct LocationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: LocationViewModel

    @State private var cities: [String] = .init()
    @State private var isLoading = true

    let countries: [Country] = Country.allCountries

    var body: some View {
        VStack {
            DtLogoView()
            Spacer()
            titleLabel

            LocationChooseButtonView(
                selectedCountry: $viewModel.selectedCountry,
                label: LabelOfButton.country.stringValue,
                countries: countries
            )
            .onChange(of: viewModel.selectedCountry) { newCountry in
                switch (newCountry, viewModel.location?.city) {
                case (let newCountry?, let gpsCity?):
                    if newCountry.name == viewModel.location?.country?.name {
                        viewModel.selectedCity = gpsCity
                    } else {
                        viewModel.selectedCity = cities.first.map { Country(name: $0, cities: []) }
                    }
                default:
                        cities = []
                }
            }
            LocationChooseButtonView(
                selectedCountry: $viewModel.selectedCity,
                label: LabelOfButton.city.stringValue,
                countries: viewModel.selectedCountry?.cities.map { Country(name: $0, cities: []) } ?? []
            )
            Spacer()
            bottomButtons
        }
        .onAppear {
            // TODO: when screen has appeared
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = false
            }
            viewModel.setupLocationManager()
        }
        .overlay(
            Group {
                if isLoading {
                    DtSpinnerView(size: 30)
                }
            }
        )
    }
}

struct LocationChooseButtonView: View {
    @Binding var selectedCountry: Country?
    @State private var isPopoverVisible = false
    @State private var selectedCountryIndex: Int?

    let label: [String]
    let countries: [Country]

    var body: some View {
        VStack {
            Button(action: {
                isPopoverVisible.toggle()
            }) {
                HStack {
                    Text(label.first ?? "")
                        .dtTypo(.p2Regular, color: .textSecondary)
                    Text((selectedCountry?.name ?? countries.first?.name) ?? "Loading...")
                        .dtTypo(.p2Regular, color: .textPrimary)
                    Spacer()
                    Image(systemName: "chevron.down")
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
                Text("Choose your \(label.last ?? "")")
                    .dtTypo(.p2Regular, color: .textPrimary)
                    .padding(.top, 20)
                List {
                    ForEach(countries.indices, id: \.self) { index in
                        Button(action: {
                            selectedCountry = countries[index]
                            selectedCountryIndex = index
                            isPopoverVisible.toggle()
                        }) {
                            Text(countries[index].name)
                                .dtTypo(.p2Regular, color: .textPrimary)
                        }
                    }
                }.background(Color.white)
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
            Button {
                // TODO: Back button
                print("back")
            } label: {
                Image("arrowLeft")
                    .resizableFit()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
            .frame(width: 56, height: AppConstants.Visual.buttonHeight)
            .background(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                .foregroundColor(.backgroundSecondary))

            DtButton(title: "Next", style: .main) {
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
