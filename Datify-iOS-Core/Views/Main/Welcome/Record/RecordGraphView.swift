//
//  RecordPowerGraphView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct RecordGraphView: View {
    @StateObject var viewModel: RecordGraphViewModel

    init(vm: RecordGraphViewModel) {
        self._viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        HStack(spacing: viewModel.distanceBetweenBars) {
            ForEach(viewModel.arrayHeights) { bar in
                RoundedRectangle(cornerRadius: viewModel.widthBar / 2)
                    .frame(width: viewModel.widthBar, height: bar.isASignal ? CGFloat(bar.height) : viewModel.widthBar)
                    .foregroundStyle(bar.coloredBool ? Color.iconsSecondary : Color.accentsPrimary)
                    .transition(bar.isASignal && !bar.coloredBool ? .scale : .opacity )
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
     RecordGraphView(vm: RecordGraphViewModel())
 }

extension RecordGraphView {
    private var recordButton: some View {
        DtCircleButton(
            systemName: (viewModel.statePlayer == .record && viewModel.canStopRecord) ? DtImage.stop :  DtImage.record,
            style: .big,
            disableImage: false) {
                viewModel.didTapRecordButton()
            }
            .animation(.easeIn, value: viewModel.statePlayer)
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
