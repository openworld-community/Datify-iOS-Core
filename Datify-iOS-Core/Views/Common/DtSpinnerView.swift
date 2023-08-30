//
//  DtSpinnerView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 30.08.2023.
//

import SwiftUI

struct DtSpinnerView: View {
    @State var isAnimating = false

    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1)
            .stroke(
                Color.DtGradient.brandLight,
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round
                )
            )
            .frame(width: 56, height: 56)
//            .shadow(radius: 3)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
            .onDisappear {
                isAnimating = false
            }
    }
}

struct DtSpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        DtSpinnerView()
    }
}
