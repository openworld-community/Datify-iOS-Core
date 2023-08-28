//
//  LoginView.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(transferData: String) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(data: transferData))
    }

    var body: some View {
        Text(viewModel.data)
            .dtTypo(.h1Medium, color: .textPrimaryLink)
            .padding()
            .background(Color.backgroundSecondary)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(transferData: "LoginView")
    }
}
