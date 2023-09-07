//
//  DtSecureFieldView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 30.08.2023.
//

import SwiftUI

struct DtSecureFieldView: View {
    @Binding var text: String
    @State private var style: DtSecureFieldView.Style
    let placeholder: String

    enum Style {
        case standart, secure
    }

    init(
        text: Binding<String>,
        style: DtSecureFieldView.Style,
        placeholder: String
    ) {
        _text = text
        self.style = style
        self.placeholder = placeholder
    }

    var body: some View {
        switch style {
        case .standart:
            DtTextFieldView(
                text: $text,
                placeholder: placeholder,
                image: Image(systemName: "eye"),
                isImageAlwaysShown: true
            ) {
                style = .secure
            }
        case .secure:
            HStack {
                SecureField(placeholder, text: $text)

                Button {
                    style = .standart
                } label: {
                    Image(systemName: "eye.slash")
                }
                .frame(width: 24, height: 24)
            }
            .dtTypo(.p2Regular, color: .textPrimary)
            .padding()
            .background(Color.backgroundSecondary)
            .cornerRadius(AppConstants.Visual.cornerRadius)
            .overlay(
                RoundedRectangle(
                    cornerRadius: AppConstants.Visual.cornerRadius
                )
                .stroke(
                    Color.backgroundStroke,
                    lineWidth: 1
                )
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.done)
        }
    }
}

struct DtSecureFieldView_Previews: PreviewProvider {
    static var previews: some View {
        DtSecureFieldView(text: .constant(""), style: .standart, placeholder: "Password")
    }
}
