//
//  RecordPowerGraphView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct VoiceGraphView: View {
    @StateObject private var viewModel: VoiceGraphViewModel

    init(vm: VoiceGraphViewModel) {
        self._viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        HStack(spacing: viewModel.spaceBetweenBars) {
            ForEach(viewModel.heightsBar) { bar in
                RoundedRectangle(cornerRadius: viewModel.widthBar / 2)
                    .frame(width: viewModel.widthBar, height: CGFloat(bar.height))
                    .foregroundStyle(bar.coloredBool ? Color.iconsSecondary : Color.accentsPrimary)
                    .transition(.scale)
            }
        }
        .frame(width: viewModel.widthVoiceGraph, height: viewModel.heightVoiceGraph)
        HStack {
            deleteButton
                .disabled(viewModel.disableDeleteButton())
            recordButton
                .disabled(viewModel.disableRecordButton())
                .padding(.horizontal)
            playButton
                .disabled(viewModel.disablePlayButton())
        }
        .padding(.bottom)
        .onAppear {
            viewModel.loadAudioDataFromFile()
        }
    }
}

#Preview {
    VoiceGraphView(vm: VoiceGraphViewModel())
}

private extension VoiceGraphView {
    var recordButton: some View {
        DtCircleButton(
            systemName: (viewModel.statePlayer == .record) ? DtImage.stopRecord :  DtImage.record,
            style: .big,
            disableImage: false) {
                viewModel.didTapRecordButton()
            }
    }
    var deleteButton: some View {
        DtCircleButton(
            systemName: DtImage.delete,
            style: .small,
            disableImage: viewModel.disableDeleteButton()) {
                viewModel.didTapDeleteButton()
            }
    }
    var playButton: some View {
        DtCircleButton(
            systemName: viewModel.statePlayer == .play ? DtImage.pause : DtImage.play,
            style: .small,
            disableImage: viewModel.disablePlayButton()) {
                viewModel.didTapPlayPauseButton()
            }
    }
}
