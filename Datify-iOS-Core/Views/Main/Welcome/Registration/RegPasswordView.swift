//
//  RegPasswordView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 10.11.2023.
//

import SwiftUI

struct RegPasswordView: View {
    private enum FocusField {
        case passwordField, checkPasswordField
    }

    @StateObject private var viewModel: RegPasswordViewModel
    @FocusState private var focusedField: FocusField?

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: RegPasswordViewModel(router: router))
    }

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("Create your password")
                        .dtTypo(.h3Medium, color: .textPrimary)
                    Text("The password must be at least 8 characters long and must not be used anywhere else")
                        .dtTypo(.p2Regular, color: .textSecondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 8) {
                    DtCustomTF(
                        style: .password,
                        input: $viewModel.password,
                        isError: $viewModel.isError,
                        textPlaceholder: "Enter password") {
                            focusedField = .checkPasswordField
                        }
                    DtCustomTF(
                        style: .password,
                        input: $viewModel.checkPassword,
                        isError: $viewModel.isError,
                        textPlaceholder: "Confirm password") {
                            if !viewModel.isButtonDisabled {
                                viewModel.validatePassword()
                            }
                        }
                        .focused($focusedField, equals: .checkPasswordField)
                    Text(
                        viewModel.isPasswordWrong ?
                        "Password mismatch" :
                            viewModel.isWrongFormat ?
                        "Invalid password format" :
                            // space in the Text so that Vstask does not twitch
                        " "
                    )
                    .dtTypo(.p4Regular, color: .accentsError)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.leading)
                }
            }

            Spacer()

            HStack(spacing: 8) {
                DtBackButton {
                    viewModel.router.pop()
                }
                DtButton(title: "Continue".localize(), style: .main) {
                    viewModel.validatePassword()
                }
                .disabled(viewModel.isButtonDisabled)
            }
            .padding(.bottom)
            .navigationBarBackButtonHidden()
        }
        .hideKeyboardTapOutside()
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        RegPasswordView(router: Router())
    }
}
