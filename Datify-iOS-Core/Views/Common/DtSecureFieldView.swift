//
//  DtSecureFieldView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 30.08.2023.
//

import SwiftUI

struct DtSecureFieldView: View {
    @State var isSecureField: Bool = true
    @Binding var text: String
    var title: String

    var body: some View {
        HStack {
            if isSecureField {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }
        }
        .dtTypo(.p2Regular, color: .textPrimary)
        .padding()
        .padding(.trailing, 36)
        .background(Color.backgroundSecondary)
        .cornerRadius(AppConstants.Visual.cornerRadius)
        .overlay(
            RoundedRectangle(
                cornerRadius: AppConstants.Visual.cornerRadius
            )
            .stroke(
                Color.backgroundStroke,
                lineWidth: 0.33
            )
        )
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .overlay(alignment: .trailing) {
            Image(systemName: isSecureField ? "eye.slash" : "eye")
                .padding(.trailing)
                .onTapGesture {
                    isSecureField.toggle()
                }
        }
    }
}

struct DtSecureFieldView_Previews: PreviewProvider {
    static var previews: some View {
        DtSecureFieldView(text: .constant("aaa"), title: "Password")
    }
}
