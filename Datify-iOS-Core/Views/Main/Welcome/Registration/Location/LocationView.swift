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
        self._country = State(initialValue: country ?? "Serbia")
        self._city = State(initialValue: city ?? "Belgrade")
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            DtLogoView()
            Spacer()
            titleLabel

            LocationChooseButtonView(label: LabelOfButton.country.stringValue, input: $viewModel.country)
            LocationChooseButtonView(label: LabelOfButton.city.stringValue, input: $viewModel.city)
            Spacer()

            bottomButtons
        }

    }
}

struct LocationChooseButtonView: View {
    let label: String
    @Binding var input: String

    var body: some View {
        Button {
            print("Choose country tap")
        } label: {
            HStack {
                Text(label)
                    .dtTypo(.p2Regular, color: .textSecondary)
                    .padding(.leading)
                Text(input)
                    .dtTypo(.p2Regular, color: .textPrimary)
                Spacer()
                Image("iconArrowBottom")
                    .padding(.trailing)
            }
        }
        .frame(height: AppConstants.Visual.buttonHeight)
        .background(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
            .foregroundColor(.backgroundSecondary))
        .padding(.horizontal)
    }
}

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
