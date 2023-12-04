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
        Menu {
            ForEach(CountryCodePhoneTF.allCases, id: \.self) { countryCode in
                Button(action: {
                    buttonText = countryCode.stringValue
                    selectedCountryCode = countryCode
                }) {
                    Text(countryCode.stringValue)
                }
            }
        } label: {
            Text(buttonText)
                .dtTypo(.p2Regular, color: Color.textPrimary)
        }
    }
}
