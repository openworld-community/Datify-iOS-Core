//
//  SmallUserCardView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct SmallUserCardView: View {
    @ObservedObject var vm: UserCardViewModel
    @Binding var selected: String?
    private var currentUser: UserModel
    var size: CGSize

    init(like: LikeModel, selectedItem: Binding<String?>, currentUser: UserModel, size: CGSize) {
        _selected = selectedItem
        self.size = size
        self.currentUser = currentUser
        vm = UserCardViewModel(dataServise: UserDataService.shared, likeServise: LikesDataService.shared)
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

// #Preview {
//    SmallUserCardView(like:
//                        LikeModel(senderID: "1",
//                                  receiverID: "1000",
//                                  date: Date()
//                                 ),
//                      viewModel: LikesViewModel(router: Router()))
// }
