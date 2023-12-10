//
//  GallaryView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 10.12.2023.
//

import SwiftUI

struct GallaryView: View {
    var size: CGSize
    var likes: [[LikeModel]]
    var spacingGalleryCard: CGFloat = 6
    var currentUser: UserModel
    var myLike: [LikeModel]

    var body: some View {
        VStack {
            if likes.isNotEmpty {
                ScrollView(showsIndicators: false) {
                    ForEach(likes.indices, id: \.self) { index in
                        HStack(alignment: index == 0 ? .top  :  .bottom, spacing: spacingGalleryCard) {
                                GalleryItemView(like: likes[index][0],
                                                   currentUser: currentUser,
                                                   isCrop: isCrop(index: index,
                                                                  indexNestedArray: 0,
                                                                  count: likes.count),
                                                   myLikes: myLike,
                                                   size: size,
                                                   spacing: spacingGalleryCard)
                                .offset(y: isCrop(index: index,
                                                  indexNestedArray: 0,
                                                  count: likes.count) ? -size.height * 0.07 : 0)
                                if likes[index].count > 1 {
                                    GalleryItemView(like: likes[index][1],
                                                       currentUser: currentUser,
                                                       isCrop: isCrop(index: index,
                                                                      indexNestedArray: 1,
                                                                      count: likes.count),
                                                       myLikes: myLike,
                                                       size: size,
                                                       spacing: spacingGalleryCard)
                                    .offset(y: isCrop(index: index,
                                                      indexNestedArray: 1,
                                                      count: likes.count) ? 0 : -size.height * 0.07)
                                } else {
                                    Rectangle()
                                        .frame(height: size.height * 0.4)
                                        .foregroundStyle(.clear)
                                    Spacer()
                                }
                        }
                        .frame(width: size.width*0.92)
                    }
                }
            } else {
                NoLikesYetView(width: size.width * 0.92, height: size.height * 0.85)
            }
        }
        .frame(width: size.width)
    }

    private func isCrop(index: Int, indexNestedArray: Int, count: Int) -> Bool {
        if indexNestedArray == 1, index == 0 {
            return true
        }
        if indexNestedArray == 0, index == (count - 1), count != 1 {
            return true
        }
        return false
    }
}

// #Preview {
//    GallaryUserView()
// }
