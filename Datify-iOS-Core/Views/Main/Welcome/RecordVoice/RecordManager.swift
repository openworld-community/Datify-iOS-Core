//
//  RecordManager.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 08.11.2023.
//

import AVFoundation
import SwiftUI

private enum Constant {
    static let deleteAnimationDuration: Double = 1
    static let maxRecordingDuration: Double = 15
    static let minRecordingDuration: Double = 15
    static let factorAmplitudes: Float = 630
    static let widthBarPercentageOfWidthGraph: CGFloat = 0.75
    static let spaceBetweenBarsPercentageOfWidthGraph: CGFloat = 0.5
    static let heightViewPercentageOfWidthGraph: CGFloat = 44
    static let audioSamplingRates = 48000
    static let numberOfAudioChannels = 2
}

class RecordManager: ObservableObject {
    @Published var statePlayer: StatePlayerEnum = .idle
    @Published var heightsBar: [BarModel] = []
    @Published var isFileExist = false
    @Published var spaceBetweenBars: CGFloat = 0
    @Published var widthBar: CGFloat = 0
    @Published var canStopRecord = false
    @Published var heightVoiceGraph: CGFloat
    @Published var wightVoiceGraph: CGFloat

    private var maxHeightBar: CGFloat = 0
    private var minHeightBar: CGFloat = 0
    private var deleteAnimationDuration: Double = Constant.deleteAnimationDuration
    private var maxRecordingDuration: Double = Constant.maxRecordingDuration
    private var minRecordingDuration: Double = Constant.minRecordingDuration
    private var barsCount = 0
    private var factorAmplitudes: Float = Constant.factorAmplitudes
    private var currentRecordingTime = 0.0
    private var index = 0
    private var audioDuration: Double = 0.0
    private var audioPlayer: AVAudioPlayer?
    private var audioRecorder: AVAudioRecorder?
    private var audioSession = AVAudioSession.sharedInstance()
    private var timer: Timer?

    init(wightVoiceGraph: CGFloat) {
        self.wightVoiceGraph = wightVoiceGraph
        self.heightVoiceGraph = (wightVoiceGraph * Constant.heightViewPercentageOfWidthGraph) / 100
        self.widthBar = (wightVoiceGraph / 100) * Constant.widthBarPercentageOfWidthGraph
        self.spaceBetweenBars = (wightVoiceGraph / 100) * Constant.spaceBetweenBarsPercentageOfWidthGraph
        self.maxHeightBar = heightVoiceGraph
        self.minHeightBar = widthBar
        self.barsCount = Int(wightVoiceGraph / (widthBar + spaceBetweenBars)) - 1
        setAudioSession()
        createHeightsBar()
    }

    func record(path: URL) {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: Constant.audioSamplingRates,
            AVNumberOfChannelsKey: Constant.numberOfAudioChannels,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: path, settings: settings)
        } catch {
            print(error.localizedDescription)
        }
        if let audioRecorder = audioRecorder {
            audioRecorder.prepareToRecord()
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            statePlayer = .record
            runRecordTimer()
        }
    }

    func stopRecording() {
        discolorBar()
        audioRecorder?.stop()
        audioRecorder = nil
        stopTimer()
        isFileExist = true
        canStopRecord = false
        statePlayer = .idle
    }

    func play(audioURL: URL) {
        if audioPlayer == nil {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                audioPlayer?.prepareToPlay()
                audioDuration = (audioPlayer?.duration) ?? 0
            } catch {
                print(error.localizedDescription)
            }
        }
        audioPlayer?.play()
        runPlayTimer()
        statePlayer = .play
    }

    func pause() {
        audioPlayer?.pause()
        timer?.invalidate()
        timer = nil
        statePlayer = .pause
    }

    func delete(audioURL: URL) {
        do {
            try FileManager.default.removeItem(at: audioURL)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        index = heightsBar.count - 1
        let timerFrequency = deleteAnimationDuration / Double(heightsBar.count)
        self.timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true) { [weak self] _ in
            guard let self else { return }
            withAnimation(.linear) {
                if self.index >= 0, self.index < self.heightsBar.count {
                    self.heightsBar[self.index].height = Float(self.minHeightBar)
                }
            }
            heightsBar[self.index].coloredBool = true
            if index == 0 {
                stopTimer()
                isFileExist = false
            } else {
                index -= 1
            }
        }
    }

    func loadAudioData(audioURL: URL) {
        let powerValues: [Float] = audioFileSetupAndRead(audioURL: audioURL)
        if powerValues.isNotEmpty {
            // splits powerValues into parts(chunkSize) and calculates the average value for each part
            var averageArray: [Float] = []
            let chunkSize = powerValues.count / Int(barsCount)
            for value in stride(from: 0, to: powerValues.count, by: chunkSize) {
                let chunk = Array(powerValues[value..<min(value + chunkSize, powerValues.count)])
                let sum = chunk.reduce(0, +)
                let average = sum / Float(chunk.count)
                averageArray.append(average)
            }
            var maxValue = averageArray.max() ?? Float(heightVoiceGraph)
            if maxValue == 0 {
                maxValue = Float(heightVoiceGraph)
            }
            var resultArray: [Float] = []
            for value in averageArray {
                var newValue = value * Float(heightVoiceGraph) / maxValue
                if newValue < Float(minHeightBar) {
                    newValue = Float(minHeightBar)
                }
                resultArray.append(newValue)
            }
            heightsBar.removeAll()
            for height in resultArray {
                heightsBar.append(BarModel(height: height, coloredBool: true))
            }
        }
    }
}

