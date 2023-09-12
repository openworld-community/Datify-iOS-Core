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

    var stringValue: String {
        switch self {
            case .country: return String(localized: "Country: ")
            case .city: return String(localized: "City: ")
        }
    }
}

struct LocationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LocationViewModel
    private unowned let router: Router<AppRoute>

    @State private var selectedCountry: Country?
    @State private var selectedCity: Country?

    let countries: [Country] = Country.allCountries

    init(
        router: Router<AppRoute>,
        viewModel: LocationViewModel

    ) {
        self.router = router
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            DtLogoView()
            Spacer()
            titleLabel

            LocationChooseButtonView(
                label: LabelOfButton.country.stringValue,
                countries: countries,
                selectedCountry: $selectedCountry
            )

//            if let selectzedCountry = selectedCountry {
                LocationChooseButtonView(
                    label: LabelOfButton.city.stringValue,
                    countries: selectedCountry?.cities.map { Country(name: $0, cities: []) } ?? [],
                    selectedCountry: $selectedCity
                )
//            }

            Spacer()

            bottomButtons
        }
        .onAppear {
            viewModel.locationManager.requestLocation()
            print("selectedCountry: \(viewModel.selectedCountry)")
            print("selectedCity: \(viewModel.selectedCity)")

        }
        .onReceive(viewModel.locationManager.$location) { location in
            // Обновление выбранных страны и города после получения местоположения
            print(selectedCountry)
            print(selectedCity)
            selectedCountry = location?.country
            selectedCity = location?.city
        }
    }
}

struct LocationChooseButtonView: View {
    let label: String
    let countries: [Country]
    @Binding var selectedCountry: Country?
    @State private var isPickerVisible = false

    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    selectedCountry = nil
                }
                print("tapped ")
            }) {
                HStack {
                    Text(label)
                    Text(selectedCountry?.name ?? "Serbia")
                        .foregroundColor(selectedCountry == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .frame(width: 24, height: 24)
                        .foregroundColor(.textSecondary)
                }
                .padding()
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                )
            }
            .padding(.horizontal)

            if selectedCountry != nil {
                Picker("", selection: $selectedCountry) {
                    ForEach(countries, id: \.self) { country in
                        Text(country.name).tag(country)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                .padding()
            }
        }
    }
}

extension LocationView {
    private var titleLabel: some View {
        VStack(spacing: 8) {
            Text("Where are you located?")
                .dtTypo(.h3Medium, color: .textPrimary)
            Text(" Choose your city of residence; this will help us find people around you more accurately")
                .dtTypo(.p2Regular, color: .textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 40)
    }

    private var bottomButtons: some View {
        HStack {
            Button {
                print("back")
            } label: {
                Image("arrowLeft")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
            .frame(width: 56, height: AppConstants.Visual.buttonHeight)
            .background(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                            .foregroundColor(.backgroundSecondary))

            DtButton(title: "Next", style: .main) {
                print("next tapped")
            }
        }.padding(.horizontal)
    }
}
