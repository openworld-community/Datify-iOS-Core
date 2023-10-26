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
    var viewModel: DatingViewModel
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @Binding var isPlaying: Bool
    @Binding var playCurrentTime: Int

    var body: some View {

        ZStack {
            Rectangle()
                .frame(height: 48)
                .cornerRadius(16)
                .opacity(0.64)
            HStack(alignment: .center) {
                Text(String(format: "%02d:%02d", 00, playCurrentTime))
                    .frame(width: 50, alignment: .leading) // Фиксируем ширину и выравнивание по правому краю
                    .fixedSize(horizontal: true, vertical: false)
                    .foregroundColor(.white)

                DtBarChartView(
                    viewModel: viewModel,
                    dataPoints: viewModel.audioSamples,
                    barWidth: computeBarWidth()
                )
                Button(action: {
                    viewModel.togglePlayback()
                }) {
                    Image(isPlaying ? DtImage.mainPause : DtImage.mainPlay)
                }
                .frame(width: 30)
            }
            .padding(.horizontal)
        }
    }

    func computeBarWidth() -> CGFloat {
        let totalSpacing: CGFloat = 2.0 * CGFloat(desiredNumberOfBars - 1)
        let availableWidth = (UIScreen.main.bounds.width - totalSpacing) * 0.5
        print("screenWidth: \(UIScreen.main.bounds.width)")
        print("totalSpacing: \(totalSpacing), availableWidth: \(availableWidth)")

        return availableWidth / CGFloat(desiredNumberOfBars)
    }

    var desiredNumberOfBars: Int {
        return 55
    }

}

struct DtAudioPlayerViewPreview: PreviewProvider {
    static var previews: some View {
        DtAudioPlayerView(
            viewModel: DatingViewModel(router: Router()),
            isPlaying: .constant(true),
            playCurrentTime: .constant(60)
        )
    }
}
