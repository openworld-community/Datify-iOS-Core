//
//  CustomTextFieldView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 31.08.2023.
//

import SwiftUI

struct DtCustomTF: View {
    @Environment(\.colorScheme) private var colorScheme

    enum Style {
        case phoneAndEmail
        case email
        case password
        case text
        case phone
        case sms
    }

    @Binding var input: String
    private let width: CGFloat
    private let height: CGFloat
    private let style: DtCustomTF.Style

    init(
        input: Binding<String>,
        width: CGFloat = .infinity,
        height: CGFloat = AppConstants.Visual.buttonHeight,
        style: DtCustomTF.Style
    ) {
        self._input = input
        self.width = width
        self.height = height
        self.style = style
    }

    var body: some View {
           VStack {
               switch style {
               case .phoneAndEmail:
                   createBody(
                       configuration: TextFieldConfiguration(
                        placeholder: ConstantsTF.emailPlaceholder.stringValue,
                           placeholderColor: .textTertiary,
                           textAlignment: .leading,
                           keyboardType: .default
                       )
                   )
               case .email:
                   createBody(
                       configuration: TextFieldConfiguration(
                        placeholder: ConstantsTF.emailPlaceholder.stringValue,
                           placeholderColor: .textTertiary,
                           textAlignment: .leading,
                           keyboardType: .emailAddress
                       )
                   )
               case .password:
                   createBody(
                       configuration: TextFieldConfiguration(
                        placeholder: ConstantsTF.passwordPlaceholder.stringValue,
                           placeholderColor: .textTertiary,
                           textAlignment: .leading,
                           keyboardType: .default
                       )
                   )
                       // MARK: Should add enum for different state of textPlaceHolder
               case .text:
                   createBody(
                       configuration: TextFieldConfiguration(
                        placeholder: ConstantsTF.namePlaceholder.stringValue,
                           placeholderColor: .textTertiary,
                        textAlignment: .center,
                           keyboardType: .default
                       )
                   )
               case .phone:
                   createBody(
                       configuration: TextFieldConfiguration(
                        placeholder: ConstantsTF.phonePlaceholder.stringValue,
                        placeholderColor: .textTertiary,
                           textAlignment: .center,
                           keyboardType: .phonePad
                       )
                   )
               case .sms:
                   Text("SMS TextField")
               }
           }
       }

    private func createBody(configuration: TextFieldConfiguration) -> some View {
        TextField(configuration.placeholder, text: $input)
            .dtTypo(.p2Medium, color: configuration.placeholderColor)
            .multilineTextAlignment(configuration.textAlignment)
            .frame(maxWidth: width, minHeight: height)
            .padding(.leading, AppConstants.Visual.paddings)
            .keyboardType(configuration.keyboardType)
            .autocapitalization(.none)
            .background(Color.backgroundSecondary)
            .cornerRadius(AppConstants.Visual.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                    .stroke(Color.backgroundStroke, lineWidth: 1)
            )
    }
}

struct TextFieldConfiguration {
    let placeholder: String
    let placeholderColor: Color
    let textAlignment: TextAlignment
    let keyboardType: UIKeyboardType
}

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
