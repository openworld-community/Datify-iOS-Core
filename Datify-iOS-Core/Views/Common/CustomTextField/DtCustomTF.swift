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
        case phone
        case sms
        case text
    }

    @State private var isEditing = false
    @Binding var input: String
    private let width: CGFloat
    private let height: CGFloat
    private let style: DtCustomTF.Style
    private let textPlaceholder: String?

    init(
        input: Binding<String>,
        width: CGFloat = .infinity,
        height: CGFloat = AppConstants.Visual.buttonHeight,
        style: DtCustomTF.Style,
        textPlaceholder: String? = nil
    ) {
        self._input = input
        self.width = width
        self.height = height
        self.style = style
        self.textPlaceholder = textPlaceholder
    }

    var body: some View {
        VStack {
            switch style {
            case .phoneAndEmail:
                    createBody(
                        configuration: TextFieldConfiguration(
                            placeholder: ConstantsTF.phoneAndEmailPlaceholder.stringValue,
                            placeholderColor: .textTertiary,
                            textAlignment: .leading,
                            keyboardType: .emailAddress,
                            secure: false
                        )
                    )
            case .email:
                    createBody(
                        configuration: TextFieldConfiguration(
                            placeholder: ConstantsTF.emailPlaceholder.stringValue,
                            placeholderColor: .textTertiary,
                            textAlignment: .leading,
                            keyboardType: .emailAddress,
                            secure: false
                        )
                    )
            case .password:
                    createBody(
                        configuration: TextFieldConfiguration(
                            placeholder: ConstantsTF.passwordPlaceholder.stringValue,
                            placeholderColor: .textTertiary,
                            textAlignment: .leading,
                            keyboardType: .default,
                            secure: true

                        )
                    )
            case .phone:
                    HStack {
                        CountryCodeButton()
                        createBody(
                            configuration: TextFieldConfiguration(
                                placeholder: ConstantsTF.phonePlaceholder.stringValue,
                                placeholderColor: .textTertiary,
                                textAlignment: .center,
                                keyboardType: .phonePad,
                                secure: false
                            )
                        )
                        .onChange(of: input) { newValue in
                            let digits = newValue.filter { $0.isNumber }
                            if digits.count >= 10 {
                                input = String(digits.prefix(10))
                            } else {
                                input = String(digits)
                            }
                            formatPhoneNumber()

                        }
                    }
            case .sms:
                    createBody(
                        configuration: TextFieldConfiguration(
                            placeholder: ConstantsTF.smsPlaceholder.stringValue,
                            placeholderColor: .textTertiary,
                            textAlignment: .center,
                            keyboardType: .phonePad,
                            secure: true
                        )
                    )
                    .onChange(of: input) { newValue in
                        let digits = newValue.filter { $0.isNumber }
                        if digits.count >= 6 {
                            input = String(digits.prefix(6))
                        } else {
                            input = String(digits)
                        }
                    }
            case .text:
                    createBody(
                        configuration: TextFieldConfiguration(
                            placeholder: textPlaceholder ?? "",
                            placeholderColor: .textTertiary,
                            textAlignment: .center,
                            keyboardType: .default,
                            secure: false
                        )
                    )
            }
        }
    }

    private func createBody(configuration: TextFieldConfiguration) -> some View {
        if configuration.secure {
            return (SecureTextFieldView(
                input: $input,
                placeholder: configuration.placeholder,
                placeholderColor: configuration.placeholderColor,
                textAlignment: configuration.textAlignment,
                keyboardType: configuration.keyboardType,
                width: width,
                height: height
            )).eraseToAnyView()
        } else {
            return (RegularTextFieldView(
                input: $input,
                placeholder: configuration.placeholder,
                placeholderColor: configuration.placeholderColor,
                textAlignment: configuration.textAlignment,
                keyboardType: configuration.keyboardType,
                width: width,
                height: height,
                style: style
            )).eraseToAnyView()
        }
    }

    private func formatPhoneNumber() {
        let digits = input.filter { $0.isNumber }
        var formattedPhone = ""

        for (index, digit) in digits.enumerated() {
            if index == 0 {
                formattedPhone += "(\(digit)"
            } else if index == 3 {
                formattedPhone += ") \(digit)"
            } else if index == 6 {
                formattedPhone += "-\(digit)"
            } else if index == 8 {
                formattedPhone += "-\(digit)"
            } else {
                formattedPhone += String(digit)
            }
        }
        input = formattedPhone
    }
}

struct TextFieldConfiguration {
    let placeholder: String
    let placeholderColor: Color
    let textAlignment: TextAlignment
    let keyboardType: UIKeyboardType
    let secure: Bool
}

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
