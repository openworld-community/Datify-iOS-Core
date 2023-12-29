//
//  CarouselView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 10.12.2023.
//

import SwiftUI

struct CarouselView: View {
    @Binding private var selectedItem: String?
    @Binding private var showInformationView: Bool
    @Binding private var blurRadius: CGFloat
    private var size: CGSize
    private var currentUser: UserTempModel
    private var likes: [LikeModel]

    init(selectedItem: Binding<String?>,
         showInformationView: Binding<Bool>,
         blurRadius: Binding<CGFloat>,
         size: CGSize,
         currentUser: UserTempModel,
         likes: [LikeModel]) {
        _selectedItem = selectedItem
        _showInformationView = showInformationView
        _blurRadius = blurRadius
        self.size = size
        self.currentUser = currentUser
        self.likes = likes
    }

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
                            getPadding()
                            ForEach(likes) { like in
                                SmallUserCardView(like: like,
                                                  selectedItem: $selectedItem,
                                                  currentUser: currentUser,
                                                  size: size)
                            }
                            getPadding()
                        }
                    }
                }
            } else {
                NoLikesYetView(width: size.width * 0.92, height: size.height * 0.96)
            }
        }
        .frame(width: size.width)
    }

    @ViewBuilder
    func getPadding() -> some View {
        Rectangle()
            .frame(width: size.width / 2 - (size.width*0.07) / 2)
            .foregroundColor(.clear)
    }
}

 #Preview {
     CarouselView(selectedItem: .constant("1"),
                  showInformationView: .constant(false),
                  blurRadius: .constant(0), size: CGSize(width: 400, height: 800),
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
    ), likes: [LikeModel(senderID: "1", receiverID: "1000", date: Date()),
               LikeModel(senderID: "2", receiverID: "1000", date: Date()),
               LikeModel(senderID: "3", receiverID: "1000", date: Date())])
 }
