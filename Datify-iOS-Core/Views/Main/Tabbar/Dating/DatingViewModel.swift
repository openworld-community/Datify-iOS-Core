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

    @Published var playbackFinished: Bool = false
    @Published var isPlaying: Bool = false
    @Published var playbackProgress: Double = 0.0
    @Published var playCurrentTime: Int = 0
    @Published var totalDuration: Double = 0.0
    @Published var audioSamples: [BarChartDataPoint] = []

    @Published var liked: Bool = false
    @Published var bookmarked: Bool = false

    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var users: [DatingModel] = DatingModel.defaultUsers
    @Published var currentUserIndex = 0

    var audioPlayerManager = DtAudioPlayerManager()
    var updateTimer: Timer?

    var error: Error? {
        didSet {
            if let error = error {
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    }

    private var cancellables: Set<AnyCancellable> = []

    init(router: Router<AppRoute>) {
        self.router = router
        loadingAudioData()
        setupBindings()
        loadInitialData()
    }

    deinit {
        updateTimer?.invalidate()
    }

    func setupBindings() {
        audioPlayerManager.$audioSamples
            .assign(to: \.audioSamples, on: self)
            .store(in: &cancellables)

        audioPlayerManager.$playbackFinished
            .assign(to: \.playbackFinished, on: self)
            .store(in: &cancellables)

        audioPlayerManager.$isPlaying
            .assign(to: \.isPlaying, on: self)
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

        $liked
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.users[self.currentUserIndex].liked = newValue
            }
            .store(in: &cancellables)

        $bookmarked
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.users[self.currentUserIndex].bookmarked = newValue
            }
            .store(in: &cancellables)

        audioPlayerManager.errorSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
            }
            .store(in: &cancellables)
    }

    func loadInitialData() {
        let currentUser = users[currentUserIndex]

        self.liked = currentUser.liked
        self.bookmarked = currentUser.bookmarked
    }

    func togglePlayback() {
        let currentUser = users[currentUserIndex]
        print("currentUser: \(currentUser.name)")
        audioPlayerManager.togglePlayback(for: currentUser.audiofile, ofType: "mp3")
    }

    func startProgressUpdates() {
        audioPlayerManager.startProgressUpdates()
    }

    func stopProgressUpdates() {
        audioPlayerManager.stopProgressUpdates()
    }

    func loadingAudioData() {
        let currentUser = users[currentUserIndex]
        print("currentUser: \(currentUser.name)")
        audioPlayerManager.loadAudioData(for: currentUser.audiofile, ofType: "mp3")
    }

    var remainingTime: Int {
        if playbackFinished {
            return 0
        } else {
            return max(Int(totalDuration) - playCurrentTime, 0)
        }
    }
}
