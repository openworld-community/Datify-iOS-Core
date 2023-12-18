//
//  DtAudioService.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 16.10.2023.
//

import Foundation
import Combine
import AVFoundation

enum AudioPlayerError: Error {
    case bufferCreationFailed
    case fileNotFound
    case audioPlayerInitializationFailed
    case audioFileReadingFailed
}

class DtAudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {

    @Published var isPlaying: Bool = false

    @Published var playbackProgress: Double = 0.0
    @Published var playCurrentTime: Int = 0

    @Published var totalDuration: Double = 0.0

    @Published var audioSamples: [BarChartDataPoint] = []
    @Published var playbackFinished: Bool = false

    let errorSubject = PassthroughSubject<Error, Never>()
    let fileManager = DtFileManager()

    var audioPlayer: AVAudioPlayer? = .init()
    var updateTimer: Timer? = .init()

    override init() {
        super.init()
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
            guard let path = fileManager.filePath(forResource: resource, ofType: type),
                  let url = URL(string: path) else {
                print("Ошибка: файл не найден")
                return
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                totalDuration = audioPlayer?.duration ?? 0.0

                audioPlayer?.play()
                startProgressUpdates()
                playbackFinished = false
                isPlaying = true
            } catch {
                self.errorSubject.send(AudioPlayerError.fileNotFound)
                playbackFinished = true
            }
        }
    }

    func startProgressUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.playCurrentTime = Int(player.currentTime)
            self.playbackProgress = player.currentTime / player.duration
            self.totalDuration = player.duration
        }
    }

    func stopProgressUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { [weak self] in
            self?.playbackProgress = 0.0
            self?.playCurrentTime = Int(self?.audioPlayer?.duration ?? 0)
            self?.playbackFinished = true
            self?.isPlaying = false
        }
        stopProgressUpdates()
    }

    func loadAudioData(for resource: String, ofType type: String) {
        audioPlayer?.stop()
        audioPlayer = nil

        guard let path = fileManager.filePath(forResource: resource, ofType: type),
              let url = URL(string: path) else {
            print("Ошибка: файл не найден")
            return
        }

        do {
            let audioFile = try AVAudioFile(forReading: url)
            let totalDurationInSeconds = Double(audioFile.length) / audioFile.fileFormat.sampleRate
            let durationPerBar = totalDurationInSeconds / 55.0
            let pointsPerBar = Int(durationPerBar * audioFile.processingFormat.sampleRate)
            totalDuration = totalDurationInSeconds

            guard let audioBuffer = AVAudioPCMBuffer(
                pcmFormat: audioFile.processingFormat,
                frameCapacity: AVAudioFrameCount(audioFile.length)
            ) else {
                self.errorSubject.send(AudioPlayerError.bufferCreationFailed)
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
            self.errorSubject.send(AudioPlayerError.audioPlayerInitializationFailed)
        }
    }

    func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        audioPlayer = nil
        playbackProgress = 0.0
        isPlaying = false
        stopProgressUpdates()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            errorSubject.send(error)
        }
    }
}

extension DtAudioPlayerManager {
    func loadAudioDataForUI(for user: inout DatingModel, ofType type: String) async {
        print("Начинается загрузка данных баров для пользователя с ID: \(user.id)")
        print(user.barData)
        guard let path = fileManager.filePath(forResource: user.audiofile, ofType: type),
              let url = URL(string: path) else {
            print("Ошибка: файл не найден")
            return
        }

        do {
            let audioFile = try AVAudioFile(forReading: url)
            print("Файл загружен: \(url)")

            let totalDurationInSeconds = Double(audioFile.length) / audioFile.fileFormat.sampleRate
            let durationPerBar = totalDurationInSeconds / 55.0
            let pointsPerBar = Int(durationPerBar * audioFile.processingFormat.sampleRate)
            print("Длительность файла в секундах: \(totalDurationInSeconds)")

            guard let audioBuffer = AVAudioPCMBuffer(
                pcmFormat: audioFile.processingFormat,
                frameCapacity: AVAudioFrameCount(audioFile.length)
            ) else {
                self.errorSubject.send(AudioPlayerError.bufferCreationFailed)
                return
            }

            try audioFile.read(into: audioBuffer)
            print("Аудиобуфер загружен")

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
                user.barData = compressedData.map { value in
                    let normalizedValue = value / maxCompressedValue
                    let barHeight = abs(Double(normalizedValue)) * desiredMaxHeight
                    let finalBarHeight = barHeight + minimumBarHeight
                    return BarChartDataPoint(value: finalBarHeight)
                }

                print("Данные баров записаны в модель")
            }
        } catch {
            self.errorSubject.send(AudioPlayerError.audioPlayerInitializationFailed)
            print("Ошибка при инициализации аудиофайла")
        }
        print("Данные баров успешно загружены для пользователя с ID: \(user.id)")
        print(user.barData)
    }
}
