//
//  RecordService.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 01.11.2023.
//

import AVFoundation
import SwiftUI
import Accelerate

protocol RecordServiceDelegate: AnyObject {
    var powerGraphModel: PowerGraphModel {get set}
}

enum RecordError: Error, LocalizedError {
    case invalidFormat(description: String)
    case audioFileNotFound(description: String)
    case recordingFailed(description: String)
    case objectNotCreated(description: String)

    var errorDescription: String {
        switch self {
        case .audioFileNotFound(let description):
            return description
        case .invalidFormat(let description):
            return description
        case .recordingFailed(let description):
            return description
        case .objectNotCreated(let description):
            return description
        }
    }
}

class RecordService: NSObject, AVAudioPlayerDelegate {

    weak var delegate: RecordServiceDelegate?
    private var audioPlayer: AVAudioPlayer?
    private var audioRecorder: AVAudioRecorder?
    private var audioSession = AVAudioSession.sharedInstance()
    private var timer: Timer?
    private var recordingCurrentTime = 0.0
    private var index = 0
    private var audioDuration: Double = 0.0

    override init() {
        super.init()
        audioSessionSet()
    }

    func audioSessionSet() {
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func record() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        delegate?.powerGraphModel.filePath = audioFilename
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        audioRecorder = try? AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder?.prepareToRecord()
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        runRecordTimer()
    }

    private func runRecordTimer() {
        if let delegate = delegate {
            let timerFrequency = TimeInterval(delegate.powerGraphModel.audioRecordingDuration / delegate.powerGraphModel.elementsCount)
            timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
                guard let self = self else { return }
                audioRecorder?.updateMeters()
                guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }
                let amplitude = 1.1 * pow(10.0, averagePower / 20.0)
                var clampedAmplitude = (min(max(amplitude * 630, Float(delegate.powerGraphModel.widthPowerElement)), Float(delegate.powerGraphModel.heightPowerGraph)))
                if self.index <= delegate.powerGraphModel.arrayHeights.count - 1 {
                    delegate.powerGraphModel.arrayHeights[self.index].height = clampedAmplitude
                    delegate.powerGraphModel.arrayHeights[self.index].coloredBool = false
                    withAnimation {
                        delegate.powerGraphModel.arrayHeights[self.index].isASignal = true
                    }
                    self.index += 1
                }
                recordingCurrentTime += timerFrequency
                if recordingCurrentTime > delegate.powerGraphModel.audioRecordingDuration {
                    stopRecording()
                }
            })
//            self.timer?.fire()
        }
    }

    func stopRecording() {
        delegate?.powerGraphModel.turnOffColor()
        audioRecorder?.stop()
        audioRecorder = nil
        stopTimer()
        delegate?.powerGraphModel.fileExistsBool = true
        delegate?.powerGraphModel.statePlayer = .inaction
    }

    private func stopTimer() {
        index = 0
        recordingCurrentTime = 0.0
        timer?.invalidate()
        timer = nil
    }

    func loadAudioData(for audioURL: URL?) throws {
        if let audioURL = audioURL {
            let audioFile = try AVAudioFile(forReading: audioURL)
            guard let format = AVAudioFormat(
                commonFormat: .pcmFormatFloat32,
                sampleRate: audioFile.fileFormat.sampleRate,
                channels: 1,
                interleaved: false
            ) else {return}
            let audioFrameCount = UInt32(audioFile.length)
            guard let audioData = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: audioFrameCount) else {return}
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
                let averagePower = sqrt(powerSum / Float(channelCount)) * 1000
                powerValues.append(averagePower)
            }
            print(frameCount)
            print(channelCount)

            var averageArray: [Float] = []
            if let delegate = delegate {
                let chunkSize = powerValues.count / Int(delegate.powerGraphModel.elementsCount)
                for i in stride(from: 0, to: powerValues.count, by: chunkSize) {
                    let chunk = Array(powerValues[i..<min(i + chunkSize, powerValues.count)])
                    let sum = chunk.reduce(0, +)
                    let average = sum / Float(chunk.count)
                    averageArray.append(average)
                }

                let maxValue = averageArray.max() ?? Float(delegate.powerGraphModel.heightPowerGraph)
                var resultArray: [Float] = []
                for value in averageArray {
                    var newValue = value * Float(delegate.powerGraphModel.heightPowerGraph) / maxValue
                    if newValue < Float(delegate.powerGraphModel.widthPowerElement) {
                        newValue = Float(delegate.powerGraphModel.widthPowerElement)
                    }
                    resultArray.append(newValue)
                }
                delegate.powerGraphModel.arrayHeights.removeAll()
                for index in resultArray.indices {
                    delegate.powerGraphModel.arrayHeights.append(BarModel(height: Float(resultArray[index]), coloredBool: true, isASignal: true))
                }
            }
        }
    }

    func play() {
        if delegate?.powerGraphModel.statePlayer == StatePlayerEnum.inaction {
            do {
//                try audioSession.setCategory(AVAudioSession.Category.playback)
//                try audioSession.setActive(true)
                audioPlayer = try AVAudioPlayer(contentsOf: (delegate?.powerGraphModel.filePath)!)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioDuration = (audioPlayer?.duration)!
                audioPlayer?.play()
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            audioPlayer?.play()
        }
        runPlayTimer()
        delegate?.powerGraphModel.statePlayer = .play
    }

    private func runPlayTimer() {
        let timerFrequency = audioDuration / (delegate?.powerGraphModel.elementsCount)!
        self.timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            if index <= (delegate?.powerGraphModel.arrayHeights.count)! - 1 {
                withAnimation {
                    self.delegate?.powerGraphModel.arrayHeights[self.index].coloredBool = false
                }
                index += 1
            }
            recordingCurrentTime += timerFrequency
            if recordingCurrentTime > audioDuration {
                stopPlay()
            }
        })
//        self.timer?.fire()
    }

    func pause() {
        audioPlayer?.pause()
        timer?.invalidate()
        timer = nil
        delegate?.powerGraphModel.statePlayer = .pause
    }

    private func stopPlay() {
        audioPlayer?.stop()
        audioPlayer = nil
        stopTimer()
        delegate?.powerGraphModel.turnOffColor()
        delegate?.powerGraphModel.statePlayer = .inaction
    }

    func delete() {
        do {
            try FileManager.default.removeItem(at: (delegate?.powerGraphModel.filePath)!)
        } catch {
            print("Could not delete file")
        }
        if let arrayHeights = delegate?.powerGraphModel.arrayHeights {
            index = arrayHeights.count - 1
            let timerFrequency = delegate!.powerGraphModel.deleteAnimationDuration / Double(arrayHeights.count)
            self.timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                withAnimation(.linear) {
                    self.delegate?.powerGraphModel.arrayHeights[self.index].isASignal = false
                }
                delegate?.powerGraphModel.arrayHeights[self.index].coloredBool = true
                delegate?.powerGraphModel.arrayHeights[self.index].height = 3
                if index == 0 {
                    stopTimer()
                    delegate?.powerGraphModel.fileExistsBool = false

                } else {
                    index -= 1
                }
            })
        }
    }
}
