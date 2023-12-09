//
//  SmallUserCardView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct SmallUserCardView: View {
    @ObservedObject private var vm: SmallUserViewModel
    @Binding private var selected: String?
    private var currentUser: UserModel
    private var size: CGSize

    init(like: LikeModel, selectedItem: Binding<String?>, currentUser: UserModel, size: CGSize) {
        _selected = selectedItem
        self.size = size
        self.currentUser = currentUser
        vm = SmallUserViewModel(dataServise: UserDataService.shared, likeServise: LikesDataService.shared)
        getUser(by: like)
    }

    var body: some View {
        HStack {
            Image(vm.user?.photos.first ?? "AvatarPhoto3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width*0.07, height: size.height*0.06)
                .cornerRadius(3)
        }
        .onTapGesture {
            withAnimation {
                selected = vm.user?.userId
            }
        }
        .padding(.horizontal, addPadding() ? 6 : 0)
    }

    func getUser(by like: LikeModel) {
        vm.getUser(userId: isThisMyLike(for: like) ? like.receiverID : like.senderID)
    }

    func isThisMyLike(for like: LikeModel) -> Bool {
        currentUser.userId == like.senderID
    }

    func addPadding() -> Bool {
        selected == vm.user?.userId
    }
}

 #Preview {
    SmallUserCardView(like: LikeModel(senderID: "1", receiverID: "1000", date: Date()),
                      selectedItem: .constant("1"),
                      currentUser: UserModel(
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
                        audiofile: "audio.mp3"
                    ),
                      size: CGSize(width: 400, height: 800))
 }