//
//  WelcomeView.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct WelcomeView: View {
    private unowned let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }

    var body: some View {
        VStack {
            DtButton(title: "Login", style: .gradient) {
                router.push(.login(data: "LoginView"))
            }

            DtButton(title: "Registration", style: .secondary) {
                router.push(.registrationSex)
            }

            DtButton(title: "Temp", style: .primary) {
                router.push(.temp)
            }
        }
        .padding()
    }
}

struct WelcomView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(router: Router())
    }
}
