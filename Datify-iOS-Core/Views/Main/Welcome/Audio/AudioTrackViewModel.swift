//
//  AudioTrackViewModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import Foundation

class AudioTrackViewModel: ObservableObject {
    @Published var canSubmit = false
    @Published var isRecording: Bool = false
    @Published var isPlaying = false

    @Published var arrayHeight: [Float] = []
}
