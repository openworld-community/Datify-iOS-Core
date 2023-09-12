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

    @State private var country: String = .init()
    @State private var city: String = .init()
    private unowned let router: Router<AppRoute>

    init(
        router: Router<AppRoute>,
        country: String?,
        city: String?,
        viewModel: LocationViewModel = LocationViewModel(router: nil)
    ) {
        self.router = router
        self._selectedCountry = State(initialValue: country ?? Country(name: "Serbia", cities: []))
        self._selectedCity = State(initialValue: city ?? "")
        self.viewModel = viewModel
    }

    let countries: [Country] = Country.allCountries
    @State private var selectedCountry: Country
    @State private var selectedCity: Country

    var cities: [String] {
        return selectedCountry.cities
    }

    var body: some View {

        VStack {
            DtLogoView()
            Spacer()
            titleLabel
            LocationChooseButtonView(label: LabelOfButton.country.stringValue, options: countries, selectedOption: $selectedCountry)
            LocationChooseButtonView(label: LabelOfButton.city.stringValue, options: selectedCountry.cities.map { Country(name: $0, cities: []) }, selectedOption: $selectedCity)
            Spacer()

            bottomButtons
        }
        .onAppear {
            print("countries: \(countries)")
            print("cities: \(cities)")
            print("selectedCountry: \(selectedCountry)")
            print("city: \(viewModel.city)")
            print("country: \(viewModel.country)")

        }

    }
}

struct LocationChooseButtonView: View {
    let label: String
    let options: [Country]
    @Binding var selectedOption: Country

    var body: some View {
        Picker(selection: $selectedOption, label: Text(label)) {
            ForEach(options, id: \.self) { country in
                Text(country.name)
            }
        }
        .pickerStyle(MenuPickerStyle()) // Установите стиль Picker в MenuPickerStyle
        .frame(height: AppConstants.Visual.buttonHeight)
        .background(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
            .foregroundColor(.backgroundSecondary))
        .padding(.horizontal)
    }
}

// struct LocationChooseButtonView: View {
//    let label: String
//    let options: [String]
//    @Binding var input: String
//    @State private var isMenuVisible = false
//    @State private var popoverPosition: Anchor<CGRect>? // Добавляем состояние для позиции Popover
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                isMenuVisible.toggle()
//                // Устанавливаем позицию Popover при нажатии на кнопку
//                popoverPosition = .bounds(.global)
//            }) {
//                HStack {
//                    Text(label)
//                        .dtTypo(.p2Regular, color: .textSecondary)
//                        .padding(.leading)
//                    Text(input)
//                        .dtTypo(.p2Regular, color: .textPrimary)
//                    Spacer()
//                    Image(systemName: "chevron.down")
//                        .padding(.trailing)
//                }
//            }
//            .frame(height: AppConstants.Visual.buttonHeight)
//            .background(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
//                .foregroundColor(.backgroundSecondary))
//            .padding(.horizontal)
//
//            // Отображаем Popover, если isMenuVisible установлено в true
//            if isMenuVisible {
//                Menu {
//                    ForEach(options, id: \.self) { option in
//                        Button(action: {
//                            input = option
//                            print("Selected option: \(option)")
//                            isMenuVisible.toggle()
//                        }) {
//                            Text(option)
//                        }
//                    }
//                } label: {
//                    EmptyView()
//                }
//                .popover(isPresented: $isMenuVisible, attachmentAnchor: popoverPosition) {
//                    // Этот код определяет внешний вид и позицию Popover
//                    // Здесь вы можете настроить стиль и расположение вашего меню
//                    VStack {
//                        // Здесь можно разместить содержимое Popover
//                    }
//                    .padding()
//                }
//            }
//        }
//    }
// }

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(router: Router(), country: "Сербия", city: "Белград")
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
