//
//  LocationView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import SwiftUI

struct LocationView: View {
    private unowned let router: Router<AppRoute>
    @State private var country: String = .init()
    @State private var city: String = .init()
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LocationViewModel

    enum Label {
        case country
        case city
        
        var stringValuer: String {
            switch Label {
                case .country: return 
            }
        }
    }
    
    init(
        router: Router<AppRoute>,
        country: String?,
        city: String?,
        viewModel: LocationViewModel = LocationViewModel(router: nil)
    ) {
        self.router = router
        self._country = State(initialValue: country ?? "Serbia")
        self._city = State(initialValue: city ?? "Belgrade")
        _viewModel = StateObject(wrappedValue: LocationViewModel(router: router))
    }

    var body: some View {
        VStack {
            DtLogoView()
            Spacer()
            titleLabel

            LocationChooseButtonView(input: $country)
            LocationChooseButtonView(input: $city)
            Spacer()

            bottomButtons
        }

    }
}

struct LocationChooseButtonView: View {
    
    @Binding var input: String

    var body: some View {
        Button {
            print("Choose country tap")
        } label: {
            HStack {
                Text("Country:")
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
