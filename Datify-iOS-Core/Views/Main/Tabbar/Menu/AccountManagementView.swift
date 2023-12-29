//
//  AccountManagementView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 29.12.2023.
//

import SwiftUI

struct AccountManagementView: View {
    var currentUser: MenuTempUserModel

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                DtMenuLongButton(icon: "phoneMenu", titleOne: "Phone", titleTwo: String(currentUser.phoneNumber ?? 1), height: 70) {

                }
                Divider()
                DtMenuLongButton(icon: "googleMenu", titleOne: "Google", titleTwo: currentUser.googleGccount, height: 70) {

                }
                Divider()
                DtMenuLongButton(icon: "aplleMenu", titleOne: "Aplle", titleTwo: currentUser.appleAccount,                                height: 70) {

                }
            }
            .cornerRadius(16)
            Spacer()
            DtButton(title: "I don't remember my password", style: .picker, action: {})
            DtButton(title: "log out", style: .picker, action: {})
            DtButton(title: "delete account", style: .delete, action: {})
        }
        .padding(.horizontal)
    }
}

#Preview {
    AccountManagementView(currentUser: MenuTempUserModel(photo: "AvatarPhoto",
                                                         name: "Alexandra",
                                                         age: 29,
                                                         phoneNumber: 95146767787,
                                                         googleGccount: "Alexandra94@gmail.com",
                                                         appleAccount: "Alexandra94@icloud.com"))
}
