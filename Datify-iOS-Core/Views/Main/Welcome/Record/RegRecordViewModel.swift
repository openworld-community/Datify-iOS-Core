//
//  RegRecordViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 09.11.2023.
//

import Foundation
import AVFoundation
import Combine
import SwiftUI

class RegRecordViewModel: ObservableObject {
    unowned var router: Router<AppRoute>
    private var cancellables: Set<AnyCancellable> = []
    @Published var fileExistsBool: Bool = false
    var recordGraphViewModel = RecordGraphViewModel()
    @Published var isAlertShowing: Bool = false
    @Published var audioAuthStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)

    init(router: Router<AppRoute>) {
        self.router = router
        setupBindings()
    }

    func setUpCaptureSession() async {
        guard await recordGraphViewModel.isAuthorized else { return }
    }

    private func setupBindings() {
        recordGraphViewModel.$fileExistsBool
            .assign(to: \.fileExistsBool, on: self)
            .store(in: &cancellables)
        
        recordGraphViewModel.$isAlertShowing
            .assign(to: \.isAlertShowing, on: self)
            .store(in: &cancellables)
    }
    
    func goToAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func checkPhotoAuthStatus() {
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
}
