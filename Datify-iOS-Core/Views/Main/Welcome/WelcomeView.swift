//
//  WelcomeView.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct WelcomeView: View {
    @State private var phoneNumber: String = .init()
    @State private var isError: Bool = false
    // titles
    private let appTitle: String = "Datify"
    private let mainText: String = "Find new acquaintance"
    private let mainTextGradient: String = "right now"
    private let orTitle: String = "or"
    // buttons
    private let signInButtonTitle: String = "Sign in"

    private unowned let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            largeTitle
            VStack(spacing: 16) {
                textField
                buttonsSection
            }
            Spacer()
        }
        .hideKeyboardTapOutside()
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
    }
}

struct WelcomView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(router: Router())
    }
}

private extension WelcomeView {
    var largeTitle: some View {
        VStack(alignment: .center) {
            Text(mainText)
                .multilineTextAlignment(.center)
                .dtTypo(.h1Medium, color: .textPrimary)
            Text(mainTextGradient)
                .foregroundLinearGradient()
                .dtTypo(.h1Medium, color: .textPrimary)
        }
        .padding()
    }

    var textField: some View {
        VStack(spacing: 4) {
            DtCustomTF(
                style: .phone,
                input: $phoneNumber,
                isError: $isError) {
                    // Do we need onSubmit action? Keyboard style is .phonePad
                    if isPhoneNumberValid() {
                        signIn()
                    }
                }
            if isError {
                Text("Wrong number")
                    .dtTypo(.p4Regular, color: .accentsError)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
            }
        }
    }

    var buttonsSection: some View {
        VStack(spacing: 16) {
            DtButton(title: signInButtonTitle, style: .gradient) {
                signIn()
            }
            .disabled(!isPhoneNumberValid())
            orLine
            SignInWithButton {
                router.push(.login)
            }
        }
    }

    var orLine: some View {
        HStack(spacing: 4) {
            DividerLine()
            Text(orTitle)
                .dtTypo(.p2Regular, color: .textSecondary)
            DividerLine()
        }
    }

    func signIn() {
        // TODO: processing phone number

        // to demonstrate an error case
        guard phoneNumber.count > 14 else {
            isError = true
            return
        }
        isError = false

        router.push(.login)
    }

    func isPhoneNumberValid() -> Bool {
        // TODO: create validation
        phoneNumber.count > 10
    }
}
