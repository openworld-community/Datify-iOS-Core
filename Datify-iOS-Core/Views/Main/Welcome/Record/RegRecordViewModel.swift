//
//  RegRecordViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import AVFoundation
import SwiftUI

struct BarModel: Hashable {
    var height: Float
    var disabledBool: Bool
    var isASignal: Bool
}

enum StatePlayerEnum {
    case play, record, pause, inaction
}

class RegRecordViewModel: ObservableObject, RecordServiceDelegate {
    unowned let router: Router<AppRoute>
    @Published var statePlayer: StatePlayerEnum
    @Published var arrayHeight: [BarModel]
    @Published var fileExistsBool: Bool
    @Published var filePath: URL?
    private var service: RecordService
    private var dataService: RecordDataService

    init(router: Router<AppRoute>) {
        self.router = router
        dataService = RecordDataService()
        statePlayer = .inaction
        arrayHeight = []
        fileExistsBool = false
        service = RecordService(widthPowerBar: 3, hrightPowerGraph: 160, distanceBetweenBars: 2, deleteAnimationDuration: 1.0, audioRecordingDuration: 15.0)
        service.delegate = self

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

    func setUpCaptureSession() async {
        guard await isAuthorized else { return }
    }

    func didTapPlayPauseButton() {
        switch statePlayer {
        case .play:
            service.pause()
        case .inaction, .pause:
            service.play()
        case .record:
            break
        }
    }

    func didTapDeleteButton() {
        service.delete(complition: nil)
    }

    func didTapRecordButton() {
        if fileExists() {
            service.delete {
                self.service.record()
                self.statePlayer = .record
            }
        } else {
            self.service.record()
            statePlayer = .record
        }
    }

    func fileExists() -> Bool {
        let fileName = "recording.m4a"
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                filePath = fileURL
                return true
            }
        }
        filePath = nil
        return false
    }

    func getPower() {
        if let filePath = filePath {
            do {
                try service.calculatePower(for: filePath)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
