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
    @State private var currentUserIndex: Int = 0

    var safeAreaTopInset: CGFloat

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))

        if let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets {
            safeAreaTopInset = safeAreaInsets.top
        } else {
            safeAreaTopInset = 0
        }
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
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .overlay(
                                IndicatorsView(
                                    isSwipeAndIndicatorsDisabled: $isSwipeAndIndicatorsDisabled,
                                    photos: viewModel.users[index].photos,
                                    selectedPhotoIndex: selectedPhotoIndex
                                )
                                .position(x: geometry.size.width / 2, y: geometry.size.height - 170), alignment: .center)

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
                                .padding(.top, safeAreaTopInset)
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
                                        showBookmarkedAnimation: $showBookmarkedAnimation,
                                        viewModel: viewModel,
                                        index: index
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
        .onChange(of: viewModel.currentUserIndex) { _ in
            withAnimation {
                showLikedAnimation = false
                showBookmarkedAnimation = false
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
