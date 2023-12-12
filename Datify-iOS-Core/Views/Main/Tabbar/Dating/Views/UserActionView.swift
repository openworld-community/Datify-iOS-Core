//
//  UserActionView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct UserActionsView: View {
    @Binding var liked: Bool

    var viewModel: DatingViewModel
    @Binding var user: DatingModel

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button(action: {
                 withAnimation {
                     liked.toggle()
                     user.liked = liked
                 }
             }, label: {
                 ZStack {
                     Rectangle()
                         .modifier(DtButtonsModifier())
                     Image(user.liked ? DtImage.mainSelectedHeart : DtImage.mainHeart)
                 }
                 .onChange(of: user.liked) { _, newValue in
                     user.liked = newValue
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
