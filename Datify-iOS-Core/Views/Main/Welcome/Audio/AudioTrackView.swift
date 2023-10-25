//
//  AudioTrackView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 25.10.2023.
//

import SwiftUI

struct AudioTrackView: View {
    @StateObject var viewModel = AudioTrackViewModel()
    var body: some View {
        HStack(spacing: 2) {
            ForEach(viewModel.arrayHeight, id: \.self) { height in
                HStack {

                }
                .frame(width: height == 15 ? 1 : 3, height: CGFloat(height) * 7)
                .background(height == 15 ? Color.red : Color.blue)
                .cornerRadius(3)
            }
            .frame(height: 80)
        }
        .onAppear {
            Task {
                await viewModel.setUpCaptureSession()
            }
            for _ in 0...75 {
                viewModel.arrayHeight.append(1.0)
            }
        }
        HStack {
            deleteButton
            recordButton
                .animation(nil)
                .disabled(viewModel.canSubmit)
            playButton
        }
    }
}

#Preview {
    AudioTrackView()
}

extension AudioTrackView {
    private var recordButton: some View {
        Button {
            Task {
                viewModel.didTapRecordButton()
//                viewModel.canSubmit = true
                if viewModel.isRecording {
                    withAnimation(.linear) {
                        viewModel.isRecording = false
                    }
                } else {
                    withAnimation(.linear) {
                        viewModel.isRecording = true
                    }
                }
            }
        } label: {

            Circle()
                .fill(Color.clear)
                .frame(width: 96, height: 96)
                .foregroundColor(Color.red)
                .overlay {
                    Image(viewModel.isRecording ? DtImage.stopRecording :  DtImage.voiceRecording
                    )
                    .resizable()
                    .frame(width: viewModel.isRecording ? 28 : 48, height: viewModel.isRecording ? 28 : 48)
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
                    Image(viewModel.fileExists() ? DtImage.deleteEnabled : DtImage.deleteDisabled)
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
                //                    playButtonAction()
            }
        } label: {
            if !viewModel.fileExists() {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color.red)
                    .overlay {
                        Image(DtImage.playDisabled)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .onAppear {
                        print("viewModel.audioURL: \(viewModel.fileExists())")
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
                        Image(viewModel.isPlaying ? DtImage.stopPlayingEnabled : DtImage.playEnabled)
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
