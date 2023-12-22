//
//  TestRecordView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 21.12.2023.
//

import SwiftUI
import AVFoundation

struct TestRecordView: View {
    @State var isHeld: Bool = false
    @State private var recordings: [(url: URL, duration: String)] = []
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            // List to display recordings
            List(recordings, id: \.url) { recording in
                Button(action: {
                    self.playRecording(url: recording.url)
                }) {
                    VStack(alignment: .leading) {
                        Text(recording.url.lastPathComponent)
                        Text("Duration: \(recording.duration)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }

                // Record button
                Text(isHeld ? "Held" : "Not Held")
                    .padding()
                    .background(isHeld ? Color.green : Color.gray)
                    .gesture(
                        // Combine a LongPressGesture and a DragGesture
                        LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                self.isHeld = true
                                startRecording()
                            }
                            .sequenced(before: DragGesture(minimumDistance: 0))
                            .onEnded { _ in
                                self.isHeld = false
                                Task {
                                    await stopRecording()
                                }

                        }
                )
        }
    }
    private func stopRecording() async {
        // ... stop recording implementation ...

        if let url = audioRecorder?.url {
            let duration = await getAudioDuration(url: url)
            recordings.append((url, duration))
        }
        audioRecorder = nil
    }

    private func getAudioDuration(url: URL) async -> String {
        let asset = AVURLAsset(url: url)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        return formatTime(seconds: durationInSeconds)
    }

    private func formatTime(seconds: Double) -> String {
        let hours = Int(seconds / 3600)
        let minutes = Int(seconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
    private func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true)

            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentPath.appendingPathComponent("\(Date().timeIntervalSince1970).m4a")

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
        } catch {
            // Handle errors here
        }
    }

    private func playRecording(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            // Handle errors here
            print("Could not load file for playback: \(error)")
        }
    }
}

#Preview {
    TestRecordView()
}
