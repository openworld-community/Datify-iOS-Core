//
//  Datify_iOS_CoreApp.swift
//  Datify-iOS-Core
//
//  Created by Александр Прайд on 20.08.2023.
//

import SwiftUI

@main
struct DatifyiOSCoreApp: App {
    var body: some Scene {
        let router: Router<AppRoute> = .init()
        let builder: NavigationViewBuilder = .init(router: router)

        WindowGroup {
//            MainAppView(router: router, navViewBuilder: builder)
            TabbarView(viewBuilder: builder, selectedTab: .chat)
        }
    }
}
