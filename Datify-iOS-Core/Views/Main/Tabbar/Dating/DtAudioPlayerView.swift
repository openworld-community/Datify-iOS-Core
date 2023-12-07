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
    @State private var isAlertPresented = false
    @State private var alertMessage = ""

    @Binding var isPlaying: Bool
    @Binding var playCurrentTime: Int
    @Binding var playbackFinished: Bool
    @Binding var totalDuration: Double

    var viewModel: DatingViewModel

    var desiredNumberOfBars = 60

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .modifier(DtPlayerModifier())
            HStack {
                let totalSeconds = playbackFinished ? Int(totalDuration) : viewModel.remainingTime
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
                        isPlaying
                            ? DtImage.mainPause
                            : DtImage.mainPlay
                    )
                }
                .frame(width: 24)
            }
            .padding(.horizontal)
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
