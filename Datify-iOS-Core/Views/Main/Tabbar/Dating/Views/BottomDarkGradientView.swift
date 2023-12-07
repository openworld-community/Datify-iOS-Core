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
    let hideHeight: CGFloat = 320
    let showHeight: CGFloat = 560

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.72)]),
                       startPoint: .top, endPoint: .bottom)
        .frame(width: geometry.size.width, height: showDescription ? showHeight : hideHeight)
        .animation(.easeInOut(duration: 0.1), value: showDescription)
        .position(x: geometry.size.width / 2, y: geometry.size.height - (showDescription ? showHeight / 2 : hideHeight / 2))
    }
}
