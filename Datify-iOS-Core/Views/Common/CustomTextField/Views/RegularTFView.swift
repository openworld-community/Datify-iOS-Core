//
    //  EmailTFView.swift
    //  Datify-iOS-Core
    //
    //  Created by Ildar Khabibullin on 02.09.2023.
    //

import SwiftUI

struct RegularTextFieldView: View {
    @Binding var input: String
    let placeholder: String
    let placeholderColor: Color
    let textAlignment: TextAlignment
    let keyboardType: UIKeyboardType
    let width: CGFloat
    let height: CGFloat
    let style: DtCustomTF.Style
    var action: (() -> Void)?

    var body: some View {
        HStack {
            TextField(placeholder, text: $input)
            if !input.isEmpty {
                Button(action: {
                    withAnimation {
                        input = ""
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.textPrimary)
                }
                .transition(.opacity)
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
