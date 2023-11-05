//
//  DtAudioService.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 16.10.2023.
//

import Foundation
import Combine
import AVFoundation

class DtAudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    var updateTimer: Timer?

    @Published var isPlaying: Bool = false
    @Published var playbackProgress: Double = 0.0

    @Published var playCurrentTime: Int = 0
    @Published var totalDuration: Double = 0.0
    @Published var audioSamples: [BarChartDataPoint] = []
    @Published var playerDuration: Double = 0.0
    @Published var playbackFinished: Bool = false

    override init() {
        super.init()
        loadAudioData()
    }

    func togglePlayback(for resource: String, ofType type: String) {
        if let player = audioPlayer {
            if player.isPlaying {
                player.pause()
                stopProgressUpdates()
                isPlaying = false
            } else {
                player.play()
                startProgressUpdates()
                playbackFinished = false
                isPlaying = true
            }
        } else {
            if let path = Bundle.main.path(forResource: resource, ofType: type) {
                let url = URL(fileURLWithPath: path)
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.delegate = self
                    audioPlayer?.prepareToPlay()
                    playerDuration = audioPlayer?.duration ?? 0.0
                    totalDuration = playerDuration

                    audioPlayer?.play()
                    startProgressUpdates()
                    playbackFinished = false
                    isPlaying = true
                } catch {
                    print("Ошибка воспроизведения файла: \(error)")
                    playbackFinished = true
                }
            }
        }
    }

    func startProgressUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.playCurrentTime = Int(player.currentTime)
            self.playbackProgress = player.currentTime / player.duration
            self.playerDuration = player.duration
        }
    }

    func stopProgressUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.playbackProgress = 0.0
            self?.playCurrentTime = Int(self?.audioPlayer?.duration ?? 0)
            self?.playbackFinished = true
            self?.isPlaying = false
        }
        stopProgressUpdates()
    }

    func loadAudioData() {
        if let path = Bundle.main.path(forResource: "recording5sec", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                let audioFile = try AVAudioFile(forReading: url)
                let totalDurationInSeconds = Double(audioFile.length) / audioFile.fileFormat.sampleRate
                let durationPerBar = totalDurationInSeconds / 55.0
                let pointsPerBar = Int(durationPerBar * audioFile.processingFormat.sampleRate)
                totalDuration = totalDurationInSeconds

                guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) else {
                    print("Ошибка создания буфера")
                    return
                }

                try audioFile.read(into: audioBuffer)

                if let floatData = audioBuffer.floatChannelData?.pointee {
                        let floatArray = Array(UnsafeBufferPointer(start: floatData, count: Int(audioFile.length)))

                        var compressedData: [Float] = []

                        for i in stride(from: 0, to: floatArray.count, by: pointsPerBar) {
                            let subArray = floatArray[i..<min(i+pointsPerBar, floatArray.count)]
                            let average = subArray.reduce(0, +) / Float(subArray.count)
                            compressedData.append(average)
                        }

                        let maxCompressedValue = compressedData.max() ?? 1.0

                        let desiredMaxHeight = 50.0
                        let minimumBarHeight = 2.0
                        audioSamples = compressedData.map { value in
                            let normalizedValue = value / maxCompressedValue
                            let barHeight = abs(Double(normalizedValue)) * desiredMaxHeight
                            let finalBarHeight = barHeight + minimumBarHeight
                            return BarChartDataPoint(value: finalBarHeight)
                        }
                    }
            } catch {
                print("Ошибка загрузки аудиоданных: \(error)")
            }
        }
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Ошибка декодирования: \(String(describing: error))")
    }

    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        print("Воспроизведение было прервано")
    }
}
