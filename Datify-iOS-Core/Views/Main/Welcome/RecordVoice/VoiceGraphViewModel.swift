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
    case play, record, pause, inaction
}

class VoiceGraphViewModel: ObservableObject {
    @Published var statePlayer: StatePlayerEnum = .inaction
    @Published var heightsBar: [BarModel] = []
    @Published var fileExists: Bool = false
    @Published var spaceBetweenBars: CGFloat = 0
    @Published var widthBar: CGFloat = 0
    @Published var canStopRecord: Bool = false
    @Published var isAlertShowing: Bool = false
    @Published var heightVoiceGraph: CGFloat = 0
    @Published var wightVoiceGraph: CGFloat = 0

    private var filePath: URL?
    private var recordManager = RecordManager(wightVoiceGraph: UIScreen.main.bounds.width)
    private var cancellables: Set<AnyCancellable> = []

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

    init() {
        setupSubscribers()
        filePath = getDocumentsDirectory()
        if let filePath = filePath {
            isFileExists(audioURL: filePath)
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = paths[0].appendingPathComponent(AppConstants.URL.recordVoice)
        return filePath
    }

    private func isFileExists(audioURL: URL) {
        if FileManager.default.fileExists(atPath: audioURL.path) {
            fileExists = true
        } else {
            fileExists = false
        }
    }

    private func setupSubscribers() {
        recordManager.$statePlayer
            .assign(to: \.statePlayer, on: self)
            .store(in: &cancellables)

        recordManager.$heightsBar
            .assign(to: \.heightsBar, on: self)
            .store(in: &cancellables)

        recordManager.$fileExists
            .assign(to: \.fileExists, on: self)
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
            .assign(to: \.wightVoiceGraph, on: self)
            .store(in: &cancellables)
    }

    func disableDeleteButton() -> Bool {
        return (!fileExists || statePlayer != .inaction) ? true : false
    }

    func disableRecordButton() -> Bool {
        return (statePlayer == .play ||
                statePlayer == .pause ||
                fileExists ||
                (statePlayer == .record && !canStopRecord)
        ) ? true : false
    }

    func disablePlayButton() -> Bool {
        return (!fileExists || statePlayer == .record) ? true: false
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
            isFileExists(audioURL: filePath)
            if fileExists {
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
                            isFileExists(audioURL: filePath)
                            if fileExists {
                                recordManager.loadAudioData(audioURL: filePath)
                            }
                        } else {
                            if statePlayer != .record {
                                self.recordManager.record(path: filePath)
                            }
                        }
                    }
                }
            }
        }
    }

    func loadAudioDataFromFile() {
        if let filePath = filePath {
            isFileExists(audioURL: filePath)
            if fileExists {
                recordManager.loadAudioData(audioURL: filePath)
            }
        }
    }
}
