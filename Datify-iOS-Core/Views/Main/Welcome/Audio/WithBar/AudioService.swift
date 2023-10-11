//
//  AudioService.swift
//  Datify-iOS-Core
//
//  Created by Александр Прайд on 11.10.2023.
//

import Foundation
import Combine
import AVFoundation

protocol AudioService {
    func buffer(url: URL, samplesCount: Int, completion: @escaping([AudioPreviewModel]) -> Void)
}

class Service {
    static let shared: AudioService = Service()
    private init() {}
}

extension Service: AudioService {
    func buffer(url: URL, samplesCount: Int, completion: @escaping([AudioPreviewModel]) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            do {
                var curUrl = url
                if url.absoluteString.hasPrefix("https://") {
                    let data = try Data(contentsOf: url)

                    let directory = FileManager.default.temporaryDirectory
                    let fileName = "chunk.m4a)"
                    curUrl = directory.appendingPathComponent(fileName)

                    try data.write(to: curUrl)
                }

                let file = try AVAudioFile(forReading: curUrl)
                if let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                              sampleRate: file.fileFormat.sampleRate,
                                              channels: file.fileFormat.channelCount, interleaved: false),
                   let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length)) {

                    try file.read(into: buf)
                    guard let floatChannelData = buf.floatChannelData else { return }
                    let frameLength = Int(buf.frameLength)

                    let samples = Array(UnsafeBufferPointer(start: floatChannelData[0], count: frameLength))

                    var result = [AudioPreviewModel]()

                    let chunked = samples.chunked(into: samples.count / samplesCount)
                    for row in chunked {
                        var accumulator: Float = 0
                        let newRow = row.map { $0 * $0 }
                        accumulator = newRow.reduce(0, +)
                        let power: Float = accumulator / Float(row.count)
                        let decibles = 10 * log10f(power)

                        result.append(AudioPreviewModel(magnitude: decibles, color: .gray))

                    }

                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            } catch {
                print("Audio Error: \(error)")
            }
        }

    }
}
