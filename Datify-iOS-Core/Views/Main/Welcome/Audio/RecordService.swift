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
    var arrayHeight: [BarModel] {get set}
    var filePath: URL? {get set}
    var statePlayer: StatePlayerEnum {get set}
}

class RecordService {
    weak var delegate: RecordServiceDelegate?
    var widthPowerElement: Int
    var heightPowerGraph: Int
    var distanceBetweenElements: Int
    var deleteAnimationDuration: Double
    var audioRecordingDuration: Double

    private var audioPlayer: AVAudioPlayer?
    private var audioRecorder: AVAudioRecorder?
    private var audioSession = AVAudioSession.sharedInstance()
    private var timer: Timer?
    private var recordingCurrentTime = 0.0
    private var index = 0

    init(widthPowerBar: Int, hrightPowerGraph: Int, distanceBetweenBars: Int, deleteAnimationDuration: Double, audioRecordingDuration: Double) {
        self.widthPowerElement = widthPowerBar
        self.distanceBetweenElements = distanceBetweenBars
        self.deleteAnimationDuration = deleteAnimationDuration
        self.audioRecordingDuration = audioRecordingDuration
        self.heightPowerGraph = hrightPowerGraph
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func record() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        delegate?.filePath = audioFilename
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
        let timerFrequency = TimeInterval(audioRecordingDuration / (Double(UIScreen.main.bounds.width / Double(widthPowerElement + distanceBetweenElements))))
        timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            audioRecorder?.updateMeters()
            guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }
            let amplitude = 1.1 * pow(10.0, averagePower / 20.0)
            var clampedAmplitude = (min(max(amplitude, 0), 1)) * 630
            if let delegate = delegate {
                if self.index <= delegate.arrayHeight.count - 1 {
                    if clampedAmplitude < Float(widthPowerElement) {
                        clampedAmplitude = Float(widthPowerElement)
                    }
                    if clampedAmplitude > Float(heightPowerGraph) {
                        clampedAmplitude = Float(heightPowerGraph)
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

    private func stopRecording() {
        self.audioRecorder?.stop()
        self.audioRecorder = nil
        self.stopTimer()
        delegate?.statePlayer = .none
    }

    private func stopTimer() {
        self.index = 0
        self.recordingCurrentTime = 0.0
        self.timer?.invalidate()
        self.timer = nil
    }

    func calculatePower(for audioURL: URL) throws {
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
        let max = (powerValues.max() ?? 184)
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
                        avarage = ((avarage * Float(heightPowerGraph)) / max) * 3
                    }
                    newArray.append(Int(avarage))
                }
            }
        for index in newArray.indices {
            delegate?.arrayHeight.append(BarModel(height: Float(newArray[index]), disabledBool: false, isASignal: true))
        }
    }

    func play() {
        if delegate?.statePlayer == StatePlayerEnum.none {
            for index in delegate!.arrayHeight.indices {
                delegate?.arrayHeight[index].disabledBool = true
            }
            playAudioFromFilePath(filePath: (delegate?.filePath)!)
        } else {
            audioPlayer?.play()
        }
        runPlayTimer()
        delegate?.statePlayer = .playing
    }

    private func playAudioFromFilePath(filePath: URL) {
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

    func pause() {
        audioPlayer?.pause()
        stopTimer()
        delegate?.statePlayer = .pause
    }

    private func stopPlay() {
        audioPlayer?.stop()
        audioPlayer = nil
        stopTimer()
        delegate?.statePlayer = .none
    }

    private func runPlayTimer() {
        let timerFrequency = TimeInterval(audioRecordingDuration / (Double(UIScreen.main.bounds.width / Double(widthPowerElement + distanceBetweenElements))))
        self.timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            if index <= (delegate?.arrayHeight.count)! - 1 {
                withAnimation {
                    self.delegate?.arrayHeight[self.index].disabledBool = false
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

    func delete(complition: (() -> Void)?) {
        do {
            try FileManager.default.removeItem(at: (delegate?.filePath)!)
//            fileExistsBool = false
        } catch {
            print("Could not delete file, probably read-only filesystem")
        }
        if !(delegate?.arrayHeight.isEmpty)! {
            index = ((delegate?.arrayHeight.count)! - 1)
            let timerFrequency = TimeInterval(deleteAnimationDuration / Double((delegate?.arrayHeight.count)!))
            self.timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
                guard let self = self else { return }
                withAnimation(.linear) {
                    self.delegate?.arrayHeight[self.index].isASignal = false
                }
                delegate?.arrayHeight[self.index].disabledBool = true
                delegate?.arrayHeight[self.index].height = 3
                if index == 0 {
                    stopTimer()
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
