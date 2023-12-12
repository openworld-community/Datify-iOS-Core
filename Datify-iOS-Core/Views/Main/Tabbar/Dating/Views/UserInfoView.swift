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
    @Binding var user: DatingModel
    var geometry: GeometryProxy

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Spacer()
                HStack(alignment: .center) {
                    Text(user.label)
                        .dtTypo(.p4Medium, color: .textInverted)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(user.colorLabel)
                        )
                        .frame(height: 24)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 0.0) {
                    HStack {
                        Image(DtImage.mainLocation)
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text(user.location)
                            .dtTypo(.p3Regular, color: .textInverted)
                    }
                    .frame(height: 20)

                    HStack {
                        Text("\(user.name), \(user.age)")
                            .dtTypo(.h3Medium, color: .textInverted)
                        Image(DtImage.mainLabel)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .frame(height: 28)
                }
                .padding(.bottom, 8)

                if showDescription && isAnimated {
                    Text(user.description)
                        .dtTypo(.p3Regular, color: .textInverted)
                        .padding(.bottom, 10)
                        .transition(
                            .asymmetric(insertion:
                                    .move(edge: .bottom)
                                    .combined(with: .opacity),
                                        removal: .move(edge: .bottom)
                            )
                        )
                }
            }
            .clipShape(Rectangle())

            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.5)) {
                    if showDescription {
                        showDescription = false
                        isSwipeAndIndicatorsDisabled = false
                        Task {
                            try await Task.sleep(nanoseconds: 300_000_000)
                            isAnimated = false
                        }
                    } else {
                        isAnimated = true
                        showDescription = true
                        isSwipeAndIndicatorsDisabled = true
                    }
                }
            }, label: {
                Text(showDescription ? "Hide" : "Show more")
                    .dtTypo(.p3Regular, color: .textInverted)
                    .opacity(0.56)
            })
        }
    }
}
