//
//  PhotoSliderView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct PhotoSliderView: View {
    @Binding var selectedPhotoIndex: Int
    @Binding var showDescription: Bool
    @Binding var isSwipeAndIndicatorsDisabled: Bool

    let photos: [String]

    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $selectedPhotoIndex) {
                ForEach(photos.indices, id: \.self) { index in
                    Image(photos[index])
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: geometry.size.width)
                        .blur(radius: showDescription ? 2 : 0)
                        .animation(.easeInOut(duration: 0.4))
                        .edgesIgnoringSafeArea(.all)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .disabled(isSwipeAndIndicatorsDisabled)
            .edgesIgnoringSafeArea(.all)
        }
    }
}