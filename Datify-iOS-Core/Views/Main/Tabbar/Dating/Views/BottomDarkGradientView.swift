//
//  BottomDarkGradientView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct BottomDarkGradientView: View {
    var geometry: GeometryProxy

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                       startPoint: .top, endPoint: .bottom)
        .frame(width: geometry.size.width, height: 320)
        .position(x: geometry.size.width / 2, y: geometry.size.height - 150)
    }
}
