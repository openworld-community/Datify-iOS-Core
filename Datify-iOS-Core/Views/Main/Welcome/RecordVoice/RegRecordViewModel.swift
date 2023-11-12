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
    @Published var fileExistsBool: Bool = false
    @Published var isAlertShowing: Bool = false
    var voiceGraphViewModel = VoiceGraphViewModel()
    private var cancellables: Set<AnyCancellable> = []

    init(router: Router<AppRoute>) {
        self.router = router
        setupSubscribers()
    }

    func setUpCaptureSession() async {
        guard await voiceGraphViewModel.isAuthorized else { return }
    }

    private func setupSubscribers() {
        voiceGraphViewModel.$fileExists
            .assign(to: \.fileExistsBool, on: self)
            .store(in: &cancellables)

        voiceGraphViewModel.$isAlertShowing
            .assign(to: \.isAlertShowing, on: self)
            .store(in: &cancellables)
    }

    func goToAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func checkRecordAuthStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .denied, .restricted, .notDetermined:
            isAlertShowing = true
        case .authorized:
            isAlertShowing = false
        default:
            break
        }
    }

    func back() {
        router.pop()
    }
}
