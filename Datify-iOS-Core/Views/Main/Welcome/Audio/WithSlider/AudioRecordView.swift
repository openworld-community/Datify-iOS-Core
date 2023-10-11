//
//  AudioRecordView.swift
//  Datify-iOS-Core
//
//  Created by Александр Прайд on 04.10.2023.
//

import SwiftUI

protocol RecordViewing {
    func recordButtonAction()
    func deleteButtonAction()
    func playButtonAction()
    func playButtonImage() -> Image
}

struct AudioRecordView: View {

    @StateObject private var viewModel = AudioRecordViewViewModel()

    var body: some View {

        VStack {
            Text("Recording Status: \(viewModel.recordingStatus)")
                .padding()

            Spacer()

            Text("\(Int(viewModel.elapsedTime))")
                .font(.largeTitle)
                .foregroundColor(.red)
                .opacity(viewModel.isRecording ? 1 : 0)
                .animation(.linear(duration: 0.1))

            Slider(value: $viewModel.elapsedTime, in: 0...viewModel.maxDuration)
                .disabled(viewModel.isRecording)
                .padding()

            HStack {

                deleteButton
                recordButton
                    .disabled(viewModel.canSubmit)
                playButton
            }

        }

    }}

struct AudioRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordView()
    }
}

// MARK: - UI Elements
extension AudioRecordView {
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
                        print("viewModel.audioURL: \(viewModel.audioURL)")
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

// MARK: - RecordViewing
extension AudioRecordView: RecordViewing {
    func playButtonImage() -> Image {
        if viewModel.isPlaying {
            return Image(DtImage.stopPlayingEnabled)

        } else {
            if !fileExists() {
                return Image(DtImage.playEnabled)

            } else {
                return Image(DtImage.playEnabled)

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
