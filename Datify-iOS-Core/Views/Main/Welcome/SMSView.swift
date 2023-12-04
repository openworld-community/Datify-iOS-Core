//
//  SMSView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 10.11.2023.
//

import SwiftUI

struct SmsView: View {
    unowned let router: Router<AppRoute>
    @State private var smsCode: String = .init()
    @State private var isError: Bool = false

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("Enter the code from SMS")
                        .dtTypo(.h3Medium, color: .textPrimary)

                    Text("This is required to confirm the number")
                        .dtTypo(.p2Regular, color: .textSecondary)
                }

                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        DtCustomTF(
                            style: .sms,
                            input: $smsCode,
                            isError: $isError) {
                                // TODO: do we need onsubmit action? keyboardStyle is .phonePad
                                router.push(.registrationSex)
                            }

                        Text("Wrong code")
                            .dtTypo(.p4Regular, color: .accentsError)
                            .opacity(isError ? 1 : 0)
                    }

                    Button {
                        // TODO: sending code again
                    } label: {
                        Text("Send the code again")
                            .dtTypo(.p3Medium, color: .textPrimaryLink)
                    }
                    .offset(x: 0, y: isError ? 0 : -16)
                }
            }

            Spacer()

            VStack(spacing: 8) {
                DtButton(title: "Continue".localize(), style: .main) {
                    // TODO: code processing action
                    validateCode()
                }
                .disabled(smsCode.isEmpty)

                DtButton(title: "Choose another way".localize(), style: .other) {
                    router.popToRoot()
                }
            }
        }
        .hideKeyboardTapOutside()
        .padding()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
    }

    private func validateCode() {
        guard smsCode == "777" else {
            isError = true
            return
        }
        isError = false
        router.push(.registrationSex)
    }
}

#Preview {
    SmsView(router: Router())
}
