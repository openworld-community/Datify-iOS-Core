//
//  UserInfoView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 05.11.2023.
//

import SwiftUI

struct UserInfoView: View {
    @Binding var showDescription: Bool
    @Binding var isSwipeAndIndicatorsDisabled: Bool

    var viewModel: DatingViewModel
    var selectedPhotoIndex: Int

    var body: some View {
        let currentUser = viewModel.users[selectedPhotoIndex]

        VStack(alignment: .leading) {
            Spacer()

            ZStack {
                    HStack(alignment: .center) {
                        ZStack {
                            Rectangle()
                                .frame(width: 120, height: 24)
                                .foregroundColor(currentUser.colorLabel)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            Text(currentUser.label)
                                .dtTypo(.p4Medium, color: .textInverted)
                        }
                        Spacer()
                    }
                }

            HStack {
                Image(DtImage.mainLocation)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text(currentUser.location)
                    .dtTypo(.p3Regular, color: .textInverted)
            }
            HStack {
                Text("\(currentUser.name), \(currentUser.age)")
                    .dtTypo(.h3Medium, color: .textInverted)
                Image(DtImage.mainLabel)
                    .resizable()
                    .frame(width: 20, height: 20)
            }

            if showDescription {
                Text(currentUser.description)
                    .dtTypo(.p3Regular, color: .textInverted)
                    .padding(.bottom, 10)
                Button(action: {
                    showDescription.toggle()
                    isSwipeAndIndicatorsDisabled.toggle()
                }, label: {
                    Text("Hide")
                        .dtTypo(.p3Regular, color: .textInverted)
                })
            } else {
                Button(action: {
                    showDescription.toggle()
                    isSwipeAndIndicatorsDisabled.toggle()
                }, label: {
                    Text("Show more")
                        .dtTypo(.p3Regular, color: .textInverted)
                })
            }
        }
    }
}
