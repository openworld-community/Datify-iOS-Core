//
//  RegRecordViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import AVFoundation
import SwiftUI

struct BarModel: Identifiable {
    var id = UUID().uuidString
    var height: Float
    var coloredBool: Bool
    var isASignal: Bool
}

enum StatePlayerEnum {
    case play, record, pause, inaction
}

class PowerGraphViewModel: ObservableObject, RecordServiceDelegate {
    unowned let router: Router<AppRoute>
    @Published var powerGraphModel: PowerGraphModel
    private var recordService = RecordService()
    private var dataService = RecordDataService()

    init(router: Router<AppRoute>, powerGraphModel: PowerGraphModel) {
        self.router = router
        self.powerGraphModel = powerGraphModel
        recordService.delegate = self
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

    func disableDeletebutton() -> Bool {
        if !powerGraphModel.fileExistsBool || powerGraphModel.statePlayer != .inaction {
            return true
        } else {
            return false
        }
    }

    func setUpCaptureSession() async {
        guard await isAuthorized else { return }
    }

    func didTapPlayPauseButton() {
        switch powerGraphModel.statePlayer {
        case .play:
            recordService.pause()
        case .inaction, .pause:
            recordService.play()
        case .record:
            break
        }
    }

    func didTapDeleteButton() {
        recordService.delete()
    }

    func didTapRecordButton() {
        if powerGraphModel.statePlayer == .record {
            recordService.stopRecording()
            fileExists()
            getPowerFromFile()
        } else {
            self.recordService.record()
            powerGraphModel.statePlayer = .record
        }
    }

    func fileExists() {
        let fileName = "recording.m4a"
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                powerGraphModel.filePath = fileURL
                powerGraphModel.fileExistsBool = true
                return
            }
        }
        powerGraphModel.filePath = nil
        powerGraphModel.fileExistsBool = false
    }

    func getPowerFromFile() {
        fileExists()
        do {
            try recordService.loadAudioData(for: powerGraphModel.filePath)
        } catch {
            print(error.localizedDescription)
        }
    }
}
