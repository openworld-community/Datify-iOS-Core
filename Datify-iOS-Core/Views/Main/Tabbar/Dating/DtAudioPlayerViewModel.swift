//
//  DtAudioPlayerViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 12.12.2023.
//

import SwiftUI
import Combine

final class DtAudioPlayerViewModel: ObservableObject {
    @Published var totalDuration: Double = 0.0
    @Published var audioSamples: [BarChartDataPoint] = []

    @Published var playbackFinished: Bool = false
    @Published var isPlaying: Bool = false
    @Published var playbackProgress: Double = 0.0
    @Published var playCurrentTime: Int = 0

    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var user: DatingModel

    var audioPlayerManager = DtAudioPlayerManager()
    var updateTimer: Timer?  = .init()

    var remainingTime: Int {
        playbackFinished ? 0 : max(Int(totalDuration) - playCurrentTime, 0)
    }

    var error: Error? {
        didSet {
            if let error = error {
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    }

    private var cancellables: Set<AnyCancellable> = []

    init(user: DatingModel, audioPlayerManager: DtAudioPlayerManager) {
        self.user = user
        self.audioPlayerManager = audioPlayerManager
        setupBindings()
        loadingAudioData(audioFile: user.audiofile)
        $user
            .dropFirst()
            .sink { [weak self] _ in
                self?.loadingAudioData(audioFile: user.audiofile)
            }
            .store(in: &cancellables)
    }

    deinit {
        updateTimer?.invalidate()
    }

    func setupBindings() {
        audioPlayerManager.$audioSamples
            .receive(on: DispatchQueue.main)
            .assign(to: \.audioSamples, on: self)
            .store(in: &cancellables)

        audioPlayerManager.$playbackFinished
            .receive(on: DispatchQueue.main)
            .assign(to: \.playbackFinished, on: self)
            .store(in: &cancellables)

        audioPlayerManager.$isPlaying
            .receive(on: DispatchQueue.main)
            .assign(to: \.isPlaying, on: self)
            .store(in: &cancellables)

        audioPlayerManager.$playbackProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newProgress in
                    self?.playbackProgress = newProgress
            }
            .store(in: &cancellables)

        audioPlayerManager.$playCurrentTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTime in
                    self?.playCurrentTime = newTime
            }
            .store(in: &cancellables)

        audioPlayerManager.$totalDuration
            .sink { [weak self] totalDuration in
                DispatchQueue.main.async {
                    self?.totalDuration = totalDuration
                }
            }
            .store(in: &cancellables)

        audioPlayerManager.errorSubject
            .receive(on: DispatchQueue.global())
            .sink { [weak self] error in
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
            }
            .store(in: &cancellables)
    }

    func togglePlayback() {
        audioPlayerManager.togglePlayback(for: user.audiofile, ofType: "mp3")
    }

    func startProgressUpdates() {
        audioPlayerManager.startProgressUpdates()
    }

    func stopProgressUpdates() {
        audioPlayerManager.stopProgressUpdates()
    }

    func loadingAudioData(audioFile: String) {
        print("Вызов loadingAudioData \(user.name) = \(user.audiofile)")
        audioPlayerManager.loadAudioData(for: audioFile, ofType: "mp3")
    }

    func stopPlayback() {
        print("Вызов stopPlayback")
        audioPlayerManager.stopPlayback()
    }

    func loadBarDataForUser(userId: DatingModel.ID) async {
        if user.barData.isEmpty {
            await audioPlayerManager.loadAudioDataForUI(for: &user, ofType: "mp3")
        }
    }
}
