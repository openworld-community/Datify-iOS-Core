//
//  PhotoSliderView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct PhotoSliderView: View {
    @Binding var selectedPhotoIndex: Int
    @Binding var currentUserIndex: DatingModel.ID?
    @Binding var showDescription: Bool
    @Binding var isSwipeAndIndicatorsDisabled: Bool
    var geometry: GeometryProxy

    @Binding var photos: [String]

    var body: some View {
        ZStack {
            TabView(selection: $selectedPhotoIndex) {
                ForEach(photos.indices, id: \.self) { index in
                    Image(photos[index])
                        .resizableFill()
                        .frame(maxWidth: geometry.size.width)
                        .blur(radius: showDescription ? 3 : 0)
                        .animation(.easeInOut(duration: 0.4))
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .disabled(isSwipeAndIndicatorsDisabled)

            BottomDarkGradientView(geometry: geometry, showDescription: $showDescription)
                .allowsHitTesting(false)
        }
        .overlay(
            IndicatorsView(
                isSwipeAndIndicatorsDisabled: $isSwipeAndIndicatorsDisabled,
                photos: photos,
                selectedPhotoIndex: selectedPhotoIndex
            )
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height * 0.76
            ), alignment: .center
        )
        .onChange(of: currentUserIndex) { _ in
            selectedPhotoIndex = 0
        }
    }
}
