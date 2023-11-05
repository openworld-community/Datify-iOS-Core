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
    @ObservedObject var viewModel: DatingViewModel

    var dataPoints: [BarChartDataPoint]
    var barWidth: CGFloat

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
                            (gradientFraction < viewModel.playbackProgress || (gradientFraction == 0 && viewModel.playbackProgress > 0)) ? interpolatedColor(for: gradientFraction) : Color.gray

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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0

        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 6: a = 255; r = int >> 16; g = int >> 8 & 0xFF; b = int & 0xFF
            case 8: a = int >> 24; r = int >> 16 & 0xFF; g = int >> 8 & 0xFF; b = int & 0xFF
            default: (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    var redComponent: Double {
        if let components = UIColor(self).cgColor.components, components.count >= 3 {
            return Double(components[0])
        }
        return 0.0
    }

    var greenComponent: Double {
        if let components = UIColor(self).cgColor.components, components.count >= 3 {
            return Double(components[1])
        }
        return 0.0
    }

    var blueComponent: Double {
        if let components = UIColor(self).cgColor.components, components.count >= 3 {
            return Double(components[2])
        }
        return 0.0
    }
}
