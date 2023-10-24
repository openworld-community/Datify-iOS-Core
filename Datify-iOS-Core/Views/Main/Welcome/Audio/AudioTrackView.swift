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
                .frame(width: 3, height: CGFloat(height) * 7)
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                .background(Color.blue)
            }
        }
        .onAppear {
            for i in 0...75 {
                viewModel.arrayHeight.append(Float.random(in: 0...20))
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
                //                    recordButtonAction()
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
                //                    deleteButtonAction()
            }
        } label: {

            Circle()
                .fill(Color.clear)
                .frame(width: 48, height: 48)
                .foregroundColor(Color.red)
                .overlay {
                    Image(fileExists() ? DtImage.deleteEnabled : DtImage.deleteDisabled)
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
            if !fileExists() {
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
                        //                            print("viewModel.audioURL: \(viewModel.audioURL)")
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

    func fileExists() -> Bool {
        let fileName = "recording.m4a"
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            print("1111fileUrl: \(fileURL)")
            return FileManager.default.fileExists(atPath: fileURL.path)
        }
        print("File doesn't exit")
        return false
    }
}
