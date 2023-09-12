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

    @ObservedObject private var viewModel: LocationViewModel

    private unowned let router: Router<AppRoute>

    @State private var country: String = .init()
    @State private var city: String = .init()
    @Binding private var selectedCountry: Country
    @Binding private var selectedCity: Country

    let countries: [Country] = Country.allCountries

    init(
        router: Router<AppRoute>,
        selectedCountry: Binding<Country>,
        selectedCity: Binding<Country>,
        viewModel: LocationViewModel = LocationViewModel(router: nil)
    ) {
        self.router = router
        self._selectedCountry = selectedCountry
        self._selectedCity = selectedCity
        self.viewModel = viewModel
    }

    var body: some View {

        VStack {
            DtLogoView()
            Spacer()
            titleLabel
//            LocationChooseButtonView(
//                label: LabelOfButton.country.stringValue,
//                countries: countries,
//                selectedCountry: $selectedCountry
//            )
//
//            LocationChooseButtonView(
//                label: LabelOfButton.city.stringValue,
//                options: selectedCountry?.cities.map { Country(name: $0, cities: []) } ?? [],
//                selectedOption: $selectedCity
//            )
            if let selectedCountry = selectedCountry {
                LocationChooseButtonView(
                    label: LabelOfButton.country.stringValue,
                    countries: countries,
                    selectedCountry: $selectedCountry
                )
            }

            if let selectedCountry = selectedCountry {
                LocationChooseButtonView(
                    label: LabelOfButton.city.stringValue,
                    countries: selectedCountry.cities.map { Country(name: $0, cities: []) },
                    selectedCountry: $selectedCity
                )
            }
            Spacer()

            bottomButtons
        }
        .onAppear {
            print("countries: \(countries)")
//            print("cities: \(cities)")
            print("selectedCountry: \(selectedCountry)")
            print("city: \(viewModel.city)")
            print("country: \(viewModel.country)")

        }

    }
}

struct LocationChooseButtonView: View {
    let label: String
    let countries: [Country]
    @Binding var selectedCountry: Country?
    @State private var isPickerVisible = false

//    var body: some View {
//        Picker(selection: $selectedOption, label: Text("\(label): \(selectedOption.name)")) {
//                ForEach(options, id: \.self) { country in
//                    Text(country.name)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            .frame(height: AppConstants.Visual.buttonHeight)
//            .background(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
//                .foregroundColor(.backgroundSecondary))
//    }

    var body: some View {
           VStack {
               Button(action: {
                   withAnimation {
                       selectedCountry = nil
                   }
               }) {
                   HStack {
                       Text(selectedCountry?.name ?? "Select Country")
                           .foregroundColor(selectedCountry == nil ? .gray : .black)
                       Spacer()
                       Image(systemName: "chevron.down.circle")
                           .resizable()
                           .frame(width: 20, height: 20)
                           .foregroundColor(.blue)
                   }
                   .padding()
                   .frame(height: 50)
                   .background(RoundedRectangle(cornerRadius: 10)
                       .foregroundColor(.white)
                       .shadow(radius: 3))
               }

               if let selectedCountry = selectedCountry {
                   Picker("", selection: $selectedCountry) {
                       ForEach(countries, id: \.self) { country in
                           Text(country.name).tag(country)
                       }
                   }
                   .pickerStyle(WheelPickerStyle()) // Вы можете выбрать другой стиль пикера
                   .labelsHidden()
                   .padding()
               }
           }
       }
}

// struct LocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationView(router: Router(), selectedCountry: , selectedCity: <#T##Binding<Country>#>)
//    }
// }

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
