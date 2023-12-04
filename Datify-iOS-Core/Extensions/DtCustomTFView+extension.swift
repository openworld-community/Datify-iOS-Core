//
//  DtCustomTFView+extension.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.09.2023.
//

import SwiftUI

struct DtCustomTFViewModifier: ViewModifier {
    var isError: Bool = false
    let style: DtCustomTF.Style
    let keyboardType: UIKeyboardType
    let submitLabel: SubmitLabel
    let textAlignment: TextAlignment
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void

    func body(content: Content) -> some View {
        return HStack {
            if style == .phone {
                CountryCodeButton()
            }
            content
        }
        .dtTypo(.p2Regular, color: .textPrimary)
        .multilineTextAlignment(textAlignment)
        .keyboardType(keyboardType)
        .autocapitalization(.none)
        .frame(
            maxWidth: width,
            minHeight: height
        )
        .padding(.horizontal)
        .background(Color.backgroundSecondary)
        .cornerRadius(AppConstants.Visual.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                    .stroke(isError ? Color.accentsError : .backgroundStroke, lineWidth: 1)
        )
        .submitLabel(submitLabel)
        .onSubmit {
            action()
        }
    }
}
