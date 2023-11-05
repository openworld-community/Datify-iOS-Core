//
//  MainView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct AnimatedIconView: View {
    var icon: Image
    @Binding var show: Bool

    var body: some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.easeInOut(duration: 0.5), value: show)
            .onAppear {
                show = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    show = false
                }
            }
    }
}

struct Indicators: View {
    var images: [String]
    var selectedImageIndex: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(images.indices, id: \.self) { index in
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(selectedImageIndex == index ? .white : .gray)
            }
        }
    }
}

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
    @Binding var showDescription: Bool
    var images: [String]
    var selectedImageIndex: Int
        // swiftlint:disable line_length
    var descriptionUser = "Я художник. Пробовала заниматься графическим дизайном и комиксами, но сейчас ищу что-то новое в области искусства и дизайна. У меня есть муж Лев, он гейм-дизайнер, и да, мы знаем, что поженились довольно рано, но на самом деле мы очень спокойные и дружелюбные люди) Сейчас нахожусь в Белграде, Сербии, я просто ищу кого-нибудь, с кем можно выпить кофе и посплетничать"

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: 120, height: 24)
                        .foregroundColor(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Text("Looking for love".localize())
                        .dtTypo(.p4Medium, color: .textInverted)
                }
                Spacer()
                Indicators(images: images, selectedImageIndex: selectedImageIndex)
                Spacer()
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
    @Binding var liked: Bool
    @Binding var bookmarked: Bool
    @Binding var showLikedAnimation: Bool
    @Binding var showBookmarkedAnimation: Bool

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Button(action: {
                 withAnimation {
                     liked.toggle()
                     showLikedAnimation = liked
                 }
             }, label: {
                 ZStack {
                     Rectangle()
                         .frame(width: 48, height: 48)
                         .foregroundColor(Color.iconsSecondary)
                         .opacity(0.64)
                         .clipShape(RoundedRectangle(cornerRadius: 16))
                     Image(liked ? DtImage.mainSelectedHeart : DtImage.mainHeart)
                 }
             })
             Button(action: {
                 withAnimation {
                     bookmarked.toggle()
                     showBookmarkedAnimation = bookmarked
                 }
             }, label: {
                 ZStack {
                     Rectangle()
                         .frame(width: 48, height: 48)
                         .foregroundColor(Color.iconsSecondary)
                         .opacity(0.64)
                         .clipShape(RoundedRectangle(cornerRadius: 16))
                     Image(bookmarked ? DtImage.mainSelectedBookmark : DtImage.mainBookmark)
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
    @State var showDescription = false
    @State var liked: Bool = false
    @State var bookmarked: Bool = false
    @State private var showLikedAnimation = false
    @State private var showBookmarkedAnimation = false

    let images = ["mockBackground", "mockBackground2", "mockBackground"] // Замените на ваши изображения
        @State private var selectedImageIndex = 0

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TabView(selection: $selectedImageIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: geometry.size.width)
                            .blur(radius: showDescription ? 2 : 0)
                            .animation(.easeInOut(duration: 0.4))
                            .edgesIgnoringSafeArea(.all)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .edgesIgnoringSafeArea(.all)

                if showLikedAnimation {
                    AnimatedIconView(icon: Image(DtImage.mainSelectedHeart), show: $showLikedAnimation)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }

                if showBookmarkedAnimation {
                    AnimatedIconView(icon: Image(DtImage.mainSelectedBookmark), show: $showBookmarkedAnimation)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }

                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                               startPoint: .top, endPoint: .bottom)
                .frame(width: geometry.size.width, height: 320)
                .position(x: geometry.size.width / 2, y: geometry.size.height - 150)

                VStack {
                    HStack {
                        DtLogoView(blackAndWhiteColor: true, fontTextColor: .white)
                        Spacer()
                        TopRightControls()
                    }
                    Spacer()
                    HStack {
                        UserInfoView(showDescription: $showDescription, images: images, selectedImageIndex: selectedImageIndex)
                        Spacer()
                        UserActionsView(liked: $liked, bookmarked: $bookmarked, showLikedAnimation: $showLikedAnimation, showBookmarkedAnimation: $showBookmarkedAnimation)
                    }
                    HStack {
                        DtAudioPlayerView(
                            viewModel: viewModel,
                            isPlaying: $viewModel.isPlaying,
                            playCurrentTime: $viewModel.playCurrentTime,
                            playbackFinished: $viewModel.playbackFinished
                        )
                        .padding(.bottom, -30)

                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            .navigationBarHidden(true)
            .background(Color.customBlack)
        }
    }
}

#Preview {
    DatingView(router: Router())
}
