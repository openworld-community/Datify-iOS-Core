//
//  AudioTrackView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct AudioTrackView: View {
    @ObservedObject var viewModel: AudioTrackViewModel

    init(viewModel: AudioTrackViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(viewModel.arrayHeight, id: \.self) { bar in
                HStack {
                    if bar.isASignal {
                        HStack {

                        }
                        .frame(width: 3, height: CGFloat(bar.height))
                        .background( bar.disabledBool ? Color(hex: 0x3C3C43, alpha: 0.3) : Color(hex: 0x6167FF))
                        .cornerRadius(3)
                        .transition(.opacity)
                    }
                }
                .frame(width: 3, height: bar.isASignal ? CGFloat(bar.height) : 3)
                .background( bar.disabledBool ? Color(hex: 0x3C3C43, alpha: 0.3) : Color(hex: 0x6167FF))
                .cornerRadius(3)
                .transition(bar.isASignal && !bar.disabledBool ? .scale : .opacity )
            }
        }
        .frame(height: 200)
        HStack {
            deleteButton
                .disabled(!viewModel.fileExistsBool)
                .disabled(viewModel.statePlayer != .none)
            recordButton
                .disabled(viewModel.statePlayer != .none)
            playButton
                .disabled(!viewModel.fileExistsBool)
                .disabled(viewModel.statePlayer == .recording)
        }
        .onAppear {
            Task {
                await viewModel.setUpCaptureSession()
            }
            _ = viewModel.fileExists()
            for _ in 0...Int(UIScreen.main.bounds.width / 5) {
                viewModel.arrayHeight.append(BarModel(height: 3, disabledBool: true, isASignal: false))
            }
        }
    }
}

#Preview {
    AudioTrackView(viewModel: AudioTrackViewModel())
}

extension AudioTrackView {
    private var recordButton: some View {
        Button {
            Task {
                viewModel.didTapRecordButton()
            }
        } label: {
            Circle()
                .fill(Color.clear)
                .frame(width: 96, height: 96)
                .foregroundColor(Color.red)
                .overlay {
                    Image(viewModel.statePlayer == .recording ? DtImage.stopRecording :  DtImage.voiceRecording
                    )
                    .resizable()
                    .frame(width: viewModel.statePlayer == .recording ? 28 : 48, height: viewModel.statePlayer == .recording ? 28 : 48)
                }
                .background(
                    RoundedRectangle(cornerRadius: 62)
                        .stroke(Color(hex: 0x3C3C43, alpha: 0.32), lineWidth: 1)
                )
        }
    }

    private var deleteButton: some View {
        Button {
            Task {
                viewModel.deleteRecord()
            }
        } label: {

            Circle()
                .fill(Color.clear)
                .frame(width: 48, height: 48)
                .foregroundColor(Color.red)
                .overlay {
                    Image(viewModel.statePlayer == .none && viewModel.fileExistsBool ? DtImage.deleteEnabled : DtImage.deleteDisabled)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .background(
                    RoundedRectangle(cornerRadius: 62)
                        .stroke(Color(hex: 0x3C3C43, alpha: 0.32), lineWidth: 1)
                )
        }
    }

    private var playButton: some View {
        Button {
            Task {
                viewModel.didTapPlayPauseButton()
            }
        } label: {
            if viewModel.fileExistsBool {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color.red)
                    .overlay {
                        Image(viewModel.statePlayer == .playing ? DtImage.pause : DtImage.playEnabled)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 62)
                            .stroke(Color(hex: 0x3C3C43, alpha: 0.32), lineWidth: 1)
                    )
            } else {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color.red)
                    .overlay {
                        Image(DtImage.playDisabled)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 62)
                            .stroke(Color(hex: 0x3C3C43, alpha: 0.32), lineWidth: 1)
                    )
            }
        }
    }
}
