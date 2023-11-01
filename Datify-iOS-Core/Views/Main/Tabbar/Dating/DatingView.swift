//
//  MainView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct TopRightControls: View {
    var body: some View {
        HStack {
            Button(action: {
                // TODO: Show Filter View
            }, label: {
                Image(DtImage.mainFilter)
            })

            Button(action: {
                // TODO: Show Notification View
            }, label: {
                Image(DtImage.mainNotifications)
            })
        }
    }
}

struct UserInfoView: View {
    @State private var showDescription = false
    // swiftlint:disable line_length
    var descriptionUser = "Я художник. Пробовала заниматься графическим дизайном и комиксами, но сейчас ищу что-то новое в области искусства и дизайна. У меня есть муж Лев, он гейм-дизайнер, и да, мы знаем, что поженились довольно рано, но на самом деле мы очень спокойные и дружелюбные люди) Сейчас нахожусь в Белграде, Сербии, я просто ищу кого-нибудь, с кем можно выпить кофе и посплетничать"

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            ZStack {
                Rectangle()
                    .frame(width: 120, height: 24)
                    .foregroundColor(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                Text("Looking for love".localize())
                    .dtTypo(.p4Medium, color: .textInverted)
            }
            HStack {
                Image(DtImage.mainLocation)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("500 meters from you".localize())
                    .dtTypo(.p3Regular, color: .textInverted)
            }
            HStack {
                Text("Aleksandra, 24".localize())
                    .dtTypo(.h3Medium, color: .textInverted)
                Image(DtImage.mainLabel)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            if showDescription {
                Text(descriptionUser)
                    .dtTypo(.p3Regular, color: .textInverted)
                    .padding(.bottom, 10)
                Button(action: {
                    showDescription.toggle()
                }, label: {
                    Text("Hide")
                        .dtTypo(.p3Regular, color: .textInverted)
                })
            } else {
                Button(action: {
                    showDescription.toggle()
                }, label: {
                    Text("Show more")
                        .dtTypo(.p3Regular, color: .textInverted)
                })
            }
        }
    }
}

struct UserActionsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button(action: {
                // TODO: Implement button action
            }, label: {
                ZStack {
                    Rectangle()
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color.iconsSecondary)
                        .opacity(0.64)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Image(DtImage.mainHeart)

                }
            })
            Button(action: {
                // TODO: Implement button action
            }, label: {
                ZStack {
                    Rectangle()
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color.iconsSecondary)
                        .opacity(0.64)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Image(DtImage.mainBookmark)

                }
            })
            Button(action: {
                // TODO: Implement button action
            }, label: {
                ZStack {
                    Rectangle()
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color.iconsSecondary)
                        .opacity(0.64)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Image(DtImage.mainProfile)

                }
            })
        }
    }
}

struct DatingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DatingViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("mockBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: geometry.size.width)
                    .edgesIgnoringSafeArea(.all)

                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.65)]),
                               startPoint: .top, endPoint: .bottom)
                .frame(width: geometry.size.width, height: geometry.size.height / 2)
                .position(x: geometry.size.width / 2, y: geometry.size.height - 100)

                VStack {
                    HStack {
                        DtLogoView(blackAndWhiteColor: true, fontTextColor: .white)
                        Spacer()
                        TopRightControls()
                    }
                    Spacer()
                    HStack {
                        UserInfoView()
                        Spacer()
                        UserActionsView()
                    }
                    HStack {
                        DtAudioPlayerView(viewModel: viewModel, isPlaying: $viewModel.isPlaying, playCurrentTime: $viewModel.playCurrentTime)
                            .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    DatingView(router: Router())
}
