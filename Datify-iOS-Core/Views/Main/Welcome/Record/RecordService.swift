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

class RecordService {
    weak var delegate: RecordServiceDelegate?
    private var audioPlayer: AVAudioPlayer?
    private var audioRecorder: AVAudioRecorder?
    private var audioSession = AVAudioSession.sharedInstance()
    private var timer: Timer?
    private var recordingCurrentTime = 0.0
    private var index = 0
    private var audioDuration: Double = 0.0

    init() {}

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
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
        audioRecorder = try? AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder?.prepareToRecord()
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        runRecordTimer()
    }

    private func runRecordTimer() {
        let timerFrequency = TimeInterval(delegate!.powerGraphModel.audioRecordingDuration / (Double(UIScreen.main.bounds.width / Double(5))))
        timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            audioRecorder?.updateMeters()
            guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }
            let amplitude = 1.1 * pow(10.0, averagePower / 20.0)
            var clampedAmplitude = (min(max(amplitude, 0), 1)) * 630
            if let delegate = delegate {
                if self.index <= delegate.powerGraphModel.arrayHeights.count - 1 {
                    if clampedAmplitude < Float(delegate.powerGraphModel.widthPowerElement) {
                        clampedAmplitude = Float(delegate.powerGraphModel.widthPowerElement)
                    }
                    if clampedAmplitude > Float(delegate.powerGraphModel.heightPowerGraph) {
                        clampedAmplitude = Float(delegate.powerGraphModel.heightPowerGraph)
                    }
                    delegate.powerGraphModel.arrayHeights[self.index].height = clampedAmplitude
                    delegate.powerGraphModel.arrayHeights[self.index].coloredBool = false
                    withAnimation {
                        delegate.powerGraphModel.arrayHeights[self.index].isASignal = true
                    }
                    self.index += 1
                }
            }
            recordingCurrentTime += timerFrequency
            if recordingCurrentTime > delegate!.powerGraphModel.audioRecordingDuration {
                stopRecording()

                delegate?.powerGraphModel.fileExistsBool = true
            }
        })
        self.timer?.fire()
    }

    func stopRecording() {
        delegate?.powerGraphModel.turnOffColor()
        audioRecorder?.stop()
        audioRecorder = nil
        stopTimer()
        delegate?.powerGraphModel.statePlayer = .inaction
    }

    private func stopTimer() {
        index = 0
        recordingCurrentTime = 0.0
        timer?.invalidate()
        timer = nil
    }

    func calculatePower(for audioURL: URL?) throws {
        if let audioURL = audioURL {
            let audioFile = try AVAudioFile(forReading: audioURL)
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
                let averagePower = sqrt(powerSum / Float(channelCount)) * 1000
                powerValues.append(averagePower)
            }
            let max = (powerValues.max() ?? 160)
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
                        if (avarage) < 3 {
                            avarage = 3
                        } else {
                            avarage = ((avarage * Float(delegate!.powerGraphModel.heightPowerGraph)) / max) * 3
                        }
                        newArray.append(Int(avarage))
                    }
                }
            delegate?.powerGraphModel.arrayHeights.removeAll()
            for index in newArray.indices {
                delegate?.powerGraphModel.arrayHeights.append(BarModel(height: Float(newArray[index]), coloredBool: true, isASignal: true))
            }
        }
    }

    func play() {
        if delegate?.powerGraphModel.statePlayer == StatePlayerEnum.inaction {
            delegate?.powerGraphModel.turnOffColor()
            playAudioFromFilePath(filePath: (delegate?.powerGraphModel.filePath)!)
        } else {
            audioPlayer?.play()
        }
        runPlayTimer()
        delegate?.powerGraphModel.statePlayer = .play
    }

    private func playAudioFromFilePath(filePath: URL) {
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try audioSession.setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: filePath)
            audioDuration = (audioPlayer?.duration)!
            audioPlayer?.play()
            runPlayTimer()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func pause() {
        audioPlayer?.pause()
        stopTimer()
        delegate?.powerGraphModel.statePlayer = .pause
    }

    private func stopPlay() {
        audioPlayer?.stop()
        audioPlayer = nil
        stopTimer()
        delegate?.powerGraphModel.statePlayer = .inaction
    }

    private func runPlayTimer() {
        let timerFrequency = audioDuration / (Double(UIScreen.main.bounds.width / Double(delegate!.powerGraphModel.widthPowerElement + delegate!.powerGraphModel.distanceBetweenElements)))
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
        self.timer?.fire()
    }

    func delete(complition: (() -> Void)?) {
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
                    if let complition = complition {
                        complition()
                    }
                } else {
                    index -= 1
                }
            })
        }
    }
}
