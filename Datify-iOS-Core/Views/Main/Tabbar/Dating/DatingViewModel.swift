//
//  DatingViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 18.12.2023.
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

    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var users: [DatingModel] = DatingModel.defaultUsers
    @Published var currentUserID: DatingModel.ID?

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

    init(router: Router<AppRoute>) {
        self.router = router
        setupBindings()
        loadInitialData()
        loadingAudioData()

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
                self?.totalDuration = totalDuration
            }
            .store(in: &cancellables)

        $liked
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self = self, let currentUserId = self.currentUserID else { return }
                if let userIndex = self.users.firstIndex(where: { $0.id == currentUserId }) {
                    self.users[userIndex].liked = newValue
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

    func loadInitialData() {
        currentUserID = users.first?.id

        if let currentUserID = currentUserID,
           let currentUser = users.first(where: {
               $0.id == currentUserID }) {
            self.liked = currentUser.liked
        }
    }

    func togglePlayback() {
        if let currentUserID = currentUserID,
           let currentUser = users.first(where: {
               $0.id == currentUserID }) {
            audioPlayerManager.togglePlayback(for: currentUser.audiofile, ofType: "mp3")
        }
    }

    func startProgressUpdates() {
        audioPlayerManager.startProgressUpdates()
    }

    func stopProgressUpdates() {
        audioPlayerManager.stopProgressUpdates()
    }

    func loadingAudioData() {
        if let currentUserID = currentUserID,
           let currentUser = users.first(where: {
               $0.id == currentUserID }) {
            audioPlayerManager.loadAudioData(for: currentUser.audiofile, ofType: "mp3")
        }
    }
}
