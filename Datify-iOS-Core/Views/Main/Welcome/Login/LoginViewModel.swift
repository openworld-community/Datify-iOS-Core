//
//  LoginViewModel.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import Foundation

final class LoginViewModel: ObservableObject {    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var authenticated: Bool = false
    @Published var invalid: Bool = false
    @Published var showSpinner: Bool = false
    @Published var showForgotPassword: Bool = false

    var isButtonDisabled: Bool {
        email.isEmpty || password.isEmpty
    }

    func authenticate() {
        guard email.lowercased() == "a", password == "a" else {
            invalid = true
            return
        }
        showSpinner = true
        authenticated = true
        email = ""
        password = ""
    }

    func forgotPassword() {
        showForgotPassword = true
    }

    func logIn() {
        authenticate()
    }

    //    func anotherWayToLogIn() {}
}

