//
//  RegEmailViewModel.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 07.09.2023.
//

import Foundation

final class RegEmailViewModel: ObservableObject {
    @Published var email: String = .init()
    @Published var isWrongFormat: Bool = false
    weak var router: Router<AppRoute>?
    var isButtonDisabled: Bool { email.isEmpty }

    init(router: Router<AppRoute>?) {
        self.router = router
    }

    func validateEmail() {
        if validate(email) {
            router?.push(.registrationLocation)
        } else {
            isWrongFormat = true
        }
    }

    private func validate(_ emailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: emailAddress)
    }
}
