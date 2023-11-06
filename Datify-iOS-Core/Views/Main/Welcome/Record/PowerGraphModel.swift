//
//  PowerGraphModel.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.11.2023.
//

import Foundation

struct PowerGraphModel {
    var statePlayer: StatePlayerEnum
    var arrayHeights: [BarModel]
    var fileExistsBool: Bool
    var filePath: URL?
    var widthPowerElement: Int
    var heightPowerGraph: Int
    var wightPowerGraph: Int
    var distanceBetweenElements: Int
    var deleteAnimationDuration: Double
    var audioRecordingDuration: Double

    init(widthElement: Int, heightGraph: Int, wightGraph: Int, distanceElements: Int, deleteDuration: Double, recordingDuration: Double) {
        self.widthPowerElement = widthElement
        self.heightPowerGraph = heightGraph
        self.wightPowerGraph = wightGraph
        self.distanceBetweenElements = distanceElements
        self.deleteAnimationDuration = deleteDuration
        self.audioRecordingDuration = recordingDuration
        self.statePlayer = .inaction
        self.fileExistsBool = true
        self.filePath = nil
        self.arrayHeights = []
        fillTheArrayHeight()
    }

    mutating func fillTheArrayHeight() {
        for _ in 0...(wightPowerGraph / (widthPowerElement + distanceBetweenElements)) {
            arrayHeights.append(BarModel(height: Float(widthPowerElement), coloredBool: true, isASignal: false))
        }
    }

    mutating func turnOffColor() {
        for index in arrayHeights.indices {
            arrayHeights[index].coloredBool = true
        }
    }
}
