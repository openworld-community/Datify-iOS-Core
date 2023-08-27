//
//  AppViewBuilder.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

final class NavigationViewBuilder {
    private unowned let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }

    // Unauthorized views
    func createWelcomeView() -> some View {
        WelcomeView(router: router)
    }
}
