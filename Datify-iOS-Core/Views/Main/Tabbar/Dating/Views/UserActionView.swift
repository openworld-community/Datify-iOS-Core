//
//  UserActionView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct UserActionsView: View {
    @Binding var liked: Bool
    @Binding var bookmarked: Bool
    @Binding var showLikedAnimation: Bool
    @Binding var showBookmarkedAnimation: Bool

    var viewModel: DatingViewModel
    var index: Int

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button(action: {
                 withAnimation {
                     liked.toggle()
                     showLikedAnimation = liked
                     viewModel.users[index].liked = liked
                 }
             }, label: {
                 ZStack {
                     Rectangle()
                         .modifier(DtButtonsModifier())
                     Image(viewModel.users[index].liked ? DtImage.mainSelectedHeart : DtImage.mainHeart)
                 }
             })

             Button(action: {
                 withAnimation {
                     bookmarked.toggle()
                     showBookmarkedAnimation = bookmarked
                     viewModel.users[index].bookmarked = bookmarked
                 }
             }, label: {
                 ZStack {
                     Rectangle()
                         .modifier(DtButtonsModifier())
                     Image(viewModel.users[index].bookmarked ? DtImage.mainSelectedBookmark : DtImage.mainBookmark)
                 }
             })

            Button(action: {
                // TODO: Implement button action
            }, label: {
                ZStack {
                    Rectangle()
                        .modifier(DtButtonsModifier())
                    Image(DtImage.mainProfile)
                }
            })
        }
    }
}
