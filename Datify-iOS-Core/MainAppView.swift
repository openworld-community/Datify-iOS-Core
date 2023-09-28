//
//  ContentView.swift
//  Datify-iOS-Core
//
//  Created by Александр Прайд on 20.08.2023.
//

import SwiftUI

struct MainAppView: View {
    @StateObject var router: Router<AppRoute>
    let navViewBuilder: NavigationViewBuilder

    var body: some View {
        NavigationStack(path: $router.paths) {
            navViewBuilder.createWelcomeView()
                .navigationDestination(for: AppRoute.self, destination: buildViews)
        }
    }

    @ViewBuilder
    private func buildViews(view: AppRoute) -> some View {
        switch view {
        case .temp: navViewBuilder.createTempView()
        case .login: navViewBuilder.createLoginView()
        case .tabbar: navViewBuilder.createTabbarView()
        case .registrationSex: navViewBuilder.createRegSexView()
        case .registrationEmail: navViewBuilder.createRegEmailView()
        case .registrationLocation: navViewBuilder.createRegLocationView()
        case .registrationRecord: navViewBuilder.createRegRecordView()
        case .registrationFinish: navViewBuilder.createRegFinishView()
        case .location: navViewBuilder.createLocationView()
        case .countryAndCity: navViewBuilder.createChooseCountryAndCityView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let router: Router<AppRoute> = .init()
    static var previews: some View {
        MainAppView(router: router, navViewBuilder: NavigationViewBuilder(router: router))
    }
}
