//
//  DatingView.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 18.12.2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct DatingView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: DatingViewModel

    @State private var currentUserID: DatingModel.ID?
    @State private var selectedPhotoIndex: Int = 0
    @State private var showLikedAnimation = false

    @State private var isSwipeAndIndicatorsDisabled = false
    @State private var showDescription = false

    @State private var isAlertPresented = false
    @State private var alertMessage: String = .init()

    var safeAreaTopInset: CGFloat? = .init()
    private let application: UIApplication

    init(
        router: Router<AppRoute>,
        application: UIApplication = UIApplication.shared
    ) {
        _viewModel = StateObject(wrappedValue: DatingViewModel(router: router))
        self.application = application
        safeAreaTopInset = getSafeAreaTop()
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                LazyVStack(spacing: 0.0) {
                    ForEach($viewModel.users) { user in
                        ZStack {
                            PhotoSliderView(
                                selectedPhotoIndex: $selectedPhotoIndex,
                                currentUserIndex: $currentUserID,
                                showDescription: $showDescription,
                                isSwipeAndIndicatorsDisabled: $isSwipeAndIndicatorsDisabled,
                                geometry: geometry,
                                photos: user.photos
                            )
                            .frame(width: geometry.size.width, height: geometry.size.height)

                            if showLikedAnimation {
                                AnimatedIconView(
                                    show: $showLikedAnimation,
                                    icon: Image(DtImage.mainSelectedHeart)
                                )
                                .position(
                                    x: geometry.size.width / 2,
                                    y: geometry.size.height / 2
                                )
                            }

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
                                        user: user,
                                        geometry: geometry
                                    )

                                    Spacer()
                                    UserActionsView(
                                        liked: $viewModel.liked,
                                        viewModel: viewModel,
                                        user: user
                                    )
                                }
                                .padding(.bottom, 12)

                                HStack {
                                    DtAudioPlayerView(
                                        isPlaying: $viewModel.isPlaying,
                                        playCurrentTime: $viewModel.playCurrentTime,
                                        playbackFinished: $viewModel.playbackFinished,
                                        totalDuration: $viewModel.totalDuration,
                                        viewModel: viewModel,
                                        screenSizeProvider: DtScreenSizeProvider()
                                    )
                                }
                                .padding(.bottom)
                            }
                            .padding(.horizontal)
                        }
                        .navigationBarHidden(true)
                        .background(Color.customBlack)
                        .id(user.id)
                    }
                }
                .scrollTargetLayout()
            }
            .environment(\.colorScheme, .light)
            .scrollPosition(id: $currentUserID)
            .onChange(of: currentUserID) { _, newValue in
                if let currentUserID = newValue {
                    viewModel.currentUserID = currentUserID
                    viewModel.loadingAudioData()
                }

                showLikedAnimation = false

                if isSwipeAndIndicatorsDisabled {
                    isSwipeAndIndicatorsDisabled = false
                }

                if showDescription {
                    showDescription = false
                }

                viewModel.isPlaying = false
                viewModel.playbackFinished = true

                viewModel.audioPlayerManager.stopPlayback()
                viewModel.startProgressUpdates()

                isAlertPresented = false

            }
        }
        .edgesIgnoringSafeArea(.top)
        .scrollTargetBehavior(.paging)
        .onTapGesture(count: 2) {
            if viewModel.liked {
                viewModel.liked = false
            } else {
                withAnimation {
                    showLikedAnimation = true
                    viewModel.liked = true
                }
                Task {
                    try await Task.sleep(for: .seconds(1))
                    showLikedAnimation = false
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

    func getSafeAreaTop() -> CGFloat? {
        let keyWindow = application.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return (keyWindow?.safeAreaInsets.top)
    }
}
