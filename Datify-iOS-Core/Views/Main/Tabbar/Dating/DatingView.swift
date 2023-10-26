//
//  MainView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

struct DatingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DatingViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))
    }

    var body: some View {
        ZStack {
            Image("mockBackground")
                .resizable()
                .ignoresSafeArea(edges: .top)
                .ignoresSafeArea(edges: .bottom)
            VStack(alignment: .leading) {
                HStack {
                    DtLogoView(blackAndWhiteColor: true, fontTextColor: .white)
                    Spacer()
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
                .padding(.horizontal)
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .frame(width: 120, height: 24)
                                .foregroundColor(.red)
                                .clipShape(.rect(cornerRadius: 16))
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
                    Spacer()
                    VStack(spacing: 12) {
                        Spacer()
                        Button(action: {
                            // TODO: Like button
                        }, label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(Color.iconsSecondary)
                                    .opacity(0.64)
                                    .clipShape(.rect(cornerRadius: 16))
                                Image(DtImage.mainHeart)
                            }
                        })
                        Button(action: {
                            // TODO: Like button
                        }, label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(Color.iconsSecondary)
                                    .opacity(0.64)
                                    .clipShape(.rect(cornerRadius: 16))
                                Image(DtImage.mainBookmark)
                            }
                        })
                        Button(action: {
                            // TODO: Like button
                        }, label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(Color.iconsSecondary)
                                    .opacity(0.64)
                                    .clipShape(.rect(cornerRadius: 16))
                                Image(DtImage.mainProfile)
                            }
                        })
                    }
                }
                .padding(.horizontal)
                DtAudioPlayerView(viewModel: viewModel, isPlaying: $viewModel.isPlaying, playCurrentTime: $viewModel.playCurrentTime)
                    .padding(.bottom, 20)
                    .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    DatingView(router: Router())
}
