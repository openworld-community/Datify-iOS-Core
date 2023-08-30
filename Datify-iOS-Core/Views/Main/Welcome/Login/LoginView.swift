//
//  LoginView.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: LoginViewModel
    
    init(transferData: String) {
        _viewModel = StateObject(wrappedValue: LoginViewModel())
    }
    
    var body: some View {
        if viewModel.authenticated && viewModel.showSpinner {
            DtSpinnerView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        viewModel.showSpinner = false
                    }
                }
                .navigationBarBackButtonHidden()
        } else if viewModel.authenticated {
            TempView()
                .navigationBarBackButtonHidden()
        } else if viewModel.showForgotPassword {
            TempView()
        } else {
            VStack {
                DtLogoView()
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Добро пожаловать!")
                        .dtTypo(.h3Medium, color: .textPrimary)
                    
                    Text("Пожалуйста, введите свои данные для авторизации в приложении")
                        .dtTypo(.p2Regular, color: .textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 40)
                
                VStack(spacing: 12) {
                    DtTextFieldView(
                        text: $viewModel.email,
                        title: "Телефон или почта"
                    )
                    
                    DtSecureFieldView(
                        text: $viewModel.password,
                        title: "Пароль"
                    )
                    
                    HStack {
                        Spacer()
                        
                        Text("Забыли пароль?")
                            .dtTypo(.p3Medium, color: .textPrimaryLink)
                            .onTapGesture {
                                viewModel.forgotPassword()
                            }
                    }
                }
                
                Spacer()
                
                DtButton(
                    title: "Войти",
                    style: viewModel.isButtonDisabled ? .secondary : .gradient
                ) {
                    if !viewModel.isButtonDisabled {
                        viewModel.authenticate()
                    }
                }
                //            .disabled(viewModel.isButtonDisabled)
                
                Text("Выбрать другой способ")
                    .dtTypo(.p2Medium, color: .textPrimary)
                    .padding(.vertical)
                    .onTapGesture {
                        //                        viewModel.anotherWayToLogIn()
                        dismiss()
                    }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            // Временный алерт
            .alert("Wrong Login or password", isPresented: $viewModel.invalid) {
                Button("OK", action: {} )
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(transferData: "LoginView")
    }
}

// TODO заменить на кастомный TextFieldView из задачи IOS-1
struct DtTextFieldView: View {
    @Binding var text: String
    var title: String
    var isNotEmpty: Bool {
        text != ""
    }
    
    var body: some View {
        TextField(
            title,
            text: $text
        )
        .dtTypo(.p2Regular, color: .textPrimary)
        .padding()
        .background(Color.backgroundSecondary)
        .cornerRadius(AppConstants.Visual.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
            .stroke(Color.backgroundStroke, lineWidth: 0.33))
        .textInputAutocapitalization(.never)
        .overlay(alignment: .trailing) {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 14, height: 14)
                .padding(.trailing, 22)
                .opacity(isNotEmpty ? 1 : 0)
                .onTapGesture {
                    text = ""
                }
        }
    }
}
