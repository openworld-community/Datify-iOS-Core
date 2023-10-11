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
    func createTabbarView(viewBuilder: NavigationViewBuilder) -> Tabbar
}

extension NavigationViewBuilder: LoginFlow {
    func createLoginView() -> some View {
        LoginView(router: router)

    }
    func createTabbarView(viewBuilder: NavigationViewBuilder) -> some View {
        TabbarView(viewBuilder: viewBuilder)
    }
}
