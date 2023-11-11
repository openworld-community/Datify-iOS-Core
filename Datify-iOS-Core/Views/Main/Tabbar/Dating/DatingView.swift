//
//  MainView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct DatingView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: DatingViewModel

    @State private var showLikedAnimation = false
    @State private var showBookmarkedAnimation = false
    @State private var isSwipeAndIndicatorsDisabled = false
    @State private var showDescription = false
    @State private var selectedPhotoIndex = 0

    @State private var isAlertPresented = false
    @State private var alertMessage = ""

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach($viewModel.users.indices, id: \.self) { index in
                        ZStack {
                            PhotoSliderView(
                                selectedPhotoIndex: $selectedPhotoIndex,
                                showDescription: $showDescription,
                                isSwipeAndIndicatorsDisabled: $isSwipeAndIndicatorsDisabled,
                                geometry: geometry,
                                photos: viewModel.users[index].photos
                            )
                            .overlay(
                                IndicatorsView(
                                    isSwipeAndIndicatorsDisabled: $isSwipeAndIndicatorsDisabled,
                                    photos: viewModel.users[index].photos,
                                    selectedPhotoIndex: selectedPhotoIndex
                                )
                                .position(x: geometry.size.width / 2, y: geometry.size.height), alignment: .center
                            )

                            if showLikedAnimation {
                                AnimatedIconView(show: $showLikedAnimation, icon: Image(DtImage.mainSelectedHeart))
                                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            }

                            if showBookmarkedAnimation {
                                AnimatedIconView(show: $showBookmarkedAnimation, icon: Image(DtImage.mainSelectedBookmark))
                                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            }

                            BottomDarkGradientView(geometry: geometry)

                            VStack {
                                HStack {
                                    DtLogoView(blackAndWhiteColor: true, fontTextColor: .white)
                                    Spacer()
                                    TopRightControls()
                                }
                                Spacer()
                                HStack {
                                    UserInfoView(
                                        showDescription: $showDescription,
                                        isSwipeAndIndicatorsDisabled: $isSwipeAndIndicatorsDisabled,
                                        viewModel: viewModel,
                                        selectedPhotoIndex: selectedPhotoIndex,
                                        index: index
                                    )
                                    Spacer()
                                    UserActionsView(
                                        liked: $viewModel.liked,
                                        bookmarked: $viewModel.bookmarked,
                                        showLikedAnimation: $showLikedAnimation,
                                        showBookmarkedAnimation: $showBookmarkedAnimation
                                    )
                                }
                                HStack {
                                    DtAudioPlayerView(
                                        isPlaying: $viewModel.isPlaying,
                                        playCurrentTime: $viewModel.playCurrentTime,
                                        playbackFinished: $viewModel.playbackFinished,
                                        viewModel: viewModel
                                    )
                                }
                                .padding(.bottom)
                            }
                            .padding(.horizontal)
                        }
                        .navigationBarHidden(true)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .background(Color.customBlack)
                    }
                }
                .scrollTargetLayout()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .scrollTargetBehavior(.paging)
        .onChange(of: viewModel.liked) { newValue in
            if newValue {
                withAnimation {
                    showLikedAnimation = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showLikedAnimation = false
                }
            }
        }
        .onChange(of: viewModel.bookmarked) { newValue in
            if newValue {
                withAnimation {
                    showBookmarkedAnimation = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showBookmarkedAnimation = false
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "An unknown error occurred"),
                dismissButton: .default(Text("OK")) {
                    viewModel.showAlert = false
                }
            )
        }
    }
}
