//
//  RecordPowerGraphView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct VoiceGraphView: View {
    @StateObject var viewModel: VoiceGraphViewModel

    init(vm: VoiceGraphViewModel) {
        self._viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        HStack(spacing: viewModel.distanceBetweenBars) {
            ForEach(viewModel.arrayHeights) { bar in
                RoundedRectangle(cornerRadius: viewModel.widthBar / 2)
                    .frame(width: viewModel.widthBar, height: bar.signal ? CGFloat(bar.height) : viewModel.widthBar)
                    .foregroundStyle(bar.coloredBool ? Color.iconsSecondary : Color.accentsPrimary)
                    .transition(bar.signal && !bar.coloredBool ? .scale : .opacity )
            }
        }
        .frame(width: viewModel.wightBarGraph, height: viewModel.heightBarGraph)
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

extension VoiceGraphView {
    private var recordButton: some View {
        DtCircleButton(
            systemName: (viewModel.statePlayer == .record) ? DtImage.stop :  DtImage.record,
            style: .big,
            disableImage: false) {
                viewModel.didTapRecordButton()
            }
            .animation(.none, value: viewModel.statePlayer)
    }
    private var deleteButton: some View {
        DtCircleButton(
            systemName: DtImage.delete,
            style: .small,
            disableImage: viewModel.disableDeleteButton()) {
                viewModel.didTapDeleteButton()
            }
    }
    private var playButton: some View {
        DtCircleButton(
            systemName: viewModel.statePlayer == .play ? DtImage.pause : DtImage.play,
            style: .small,
            disableImage: viewModel.disablePlayButton()) {
                viewModel.didTapPlayPauseButton()
            }
    }
}
