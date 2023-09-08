//
//  WelcomeView.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct WelcomeView: View {
    // titles
    private let appTitle: String = "Datify"
    private let mainText: String = "Find new acquaintance"
    private let mainTextGradient: String = "right now"
    private let orTitle: String = "or"
    private let alreadyHaveAnAccountTitle: String = "Already have an account?"
    // buttons
    private let signUpButtonTitle: String = "Sign up"
    private let signInButtonTitle: String = "Sign in"

    private unowned let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }

    var body: some View {
        VStack {
            Spacer()
            largeTitle
            Spacer()
            buttonsSection
            alreadyHaveAnAccountSection
        }
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

extension WelcomeView {
    private var largeTitle: some View {
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

    private var buttonsSection: some View {
        VStack {
            SignInWithButton {
                router.push(.login)
            }
            .padding()
            orLine
            DtButton(title: signUpButtonTitle, style: .main) {
                router.push(.registrationEmail)
            }
            .padding()
        }
    }

    private var orLine: some View {
        HStack(spacing: 4) {
            DividerLine()
            Text(orTitle)
                .dtTypo(.p2Regular, color: .textSecondary)
            DividerLine()
        }
    }

    private var alreadyHaveAnAccountSection: some View {
        Button {
            router.push(.login)
        } label: {
            HStack {
                Text(alreadyHaveAnAccountTitle)
                    .dtTypo(.p2Regular, color: .textSecondary)
                Text(signInButtonTitle)
                    .dtTypo(.p2Regular, color: .textPrimaryLink)
            }
        }
    }
}
