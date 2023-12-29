//
//  MenuView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: MenuViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: MenuViewModel(router: router))
    }

    var body: some View {
        VStack {
            Spacer()
            if let user = viewModel.currentUser {
                Image(user.photo)
                    .resizableFill()
                    .frame(width: 120, height: 120)
                    .cornerRadius(60)
                HStack {
                    Text("\(user.name),")
                    Text("\(user.age)")
                }
                .dtTypo(.h3Regular, color: .customBlack)
            }
            HStack {
                Spacer()
                VStack {
                    Image("menuHeart")
                    Text("likes")
                }
                .frame(width: 120, height: 60)
                .background(Color.backgroundSecondary)
                .cornerRadius(16)

                VStack {
                    Image("menuNotification")
                    Text("notifications")
                }
                .frame(width: 120, height: 60)
                .background(Color.backgroundSecondary)
                .cornerRadius(16)
                VStack {
                    Image("menuProfile")
                    Text("profile")
                }
                .frame(width: 120, height: 60)
                .background(Color.backgroundSecondary)
                .cornerRadius(16)
                Spacer()
            }
            .dtTypo(.p3Medium, color: .customBlack)
            Spacer()
        }
    }
}

#Preview {
    MenuView(router: Router())
}
