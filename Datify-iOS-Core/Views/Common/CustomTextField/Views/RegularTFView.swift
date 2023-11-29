//
//  RegularTextFieldView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

struct RegularTextFieldView: View {

    let style: DtCustomTF.Style
    @Binding var input: String
    @Binding var isError: Bool
    let placeholder: String
    let keyboardType: UIKeyboardType
    let submitLabel: SubmitLabel
    let textAlignment: TextAlignment
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    var body: some View {
        HStack {
            TextField(placeholder, text: $input)
                .padding(.leading, textAlignment == .center ? input.isEmpty ? 0 : 40 : 0)
            if !input.isEmpty {
                Button(action: {
                    withAnimation {
                        input = ""
                    }
                }) {
                    Image(DtImage.xmark)
                        .foregroundColor(.textPrimary)
                }
                .transition(.opacity)
            }
        }
        .modifier(DtCustomTFViewModifier(
            isError: isError,
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
