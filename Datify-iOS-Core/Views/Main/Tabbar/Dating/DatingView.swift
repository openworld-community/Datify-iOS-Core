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
                Image(DtImage.mainLocation)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            Button(action: {
                // TODO: Show more information about person
            }, label: {
                Text("Show more")
                    .dtTypo(.p3Regular, color: .textPrimary)
            })
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
                .padding(.bottom, 50)
                .padding(.trailing)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    DatingView(router: Router())
}
