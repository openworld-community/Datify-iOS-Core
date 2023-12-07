//
//  MediumUserCardView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct MediumUserCardView: View {
    @ObservedObject var vm: UserCardViewModel
    private var isCrop: Bool
    private var size: CGSize
    private var spacing: CGFloat

    init(like: LikeModel, currentUser: UserModel, isCrop: Bool, myLikes: [LikeModel], size: CGSize, spacing: CGFloat) {
        self.isCrop = isCrop
        self.size = size
        self.spacing = spacing
        vm = UserCardViewModel(dataServise: UserDataService.shared,
                               likeServise: LikesDataService.shared,
                               myLikes: myLikes,
                               like: like,
                               currentUser: currentUser)
        vm.getUser()
    }

    var body: some View {
        VStack {
            if let user = vm.user {
                ZStack {
                    Image(user.photos.first ?? "AvatarPhoto3")
                        .resizableFill()
                        .frame(width: size.width*0.92 / 2 - spacing / 2,
                               height: isCrop ? size.height * 0.4 - size.height * 0.07 : size.height * 0.4)
                        .blur(radius: 10)
                        .cornerRadius(20)
                    Image(user.photos.first ?? "AvatarPhoto3")
                        .resizableFill()
                        .frame(width: size.width*0.92 / 2 - spacing / 2,
                               height: isCrop ? size.height * 0.4 - size.height * 0.07 : size.height * 0.4)
                        .mask(Rectangle().offset(y: -size.height * 0.07))
                        .cornerRadius(20)
                    VStack {
                        HStack {
                            HStack {
                                Text("\(user.label)")
                                    .padding()
                            }
                            .background(user.colorLabel)
                            .frame(height: 24)
                            .cornerRadius(12)
                            .padding(.leading, 4)
                            Spacer()
                            Button(action: {
                                if vm.isLiked().bool {
                                    vm.deleteLike(likeId: vm.isLiked().myLike?.id)
                                } else {
                                    vm.createNewLike(senderID: vm.currentUser.userId)
                                }
                            }, label: {
                                ZStack {
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundStyle(vm.isLiked().bool ? .ultraThickMaterial : .ultraThinMaterial)
                                    Image(vm.isLiked().bool ? "heartRed" : "heartWhite")
                                        .frame(width: 16, height: 16)
                                }
                            })
                        }
                        .padding(.top, 5)
                        .padding(.horizontal, 5)
                        Spacer()
                        HStack {
                            Text("\(user.name), " + "\(user.age) ")
                                .dtTypo(.p2Medium, color: .textInverted)
                                .padding(.leading)
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundStyle(.green)
                            Spacer()

                        }
                        .frame(height: size.height * 0.07)
                    }
                    .frame(width: size.width*0.92 / 2 - spacing / 2,
                           height: isCrop ? size.height * 0.4 - size.height * 0.07 : size.height * 0.4)
                }
                .onAppear {
                    vm.likeIsViewed(likeId: vm.like.id)
                }
            } else {
                NoLikesYetView(width: size.width * 0.92, height: size.height * 0.85)
            }
        }
    }
}

 #Preview {
     MediumUserCardView(like: LikeModel(senderID: "1", receiverID: "2", date: Date()),
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
                        isCrop: false,
                        myLikes: [LikeModel(senderID: "1000", receiverID: "1", date: Date()),
                                  LikeModel(senderID: "1000", receiverID: "2", date: Date()),
                                  LikeModel(senderID: "1000", receiverID: "3", date: Date()),
                                  LikeModel(senderID: "1000", receiverID: "4", date: Date())],
                        size: CGSize(width: 400, height: 800),
                        spacing: 6)
 }
