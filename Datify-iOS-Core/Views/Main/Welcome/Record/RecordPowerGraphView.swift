//
//  RecordPowerGraphView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct RecordPowerGraphView: View {
    @ObservedObject var viewModel: RegRecordViewModel

    init(viewModel: RegRecordViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(viewModel.arrayHeight, id: \.self) { bar in
                HStack {
                    if bar.isASignal {
                        RoundedRectangle(cornerRadius: 3)
                        .frame(width: 3, height: CGFloat(bar.height))
                        .foregroundStyle( bar.disabledBool ? Color(hex: 0x3C3C43, alpha: 0.3) : Color(hex: 0x6167FF))
                        .transition(.opacity)
                    }
                }
                .id(bar.height)
                .frame(width: 3, height: bar.isASignal ? CGFloat(bar.height) : 3)
                .background( bar.disabledBool ? Color(hex: 0x3C3C43, alpha: 0.3) : Color(hex: 0x6167FF))
                .cornerRadius(3)
                .transition(bar.isASignal && !bar.disabledBool ? .scale : .opacity )
            }
        }
        .frame(height: 160)
        .background(.green)
        HStack {
            deleteButton
                .disabled(!viewModel.fileExistsBool)
                .disabled(viewModel.statePlayer != .inaction)
            recordButton
                .disabled(viewModel.statePlayer != .inaction)
                .padding(.horizontal)
            playButton
                .disabled(!viewModel.fileExistsBool)
                .disabled(viewModel.statePlayer == .record)
        }
        .padding(.bottom)
        .onAppear {
            Task {
                await viewModel.setUpCaptureSession()
            }
            if viewModel.fileExists() {
                viewModel.fileExistsBool = true
                viewModel.getPower()
            } else {
                for _ in 0...Int(UIScreen.main.bounds.width / 5) {
                    viewModel.arrayHeight.append(BarModel(height: 3, disabledBool: true, isASignal: false))
                }
            }
        }
    }
}

#Preview {
    RecordPowerGraphView(viewModel: RegRecordViewModel(router: Router()))
}

extension RecordPowerGraphView {
    private var recordButton: some View {
        DtCircleButton(
            systemName: viewModel.statePlayer == .record ? DtImage.stop :  DtImage.record,
            style: .big,
            disable: false) {
            viewModel.didTapRecordButton()
        }
    }

    private var deleteButton: some View {
        DtCircleButton(
            systemName: DtImage.delete,
            style: .small,
            disable: viewModel.statePlayer == .inaction && viewModel.fileExistsBool ? false : true) {
            viewModel.didTapDeleteButton()
        }
    }

    private var playButton: some View {
        DtCircleButton(
            systemName: viewModel.statePlayer == .play ? DtImage.pause : DtImage.playEnabled,
            style: .small,
            disable: false) {
            viewModel.didTapPlayPauseButton()
        }
    }
}
