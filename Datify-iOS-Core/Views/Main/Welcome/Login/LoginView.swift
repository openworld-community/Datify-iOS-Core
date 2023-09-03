//
//  LoginView.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LoginViewModel
    @State private var showErrorAlert: Bool = false
    @FocusState private var focusedField: FocusField?

    private enum FocusField {
        case textField, secureField
    }

    init(viewModel: LoginViewModel = LoginViewModel()) {
        _viewModel = StateObject(wrappedValue: LoginViewModel())
    }

    var body: some View {
        checkState()
            // Временный(?) алерт
            .alert("Wrong Login or password. Please try again!", isPresented: $showErrorAlert) {
                Button("OK", action: { viewModel.loginState = .idle })
            }
            .sheet(isPresented: $viewModel.isShowingSheet) {
                TempView()
            }
            .onTapGesture {
                focusedField = nil
            }
    }

    @ViewBuilder
    private func checkState() -> some View {
        switch viewModel.loginState {
        case .idle:
            VStack {
                DtLogoView()

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
                        placeholder: "Phone number or Email",
                        imageName: "xmark",
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
                        placeholder: "Password"
                    )
                    .focused($focusedField, equals: .secureField)
                    .onSubmit {
                        if !viewModel.isButtonDisabled {
                            viewModel.authenticate()
                        }
                    }

                    HStack {
                        Spacer()

                        Text("Forgot your password?")
                            .dtTypo(.p3Medium, color: .textPrimaryLink)
                            .onTapGesture {
                                viewModel.forgotPassword()
                            }
                    }
                }

                Spacer()

                DtButton(
                    title: "Log in",
                    style: viewModel.isButtonDisabled ? .secondary : .gradient
                ) {
                    if !viewModel.isButtonDisabled {
                        viewModel.authenticate()
                    }
                }

                Text("Choose another way")
                    .dtTypo(.p2Medium, color: .textPrimary)
                    .padding(.vertical)
                    .onTapGesture {
                        dismiss()
                    }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        case .inProcess:
            DtSpinnerView(sideSize: 56)
                .navigationBarBackButtonHidden()
        case .success:
            TempView()
                .navigationBarBackButtonHidden()
        case .error:
            Text("")
                .onAppear {
                    showErrorAlert = true
                }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// TODO: replace with TextFieldView from task IOS-1
struct DtTextFieldView: View {
    @Binding var text: String
    let placeholder: String
    let imageName: String
    let isImageAlwaysShown: Bool
    let submitlabel: SubmitLabel
    let action: () -> Void
    private var isNotEmpty: Bool {
        text != ""
    }

    init(
        text: Binding<String>,
        placeholder: String,
        imageName: String,
        isImageAlwaysShown: Bool = false,
        submitLabel: SubmitLabel,
        action: @escaping () -> Void
    ) {
        _text = text
        self.placeholder = placeholder
        self.imageName = imageName
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
                Image(systemName: imageName)
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
        .submitLabel(submitlabel)
    }
}
