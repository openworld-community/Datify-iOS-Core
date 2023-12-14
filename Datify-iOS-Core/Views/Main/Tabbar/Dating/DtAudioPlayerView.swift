//
//  AudioPlayerView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 21.10.2023.
//

import SwiftUI
import AVFoundation
import Charts

struct DtAudioPlayerView: View {
    @StateObject var viewModel: DtAudioPlayerViewModel

    @State private var isAlertPresented = false
    @State private var alertMessage = ""

    @State private var isPlaying: Bool = false
    @State private var playCurrentTime: Int = 0
    @State private var playbackFinished: Bool = true
    @State private var totalDuration: Double = 0.0

    @State private var user: DatingModel?
    let audioPlayerManager: DtAudioPlayerManager
    var currentUserID: DatingModel.ID?

    var desiredNumberOfBars = 60

    init(user: DatingModel, audioPlayerManager: DtAudioPlayerManager, currentUserID: DatingModel.ID) {
        _viewModel = StateObject(wrappedValue: DtAudioPlayerViewModel(user: user, audioPlayerManager: audioPlayerManager))
        self.audioPlayerManager = audioPlayerManager
        self.currentUserID = currentUserID
    }

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .modifier(DtPlayerModifier())
            HStack {
                let totalSeconds = viewModel.playbackFinished
                ? Int(viewModel.totalDuration)
                : viewModel.remainingTime

                Text(String(format: "%02d:%02d", totalSeconds.minutes, totalSeconds.seconds))
                    .dtTypo(.p3Regular, color: .white)
                    .frame(width: 48, alignment: .leading)
                    .fixedSize(horizontal: true, vertical: false)

                DtBarChartView(
                    viewModel: viewModel,
                    dataPoints: viewModel.audioSamples,
                    barWidth: computeBarWidth()
                )
                Button(action: {
                    viewModel.togglePlayback()
                }) {
                    Image(
                        viewModel.isPlaying
                            ? DtImage.mainPause
                            : DtImage.mainPlay
                    )
                }
                .frame(width: 24)
            }
            .padding(.horizontal)
        }
        .onChange(of: currentUserID) { _, _ in
            print("currentUserID from DtAudioPlayerView: \(currentUserID)")
//            viewModel.loadingAudioData(audioFile: user?.audiofile ?? "")
            viewModel.isPlaying = false
            viewModel.playbackFinished = true
            viewModel.stopPlayback()
            viewModel.stopProgressUpdates()
        }
    }

    func computeBarWidth() -> CGFloat {
        let totalSpacing: CGFloat = CGFloat(desiredNumberOfBars - 1) * 2
        let labelWidths: CGFloat = 50 + 30 + 4 * 16
        let availableWidth = UIScreen.main.bounds.width - totalSpacing - labelWidths
        return availableWidth / CGFloat(desiredNumberOfBars)
    }
}

struct DtPlayerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 48)
            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.5))
            .opacity(0.24)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0.33, green: 0.33, blue: 0.35, opacity: 0.64))
            )
    }
}

struct DtButtonsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 48, height: 48)
            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.5))
            .opacity(0.24)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0.33, green: 0.33, blue: 0.35, opacity: 0.64))
            )
    }
}
