//
//  AnimatedIconView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct AnimatedIconView: View {
    @Binding var show: Bool

    var icon: Image

    var body: some View {
        icon
            .resizableFit()
            .frame(width: 80, height: 80)
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .transition(.scale.combined(with: .opacity))
            .onAppear {
                withAnimation(.snappy(duration: 0.5)) {
                    show = true
                }
            }
    }
}
