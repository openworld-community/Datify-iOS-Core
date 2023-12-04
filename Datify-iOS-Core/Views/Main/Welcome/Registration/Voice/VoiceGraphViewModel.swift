//
//  RecordGraphViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import AVFoundation
import SwiftUI
import Combine

struct BarModel: Identifiable {
    var id = UUID()
    var height: Float
    var coloredBool: Bool
}

enum StatePlayerEnum {
    case play, record, pause, idle
}

class VoiceGraphViewModel: ObservableObject {
    @Published var statePlayer: StatePlayerEnum = .idle
    @Published var heightsBar: [BarModel] = []
    @Published var isFileExist = false
    @Published var spaceBetweenBars: CGFloat = 0
    @Published var widthBar: CGFloat = 0
    @Published var canStopRecord = false
    @Published var isAlertShowing = false
    @Published var heightVoiceGraph: CGFloat = 0
    @Published var widthVoiceGraph: CGFloat = 0

    private var filePath: URL?
    private var recordManager = RecordManager(wightVoiceGraph: UIScreen.main.bounds.width)
    private var cancellables: Set<AnyCancellable> = []

    func isAuthorized() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        var isAuthorized = status == .authorized
        if status == .notDetermined {
            isAuthorized = await AVCaptureDevice.requestAccess(for: .audio)
        }
        return isAuthorized
    }

    init() {
        setupSubscribers()
        filePath = getDocumentsDirectory()
        if let filePath {
            doFileExists(audioURL: filePath)
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = paths[0].appendingPathComponent(AppConstants.FileName.recordVoice)
        return filePath
    }

    private func doFileExists(audioURL: URL, callBack: (() -> Void)? = nil) {
        isFileExist = FileManager.default.fileExists(atPath: audioURL.path)
        if isFileExist {
            if let callBack {
                callBack()
            }
        }
    }

    private func setupSubscribers() {
        recordManager.$statePlayer
            .assign(to: \.statePlayer, on: self)
            .store(in: &cancellables)

        recordManager.$heightsBar
            .assign(to: \.heightsBar, on: self)
            .store(in: &cancellables)

        recordManager.$isFileExist
            .assign(to: \.isFileExist, on: self)
            .store(in: &cancellables)

        recordManager.$spaceBetweenBars
            .assign(to: \.spaceBetweenBars, on: self)
            .store(in: &cancellables)

        recordManager.$widthBar
            .assign(to: \.widthBar, on: self)
            .store(in: &cancellables)

        recordManager.$canStopRecord
            .assign(to: \.canStopRecord, on: self)
            .store(in: &cancellables)

        recordManager.$heightVoiceGraph
            .assign(to: \.heightVoiceGraph, on: self)
            .store(in: &cancellables)

        recordManager.$wightVoiceGraph
            .assign(to: \.widthVoiceGraph, on: self)
            .store(in: &cancellables)
    }

    func disableDeleteButton() -> Bool {
        (!isFileExist || statePlayer != .idle) ? true : false
    }

    func disableRecordButton() -> Bool {
        (statePlayer == .play ||
                statePlayer == .pause ||
                isFileExist ||
                (statePlayer == .record && !canStopRecord)
        ) ? true : false
    }

    func disablePlayButton() -> Bool {
        (!isFileExist || statePlayer == .record) ? true: false
    }

    func didTapPlayPauseButton() {
        switch statePlayer {
        case .play:
            recordManager.pause()
        case .idle, .pause:
            if let filePath {
                recordManager.play(audioURL: filePath)
            }
        case .record:
            break
        }
    }

    func didTapDeleteButton() {
        if let filePath {
            doFileExists(audioURL: filePath) {
                self.recordManager.delete(audioURL: filePath)
            }
        }
    }

    @MainActor
    func didTapRecordButton() {
        Task {
            if await isAuthorized() {
                if let filePath, statePlayer == .record, canStopRecord {
                    recordManager.stopRecording()
                    doFileExists(audioURL: filePath) {
                        self.recordManager.loadAudioData(audioURL: filePath)
                    }
                } else {
                    if let filePath, statePlayer != .record {
                        self.recordManager.record(path: filePath)
                    }
                }
            } else {
                await MainActor.run {
                    isAlertShowing = true
                }
            }
        }
    }

    func loadAudioDataFromFile() {
        if let filePath {
            doFileExists(audioURL: filePath) {
                self.recordManager.loadAudioData(audioURL: filePath)
            }
        }
    }
}
