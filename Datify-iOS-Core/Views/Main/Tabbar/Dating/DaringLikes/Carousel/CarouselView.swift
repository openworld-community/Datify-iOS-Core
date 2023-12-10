//
//  CarouselView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 10.12.2023.
//

import SwiftUI

struct CarouselView: View {
    var size: CGSize
    var currentUser: UserModel
    var likes: [LikeModel]
    @Binding var selectedItem: String?
    @Binding var showInformationView: Bool
    @Binding var blurRadius: CGFloat

    var body: some View {
        VStack {
            if selectedItem != nil {
                VStack {
                    BigUserCardView(selectedItem: $selectedItem,
                                    size: size,
                                    showInformationView: $showInformationView,
                                    blurRadius: $blurRadius)
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 2) {
                            HStack {Text("")}
                                .frame(width: size.width / 2 - (size.width*0.07) / 2)
                            ForEach(likes) { like in
                                SmallUserCardView(like: like,
                                                  selectedItem: $selectedItem,
                                                  currentUser: currentUser,
                                                  size: size)
                            }
                            HStack {Text("")}
                                .frame(width: size.width / 2 - (size.width*0.07) / 2)
                        }
                    }
//                    .padding(.bottom)
                }
            } else {
                NoLikesYetView(width: size.width * 0.92, height: size.height * 0.85)
            }

        }
        .frame(width: size.width)
    }
}

// #Preview {
//    CarouselUserView()
// }
