//
//  PhoneEmailTFView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

struct PhoneEmailTFView: View {
    @Binding var input: String

    var body: some View {
        let placeholder = ConstantsTF.phoneAndEmailPlaceholder.stringValue

        TextField(placeholder, text: $input)
            .frame(height: AppConstants.Visual.buttonHeight)
            .padding(.leading, AppConstants.Visual.paddings)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .background(Color.backgroundSecondary)
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                    .stroke(Color.backgroundStroke, lineWidth: 1)
                )
            .cornerRadius(AppConstants.Visual.cornerRadius)
            .multilineTextAlignment(.leading)
            .font(dtTypo(.p2Regular, color: Color.textTertiary) as? Font)
    }
}
