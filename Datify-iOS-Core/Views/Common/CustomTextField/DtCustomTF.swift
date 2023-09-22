//
//  CustomTextFieldView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 31.08.2023.
//

import SwiftUI

struct DtCustomTF: View {
    @Environment(\.colorScheme) private var colorScheme

    enum Style: Hashable {
        case phoneAndEmail
        case email
        case password
        case phone
        case sms
        case text(String, TextAlignment?)

        var stringValue: String {
            switch self {
            case .phoneAndEmail: return String(localized: "Phone or Email")
            case .email: return String(localized: "Email")
            case .password: return String(localized: "Password")
            case .phone: return "(000) 000-00-00"
            case .sms: return "00 00 00"
            case .text(let text, _): return text
            }
        }

        var keyboardStyle: UIKeyboardType {
            switch self {
            case .email, .phoneAndEmail: return .emailAddress
            case .phone, .sms: return .phonePad
            default: return .default
            }
        }

        var submitLabel: SubmitLabel {
            switch self {
            case .phone, .email, .phoneAndEmail: return .continue
            case  .sms, .password, .text: return .done
            }
        }

        var textAlignment: TextAlignment {
            switch self {
            case .email, .phoneAndEmail, .password: return .leading
            case .phone, .sms: return .center
            case .text(_, let alignment): return alignment ?? .center
            }
        }
    }

    @State private var isEditing = false
    private let style: DtCustomTF.Style
    @Binding var input: String
    private let width: CGFloat
    private let height: CGFloat
    private let textPlaceholder: String?

    var action: () -> Void

    init(
        style: DtCustomTF.Style,
        input: Binding<String>,
        width: CGFloat = .infinity,
        height: CGFloat = AppConstants.Visual.buttonHeight,
        textPlaceholder: String? = nil,
        action: @escaping () -> Void = UIApplication.shared.dismissKeyboard
    ) {
        self.style = style
        self._input = input
        self.width = width
        self.height = height
        self.textPlaceholder = textPlaceholder
        self.action = action
    }

    var body: some View {
        VStack {
            switch style {
            case .phoneAndEmail:
                    RegularTextFieldView(
                        style: style,
                        input: $input,
                        placeholder: style.stringValue,
                        keyboardType: style.keyboardStyle,
                        submitLabel: style.submitLabel,
                        textAlignment: style.textAlignment,
                        width: width,
                        height: height,
                        action: action
                    )
            case .email:
                    RegularTextFieldView(
                        style: style,
                        input: $input,
                        placeholder: style.stringValue,
                        keyboardType: style.keyboardStyle,
                        submitLabel: style.submitLabel,
                        textAlignment: style.textAlignment,
                        width: width,
                        height: height,
                        action: action
                    )
            case .password:
                    SecureTextFieldView(
                        style: style,
                        input: $input,
                        placeholder: style.stringValue,
                        keyboardType: style.keyboardStyle,
                        submitLabel: style.submitLabel,
                        textAlignment: style.textAlignment,
                        width: width,
                        height: height,
                        action: action
                    )
            case .phone:
                    HStack {
                        CountryCodeButton()
                        RegularTextFieldView(
                            style: style,
                            input: $input,
                            placeholder: style.stringValue,
                            keyboardType: style.keyboardStyle,
                            submitLabel: style.submitLabel,
                            textAlignment: style.textAlignment,
                            width: width,
                            height: height,
                            action: action
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
                    RegularTextFieldView(
                        style: style,
                        input: $input,
                        placeholder: style.stringValue,
                        keyboardType: style.keyboardStyle,
                        submitLabel: style.submitLabel,
                        textAlignment: style.textAlignment,
                        width: width,
                        height: height,
                        action: action
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
                    RegularTextFieldView(
                        style: style,
                        input: $input,
                        placeholder: style.stringValue,
                        keyboardType: style.keyboardStyle,
                        submitLabel: style.submitLabel,
                        textAlignment: style.textAlignment,
                        width: width,
                        height: height,
                        action: action
                    )
            }
        }
    }

    private func formatPhoneNumber() {
        let digits = input.filter { $0.isNumber }
        var formattedPhone = ""

        for (index, digit) in digits.enumerated() {
            switch index {
            case 0: formattedPhone += "(\(digit)"
            case 3: formattedPhone += ") \(digit)"
            case 6: formattedPhone += "-\(digit)"
            case 8: formattedPhone += "-\(digit)"
            default: formattedPhone += String(digit)
            }
        }
        input = formattedPhone
    }
}

struct DtCustomTF_Previews: PreviewProvider {

    static var styles: [DtCustomTF.Style] = [.phoneAndEmail, .email, .password, .phone, .sms, .text("", .center)]

    static var previews: some View {
        VStack {
            ForEach(styles, id: \.self) { style in
                DtCustomTF(
                    style: style,
                    input: .constant("email_just_change_here"),
                    height: 52,
                    textPlaceholder: style.stringValue
                )
                .previewLayout(.sizeThatFits)
                .padding()
            }
        }
    }
}
