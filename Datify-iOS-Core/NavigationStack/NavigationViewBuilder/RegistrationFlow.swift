//
//  RegistrationFlow.swift
//  Datify-iOS-Core
//
//  Created by Sergei Volkov on 27.08.2023.
//

import SwiftUI

protocol RegistrationFlow {
    associatedtype RegSex: View
    associatedtype RegEmail: View
    associatedtype RegLocation: View
    associatedtype RegRecord: View
    associatedtype RegFinish: View

    func createRegSexView() -> RegSex
    func createRegEmailView() -> RegEmail
    func createRegLocationView() -> RegLocation
    func createRegRecordView() -> RegRecord
    func createRegFinishView() -> RegFinish
}

extension NavigationViewBuilder: RegistrationFlow {
    func createRegSexView() -> some View {
        Text("RegSex")
    }
    func createRegEmailView() -> some View {
        Text("RegEmail")
    }
    func createRegLocationView() -> some View {
        let viewModel = LocationViewModel(router: Router<AppRoute>())
              return LocationView(router: Router<AppRoute>(), viewModel: viewModel)
          }
    func createRegRecordView() -> some View {
        Text("RegRecord")
    }
    func createRegFinishView() -> some View {
        Text("RegFinish")
    }
}
