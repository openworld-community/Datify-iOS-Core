//
//  RegRecordView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct RegRecordView: View {
    @StateObject var viewModel: RegRecordViewModel

    init(router: Router<AppRoute>) {
        self._viewModel = StateObject(wrappedValue: RegRecordViewModel(router: router))
    }

    var body: some View {
        VStack {
            Spacer()
            titleSegment
            VoiceGraphView(vm: viewModel.voiceGraphViewModel)
                .padding(.vertical)
            navigationButtons
        }
        .task {
            await viewModel.setUpCaptureSession()
            viewModel.checkRecordAuthStatus()
        }
        .alert(
            "Access denied",
            isPresented: $viewModel.isAlertShowing
        ) {
            Button("OK") {
                viewModel.goToAppSettings()
            }
            Button("Cancel", role: .cancel) {
                Task { @MainActor in
                    viewModel.isAlertShowing = false
                }
            }
        } message: {
            Text("Open Settings for editing?")
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        RegRecordView(router: Router())
    }
}

private extension RegRecordView {
    var titleSegment: some View {
        VStack(spacing: 8) {
            Text("Record a voice message for other people")
                .dtTypo(.h3Medium, color: .textPrimary)
            Text("Your voice message will be listened, to find out more about you")
                .dtTypo(.p2Regular, color: .textSecondary)
        }
        .multilineTextAlignment(.center)
        .padding()
    }
    var navigationButtons: some View {
        HStack(spacing: 8) {
            DtBackButton {
                // TODO: - Back button action
                viewModel.back()
            }
            DtButton(title: "Continue".localize(), style: viewModel.isFileExist ? .main : .secondary) {
                // TODO: - Proceed button action
                viewModel.router.push(.registrationFinish)
            }
            .disabled(!viewModel.isFileExist)
        }
        .padding(.horizontal)
    }
}
