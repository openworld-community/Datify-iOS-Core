//
//  AudioTrackViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import Foundation
import AVFAudio
import AVFoundation
import SwiftUI

struct BarModel: Hashable {
    var height: Float
    var disabledBool: Bool
    var isASignal: Bool
}

class AudioTrackViewModel: ObservableObject {
    @Published var canSubmit: Bool = false
    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var arrayHeight: [BarModel] = []
    @Published var fileExistsBool: Bool = false

    var audioRecorder: AVAudioRecorder?
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

    func startRecording() {

        var audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        self.audioRecorder = try? AVAudioRecorder(url: audioFilename, settings: settings)
        self.audioRecorder?.prepareToRecord()
        self.audioRecorder?.isMeteringEnabled = true

        self.audioRecorder?.record()
        self.audioRecorder?.stop()
        self.audioRecorder?.record()

        self.runMeteringTimer()
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func play() {

        for i in arrayHeight.indices {
            arrayHeight[i].disabledBool = true
        }
        runPlayTimer()
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
        stopPlayTimer()
    }

    func stopPlayTimer() {
        self.index = 0
        self.playTimer?.invalidate()
        self.playTimer = nil
    }

    func runMeteringTimer() {

        self.meteringTimer = Timer.scheduledTimer(withTimeInterval: self.meteringFrequency, repeats: true, block: { [weak self] (_) in

            guard let self = self else { return }
            recordingCurrentTime += meteringFrequency

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
            if recordingCurrentTime > recordingTime {
                stopRecording()
                fileExistsBool = fileExists()
            }
        })
        self.meteringTimer?.fire()
    }

    func stopRecording() {
        self.audioRecorder?.stop()
        self.audioRecorder = nil
        self.isRecording = false
        self.stopMeteringTimer()
        self.canSubmit = false
    }

    func stopMeteringTimer() {
        self.index = 0
        self.recordingCurrentTime = 0.0
        self.meteringTimer?.invalidate()
        self.meteringTimer = nil
    }

    func fileExists() -> Bool {
        let fileName = "recording.m4a"
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            return FileManager.default.fileExists(atPath: fileURL.path)
        }
        print("File doesn't exit")
        return false
    }

    func didTapRecordButton() {
        if isRecording {
            self.stopRecording()
        } else {
            self.startRecording()
        }
    }

    func deleteRecord() {
        // TODO: - delete func
//        arrayHeight.removeAll()
    }
}
