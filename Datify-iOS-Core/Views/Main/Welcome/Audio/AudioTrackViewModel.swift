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

class AudioTrackViewModel: ObservableObject {
    @Published var canSubmit: Bool = false
    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var arrayHeight: [Float] = []
    @Published var fileExistsBool: Bool = false

    var audioRecorder: AVAudioRecorder?
    var meteringTimer: Timer?
    var meteringFrequency = 15 / Double(UIScreen.main.bounds.width / 5)
    var recordingTime = 0.0
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

    func runMeteringTimer() {

        self.meteringTimer = Timer.scheduledTimer(withTimeInterval: self.meteringFrequency, repeats: true, block: { [weak self] (_) in

            guard let self = self else { return }
            recordingTime += meteringFrequency

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
                    self.arrayHeight[self.index] = clampedAmplitude
                if index <= arrayHeight.count - 2 {
                    self.arrayHeight[self.index + 1] = 184
                }
                self.index += 1
            }
            if recordingTime > 15.0 {
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
//        if fileExists() {
//            deleteRecord()
//        }
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
