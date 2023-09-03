//
//  PhoneEmailTFView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

struct SecureTextFieldView: View {
    @Binding var input: String
    let placeholder: String
    let placeholderColor: Color
    let textAlignment: TextAlignment
    let keyboardType: UIKeyboardType
    let width: CGFloat
    let height: CGFloat
    var action: (() -> Void)?

    @State private var isPasswordVisible = false

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
        .dtTypo(.p2Regular, color: input.isEmpty ? placeholderColor : Color.textPrimary)
        .multilineTextAlignment(textAlignment)
        .keyboardType(keyboardType)
        .autocapitalization(.none)
        .frame(maxWidth: width, minHeight: height)
        .padding(.horizontal, AppConstants.Visual.paddings)
        .background(Color.backgroundSecondary)
        .cornerRadius(AppConstants.Visual.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                .stroke(Color.backgroundStroke, lineWidth: 1)
        )
        .onSubmit {
            action?()
        }
    }
}
