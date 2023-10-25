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
    associatedtype RegLocationCountryAndCity: View
    associatedtype RegRecord: View
    associatedtype RegFinish: View
    associatedtype RegPhoto: View

    func createRegSexView() -> RegSex
    func createRegEmailView() -> RegEmail
    func createRegLocationView() -> RegLocation
    func createRegLocationCountryAndCityView(
        viewModel: LocationViewModel,
        isCountrySelection: Bool) -> RegLocationCountryAndCity
    func createRegRecordView() -> RegRecord
    func createRegFinishView() -> RegFinish
    func createRegPhotoView() -> RegPhoto
}

extension NavigationViewBuilder: RegistrationFlow {
    func createRegSexView() -> some View {
        Text("RegSex")
    }
    func createRegEmailView() -> some View {
        RegEmailView(router: router)
    }
    func createRegLocationView() -> some View {
        LocationView(router: router)
    }
    func createRegLocationCountryAndCityView(viewModel: LocationViewModel, isCountrySelection: Bool) -> some View {
        CountryAndCityView(viewModel: viewModel, isCountrySelection: isCountrySelection)
    }
    func createRegRecordView() -> some View {
        Text("RegRecord")
    }
    func createRegFinishView() -> some View {
        Text("RegFinish")
    }
    func createRegPhotoView() -> some View {
        RegPhotoView(router: router)
    }
}
