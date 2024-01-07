//
//  DtProgressBarView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 06.01.2024.
//

import SwiftUI

struct DtProgressBarView: View {
    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<count) { index in
                RoundedRectangle(cornerRadius: 2)
                    .frame(height: 4)
                    .foregroundStyle(index == currentIndex ? .white : .white.opacity(0.3))
            }
        }
    }
}

#Preview {
    ZStack {
        Color.gray
            .ignoresSafeArea()

        DtProgressBarView(
            count: 9,
            currentIndex: 5
        )
    }
}
