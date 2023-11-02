//
//  AudioService.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 01.11.2023.
//

import AVFoundation
import SwiftUI
import Accelerate

protocol AudioDelegate: AnyObject {
    var arrayHeight: [BarModel] {get set}
    var filePath: URL? {get set}
    var statePlayer: StatePlayerEnum {get set}
}

class AudioService {

    weak var delegate: AudioDelegate?
    var widthPowerBar: Int
    var distanceBetweenBars: Int
    var deleteAnimationDuration: Double
    var audioRecordingDuration: Double

    init(widthPowerBar: Int, distanceBetweenBars: Int, deleteAnimationDuration: Double, audioRecordingDuration: Double) {
        self.widthPowerBar = widthPowerBar
        self.distanceBetweenBars = distanceBetweenBars
        self.deleteAnimationDuration = deleteAnimationDuration
        self.audioRecordingDuration = audioRecordingDuration
    }

    var filePath: URL?
    var audioRecorder: AVAudioRecorder?
    var audioSession = AVAudioSession.sharedInstance()
    var timer: Timer?

    var recordingCurrentTime = 0.0
    var index = 0

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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

        self.runRecordTimer()
    }

    private func runRecordTimer() {
        let timerFrequency = TimeInterval(audioRecordingDuration / (Double(UIScreen.main.bounds.width / Double(widthPowerBar + distanceBetweenBars))))
        timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            audioRecorder?.updateMeters()
            // get the average power, in decibels
            guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }
            let amplitude = 1.1 * pow(10.0, averagePower / 20.0)
            var clampedAmplitude = (min(max(amplitude, 0), 1)) * 630

            if var delegate = delegate {
                if self.index <= delegate.arrayHeight.count - 1 {
                    if clampedAmplitude < Float(widthPowerBar) {
                        clampedAmplitude = Float(widthPowerBar)
                    }
                    if clampedAmplitude > 184 {
                        clampedAmplitude = 184
                    }
                    delegate.arrayHeight[self.index].height = clampedAmplitude

                    delegate.arrayHeight[self.index].disabledBool = false
                    withAnimation {
                        delegate.arrayHeight[self.index].isASignal = true
                    }
                    self.index += 1
                }
            }

            recordingCurrentTime += timerFrequency
            if recordingCurrentTime > audioRecordingDuration {
                stopRecording()
//                fileExistsBool = true
            }
        })
        self.timer?.fire()
    }

    func stopRecording() {
        self.audioRecorder?.stop()
        self.audioRecorder = nil
        self.stopTimer()
        delegate?.statePlayer = .none
    }

    func stopTimer() {
        self.index = 0
        self.recordingCurrentTime = 0.0
        self.timer?.invalidate()
        self.timer = nil
    }

    func calculatePower(for audioURL: URL) throws {
        let audioFile = try AVAudioFile(forReading: audioURL)

        // Получаем аудио данные
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: audioFile.fileFormat.sampleRate, channels: 1, interleaved: false)
        let audioFrameCount = UInt32(audioFile.length)
        let audioData = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: audioFrameCount)!
        try audioFile.read(into: audioData)

        let channelCount = Int(audioData.format.channelCount)
        let frameCount = Int(audioData.frameLength)
        let powerData = Array(UnsafeBufferPointer(start: audioData.floatChannelData?[0], count: frameCount))

        var powerValues: [Float] = []
        for i in 0..<frameCount {
            var powerSum: Float = 0.0
            for j in 0..<channelCount {
                let power = pow(powerData[i + j * frameCount], 2)
                powerSum += power
            }
            let averagePower = sqrt(powerSum / Float(channelCount))
            powerValues.append(averagePower)
        }
        let max = (powerValues.max() ?? 1) * 10000
            let sector = Int(powerValues.count) / Int(UIScreen.main.bounds.width / 5)
            var box = 0
            var temp: Float = 0.0
            var newArray: [Int] = []
            for value in powerValues {
                if box < sector {
                    temp += value
                    box += 1
                } else {
                    var avarage: Float = temp / Float(box)
                    temp = 0
                    box = 0
                    if (avarage * 1000) < 3 {
                        avarage = 3
                    } else {
                        avarage = (((avarage * 10000) * 184) / max) * 3
                    }
                    newArray.append(Int(avarage))
                }
            }
        for index in newArray.indices {
            delegate?.arrayHeight.append(BarModel(height: Float(newArray[index]), disabledBool: false, isASignal: true))
        }
    }
}
