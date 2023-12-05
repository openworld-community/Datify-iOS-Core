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

    init(like: LikeModel, currentUser: UserModel) {
        self.currentUser = currentUser
        vm = SmallUserCardViewModel()
        getUser(by: like)
    }

    var body: some View {
        HStack {
            Image(vm.user?.photos.first ?? "AvatarPhoto3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 176, height: 288)
                .cornerRadius(20)
        }
    }

    func getUser(by like: LikeModel) {
        vm.getUser(userId: isThisMyLike(for: like) ? like.receiverID : like.senderID)
    }

    func isThisMyLike(for like: LikeModel) -> Bool {
        currentUser.userId == like.senderID
    }
}

//        @ObservedObject private var viewModel: LikesViewModel
//        private var sender: UserModel?
//
//    init(like: LikeModel, viewModel: LikesViewModel) {
//            _viewModel = ObservedObject(wrappedValue: viewModel)
////            self.sender = viewModel.fetchUserData(userId: isThisMyLike(for: like) ? like.receiverID : like.senderID)
//        }
//
//        var body: some View {
//            HStack {
//                Image(sender?.photos.first ?? "user5")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 176, height: 288)
//                    .cornerRadius(20)
//            }
//        }
//
//        func isThisMyLike(for like: LikeModel) -> Bool {
//            viewModel.currentUser?.userId == like.senderID
//        }
//    }

// #Preview {
//    MainUserCardView(like: LikeModel(senderID: "1", receiverID: "1000", date: Date()), viewModel: LikesViewModel(router: Router()))
// }
