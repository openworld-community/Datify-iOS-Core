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
            if !input.isEmpty {
                Button(action: {
                    withAnimation {
                        input = ""
                    }
                }) {
                    Image("xmark")
                        .foregroundColor(.textPrimary)
                }
                .transition(.opacity)
            }
        }
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
        .onSubmit {
            action?()
        }
    }
}
