//
//  WelcomView.swift
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
            Button("Login") {
                router.push(.login(data: "LoginView"))
            }
            Button("Registration") {
                router.push(.registrationSex)
            }
        }
    }
}

struct WelcomView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(router: Router())
    }
}
