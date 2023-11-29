//
//  RecoveryView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 19.11.2023.
//

import SwiftUI

struct RecoveryView: View {
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 8) {
                Text("Password reset")
                    .dtTypo(.h3Medium, color: .textPrimary)

                VStack {
                    Text("To reset the pin code, confirm the action by entering the code sent to the mail")
                        .dtTypo(.p2Regular, color: .textSecondary)
                        .multilineTextAlignment(.center)

                    Text("i******7@gmail.com")
                        .dtTypo(.p2Regular, color: .textPrimary)
                        .tint(.textPrimary)
                }
            }

            VStack(spacing: 8) {
                DtCustomTF(
                    style: .sms,
                    input: $viewModel.receivedPassword,
                    isError: $viewModel.isError
                )

                Text("Wrong password")
                    .dtTypo(.p4Regular, color: .accentsError)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .opacity(viewModel.isError ? 1 : 0)
            }

            Spacer()

            DtButton(
                title: "Sign in".localize(),
                style: .main
            ) {
                viewModel.validateReceivedPassword()
            }
            .disabled(viewModel.receivedPassword.isEmpty)
        }
        .hideKeyboardTapOutside()
        .padding()
    }
}

#Preview {
    RecoveryView(viewModel: LoginViewModel(router: Router()))
}
