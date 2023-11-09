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
    var isASignal: Bool
}

enum StatePlayerEnum {
    case play, record, pause, inaction
}

class RecordGraphViewModel: ObservableObject {

    @Published var statePlayer: StatePlayerEnum = .inaction
    @Published var arrayHeights: [BarModel] = []
    @Published var fileExistsBool: Bool = false
    @Published var distanceBetweenBars: CGFloat = 0
    @Published var widthBar: CGFloat = 0
    @Published var canStopRecord: Bool = false
    @Published var isAlertShowing: Bool = false

    var filePath: URL?
//    var size: CGSize = .zero

    private var recordManager = RecordManager(wightBarGraph: UIScreen.main.bounds.width, heightBarGraph: 160)
    private var cancellables: Set<AnyCancellable> = []

    init() {
        setupBindings()
        filePath = getDocumentsDirectory()
        if let filePath = filePath {
            fileExists(audioURL: filePath)
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = paths[0].appendingPathComponent(AppConstants.URL.recordVoice)
        return filePath
    }

    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            var isAuthorized = status == .authorized
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .audio)
            }
            return isAuthorized
        }
    }

    private func setupBindings() {
        recordManager.$statePlayer
            .assign(to: \.statePlayer, on: self)
            .store(in: &cancellables)

        recordManager.$arrayHeights
            .assign(to: \.arrayHeights, on: self)
            .store(in: &cancellables)

        recordManager.$fileExistsBool
            .assign(to: \.fileExistsBool, on: self)
            .store(in: &cancellables)

        recordManager.$distanceBetweenBars
            .assign(to: \.distanceBetweenBars, on: self)
            .store(in: &cancellables)

        recordManager.$widthBar
            .assign(to: \.widthBar, on: self)
            .store(in: &cancellables)

        recordManager.$canStopRecord
            .assign(to: \.canStopRecord, on: self)
            .store(in: &cancellables)
    }

    func disableDeleteButton() -> Bool {
        return (!fileExistsBool || statePlayer != .inaction) ? true : false
    }

    func disableRecordButton() -> Bool {
        return (statePlayer == .play ||
                statePlayer == .pause ||
                fileExistsBool ||
                (statePlayer == .record && !canStopRecord)
        ) ? true : false
    }

    func disablePlayButton() -> Bool {
        return (!fileExistsBool || statePlayer == .record) ? true: false
    }

    func didTapPlayPauseButton() {
        switch statePlayer {
        case .play:
            recordManager.pause()
        case .inaction, .pause:
            if let filePath = filePath {
                recordManager.play(audioURL: filePath)
            }
        case .record:
            break
        }
    }

    func didTapDeleteButton() {
        if let filePath = filePath {
            if fileExistsBool {
                recordManager.delete(audioURL: filePath)
            }
        }
    }

    func didTapRecordButton() {
        Task {
            if await !isAuthorized {
                await MainActor.run {
                    isAlertShowing = true
                }
            } else {
                await MainActor.run {
                    if let filePath = filePath {
                        if statePlayer == .record && canStopRecord {
                            recordManager.stopRecording()
                            fileExists(audioURL: filePath)
                            loadAudioDataFromFile()
                        } else {
                            if statePlayer != .record {
                                self.recordManager.record(audioURL: filePath)
                                statePlayer = .record
                            }
                        }
                    }
                }

            }
        }

    }

    private func fileExists(audioURL: URL) {
        if FileManager.default.fileExists(atPath: audioURL.path) {
            fileExistsBool = true
        } else {
            fileExistsBool = false
        }
    }

    func loadAudioDataFromFile() {
        if let filePath = filePath {
            if fileExistsBool {
                recordManager.loadAudioData(audioURL: filePath)
            }
        }
    }
}
