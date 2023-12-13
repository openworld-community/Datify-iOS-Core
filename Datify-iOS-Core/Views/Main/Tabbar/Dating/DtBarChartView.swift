//
//  DtAudioPreviewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 16.10.2023.
//

import SwiftUI
import Combine

struct BarChartDataPoint: Identifiable {
    let id = UUID()
    var value: Double
}

struct DtBarChartView: View {
    @ObservedObject var viewModel: DtAudioPlayerViewModel

    var dataPoints: [BarChartDataPoint] = .init()
    var barWidth: CGFloat = .init()

    var gradientColors: [(Double, Color)] {
        return [
            (0, Color(hex: "6167FF")),
            (0.25, Color(hex: "9E59FF")),
            (0.5, Color(hex: "DD60D8")),
            (1.0, Color(hex: "FF80AC"))
        ]
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(dataPoints.indices, id: \.self) { index in
                let gradientFraction = Double(index) / Double(dataPoints.count - 1)
                let color = viewModel.playbackFinished ? Color.gray :
                (gradientFraction < viewModel.playbackProgress || (gradientFraction == 0 && viewModel.playbackProgress > 0))
                ? interpolatedColor(for: gradientFraction)
                : Color(red: 235/255, green: 235/255, blue: 245/255, opacity: 0.3)

                Rectangle()
                    .fill(color)
                    .frame(width: barWidth, height: min(20, CGFloat(dataPoints[index].value)))
                    .cornerRadius(3)
            }
        }
        .padding(.horizontal, 0)
        .frame(maxWidth: .infinity)
    }

    func interpolatedColor(for fraction: Double) -> Color {
        for index in 0..<gradientColors.count - 1 {
            if fraction >= gradientColors[index].0 && fraction <= gradientColors[index + 1].0 {
                let startColor = gradientColors[index].1
                let endColor = gradientColors[index + 1].1
                let t = (fraction - gradientColors[index].0) / (gradientColors[index + 1].0 - gradientColors[index].0)

                return Color(
                    red: lerp(startColor.redComponent, endColor.redComponent, t),
                    green: lerp(startColor.greenComponent, endColor.greenComponent, t),
                    blue: lerp(startColor.blueComponent, endColor.blueComponent, t)
                )
            }
        }
        return Color.white
    }

    func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double {
        return a + (b - a) * t
    }
}
