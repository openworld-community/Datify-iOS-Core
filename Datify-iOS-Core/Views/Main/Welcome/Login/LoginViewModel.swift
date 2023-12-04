//
//  LoginViewModel.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import Foundation

enum LoginState {
    case idle, inProcess, success, error, recovery
}

final class LoginViewModel: ObservableObject {
    @Published var loginState: LoginState = .idle
    @Published var isError: Bool = false
    @Published var password: String = .init()
    @Published var showForgotSheet: Bool = false
    @Published var receivedPassword: String = .init()
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
        isError = false
        loginState = .recovery
    }

    func chooseAnotherWay() {
        router.popToRoot()
    }

    func validateReceivedPassword() {
        loginState = .inProcess

        // TODO: received password processing
        guard receivedPassword == "777" else {
            loginState = .recovery
            isError = true
            return
        }

        router.push(.tabbar)

        loginState = .success
        isError = false

        receivedPassword = .init()
    }
}
