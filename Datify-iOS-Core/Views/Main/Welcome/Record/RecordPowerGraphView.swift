//
//  RecordPowerGraphView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct RecordPowerGraphView: View {
    @ObservedObject var viewModel: PowerGraphViewModel

    init(graphModel: PowerGraphModel) {
        self._viewModel = ObservedObject(wrappedValue: PowerGraphViewModel(powerGraphModel: graphModel))
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(viewModel.powerGraphModel.arrayHeights) { bar in
                HStack {
                    if bar.isASignal {
                        RoundedRectangle(cornerRadius: 3)
                        .frame(width: 3, height: CGFloat(bar.height))
                        .foregroundStyle( bar.coloredBool ? Color(hex: 0x3C3C43, alpha: 0.3) : Color(hex: 0x6167FF))
                        .transition(.opacity)
                    }
                }
                .frame(width: 3, height: bar.isASignal ? CGFloat(bar.height) : 3)
                .background( bar.coloredBool ? Color(hex: 0x3C3C43, alpha: 0.3) : Color(hex: 0x6167FF))
                .cornerRadius(3)
                .transition(bar.isASignal && !bar.coloredBool ? .scale : .opacity )
            }
        }
        .frame(height: 160)
        HStack {
            deleteButton
                .disabled(!viewModel.powerGraphModel.fileExistsBool)
                .disabled(viewModel.powerGraphModel.statePlayer != .inaction)
            recordButton
                .disabled(viewModel.powerGraphModel.statePlayer == .play || viewModel.powerGraphModel.statePlayer == .pause)
                .disabled(viewModel.powerGraphModel.fileExistsBool)
                .padding(.horizontal)
            playButton
                .disabled(!viewModel.powerGraphModel.fileExistsBool)
                .disabled(viewModel.powerGraphModel.statePlayer == .record)
        }
        .padding(.bottom)
        .onAppear {
            Task {
                await viewModel.setUpCaptureSession()
            }
            viewModel.getPowerFromFile()
        }
    }
}

#Preview {
    RecordPowerGraphView(graphModel: PowerGraphModel(widthElement: 3, heightGraph: 160, wightGraph: Int(UIScreen.main.bounds.width), distanceElements: 2, deleteDuration: 1.0, recordingDuration: 15))
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
