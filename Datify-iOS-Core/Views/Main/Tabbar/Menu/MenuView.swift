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
            if let user = viewModel.currentUser {
                Image(user.photo)
                    .resizableFill()
                    .frame(width: 120, height: 120)
                    .cornerRadius(60)
                    .padding(.top, 20)
                HStack {
                    Text("\(user.name),")
                    Text("\(user.age)")
                }
                .dtTypo(.h3Regular, color: .customBlack)
            }
            HStack(spacing: 6) {
                DtMenuShortButton(icon: "menuHeart", title: "likes") {

                }
                DtMenuShortButton(icon: "menuNotification", title: "notifications") {

                }
                DtMenuShortButton(icon: "menuProfile", title: "profile") {

                }
            }
            .dtTypo(.p3Medium, color: .customBlack)
            VStack(spacing: 0) {
                DtMenuLongButton(icon: "accountManagement", titleOne: "Account management", height: 50) {

                }
                Divider()
                DtMenuLongButton(icon: "feedback", titleOne: "Feedback", height: 50) {

                }
                Divider()
                DtMenuLongButton(icon: "faq", titleOne: "FAQ", height: 50) {

                }
            }
            .cornerRadius(16)
            .padding(.top, 8)
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    MenuView(router: Router())
}
