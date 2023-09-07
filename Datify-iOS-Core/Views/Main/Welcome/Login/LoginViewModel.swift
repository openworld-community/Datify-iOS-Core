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
    @Published var isError: Bool = false
    @Published var email: String = .init()
    @Published var password: String = .init()
    @Published var forgotSheet: Bool = false
    private weak var router: Router<AppRoute>?

    var isButtonDisabled: Bool {
        email.isEmpty || password.isEmpty
    }

    init(router: Router<AppRoute>?) {
        self.router = router
    }

    func authenticate() {
        loginState = .inProcess

        guard email.lowercased() == "a", password == "a" else {
            loginState = .error
            isError = true
            return
        }

        self.loginState = .success
//        router?.push(.tabbar)
        // TODO: remove router?.push(.registrationEmail)
        router?.push(.registrationEmail)

        email = .init()
        password = .init()
    }

    func forgotPassword() {
        forgotSheet = true
    }
}
