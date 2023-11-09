//
//  RecordManager.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 08.11.2023.
//

import AVFoundation
import SwiftUI
import Accelerate

class RecordManager: ObservableObject {

    private enum Record {
        static let deleteAnimationDurationSec: Double = 1
        static let maxRecordingDurationSec: Double = 15.0
        static let minRecordingDurationSec: Double = 1.0
        static let factorAmplitudes: Float = 630
        static let widthBarPercentageOfWidthView: CGFloat = 0.75
        static let distanceBetweenBarsPercentageOfWidthView: CGFloat = 0.5
    }

    @Published var statePlayer: StatePlayerEnum = .inaction
    @Published var arrayHeights: [BarModel] = []
    @Published var fileExistsBool: Bool = false
    @Published var distanceBetweenBars: CGFloat = 0
    @Published var widthBar: CGFloat = 0
    @Published var canStopRecord: Bool = false

    var heightBarGraph: CGFloat
    var wightBarGraph: CGFloat

    private var maxHeightBar: CGFloat = 0
    private var minHeightBar: CGFloat = 0
    private var deleteAnimationDuration: Double = Record.deleteAnimationDurationSec
    private var maxRecordingDuration: Double = Record.maxRecordingDurationSec
    private var minRecordingDuration: Double = Record.minRecordingDurationSec
    private var barsCount: Double = 0
    private var factorAmplitudes: Float = Record.factorAmplitudes

    private var audioPlayer: AVAudioPlayer?
    private var audioRecorder: AVAudioRecorder?
    private var audioSession = AVAudioSession.sharedInstance()
    private var timer: Timer?
    private var recordingCurrentTime = 0.0
    private var index = 0
    private var audioDuration: Double = 0.0

    init(wightBarGraph: CGFloat, heightBarGraph: CGFloat) {
        self.wightBarGraph = wightBarGraph
        self.heightBarGraph = heightBarGraph
        self.widthBar = (wightBarGraph / 100) * Record.widthBarPercentageOfWidthView
        self.distanceBetweenBars = (wightBarGraph / 100) * Record.distanceBetweenBarsPercentageOfWidthView
        self.maxHeightBar = heightBarGraph
        self.minHeightBar = widthBar
        self.barsCount = wightBarGraph / (widthBar + distanceBetweenBars)
        setAudioSession()
        fillTheArrayHeight()
    }

    private func fillTheArrayHeight() {
         for _ in 0...Int(barsCount) {
             arrayHeights.append(BarModel(height: Float(minHeightBar), coloredBool: true, isASignal: false))
         }
     }

     private func turnOffColor() {
         for index in arrayHeights.indices {
             arrayHeights[index].coloredBool = true
         }
     }

    func setAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
    }

    func record(audioURL: URL) {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings)
        audioRecorder?.prepareToRecord()
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        runRecordTimer()
    }

    private func runRecordTimer() {
        let timerFrequency = TimeInterval(maxRecordingDuration / barsCount)
        timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            // get audio signal amplitude values in decebels
            audioRecorder?.updateMeters()
            guard let averagePower = self.audioRecorder?.averagePower(forChannel: 0) else { return }
            // converting a value from decibels to amplitude, factorAmplitudes is the amplitude factor
            let amplitude = factorAmplitudes * pow(10.0, averagePower / 20.0)
            let clampedAmplitude = (min(max(amplitude, Float(minHeightBar)), Float(heightBarGraph)))
            if self.index <= arrayHeights.count - 1 {
                arrayHeights[self.index].height = clampedAmplitude
                arrayHeights[self.index].coloredBool = false
                withAnimation {
                    self.arrayHeights[self.index].isASignal = true
                }
                self.index += 1
            }
            recordingCurrentTime += timerFrequency
            if recordingCurrentTime > maxRecordingDuration {
                stopRecording()
            }
            if !canStopRecord {
                if recordingCurrentTime > minRecordingDuration {
                    canStopRecord = true
                }
            }

        })
    }

    func stopRecording() {
        turnOffColor()
        audioRecorder?.stop()
        audioRecorder = nil
        stopTimer()
        fileExistsBool = true
        canStopRecord = false
        statePlayer = .inaction
    }

    private func stopTimer() {
        index = 0
        recordingCurrentTime = 0.0
        timer?.invalidate()
        timer = nil
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
            let powerData = Array(UnsafeBufferPointer(start: audioFileBuffer.floatChannelData?[0], count: frameCount))

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
            print("Ошибка при загрузке аудиофайла: \(error.localizedDescription)")
        }
        return powerValues
    }

    func loadAudioData(audioURL: URL) {
        let powerValues: [Float] = audioFileSetupAndRead(audioURL: audioURL)
        if !powerValues.isEmpty {

            // splits powerValues into parts(chunkSize) and calculates the average value for each part
            var averageArray: [Float] = []
            let chunkSize = powerValues.count / Int(barsCount)
            for value in stride(from: 0, to: powerValues.count, by: chunkSize) {
                let chunk = Array(powerValues[value..<min(value + chunkSize, powerValues.count)])
                let sum = chunk.reduce(0, +)
                let average = sum / Float(chunk.count)
                averageArray.append(average)
            }
            let maxValue = averageArray.max() ?? Float(heightBarGraph)
            var resultArray: [Float] = []
            for value in averageArray {
                var newValue = value * Float(heightBarGraph) / maxValue
                if newValue < Float(widthBar) {
                    newValue = Float(widthBar)
                }
                resultArray.append(newValue)
            }
            arrayHeights.removeAll()
            for index in resultArray.indices {
                arrayHeights.append(BarModel(height: Float(resultArray[index]), coloredBool: true, isASignal: true))
            }
        }
    }

    func play(audioURL: URL) {
        if statePlayer == StatePlayerEnum.inaction {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                audioPlayer?.prepareToPlay()
                audioDuration = (audioPlayer?.duration) ?? 0
                audioPlayer?.play()
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            audioPlayer?.play()
        }
        runPlayTimer()
        statePlayer = .play
    }

    private func runPlayTimer() {
        if audioDuration > 0 {
            let timerFrequency = audioDuration / (barsCount)
            self.timer = Timer.scheduledTimer(
                withTimeInterval: timerFrequency,
                repeats: true,
                block: { [weak self] (_) in
                    guard let self = self else { return }
                    if index <= (arrayHeights.count) - 1 {
                        self.arrayHeights[self.index].coloredBool = false
                        index += 1
                    }
                    recordingCurrentTime += timerFrequency
                    if recordingCurrentTime > audioDuration {
                        stopPlay()
                    }
                })
        }
    }

    func pause() {
        audioPlayer?.pause()
        timer?.invalidate()
        timer = nil
        statePlayer = .pause
    }

    private func stopPlay() {
        audioPlayer?.stop()
        audioPlayer = nil
        stopTimer()
        turnOffColor()
        statePlayer = .inaction
    }

    func delete(audioURL: URL) {
        do {
            try FileManager.default.removeItem(at: audioURL)
        } catch {
            print("Could not delete file")
        }
        index = arrayHeights.count - 1
        let timerFrequency = deleteAnimationDuration / Double(arrayHeights.count)
        self.timer = Timer.scheduledTimer(withTimeInterval: timerFrequency, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            withAnimation(.linear) {
                self.arrayHeights[self.index].isASignal = false
            }
            arrayHeights[self.index].coloredBool = true
            arrayHeights[self.index].height = Float(minHeightBar)
            if index == 0 {
                stopTimer()
                fileExistsBool = false
            } else {
                index -= 1
            }
        })
    }
}
