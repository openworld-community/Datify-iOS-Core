//
//  LoginFlow.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

protocol LoginFlow {
    associatedtype Login: View

    func createLoginView() -> Login
}

extension NavigationViewBuilder: LoginFlow {
    func createLoginView() -> some View {
        LoginView()
    }
}
