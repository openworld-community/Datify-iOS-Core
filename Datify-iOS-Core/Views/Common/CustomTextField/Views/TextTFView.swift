//
//  NameTFView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

struct TextTFView: View {
    @Binding var input: String
    let placeholder: String

    var body: some View {
        TextField(placeholder, text: $input)
            .frame(height: AppConstants.Visual.buttonHeight)
            .keyboardType(.emailAddress)
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
