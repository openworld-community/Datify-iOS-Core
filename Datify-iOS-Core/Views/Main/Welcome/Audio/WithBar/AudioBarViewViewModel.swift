//
//  AudioBarViewViewModel.swift
//  Datify-iOS-Core
//
//  Created by Александр Прайд on 11.10.2023.
//

import Foundation
import AVKit
import SwiftUI
import AVFoundation
import Combine

class AudioPlayViewModel: ObservableObject {

    private var audioRecorder: AVAudioRecorder?
    // var audioPlayer: AVAudioPlayer?
    var audioPlayer: AVPlayer?
    private var timer: Timer?

    @Published var audioURL: URL?

    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var recordingStatus: String = "Not Recording"

    @Published var elapsedTime: TimeInterval = 0
    @Published var maxDuration: TimeInterval = 15.0

    @Published var canSubmit = false

    @Published public var soundSamples = [AudioPreviewModel]()
    var sampleCount: Int
    var index = 0
    var dataManager: AudioService?

    init(url: URL, sampelsCount: Int) {
        self.audioURL = url
        self.sampleCount = sampelsCount

        let fileName = self.getDocumentsDirectory().appendingPathComponent("recording.m4a")
        audioURL = fileName

        checkFileAndSetCanSubmit()
        visualizeAudio()
    }

    func startTimer() {

        countDuration { duration in
            let timeInterval = duration / Double(self.sampleCount)

            self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
                if self.index < self.soundSamples.count {
                    withAnimation(Animation.linear) {
                        self.soundSamples[self.index].color = Color.black
                    }
                    self.index += 1
                }
            })
        }
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.audioPlayer?.pause()
        self.audioPlayer?.seek(to: .zero)
        self.timer?.invalidate()
        self.isPlaying = false
        self.index = 0
        self.soundSamples = self.soundSamples.map { tmp -> AudioPreviewModel in
            var cur = tmp
            cur.color = Color.gray
            return cur
        }
    }

    func startRecording() {
        isRecording = true

        startTimer()

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        guard let url = audioURL else { return }

        print("метод записи \(url.path)")
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            isRecording = true
            recordingStatus = "Recording..."

            startTimer()
            countDuration { _ in }

        } catch {
            print("Error recording audio: \(error)")
        }
    }

    func stopRecording() {
        isRecording = false
        timer?.invalidate()
        audioRecorder?.stop()
        recordingStatus = "Recording Stopped"
    }

    func play() {
        guard let url = audioURL else { return }

        audioPlayer = AVPlayer(url: url)

        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayer?.currentItem)

        audioPlayer?.play()
        isPlaying = true

        startTimer()
        countDuration { _ in }

    }

    func pauseAudio() {
        audioPlayer?.pause()
        timer?.invalidate()
        self.isPlaying = false
    }

    func stopPlayback() {
        audioPlayer?.pause()
        isPlaying = false

        recordingStatus = "Recording is Paused"

        timer?.invalidate()
        timer = nil
    }

    func delete() {

        recordingStatus = "Recording is Deleted"

        guard let url = audioURL?.path else { return }
        print("первый \(url)")

        removeOldFile(path: url)

        if fileExist(path: url) {
            print("второй \(url)")
            removeOldFile(path: url)

            do {
                try FileManager.default.removeItem(atPath: url)

                print("файл удалён")
            } catch {
                print("error remove file \(url) - \(error.localizedDescription)")
            }
        }

        elapsedTime = 0
        timer?.invalidate()
        timer = nil
    }

    func countDuration(completion: @escaping(Float64) -> Void) {

        DispatchQueue.global(qos: .background).async {
            if let duration = self.audioPlayer?.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                DispatchQueue.main.async {
                    completion(seconds)
                }
                return
            }
            DispatchQueue.main.async {
                completion(1)
            }
        }

    }

    func visualizeAudio() {
        dataManager?.buffer(url: audioURL!, samplesCount: sampleCount) { results in
            self.soundSamples = results
        }
    }

    private func fileExist(path: String) -> Bool {
        var isDir = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        return exists && isDir.boolValue
    }

    func checkFileAndSetCanSubmit() {
        let fileName = "recording.m4a"
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            let fileExists = FileManager.default.fileExists(atPath: fileURL.path)
            canSubmit = fileExists
        }
    }

    private func removeOldFile(path: String) {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print("error remove file \(path) - \(error.localizedDescription)")
            }
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if flag {
//            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
//
//            do {
//                let audioData = try Data(contentsOf: audioFilename)
//            } catch {
//                print("Failed to load recorded audio data")
//            }
//        }
    }

}
