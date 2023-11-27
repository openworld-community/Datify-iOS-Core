//
//  LikeCircleView.swift
//  Datify-iOS-Core
//
//  Created by Илья on 22.11.2023.
//

import SwiftUI

struct LikeCircleView: View {
    let user: TempUserModel?
    let isNew: Bool

    var body: some View {
        if let user {
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.textTertiary, lineWidth: 1)
                        .frame(width: 78)
                    Circle()
                        .stroke(Color.DtGradient.brandLight, lineWidth: 2)
                        .frame(width: 78)
                        .opacity(isNew ? 1 : 0)
                    Image(user.photoURL)
                        .resizableFill()
                        .clipShape(.circle)
                    .frame(width: 72, height: 72)
                }
                .frame(width: 80, height: 80, alignment: .center)
                Text(user.name)
                    .dtTypo(.p4Regular, color: .textPrimary)
            }
        }
    }
}

#Preview {
    LikeCircleView(user: TempUserModel(id: "1",
                                       name: "Alexandra",
                                       age: 21,
                                       isOnline: true,
                                       photoURL: "AvatarPhoto"), isNew: false)
}
