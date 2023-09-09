//
//  PreviewCTF.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 02.09.2023.
//

import SwiftUI

struct ContentViewCTF: View {
    @State private var inputPhoneEmail = ""
    @State private var inputEmail = ""
    @State private var inputPassword = ""
    @State private var inputPhone = ""
    @State private var inputSms = ""
    @State private var inputName = ""

    var body: some View {
        PreviewCTF(
            inputPhoneEmail: $inputPhoneEmail,
            inputEmail: $inputEmail,
            inputPassword: $inputPassword,
            inputPhone: $inputPhone,
            inputSms: $inputSms,
            inputName: $inputName
        )
    }
}

struct ContentViewCTF_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewCTF()
    }
}

struct PreviewCTF: View {
    @Binding var inputPhoneEmail: String
    @Binding var inputEmail: String
    @Binding var inputPassword: String
    @Binding var inputPhone: String
    @Binding var inputSms: String
    @Binding var inputName: String

    var body: some View {
        VStack {
            DtCustomTF(
                input: $inputPhoneEmail,
                style: .phoneAndEmail,
                action: {
                    print("Enter нажат: \(inputPhoneEmail)")
                }
            )
            DtCustomTF(
                input: $inputEmail,
                style: .email,
                action: {
                    print("Enter нажат: \(inputEmail)")
                }
            )
            DtCustomTF(
                input: $inputPassword,
                style: .password,
                action: {
                    print("Enter нажат: \(inputPassword)")
                })
            DtCustomTF(
                input: $inputPhone,
                style: .phone,
                action: {
                    print("Enter нажат: \(inputPhone)")
                }
            )
            DtCustomTF(
                input: $inputSms,
                style: .sms,
                action: {
                    print("Enter нажат: \(inputSms)")
                }
            )
            DtCustomTF(
                input: $inputName,
                style: .text,
                textPlaceholder: "Your Name",
                action: {
                    print("Enter нажат: \(inputName)")
                }
            )
        }
    }
}
