//
//  NoLikesYetView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 07.12.2023.
//

import SwiftUI

struct NoLikesYetView: View {
    private var width: CGFloat
    private var height: CGFloat

    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    VStack(spacing: 7) {
                        Text("No likes yet")
                            .dtTypo(.p2Medium, color: .textPrimary)
                        Text("Like and study the profiles of other people, so they can pay attention to your activity and show reciprocity")
                            .dtTypo(.p3Medium, color: .textTertiary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(width: width, height: colculetHeight(overallHeight: geometry.size.height) ? height*0.95 : height)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(10)
                }
                Spacer()
                DtButton(title: "Continue".localize(), style: .main) { }
                    .frame(width: width)
                    .padding(.bottom)
            }
        }
        .frame(width: width)
    }

    func colculetHeight(overallHeight: CGFloat) -> Bool {
        var result: Bool = false
        if (overallHeight - 54) < height {
            result = true
        }
        return result
    }
}

#Preview {
    NoLikesYetView(width: 350, height: 750)
}
