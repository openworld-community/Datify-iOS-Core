//
//  LocationView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 10.09.2023.
//

import SwiftUI

struct LocationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LocationViewModel
    @State private var isAlertPresented = false
    @State private var alertMessage = ""

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: LocationViewModel(router: router))
    }

    var body: some View {
        VStack {
            Spacer()
            titleLabel
            locationChooseButton(label: "Country".localize(), isCountrySelection: true)
            locationChooseButton(label: "City".localize(), isCountrySelection: false)
            Spacer()
            bottomButtons
        }
        .onReceive(viewModel.$errorMessage) { errorMessage in
            if let errorMessage = errorMessage {
                alertMessage = errorMessage
                isAlertPresented = true
            }
        }
        .task {
            // TODO: when screen has appeared.
            // Upload data to CountryModel from server via API
            // Find geolocation in data in CountryModel
            do {
                try await Task.sleep(nanoseconds: UInt64(0.8))
                viewModel.locationManager.isLoading = false
            } catch {
                alertMessage = "An error occurred: \(error.localizedDescription)"
                viewModel.error = error
            }
        }
        .overlay(
            Group {
                if viewModel.locationManager.isLoading {
                    DtSpinnerView(size: 56)
                }
            }
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    isAlertPresented = false
                }
            )
        }
    }

    private func locationChooseButton(label: String, isCountrySelection: Bool) -> some View {
        LocationChooseButtonView(
            location: $viewModel.location,
            label: label,
            viewModel: viewModel,
            isCountrySelection: isCountrySelection
        )
    }
}

struct LocationChooseButtonView: View {
    @Binding var location: LocationModel?

    let label: String
    @ObservedObject var viewModel: LocationViewModel
    @State var isCountrySelection: Bool

    var body: some View {
        Button {
            viewModel.chooseCountryAndCity(isCountrySelection: isCountrySelection)
        } label: {
            HStack {
                Text("\(label.capitalized):")
                    .dtTypo(.p2Regular, color: .textSecondary)
                Text(locationValue)
                    .dtTypo(.p2Regular, color: .textPrimary)
                Spacer()
                Image(DtImage.arrowRight)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .frame(height: AppConstants.Visual.buttonHeight)
            .background(
                RoundedRectangle(
                    cornerRadius: AppConstants.Visual.cornerRadius
                )
                .foregroundColor(.backgroundSecondary)
            )
        }
        .padding(.horizontal)
    }

    private var locationValue: String {
        if isCountrySelection {
            return viewModel.location?.selectedCountry?.name ?? "Loading...".localize()
        } else {
            return viewModel.location?.selectedCountry?.selectedCity ?? "Loading...".localize()
        }
    }
}

extension LocationView {
    private var titleLabel: some View {
        VStack(spacing: 8) {
            Text("Where are you located?")
                .dtTypo(.h3Medium, color: .textPrimary)
            Text("Choose your city of residence, this will help us find people around you more accurately")
                .dtTypo(.p2Regular, color: .textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.bottom, 40)
    }

    private var bottomButtons: some View {
        HStack {
            DtBackButton {
                // TODO: Back button
                viewModel.back()

            }
            DtButton(title: "Next".localize(), style: .main) {
                // TODO: Next button
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}
