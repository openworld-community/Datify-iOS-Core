//
//  LoginViewModel.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published var data: String

    init(data: String) {
        self.data = data
    }
}
