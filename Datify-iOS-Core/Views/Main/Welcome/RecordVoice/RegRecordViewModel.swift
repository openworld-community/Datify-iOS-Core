//
//  RegRecordViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 09.11.2023.
//

import AVFoundation
import Combine
import SwiftUI

class RegRecordViewModel: ObservableObject {
    unowned var router: Router<AppRoute>
    @Published var isFileExist: Bool = false
    @Published var isAlertShowing: Bool = false
    var voiceGraphViewModel = VoiceGraphViewModel()
    private var cancellables: Set<AnyCancellable> = []
    private var application: UIApplication

    init(router: Router<AppRoute>, application: UIApplication = UIApplication.shared) {
        self.router = router
        self.application = application
        setupSubscribers()
    }

    func setUpCaptureSession() async {
        guard await voiceGraphViewModel.isAuthorized() else { return }
    }

    private func setupSubscribers() {
        voiceGraphViewModel.$isFileExist
            .assign(to: \.isFileExist, on: self)
            .store(in: &cancellables)

        voiceGraphViewModel.$isAlertShowing
            .assign(to: \.isAlertShowing, on: self)
            .store(in: &cancellables)
    }

    func goToAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              application.canOpenURL(url) else { return }
        application.open(url, options: [:], completionHandler: nil)
    }

    func checkRecordAuthStatus() {
        Task {
            let response = await PermissionCenter.requestPermission(type: .microphone)
            switch response {
            case .success:
                await MainActor.run {
                    isAlertShowing = false
                }
            case .failure(let error):
                await MainActor.run {
                    isAlertShowing = true
                }
                print(error)
            }
        }
    }

    func back() {
        if router.paths.count > 1 {
            router.pop()
        }
    }
}
