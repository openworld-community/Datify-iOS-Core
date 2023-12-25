//
//  RegPasswordViewModel.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 19.11.2023.
//

import Foundation

final class RegPasswordViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    @Published var password: String = .init()
    @Published var checkPassword: String = .init()
    @Published var isPasswordWrong: Bool = false
    @Published var isWrongFormat: Bool = false
    @Published var isError: Bool = false
    var isButtonDisabled: Bool {
        checkPassword.isEmpty ||
        checkPassword.count < 8 ||
        password.isEmpty ||
        password.count < 8
    }

    init(router: Router<AppRoute>) {
        self.router = router
    }

    func validatePassword() {
        if password == checkPassword {
            isPasswordWrong = false
            isError = false
            if verifyPassword() {
                isWrongFormat = false
                // TODO: - password processing
                router.push(.registrationEmail)
            } else {
                isWrongFormat = true
                isError = true
            }
        } else {
            isPasswordWrong = true
            isError = true
        }
    }

    func verifyPassword() -> Bool {
        let REGEX: String = Regex.password.rawValue
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: password)
    }
}
