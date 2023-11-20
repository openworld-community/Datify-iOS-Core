//
//  AppViewBuilder.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

final class NavigationViewBuilder {
    unowned let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }

    /// Unauthorized views
    func createWelcomeView() -> some View {
        WelcomeView(router: router)
    }
    func createSMSView() -> some View {
        SMSView(router: router)
    }

    /// Temp View
    func createTempView() -> some View {
        TempView()
    }
    /// Tabbar
    func createTabbarView() -> some View {
        TabbarView(viewBuilder: self)
    }
}
