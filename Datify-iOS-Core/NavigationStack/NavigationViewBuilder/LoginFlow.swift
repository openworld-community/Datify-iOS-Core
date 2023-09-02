//
//  LoginFlow.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

protocol LoginFlow {
    associatedtype Login: View

    func createLoginView(transferData: String) -> Login
}

extension NavigationViewBuilder: LoginFlow {
    func createLoginView(transferData: String) -> some View {
        LoginView(transferData: transferData)
    }
}
