//
//  SmallUserCardView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct SmallUserCardView: View {
    @ObservedObject private var viewModel: UserCardViewModel
    @Binding private var selectedItem: String?
    private var currentUser: UserTempModel
    private var size: CGSize

    init(like: LikeModel, selectedItem: Binding<String?>, currentUser: UserTempModel, size: CGSize) {
        _selectedItem = selectedItem
        self.size = size
        self.currentUser = currentUser
        viewModel = UserCardViewModel(dataServise: UserDataService.shared, likeServise: LikesDataService.shared)
        getUser(by: like)
    }

    var body: some View {
        if let user = viewModel.user {
            HStack {
                if let photo = user.photos.first {
                    Image(photo)
                        .resizableFill()
                        .frame(width: size.width*0.07, height: size.height*0.06)
                        .cornerRadius(3)
                }
            }
            .onTapGesture {
                withAnimation {
                    selectedItem = viewModel.user?.userId
                }
            }
            .padding(.horizontal, addPadding() ? 6 : 0)
        }
    }

    func getUser(by like: LikeModel) {
        viewModel.getUser(userId: isThisMyLike(for: like) ? like.receiverID : like.senderID)
    }

    func isThisMyLike(for like: LikeModel) -> Bool {
        currentUser.userId == like.senderID
    }

    func addPadding() -> Bool {
        selectedItem == viewModel.user?.userId
    }
}

 #Preview {
    SmallUserCardView(like: LikeModel(senderID: "1",
                                      receiverID: "1000",
                                      date: Date()),
                      selectedItem: .constant("1"),
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
                    ),
                      size: CGSize(width: 400, height: 800))
 }
