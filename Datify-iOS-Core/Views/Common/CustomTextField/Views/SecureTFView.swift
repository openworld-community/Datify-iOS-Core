//
//  PhoneEmailTFView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

struct SecureTextFieldView: View {
    @State private var isPasswordVisible = false

    let style: DtCustomTF.Style
    @Binding var input: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let submitLabel: SubmitLabel
    let textAlignment: TextAlignment
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    var body: some View {
        HStack {
            if isPasswordVisible {
                TextField(placeholder, text: $input)
            } else {
                SecureField(placeholder, text: $input)
            }

            if !input.isEmpty {
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(isPasswordVisible ? "eyeShow" : "eyeHide")
                        .foregroundColor(.textPrimary)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .disableAutocorrection(true)
        .modifier(DtCustomTFViewModifier(
            style: style,
            keyboardType: keyboardType,
            submitLabel: submitLabel,
            textAlignment: textAlignment,
            width: width,
            height: height,
            action: action
        ))
    }
}
