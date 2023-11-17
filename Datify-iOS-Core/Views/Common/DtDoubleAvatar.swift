//
//  DtDoubleAvatar.swift
//  Datify-iOS-Core
//
//  Created by Илья on 05.11.2023.
//

import SwiftUI

struct DtDoubleAvatar: View {
    let user1: TempUserModel?
    let user2: TempUserModel?

    var body: some View {
        if let user1 = user1 {
            ZStack {
                if let user2 = user2 {
                    Image(user1.photoURL)
                        .resizableFill()
                        .clipShape(Circle())
                        .frame(width: 44, height: 44)
                        .offset(x: -6, y: -6)
                        .mask(
                            ZStack {
                                Circle()
                                    .frame(width: 44, height: 44)
                                    .offset(x: -6, y: -6)
                                Circle()
                                    .frame(width: 44, height: 44)
                                    .offset(x: 6, y: 6)
                                    .blendMode(.destinationOut)
                            }
                        )
                    Image(user2.photoURL)
                        .resizableFill()
                        .clipShape(Circle())
                        .frame(width: 44, height: 44)
                        .offset(x: 6, y: 6)
                        .mask {
                            ZStack {
                                Circle()
                                    .frame(width: 44, height: 44)
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                                    .blendMode(.destinationOut)
                            }
                            .offset(x: 6, y: 6)
                        }
                } else {
                    Image(user1.photoURL)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 56, height: 56)
                }
            }
            .frame(width: 56, height: 56)
        } else { EmptyView() }
    }
}
