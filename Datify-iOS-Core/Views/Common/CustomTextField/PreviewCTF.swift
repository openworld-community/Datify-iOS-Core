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
                style: .phoneAndEmail
            )
            DtCustomTF(
                input: $inputEmail,
                style: .email
            )
            DtCustomTF(
                input: $inputPassword,
                style: .password
            )
            DtCustomTF(
                input: $inputPhone,
                style: .phone
            )
            DtCustomTF(
                input: $inputSms,
                style: .sms
            )
            DtCustomTF(
                input: $inputName,
                style: .text,
                textPlaceholder: "Your Name"
            )
        }
    }
}
