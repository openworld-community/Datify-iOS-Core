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

    @Published var isPlaying: Bool = false {
        didSet {
            print("viewModel.isPlaying: \(isPlaying)")
        }

    }
    @Published var playbackProgress: Double = 0.0 {
        didSet {
            print("Прогресс в DatingViewModel: \(playbackProgress)")
        }
    }
    @Published var playCurrentTime: Int = 0 {
        didSet {
            print("playCurrentTime: \(playCurrentTime)")
        }
    }
    @Published var totalDuration: Double = 0.0
    @Published var audioSamples: [BarChartDataPoint] = []

    private var cancellables: Set<AnyCancellable> = []

    init(router: Router<AppRoute>) {
        self.router = router

        loadingAudioData()

        audioPlayerManager.$audioSamples
            .assign(to: \.audioSamples, on: self)
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
                self?.playbackProgress = newProgress
                print("+++++++++playbackProgress \(newProgress)")
            }
            .store(in: &cancellables)

        audioPlayerManager.$playCurrentTime
            .sink { [weak self] newCurrentTime in
                self?.playCurrentTime = newCurrentTime
                print("+++++++++newCurrentTime \(newCurrentTime)")
            }
            .store(in: &cancellables)
    }

    func togglePlayback() {
        audioPlayerManager.togglePlayback(for: "recording", ofType: "mp3")
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
}
