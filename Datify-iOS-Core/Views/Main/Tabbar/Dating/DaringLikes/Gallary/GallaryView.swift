//
//  GallaryView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 10.12.2023.
//

import SwiftUI

struct GallaryView: View {
    private var size: CGSize
    private var likes: [[LikeModel]]
    private var spacingGalleryCard: CGFloat = 6
    private var currentUser: UserTempModel
    private var myLike: [LikeModel]

    init(size: CGSize,
         likes: [[LikeModel]],
         currentUser: UserTempModel,
         myLike: [LikeModel]) {
        self.size = size
        self.likes = likes
        self.currentUser = currentUser
        self.myLike = myLike
    }

    var body: some View {
        VStack {
            if likes.isNotEmpty {
                ScrollView(showsIndicators: false) {
                    ForEach(likes.indices, id: \.self) { index in
                        HStack(alignment: index == 0 ? .top  :  .bottom, spacing: spacingGalleryCard) {
                                GalleryItemView(like: likes[index][0],
                                                   currentUser: currentUser,
                                                   isCrop: isCrop(indexArray: index,
                                                                  indexNestedArray: 0,
                                                                  count: likes.count),
                                                   myLikes: myLike,
                                                   size: size,
                                                   spacing: spacingGalleryCard)
                                .offset(y: isCrop(indexArray: index,
                                                  indexNestedArray: 0,
                                                  count: likes.count) ? -size.height * 0.07 : 0)
                                if likes[index].count > 1 {
                                    GalleryItemView(like: likes[index][1],
                                                       currentUser: currentUser,
                                                       isCrop: isCrop(indexArray: index,
                                                                      indexNestedArray: 1,
                                                                      count: likes.count),
                                                       myLikes: myLike,
                                                       size: size,
                                                       spacing: spacingGalleryCard)
                                    .offset(y: isCrop(indexArray: index,
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
                NoLikesYetView(width: size.width * 0.92, height: size.height * 0.86)
            }
        }
        .frame(width: size.width)
    }

    private func isCrop(indexArray: Int, indexNestedArray: Int, count: Int) -> Bool {
        var result: Bool = false
        if indexNestedArray == 1, indexArray == 0 {
            result = true
        }
        if indexNestedArray == 0, indexArray == (count - 1), count != 1 {
            result = true
        }
        return result
    }
}

 #Preview {
     GallaryView(size: CGSize(width: 400, height: 800),
                 likes: [[LikeModel(senderID: "1", receiverID: "1000", date: Date()),
                          LikeModel(senderID: "2", receiverID: "1000", date: Date())],
                         [LikeModel(senderID: "3", receiverID: "1000", date: Date()),
                          LikeModel(senderID: "4", receiverID: "1000", date: Date())],
                         [LikeModel(senderID: "5", receiverID: "1000", date: Date()),
                          LikeModel(senderID: "6", receiverID: "1000", date: Date())]],
                currentUser: UserTempModel(
                    userId: "1000",
                    photos: ["user1", "user1", "user1"],
                    label: "Label1",
                    colorLabel: .red,
                    location: "New York",
                    name: "Michael",
                    age: 25,
                    star: true,
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                    liked: true,
                    bookmarked: false,
                    audiofile: "audio.mp3",
                    online: true
                ), myLike: [LikeModel(senderID: "1000", receiverID: "1", date: Date()),
                            LikeModel(senderID: "1000", receiverID: "2", date: Date()),
                            LikeModel(senderID: "1000", receiverID: "3", date: Date())])
 }
