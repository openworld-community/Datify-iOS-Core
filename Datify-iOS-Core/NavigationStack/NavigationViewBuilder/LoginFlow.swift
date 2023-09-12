//
//  LoginFlow.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

protocol LoginFlow {
    associatedtype Login: View
    associatedtype Tabbar: View

    func createLoginView() -> Login
    func createTabbarView() -> Tabbar
}

extension NavigationViewBuilder: LoginFlow {
    func createLoginView() -> some View {
        let viewModel = LocationViewModel(router: Router<AppRoute>()) // Создайте экземпляр Router, если необходимо
        return LocationView(router: Router<AppRoute>(), viewModel: viewModel)
    }
    func createTabbarView() -> some View {
        TempView()
            .navigationBarBackButtonHidden()
    }
}
