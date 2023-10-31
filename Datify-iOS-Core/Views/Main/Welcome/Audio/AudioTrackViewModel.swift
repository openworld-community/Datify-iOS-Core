//
//  AudioTrackViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import Foundation
import AVFoundation
import SwiftUI
 import AVKit
import AudioToolbox

struct BarModel: Hashable {
    var height: Float
    var disabledBool: Bool
    var isASignal: Bool
}

enum StatePlayerEnum {
    case playing, recording, pause, none
}

class AudioTrackViewModel: ObservableObject {
    @Published var statePlayer: StatePlayerEnum = .none
    @Published var arrayHeight: [BarModel] = []
    @Published var fileExistsBool: Bool = false
    @Published var filePath: URL?

    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var audioSession = AVAudioSession.sharedInstance()
    var timer: Timer?

    var widthPowerBar = 3
    var distanceBetweenBars = 2
    var deleteAnimationDuration = 1.0
    var audioRecordingDuration = 15.0

    var recordingCurrentTime = 0.0
    var index = 0

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

    func setUpCaptureSession() async {
        guard await isAuthorized else { return }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func playAudioFromFilePath(filePath: URL) {
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
                try audioSession.setActive(true)
                audioPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioPlayer?.volume = 1
                audioPlayer?.play()
            } catch let error {
                print(error.localizedDescription)
            }
    }

    func didTapPlayPauseButton() {
        switch statePlayer {
        case .playing:
            pause()
        case .none, .pause:
            play()
        case .recording:
            break
        }
    }

    func pause() {
        audioPlayer?.pause()
        stopTimer()
        statePlayer = .pause
    }

    func play() {
        if statePlayer == .none {
            for index in arrayHeight.indices {
                arrayHeight[index].disabledBool = true
            }
            playAudioFromFilePath(filePath: filePath!)
        } else {
            audioPlayer?.play()
        }
        runPlayTimer()
        statePlayer = .playing
    }

    func runPlayTimer() {
        let timerFrequency = TimeInterval(audioRecordingDuration / (Double(UIScreen.main.bounds.width / Double(widthPowerBar + distanceBetweenBars))))
        self.timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            if index <= arrayHeight.count - 1 {
                withAnimation {
                    self.arrayHeight[self.index].disabledBool = false
                }
                index += 1
            }
            recordingCurrentTime += timerFrequency
            if recordingCurrentTime > audioRecordingDuration {
                stopPlay()
            }
        })
        self.timer?.fire()
    }

    func stopPlay() {
        audioPlayer?.stop()
        audioPlayer = nil
        stopTimer()
        statePlayer = .none
    }

    func stopTimer() {
        self.index = 0
        self.recordingCurrentTime = 0.0
        self.timer?.invalidate()
        self.timer = nil
    }

    func didTapRecordButton() {
        if fileExists() {
            deleteRecord {
                self.startRecording()
                self.statePlayer = .recording
            }
        } else {
            self.startRecording()
            statePlayer = .recording
        }
    }

    func startRecording() {

        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        filePath = audioFilename
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }

        self.audioRecorder = try? AVAudioRecorder(url: audioFilename, settings: settings)
        self.audioRecorder?.prepareToRecord()
        self.audioRecorder?.isMeteringEnabled = true
        self.audioRecorder?.record()

        self.runMeteringTimer()
    }

    func runMeteringTimer() {
        let timerFrequency = TimeInterval(audioRecordingDuration / (Double(UIScreen.main.bounds.width / Double(widthPowerBar + distanceBetweenBars))))
        timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            audioRecorder?.updateMeters()
            // get the average power, in decibels
            guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }
            let amplitude = 1.1 * pow(10.0, averagePower / 20.0)
            var clampedAmplitude = (min(max(amplitude, 0), 1)) * 630
            if self.index <= arrayHeight.count - 1 {
                if clampedAmplitude < Float(widthPowerBar) {
                    clampedAmplitude = Float(widthPowerBar)
                }
                if clampedAmplitude > 184 {
                    clampedAmplitude = 184
                }
                self.arrayHeight[self.index].height = clampedAmplitude
                self.arrayHeight[self.index].disabledBool = false
                withAnimation {
                    self.arrayHeight[self.index].isASignal = true
                }
                self.index += 1
            }
            recordingCurrentTime += timerFrequency
            if recordingCurrentTime > audioRecordingDuration {
                stopRecording()
                fileExistsBool = true
            }
        })
        self.timer?.fire()
    }

    func stopRecording() {
        self.audioRecorder?.stop()
        self.audioRecorder = nil
        self.stopMeteringTimer()
        statePlayer = .none
    }

    func stopMeteringTimer() {
        self.index = 0
        self.recordingCurrentTime = 0.0
        self.timer?.invalidate()
        self.timer = nil
    }

    func  fileExists() -> Bool {
        let fileName = "recording.m4a"
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            self.filePath = fileURL
            print(FileManager.default.fileExists(atPath: fileURL.path))
            return FileManager.default.fileExists(atPath: fileURL.path)
        }
        filePath = nil
        return false
    }

    func deleteRecord(complition: (() -> Void)?) {
        do {
            try FileManager.default.removeItem(at: filePath!)
            fileExistsBool = false
        } catch {
            print("Could not delete file, probably read-only filesystem")
        }
        if !arrayHeight.isEmpty {
            index = (arrayHeight.count - 1)
            let timerFrequency = TimeInterval(deleteAnimationDuration / Double(arrayHeight.count))
            self.timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
                guard let self = self else { return }
                print(arrayHeight.count)
                print("index - " + "\(index)")
                withAnimation(.linear) {
                    self.arrayHeight[self.index].isASignal = false
                }
                arrayHeight[self.index].disabledBool = true
                arrayHeight[self.index].height = 3
                if index == 0 {
                    stopDelete()
                    if let complition = complition {
                        complition()
                    }
                } else {
                    index -= 1
                }
            })
        }
    }

    func stopDelete() {
        stopTimer()
    }
}