private extension RecordManager {
    func createHeightsBar() {
        for _ in 0...barsCount {
            heightsBar.append(BarModel(height: Float(minHeightBar), coloredBool: true))
        }
    }

   func discolorBar() {
       for index in heightsBar.indices where index < self.heightsBar.count {
           heightsBar[index].coloredBool = true
       }
    }

    func setAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func runRecordTimer() {
        let timerFrequency = TimeInterval(maxRecordingDuration / Double(barsCount))
        timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true) { [weak self] (_) in
            guard let self else { return }
            // get audio signal amplitude values in decebels
            audioRecorder?.updateMeters()
            guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }
            // converting a value from decibels to amplitude, factorAmplitudes is the amplitude factor
            let amplitude = factorAmplitudes * pow(10.0, averagePower / 20.0)
            let clampedAmplitude = (min(max(amplitude, Float(minHeightBar)), Float(heightVoiceGraph)))
            if self.index < heightsBar.count {
                heightsBar[self.index].coloredBool = false
                withAnimation {
                    self.heightsBar[self.index].height = clampedAmplitude
                }
                self.index += 1
            }
            currentRecordingTime += timerFrequency
            if currentRecordingTime > maxRecordingDuration {
                stopRecording()
            }
            if !canStopRecord, currentRecordingTime > minRecordingDuration {
                canStopRecord = true
            }
        }
    }

    func runPlayTimer() {
        if audioDuration > 0 {
            let timerFrequency = audioDuration / Double(barsCount)
            self.timer = Timer.scheduledTimer(
                withTimeInterval: timerFrequency,
                repeats: true,
                block: { [weak self] (_) in
                    guard let self else { return }
                    if index < heightsBar.count {
                        self.heightsBar[self.index].coloredBool = false
                        index += 1
                    }
                    currentRecordingTime += timerFrequency
                    if currentRecordingTime > audioDuration {
                        stopPlay()
                    }
                })
        }
    }

    func audioFileSetupAndRead(audioURL: URL) -> [Float] {
        var powerValues: [Float] = []
        do {
            let audioFile = try AVAudioFile(forReading: audioURL)
            let audioFormat = audioFile.processingFormat
            let audioFrameCount = UInt32(audioFile.length)
            // creating a buffer for audio data
            guard let audioFileBuffer = AVAudioPCMBuffer(
                pcmFormat: audioFormat,
                frameCapacity: audioFrameCount) else {return []}
            // reading audio file data into buffer
            try audioFile.read(into: audioFileBuffer)
            // determining the number of channels and the number of frames
            let channelCount = Int(audioFileBuffer.format.channelCount)
            let frameCount = Int(audioFileBuffer.frameLength)
            // creating an array with data on the amplitude of the audio signal
            let powerData = Array(UnsafeBufferPointer(
                start: audioFileBuffer.floatChannelData?[0],
                count: frameCount * channelCount))
            // calculates the volume level of an audio file on each frame
            for frame in 0..<frameCount {
                var powerSum: Float = 0.0
                for channel in 0..<channelCount {
                    let power = pow(powerData[frame + channel * frameCount], 2)
                    powerSum += power
                }
                let averagePower = sqrt(powerSum / Float(channelCount))
                powerValues.append(averagePower)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return powerValues
    }

    func stopTimer() {
        index = 0
        currentRecordingTime = 0.0
        timer?.invalidate()
        timer = nil
    }

    func stopPlay() {
        audioPlayer?.stop()
        audioPlayer = nil
        stopTimer()
        discolorBar()
        statePlayer = .idle
    }
}
