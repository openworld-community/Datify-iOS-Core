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
    @State private var isAnimated = false

    var viewModel: DatingViewModel
    var selectedPhotoIndex: Int
    var index: Int

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer()
                ZStack {
                    HStack(alignment: .center) {
                        ZStack {
                            Rectangle()
                                .frame(width: 120, height: 24)
                                .foregroundColor(viewModel.users[index].colorLabel)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            Text(viewModel.users[index].label)
                                .dtTypo(.p4Medium, color: .textInverted)
                        }
                        Spacer()
                    }
                }
                HStack {
                    Image(DtImage.mainLocation)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(viewModel.users[index].location)
                        .dtTypo(.p3Regular, color: .textInverted)
                }
                HStack {
                    Text("\(viewModel.users[index].name), \(viewModel.users[index].age)")
                        .dtTypo(.h3Medium, color: .textInverted)
                    Image(DtImage.mainLabel)
                        .resizable()
                        .frame(width: 20, height: 20)
                }

                if showDescription {
                    Text(viewModel.users[index].description)
                        .dtTypo(.p3Regular, color: .textInverted)
                        .padding(.bottom, 10)
//                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                        .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .bottom)))

                }
            }
            .clipShape(Rectangle())

            Button(action: {
                if showDescription {
                    showDescription = false
                    print("showDescription is now1: \(showDescription)")
                } else {
                    showDescription = true
                    print("showDescription is now2: \(showDescription)")
                }
                isSwipeAndIndicatorsDisabled.toggle()
            }, label: {
                Text(showDescription ? "Hide" : "Show more")
                    .dtTypo(.p3Regular, color: .textInverted)
                    .opacity(0.56)
            })
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5), value: showDescription)
        .animation(.easeInOut(duration: 0.3), value: showDescription)
    }

    private func toggleDescription() {
        showDescription.toggle()
        isSwipeAndIndicatorsDisabled.toggle()
        isAnimated = false
    }
}
