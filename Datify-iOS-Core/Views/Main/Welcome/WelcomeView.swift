//
//  WelcomeView.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct WelcomeView: View {
    // titles
    let appTitle: String = "Datify"
    let mainText: String = "Find new acquaintance right"
    let mainTextGradient: String = "now"
    let orTitle: String = "or"
    let alreadyHaveAnAccountTitle: String = "Already have an account?"
    // buttons
    let signUpButtonTitle: String = "Sign up"
    let signInButtonTitle: String = "Sign in"
    // numbers
    let frame120: CGFloat = 120
    let frame24: CGFloat = 24
    let frame4: CGFloat = 4

    private unowned let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }

    var body: some View {
        ZStack {
            VStack {
                topLogoAndTitle
                Spacer(minLength: frame120)
                largeTitle
                Spacer(minLength: frame120)
                buttonsSection
                alreadyHaveAnAccountSection
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
    private var topLogoAndTitle: some View {
        HStack(spacing: frame4) {
            Image(DtImage.appLogo)
                .resizable()
                .frame(width: frame24, height: frame24)
            Text(appTitle)
                .dtTypo(.p1Medium, color: .textPrimary)
                .fontWeight(.bold)
        }
        .padding(.top)
    }
    
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
                router.push(.login(data: "TempView"))
            }
            .padding()
            orLine
            DtButton(title: signUpButtonTitle, style: .main) {
                router.push(.login(data: "LoginView"))
            }
            .padding()
        }
    }

    private var orLine: some View {
        HStack {
            Image(DtImage.vectorImage)
            Text(orTitle)
                .dtTypo(.p2Regular, color: .textSecondary)
            Image(DtImage.vectorImage)

        }
    }

    private var alreadyHaveAnAccountSection: some View {

        Button {
            DispatchQueue.main.async {
                router.push(.login(data: "TempView"))
            }

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
