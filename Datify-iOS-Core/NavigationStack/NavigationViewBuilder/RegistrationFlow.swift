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
    associatedtype RegEnterName: View
    associatedtype RegBirthday: View
    associatedtype RegOccupation: View
    associatedtype RegPassword: View

    func createRegSexView() -> RegSex
    func createRegEmailView() -> RegEmail
    func createRegLocationView() -> RegLocation
    func createRegLocationCountryAndCityView(
        viewModel: LocationViewModel,
        isCountrySelection: Bool) -> RegLocationCountryAndCity
    func createRegRecordView() -> RegRecord
    func createRegFinishView() -> RegFinish
    func createRegPhotoView() -> RegPhoto
    func createRegEnterNameView() -> RegEnterName
    func createRegBirthdayView() -> RegBirthday
    func createRegOccupationView() -> RegOccupation
    func createRegPasswordView() -> RegPassword
}

extension NavigationViewBuilder: RegistrationFlow {
    func createRegSexView() -> some View {
        RegSelectGenderView(router: router)
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
        RegRecordView(router: router)
    }
    func createRegFinishView() -> some View {
        RegFinalView(router: router)
    }
    func createRegPhotoView() -> some View {
        RegPhotoView(router: router)
    }
    func createRegEnterNameView() -> some View {
        RegEnterNameView(router: router)
    }
    func createRegBirthdayView() -> some View {
        RegBirthdayView(router: router)
    }
    func createRegOccupationView() -> some View {
        RegOccupationView(router: router)
    }
    func createRegPasswordView() -> some View {
        PasswordView(router: router)
    }
}
