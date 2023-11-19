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
    @Published var password: String = .init()
    @Published var showForgotSheet: Bool = false
    unowned let router: Router<AppRoute>

    var isButtonDisabled: Bool {
        password.isEmpty
    }

    init(router: Router<AppRoute>) {
        self.router = router
    }

    func authenticate() {
        loginState = .inProcess

        // TODO: password processing
        guard password == "a" else {
            loginState = .error
            isError = true
            return
        }
        router.push(.tabbar)

        loginState = .success
        isError = false

        password = .init()
    }

    func forgotPassword() {
        showForgotSheet = true
    }

    func chooseAnotherWay() {
        router.popToRoot()
    }
}
