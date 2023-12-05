//
//  MediumUserCardView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct MediumUserCardView: View {
    @ObservedObject var vm: SmallUserCardViewModel
    private var currentUser: UserModel
    private var isCrop: Bool
    private var myLikes: [LikeModel]

    init(like: LikeModel, currentUser: UserModel, isCrop: Bool, myLikes: [LikeModel]) {
        self.myLikes = myLikes
        self.isCrop = isCrop
        self.currentUser = currentUser
        vm = SmallUserCardViewModel()
        getUser(by: like)
    }

    var body: some View {
        VStack {
            ZStack {
                    Image(vm.user?.photos.first ?? "AvatarPhoto3")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 176, height: isCrop ? 288 - 50 : 288)
                        .blur(radius: 10)
                        .cornerRadius(20)

                    Image(vm.user?.photos.first ?? "AvatarPhoto3")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 176, height: isCrop ? 288 - 50 : 288 )
                        .mask(Rectangle().offset(y: -50))
                        .cornerRadius(20)
                VStack {
                    if let user = vm.user {
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

                            }, label: {
                                ZStack {
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundStyle(isLiked() ? .ultraThickMaterial : .ultraThinMaterial)
                                    Image(isLiked() ? "heartRed" : "heartWhite")
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
                        .frame(height: 50)
                    }
                }
                .frame(width: 176, height: isCrop ? 288 - 50 : 288)
            }
        }
    }

    func getUser(by like: LikeModel) {
        vm.getUser(userId: isThisMyLike(for: like) ? like.receiverID : like.senderID)
    }

    func isThisMyLike(for like: LikeModel) -> Bool {
        currentUser.userId == like.senderID
    }

    func isLiked() -> Bool {
    var result: Bool = false
        for myLike in myLikes {
            if myLike.receiverID == vm.user?.userId {
               result = true
            }
        }
        return result
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
                        isCrop: false, myLikes: [LikeModel(senderID: "1000", receiverID: "1", date: Date()),
                                                 LikeModel(senderID: "1000", receiverID: "2", date: Date()),
                                                 LikeModel(senderID: "1000", receiverID: "3", date: Date()),
                                                 LikeModel(senderID: "1000", receiverID: "4", date: Date())])
 }
