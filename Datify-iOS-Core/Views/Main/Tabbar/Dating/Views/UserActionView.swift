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

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button(action: {
                 withAnimation {
                     liked.toggle()
                     showLikedAnimation = liked
                 }
             }, label: {
                 ZStack {
                     Rectangle()
                         .frame(width: 48, height: 48)
                         .foregroundColor(Color.iconsSecondary)
                         .opacity(0.64)
                         .clipShape(RoundedRectangle(cornerRadius: 16))
                     Image(liked ? DtImage.mainSelectedHeart : DtImage.mainHeart)
                 }
             })
             Button(action: {
                 withAnimation {
                     bookmarked.toggle()
                     showBookmarkedAnimation = bookmarked
                 }
             }, label: {
                 ZStack {
                     Rectangle()
                         .frame(width: 48, height: 48)
                         .foregroundColor(Color.iconsSecondary)
                         .opacity(0.64)
                         .clipShape(RoundedRectangle(cornerRadius: 16))
                     Image(bookmarked ? DtImage.mainSelectedBookmark : DtImage.mainBookmark)
                 }
             })

            Button(action: {
                // TODO: Implement button action
            }, label: {
                ZStack {
                    Rectangle()
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color.iconsSecondary)
                        .opacity(0.64)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Image(DtImage.mainProfile)

                }
            })
        }
    }
}
