//
//  DatingViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI
import Combine

final class DatingViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    var audioPlayerManager = DtAudioPlayerManager()
    var updateTimer: Timer?
    let defaultDatingModel = DatingModel()

    @Published var playbackFinished: Bool = false
    @Published var isPlaying: Bool = false
    @Published var playbackProgress: Double = 0.0
    @Published var playCurrentTime: Int = 0
    @Published var totalDuration: Double = 0.0
    @Published var audioSamples: [BarChartDataPoint] = []

    private var cancellables: Set<AnyCancellable> = []

    init(router: Router<AppRoute>) {
        self.router = router

        loadingAudioData()

        audioPlayerManager.$audioSamples
            .assign(to: \.audioSamples, on: self)
            .store(in: &cancellables)

        audioPlayerManager.$playbackFinished
            .assign(to: \.playbackFinished, on: self)
            .store(in: &cancellables)

        audioPlayerManager.$isPlaying
            .assign(to: \.isPlaying, on: self)
            .store(in: &cancellables)

        audioPlayerManager.$audioSamples
            .sink { newSamples in
                print("Получены новые audioSamples в DatingViewModel: \(newSamples.count) элементов")
            }
            .store(in: &cancellables)
        audioPlayerManager.$playbackProgress
            .sink { [weak self] newProgress in
                DispatchQueue.main.async {
                    self?.playbackProgress = newProgress
                }
            }
            .store(in: &cancellables)
        audioPlayerManager.$totalDuration
            .sink { [weak self] totalDuration in
                self?.totalDuration = totalDuration
            }
            .store(in: &cancellables)
        audioPlayerManager.$playCurrentTime
            .sink { [weak self] newTime in
                DispatchQueue.main.async {
                    self?.playCurrentTime = newTime
                }
            }
            .store(in: &cancellables)
        audioPlayerManager.$playCurrentTime
            .sink { [weak self] currentTime in
                DispatchQueue.main.async {
                    self?.playCurrentTime = currentTime
                }
            }
            .store(in: &cancellables)
    }

    func togglePlayback() {
        audioPlayerManager.togglePlayback(for: "recording5sec", ofType: "mp3")
    }

    func startProgressUpdates() {
        audioPlayerManager.startProgressUpdates()
    }

    func stopProgressUpdates() {
        audioPlayerManager.stopProgressUpdates()
    }

    func loadingAudioData() {
        audioPlayerManager.loadAudioData()
    }

    var remainingTime: Int {
        if playbackFinished {
            return 0
        } else {
            return max(Int(totalDuration) - playCurrentTime, 0)
        }
    }

    func minutes(from seconds: Int) -> Int {
        seconds / 60
    }

    func seconds(from seconds: Int) -> Int {
        seconds % 60
    }

}
