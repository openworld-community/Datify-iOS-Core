//
//  LoginView.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(router: router))
    }

    var body: some View {
        checkState()
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DtLogoView()
                }
            }
            .sheet(isPresented: $viewModel.showForgotSheet) {
                TempView()
            }
            .hideKeyboardTapOutside()
            .navigationBarBackButtonHidden()
    }

    private var idleView: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 8) {
                Text("Welcome!")
                    .dtTypo(.h3Medium, color: .textPrimary)

                Text("Please enter your details for authorisation in the app")
                    .dtTypo(.p2Regular, color: .textSecondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 12) {
                VStack(spacing: 4) {
                    DtCustomTF(
                        style: .password,
                        input: $viewModel.password,
                        isError: $viewModel.isError
                    ) {
                        if !viewModel.isButtonDisabled {
                            viewModel.authenticate()
                        }
                    }

                    if viewModel.isError {
                        Text("Wrong password")
                            .dtTypo(.p4Regular, color: .accentsError)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                }

                Button {
                    viewModel.forgotPassword()
                } label: {
                    Text("Forgot your password?")
                        .dtTypo(.p3Medium, color: .textPrimaryLink)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .trailing
                )
            }

            Spacer()

            VStack(spacing: 8) {
                DtButton(
                    title: String(localized: "Sign in"),
                    style: .main
                ) {
                    viewModel.authenticate()
                }
                .disabled(viewModel.isButtonDisabled)

                Button {
                    viewModel.chooseAnotherWay()
                } label: {
                    Text("Choose another way")
                        .dtTypo(.p2Medium, color: .textPrimary)
                        .padding(.vertical)
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    private func checkState() -> some View {
        switch viewModel.loginState {
        case .inProcess:
            DtSpinnerView(size: 56)
        default:
            idleView
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(router: Router())
    }
}
