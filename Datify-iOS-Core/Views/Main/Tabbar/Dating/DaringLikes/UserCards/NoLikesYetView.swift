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
        VStack(spacing: 7) {
            Text("No likes yet")
                .dtTypo(.p2Medium, color: .textPrimary)
            Text("Like and study the profiles of other people, so they can pay attention to your activity and show reciprocity")
                .dtTypo(.p3Medium, color: .textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(width: width, height: height)
        .background(Color.backgroundSecondary)
        .cornerRadius(10)
    }

}

#Preview {
    NoLikesYetView(width: 350, height: 750)
}
