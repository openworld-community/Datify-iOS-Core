//
//  LocationFlow.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 28.09.2023.
//

import SwiftUI

protocol LocationFlow {
    associatedtype Location: View
    associatedtype CountryAndCity: View
    associatedtype Tabbar: View

    func createLocationView() -> Location
    func createChooseCountryAndCityView() -> CountryAndCity
    func createTabbarView() -> Tabbar
}

extension NavigationViewBuilder: LocationFlow {
    func createLocationView() -> some View {
        LocationView(router: router)
    }

    func createChooseCountryAndCityView() -> some View {
        CountryAndCityView(viewModel: LocationViewModel(router: router))

    }
}
