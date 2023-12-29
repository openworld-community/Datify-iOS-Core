//
//  MediumUserCardView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct GalleryItemView: View {
    @ObservedObject var viewModel: GalleryItemViewModel
    private var isCrop: Bool
    private var size: CGSize
    private var spacing: CGFloat

    init(like: LikeModel,
         currentUser: UserTempModel,
         isCrop: Bool,
         myLikes: [LikeModel],
         size: CGSize,
         spacing: CGFloat) {
        self.isCrop = isCrop
        self.size = size
        self.spacing = spacing
        viewModel = GalleryItemViewModel(dataServise: UserDataService.shared,
                                         likeServise: LikesDataService.shared,
                                         myLikes: myLikes,
                                         like: like,
                                         currentUser: currentUser)
        viewModel.getUser()
    }

    var body: some View {
        VStack {
            if let user = viewModel.user {
                ZStack {
                    if let photo = user.photos.first {
                        userPhoto(photo: photo)
                    }
                    VStack {
                        userLabalAndLikeIcon(user: user)
                        Spacer()
                        userDate(user: user)
                    }
                }
                .frame(width: size.width*0.92 / 2 - spacing / 2,
                       height: isCrop ? size.height * 0.4 - size.height * 0.07 : size.height * 0.4)
                .onAppear {
                    viewModel.likeIsViewed(likeId: viewModel.like.id)
                }
            } else {
                NoLikesYetView(width: size.width * 0.92, height: size.height * 0.85)
            }
        }
    }
}

private extension GalleryItemView {
    @ViewBuilder
    func userPhoto(photo: String) -> some View {
        Image(photo)
            .resizableFill()
            .frame(width: size.width*0.92 / 2 - spacing / 2,
                   height: isCrop ? size.height * 0.4 - size.height * 0.07 : size.height * 0.4)
            .blur(radius: 10)
            .cornerRadius(20)
        Image(photo)
            .resizableFill()
            .frame(width: size.width*0.92 / 2 - spacing / 2,
                   height: isCrop ? size.height * 0.4 - size.height * 0.07 : size.height * 0.4)
            .mask(Rectangle().offset(y: -size.height * 0.07))
            .cornerRadius(20)
    }

    @ViewBuilder
    func userLabalAndLikeIcon(user: UserTempModel) -> some View {
        HStack {
                HStack {
                    Text("\(user.label)")
                        .dtTypo(.p3Regular, color: .textInverted)
                        .padding()
                }
                .background(user.colorLabel)
                .frame(height: 24)
                .cornerRadius(12)
                .padding(.leading, 4)
            Spacer()
            Button(action: {
                if viewModel.isLiked().bool {
                    viewModel.deleteLike(likeId: viewModel.isLiked().myLike?.id)
                } else {
                    viewModel.createNewLike(senderID: viewModel.currentUser.userId)
                }
            }, label: {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(viewModel.isLiked().bool ? .ultraThickMaterial : .ultraThinMaterial)
                    Image(DtImage.heart)
                        .renderingMode(.template)
                        .foregroundColor(viewModel.isLiked().bool ? .red : .white)
                        .frame(width: 16, height: 16)
                }
            })
        }
        .padding(.top, 5)
        .padding(.horizontal, 5)
    }

    @ViewBuilder
    func userDate(user: UserTempModel) -> some View {
        HStack {
            Text("\(user.name), " + "\(user.age) ")
                .dtTypo(.p1Medium, color: .textInverted)
                .padding(.leading)
            Circle()
                .frame(width: 6, height: 6)
                .foregroundStyle(user.online ? .green : .gray )
            Spacer()
        }
        .frame(height: size.height * 0.07)
    }
}

 #Preview {
     GalleryItemView(like: LikeModel(senderID: "1", receiverID: "2", date: Date()),
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
                        isCrop: false,
                        myLikes: [LikeModel(senderID: "1000", receiverID: "1", date: Date()),
                                  LikeModel(senderID: "1000", receiverID: "2", date: Date()),
                                  LikeModel(senderID: "1000", receiverID: "3", date: Date()),
                                  LikeModel(senderID: "1000", receiverID: "4", date: Date())],
                        size: CGSize(width: 400, height: 800),
                        spacing: 6)
 }
