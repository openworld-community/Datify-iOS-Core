//
//  LoginView.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct LoginView: View {
    private unowned let router: Router<AppRoute>
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LoginViewModel
    @FocusState private var focusedField: FocusField?

    private enum FocusField {
        case textField, secureField
    }

    init(router: Router<AppRoute>,
         viewModel: LoginViewModel = LoginViewModel(router: nil)
    ) {
        self.router = router
        _viewModel = StateObject(wrappedValue: LoginViewModel(router: router))
    }

    var body: some View {
        checkState()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DtLogoView()
                }
            }
            .sheet(isPresented: $viewModel.forgotSheet) {
                TempView()
            }
            .onTapGesture {
                focusedField = nil
            }
    }

    private var idleView: some View {
        VStack {
            Spacer()

            VStack(spacing: 8) {
                Text("Welcome!")
                    .dtTypo(.h3Medium, color: .textPrimary)

                Text("Please enter your details for authorisation in the app")
                    .dtTypo(.p2Regular, color: .textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 40)

            VStack(spacing: 12) {
                DtTextFieldView(
                    text: $viewModel.email,
                    placeholder: String(localized: "Phone number or Email"),
                    image: Image(systemName: "xmark"),
                    submitLabel: .continue
                ) {
                    viewModel.email = .init()
                }
                .focused($focusedField, equals: .textField)
                .onSubmit {
                    focusedField = .secureField
                }

                DtSecureFieldView(
                    text: $viewModel.password,
                    style: .secure,
                    placeholder: String(localized: "Password")
                )
                .focused($focusedField, equals: .secureField)
                .onSubmit {
                    if !viewModel.isButtonDisabled {
                        viewModel.authenticate()
                    }
                }

                HStack {
                    Spacer()

                    Button {
                        viewModel.forgotPassword()
                    } label: {
                        Text("Forgot your password?")
                            .dtTypo(.p3Medium, color: .textPrimaryLink)
                    }
                }
            }

            Spacer()

            DtButton(
                title: String(localized: "Sign in"),
                style: .gradient
            ) {
                viewModel.authenticate()
            }
            .disabled(viewModel.isButtonDisabled)

            Button {
                dismiss()
            } label: {
                Text("Choose another way")
                    .dtTypo(.p2Medium, color: .textPrimary)
                    .padding(.vertical)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    @ViewBuilder
    private func checkState() -> some View {
        switch viewModel.loginState {
        case .inProcess:
            DtSpinnerView(size: 56)
                .navigationBarBackButtonHidden()
        default:
            idleView
                // Temporary(?) alert
                .alert("Wrong Login or password. Please try again!", isPresented: $viewModel.isError) {
                    Button("OK", action: {
                        viewModel.loginState = .idle
                        viewModel.isError = false
                    })
                }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(router: Router())
    }
}

// TODO: replace with TextFieldView from task IOS-1
struct DtTextFieldView: View {
    @Binding var text: String
    let placeholder: String
    let image: Image?
    let isImageAlwaysShown: Bool
    let submitlabel: SubmitLabel
    let action: () -> Void
    private var isNotEmpty: Bool {
        text != ""
    }

    init(
        text: Binding<String>,
        placeholder: String,
        image: Image?,
        isImageAlwaysShown: Bool = false,
        submitLabel: SubmitLabel = .done,
        action: @escaping () -> Void
    ) {
        _text = text
        self.placeholder = placeholder
        self.image = image
        self.isImageAlwaysShown = isImageAlwaysShown
        self.submitlabel = submitLabel
        self.action = action
    }

    var body: some View {
        HStack {
            TextField(
                placeholder,
                text: $text
            )

            Button {
                action()
            } label: {
                image
            }
            .frame(width: 24, height: 24)
            .opacity(
                isImageAlwaysShown ?
                1 :
                (isNotEmpty ? 1 : 0)
            )
        }
        .dtTypo(.p2Regular, color: .textPrimary)
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(AppConstants.Visual.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
            .stroke(Color.backgroundStroke, lineWidth: 1))
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .submitLabel(submitlabel)
    }
}
