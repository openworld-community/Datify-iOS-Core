//
//  BottomDarkGradientView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct BottomDarkGradientView: View {

    var geometry: GeometryProxy
    @Binding var showDescription: Bool
    let hideHeightPercent: CGFloat = 0.4
    let showHeightPercent: CGFloat = 0.7

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.72)]),
                       startPoint: .top, endPoint: .bottom)
        .frame(width: geometry.size.width, height: showDescription
               ? (geometry.size.height * showHeightPercent)
               : (geometry.size.height * hideHeightPercent)
        )
        .position(
            x: geometry.size.width / 2,
            y: geometry.size.height - (showDescription
                                       ? (geometry.size.height * showHeightPercent) / 2
                                       : (geometry.size.height * hideHeightPercent) / 2)
        )
    }
}
