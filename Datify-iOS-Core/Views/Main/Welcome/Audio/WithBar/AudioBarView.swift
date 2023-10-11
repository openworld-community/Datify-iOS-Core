//
//  AudioBarView.swift
//  Datify-iOS-Core
//
//  Created by Александр Прайд on 11.10.2023.
//

import SwiftUI
import AVFoundation
import AVKit

protocol AudioRecordViewing {
    func recordButtonAction()
    func deleteButtonAction()
    func playButtonAction()
}

struct BarView: View {
    let value: CGFloat
    var color: Color = Color.gray

    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .cornerRadius(10)
                .frame(width: 2, height: value)
        }
    }
}

struct AudioBarView: View {

    @StateObject private var viewModel: AudioPlayViewModel

    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 70) / 2

        return CGFloat(level * (40/35))
    }

    init(audio: String) {
        _viewModel = StateObject(wrappedValue: AudioPlayViewModel(url: URL(string: audio)!, sampelsCount: Int(UIScreen.main.bounds.width * 0.6 / 4)))
    }

    var body: some View {
        VStack {
            Spacer()
            voiceVisualizationView
            Spacer()
            HStack {
                deleteButton
                recordButton
                playButton
            }
        }
    }
}

struct AudioBarViewModel_Previews: PreviewProvider {
    static var previews: some View {
        AudioBarView(audio: "audio.mp3")
    }
}

// MARK: - UI Elements
extension AudioBarView {

    private var voiceVisualizationView: some View {
        VStack {
            HStack(alignment: .center, spacing: 2) {
                if viewModel.soundSamples.isEmpty {
                    ProgressView()
                } else {
                    ForEach(viewModel.soundSamples, id: \.self) { model in
                        BarView(value: self.normalizeSoundLevel(level: model.magnitude), color: model.color)
                    }
                }
            }.frame(width: UIScreen.main.bounds.width * 0.6)

        }.padding(.vertical, 8)
            .padding(.horizontal)
            .frame(minHeight: 0, maxHeight: 50)
            .background(Color.red.opacity(0.3).cornerRadius(10))

    }

    private var recordButton: some View {
        Button {
            Task {
                recordButtonAction()
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
                    .frame(width: 48, height: 48)
                }
        }
        .background(
            RoundedRectangle(cornerRadius: 62)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }

    private var deleteButton: some View {
        Button {
            Task {
                deleteButtonAction()
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
                        .stroke(Color.secondary, lineWidth: 1)
                )
        }

    }

    private var playButton: some View {
        Button {
            Task {
                playButtonAction()
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
                        print("viewModel.audioURL: \(String(describing: viewModel.audioURL))")
                    }
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
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 62)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }
}

// MARK: - AudioRecordViewing
extension AudioBarView: AudioRecordViewing {

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

    func recordButtonAction() {
        if viewModel.isRecording {
            viewModel.stopRecording()

        } else {
            viewModel.startRecording()
        }
    }

    func deleteButtonAction() {
        viewModel.delete()
    }

    func playButtonAction() {
        if viewModel.isPlaying == true {
            viewModel.stopPlayback()
        } else if viewModel.audioURL != nil {
                viewModel.play()
        }
    }
}
