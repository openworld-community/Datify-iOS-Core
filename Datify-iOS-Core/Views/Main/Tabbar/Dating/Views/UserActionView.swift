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
    var index: Int  = .init()

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button(action: {
                 withAnimation {
                     liked.toggle()
                     viewModel.users[index].liked = liked
                 }
             }, label: {
                 ZStack {
                     Rectangle()
                         .modifier(DtButtonsModifier())
                     Image(viewModel.users[index].liked ? DtImage.mainSelectedHeart : DtImage.mainHeart)
                 }
                 .onChange(of: viewModel.users[index].liked) { _, newValue in
                     viewModel.users[index].liked = newValue
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
