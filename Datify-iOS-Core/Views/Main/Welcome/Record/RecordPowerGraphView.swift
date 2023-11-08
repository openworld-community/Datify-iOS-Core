//
//  RecordPowerGraphView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct RecordPowerGraphView: View {
    @ObservedObject var viewModel: PowerGraphViewModel

    init(viewModel: PowerGraphViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(viewModel.powerGraphModel.arrayHeights) { bar in
               RoundedRectangle(cornerRadius: 3)
                .frame(width: viewModel.powerGraphModel.widthPowerElement, height: bar.isASignal ? CGFloat(bar.height) : viewModel.powerGraphModel.widthPowerElement)
                .foregroundStyle(bar.coloredBool ? Color.iconsSecondary : Color(hex: 0x6167FF))
                .transition(bar.isASignal && !bar.coloredBool ? .scale : .opacity )
            }
        }
        .frame(height: viewModel.powerGraphModel.heightPowerGraph)
        HStack {
            deleteButton
                .disabled(viewModel.disableDeletebutton())
            recordButton
                .disabled(viewModel.powerGraphModel.statePlayer == .play || viewModel.powerGraphModel.statePlayer == .pause)
                .disabled(viewModel.powerGraphModel.fileExistsBool)
                .padding(.horizontal)
            playButton
                .disabled(!viewModel.powerGraphModel.fileExistsBool)
                .disabled(viewModel.powerGraphModel.statePlayer == .record)
        }
        .padding(.bottom)
        .task {
            await viewModel.setUpCaptureSession()
            viewModel.getPowerFromFile()
        }
    }
}

#Preview {
    RecordPowerGraphView(viewModel: PowerGraphViewModel(
        router: Router(),
        powerGraphModel: PowerGraphModel(widthElement: 3, heightGraph: 160, wightGraph: 355, distanceElements: 2, deleteDuration: 1.0, recordingDuration: 15)))
 }

extension RecordPowerGraphView {
    private var recordButton: some View {
        DtCircleButton(
            systemName: viewModel.powerGraphModel.statePlayer == .record ? DtImage.stop :  DtImage.record,
            style: .big,
            disable: false) {
            viewModel.didTapRecordButton()
        }
    }

    private var deleteButton: some View {
        DtCircleButton(
            systemName: DtImage.delete,
            style: .small,
            disable: viewModel.powerGraphModel.statePlayer == .inaction && viewModel.powerGraphModel.fileExistsBool ? false : true) {
            viewModel.didTapDeleteButton()
        }
    }

    private var playButton: some View {
        DtCircleButton(
            systemName: viewModel.powerGraphModel.statePlayer == .play ? DtImage.pause : DtImage.play,
            style: .small,
            disable: viewModel.powerGraphModel.statePlayer != .record && viewModel.powerGraphModel.fileExistsBool ? false : true) {
            viewModel.didTapPlayPauseButton()
        }
    }
}
