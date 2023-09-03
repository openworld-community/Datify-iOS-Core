//
//  LoginViewModel.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import Foundation

enum LoginState {
    case idle, inProcess, success, error
}

final class LoginViewModel: ObservableObject {
    @Published var loginState: LoginState = .idle
    @Published var email: String = .init()
    @Published var password: String = .init()
    @Published var isShowingSheet = false

    var isButtonDisabled: Bool {
        email.isEmpty || password.isEmpty
    }

    func authenticate() {
        loginState = .inProcess

        guard email.lowercased() == "a", password == "a" else {
            loginState = .error
            return
        }

        self.loginState = .success

        email = .init()
        password = .init()
    }

    func forgotPassword() {
        isShowingSheet = true
    }
}
