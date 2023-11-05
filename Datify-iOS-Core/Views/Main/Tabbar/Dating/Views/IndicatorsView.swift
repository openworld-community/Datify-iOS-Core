//
//  IndicatorView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct IndicatorsView: View {
    @Binding var isSwipeAndIndicatorsDisabled: Bool

    var photos: [String]
    var selectedPhotoIndex: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(photos.indices, id: \.self) { index in
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(selectedPhotoIndex == index ? .white : .gray)
                    .opacity(isSwipeAndIndicatorsDisabled ? 0 : 1)
            }
        }
    }
}
