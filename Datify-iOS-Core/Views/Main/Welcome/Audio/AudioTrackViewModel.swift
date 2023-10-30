//
//  AudioTrackViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import Foundation
// import AVFAudio
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
    var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    var meteringTimer: Timer?
    var playTimer: Timer?
    var meteringFrequency = 15 / Double(UIScreen.main.bounds.width / 5)
    var recordingTime = 15.0
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
                self.audioPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioPlayer?.volume = 1
                self.audioPlayer?.play()
                print(filePath)
                print("play")

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
        playTimer?.invalidate()
        playTimer = nil
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
        self.playTimer = Timer.scheduledTimer(withTimeInterval: self.meteringFrequency, repeats: true, block: { [weak self] (_) in

            guard let self = self else { return }
            recordingCurrentTime += meteringFrequency

            if self.index <= arrayHeight.count - 1 {

                withAnimation {
                    self.arrayHeight[self.index].disabledBool = false
                }

                self.index += 1
            }
            if recordingCurrentTime > recordingTime {
                stopPlay()
            }
        })
        self.playTimer?.fire()
    }

    func stopPlay() {
        audioPlayer?.stop()
        audioPlayer = nil
        stopPlayTimer()
        statePlayer = .none
    }

    func stopPlayTimer() {
        self.index = 0
        self.recordingCurrentTime = 0.0
        self.playTimer?.invalidate()
        self.playTimer = nil
    }

    func didTapRecordButton() {
        statePlayer = .recording
        if fileExists() {
            deleteRecord()
        }
        self.startRecording()
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
        self.audioRecorder?.stop()
        self.audioRecorder?.record()

        self.runMeteringTimer()
    }

    func runMeteringTimer() {

        self.meteringTimer = Timer.scheduledTimer(withTimeInterval: self.meteringFrequency, repeats: true, block: { [weak self] (_) in

            guard let self = self else { return }

            self.audioRecorder?.updateMeters()
            guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }

            let amplitude = 1.1 * pow(10.0, averagePower / 20.0)
            var clampedAmplitude = min(max(amplitude, 0), 1)

            if self.index <= arrayHeight.count - 1 {
                if (clampedAmplitude * 630) < 1 {
                    clampedAmplitude = 1
                }
                if (clampedAmplitude * 630) > 184 {
                    clampedAmplitude = 183
                } else {
                    clampedAmplitude *= 630
                }

                    self.arrayHeight[self.index].height = clampedAmplitude
                    self.arrayHeight[self.index].disabledBool = false
                withAnimation {
                    self.arrayHeight[self.index].isASignal = true
                }
                self.index += 1
            }

            recordingCurrentTime += meteringFrequency
            if recordingCurrentTime > recordingTime {
                stopRecording()
                fileExistsBool = true
            }
        })
        self.meteringTimer?.fire()
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
        self.meteringTimer?.invalidate()
        self.meteringTimer = nil
    }

    func  fileExists() -> Bool {
        let fileName = "recording.m4a"
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            self.filePath = fileURL
            return FileManager.default.fileExists(atPath: fileURL.path)
        }
        self.filePath = nil
        return false
    }

    func deleteRecord() {
        do {
            try FileManager.default.removeItem(at: filePath!)
            fileExistsBool = false
            for index in arrayHeight.indices.reversed() {
                arrayHeight[index].disabledBool = true
                withAnimation(.easeIn) {
                    arrayHeight[index].isASignal = false
                }
                arrayHeight[index].height = 3
            }
        } catch {
            print("Could not delete file, probably read-only filesystem")
        }
    }
}
