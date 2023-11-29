//
//  DtDoubleAvatar.swift
//  Datify-iOS-Core
//
//  Created by Илья on 05.11.2023.
//

import SwiftUI

struct DtUserCircleImage: View {
    let photoURL: String
    let width: CGFloat
    let offsetXY: CGFloat
    let maskType: MaskType?
    let blurRadius: CGFloat

    enum MaskType {
        case topImage, bottomImage
    }

    init(photoURL: String, width: CGFloat = 56, offsetXY: CGFloat = 0, blurRadius: CGFloat = 0, maskType: MaskType? = nil) {
        self.photoURL = photoURL
        self.width = width
        self.offsetXY = offsetXY
        self.blurRadius = blurRadius
        self.maskType = maskType
    }

    var body: some View {
        let circleImage = Image(photoURL)
            .resizableFill()
            .blur(radius: blurRadius)
            .clipShape(.circle)
            .frame(width: width)
            .offset(x: offsetXY, y: offsetXY)

        if let maskType {
            circleImage
                .mask {
                    switch maskType {
                    case .topImage:
                        ZStack {
                            Circle()
                                .frame(width: width)
                                .offset(x: offsetXY, y: offsetXY)
                            Circle()
                                .frame(width: width)
                                .offset(x: -offsetXY, y: -offsetXY)
                                .blendMode(.destinationOut)
                        }
                    case .bottomImage:
                        ZStack {
                            Circle()
                                .frame(width: width)
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                                .blendMode(.destinationOut)
                        }
                        .offset(x: offsetXY, y: offsetXY)
                    }
                }
        } else {
            circleImage
        }
    }

    @ViewBuilder
    static func doubleUserImage(user1: TempUserModel?, user2: TempUserModel?) -> some View {
        if let user1 {
            ZStack {
                if let user2 {
                    Self(photoURL: user1.photoURL, width: 44, offsetXY: -6, maskType: .topImage)
                    Self(photoURL: user2.photoURL, width: 44, offsetXY: 6, maskType: .bottomImage)
                } else {
                    Self(photoURL: user1.photoURL)
                }
            }
            .frame(width: 56, height: 56)
        } else { EmptyView() }
    }
}
