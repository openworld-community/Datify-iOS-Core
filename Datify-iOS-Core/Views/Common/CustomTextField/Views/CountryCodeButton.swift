//
//  CountryCodeButton.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 03.09.2023.
//

import SwiftUI

struct CountryCodeButton: View {
    @State private var selectedCountryCode: CountryCodePhoneTF?
    @State private var buttonText: String = CountryCodePhoneTF.russia.stringValue

    var body: some View {
        Button {
            print("button country code tapped")
        } label: {
            Text(buttonText)
                .dtTypo(.p2Regular, color: Color.textPrimary)
        }
        .contextMenu {
            ForEach(CountryCodePhoneTF.allCases, id: \.self) { countryCode in
                Button(action: {
                    buttonText = countryCode.stringValue
                    selectedCountryCode = countryCode
                }) {
                    Text(countryCode.stringValue)
                }
            }
        }
        .frame(height: AppConstants.Visual.buttonHeight)
        .padding(.horizontal)
        .background(Color.backgroundSecondary)
        .cornerRadius(AppConstants.Visual.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                .stroke(Color.backgroundStroke, lineWidth: 1)
        )
    }
}
