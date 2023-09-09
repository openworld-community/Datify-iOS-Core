//
//  PhoneTFView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

struct PhoneTFView: View {
    @Binding var input: String
    var body: some View {
        let firstPlaceholder = CountryCodePhoneTF.russia.stringValue
        let secondPlaceholder = ConstantsTF.phonePlaceholder.stringValue
        HStack {
            Button {
                print("Button country code tapped")
            } label: {
                Text(firstPlaceholder)
                    .multilineTextAlignment(.center)
                    .font(dtTypo(.p2Regular, color: Color.textTertiary) as? Font)
                    .padding(.all, AppConstants.Visual.paddings)
            }
            .frame(height: AppConstants.Visual.buttonHeight)
            .background(Color.backgroundSecondary)
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                    .stroke(Color.backgroundStroke, lineWidth: 1)
            )
            .cornerRadius(AppConstants.Visual.cornerRadius)
            .padding(.trailing, AppConstants.Visual.paddings / 2)
            TextField(secondPlaceholder, text: $input)
                .frame(height: AppConstants.Visual.buttonHeight)
                .keyboardType(.phonePad)
                .autocapitalization(.none)
                .background(Color.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                        .stroke(Color.backgroundStroke, lineWidth: 1)
                )
                .cornerRadius(AppConstants.Visual.cornerRadius)
                .multilineTextAlignment(.center)
                .font(dtTypo(.p2Regular, color: Color.textTertiary) as? Font)
        }
    }
}
