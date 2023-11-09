//
//  RegRecordViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 09.11.2023.
//

import Foundation
import AVFoundation
import Combine

class RegRecordViewModel: ObservableObject {
    unowned var router: Router<AppRoute>
    private var cancellables: Set<AnyCancellable> = []
    @Published var fileExistsBool: Bool = false
    var recordGraphViewModel = RecordGraphViewModel()

    init(router: Router<AppRoute>) {
        self.router = router
        setupBindings()
    }

    func setUpCaptureSession() async {
        guard await isAuthorized else { return }
    }

    private func setupBindings() {
        recordGraphViewModel.$fileExistsBool
            .assign(to: \.fileExistsBool, on: self)
            .store(in: &cancellables)
    }

    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            var isAuthorized = status == .authorized
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .audio)
            }
            return isAuthorized
        }
    }
}
