//
//  LikesView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

struct LikesView: View {
    enum DisplayMode {
        case gallery, carousel
    }

    @Environment (\.dismiss) private var dismiss
    @StateObject private var viewModel: LikesViewModel
    @State private var tag: LikeTage = .receivedLikes
    @State private var displayMode: DisplayMode = .carousel
    @State private var showFilters: Bool = false
    @State private var showInformationView: Bool = false
    @State private var blurRadius: CGFloat = 0

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: LikesViewModel(router: router,
                                                              userDataService: UserDataService.shared,
                                                              likesDataService: LikesDataService.shared))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack {
                    if let currentUser = viewModel.currentUser {
                        categoriesFilter(size: geometry.size)
                        switch displayMode {
                        case .carousel: CarouselView(selectedItem: getLikesAndSelectedItem().selected,
                                                     showInformationView: $showInformationView,
                                                     blurRadius: $blurRadius,
                                                     size: geometry.size,
                                                     currentUser: currentUser,
                                                     likes: getLikesAndSelectedItem().likes)
                        case .gallery: GallaryView(size: geometry.size,
                                                   likes: chunkedArray(elements: 2),
                                                   currentUser: currentUser,
                                                   myLike: viewModel.myLikes)
                        }
                    }
                }
                .sheetFilter(isPresented: $showFilters, title: "Filter") {
                    FilterView(sortOption: $viewModel.sortOption)
                }
                InformationView(showView: $showInformationView,
                                widthScreen: geometry.size.width,
                                title: "Restore chat?",
                                text: "The chat with this user has been deleted, are you sure you want to restore it?",
                                titleButton: "Yes, restore") {
                    // TODO: func restore chat
                    showInformationView = false
                    withAnimation {
                        blurRadius = 0
                    }
                }
            }
        }
        .onChange(of: showFilters) { newValue in
            withAnimation {
                blurRadius = newValue ? 10.0 : 0
            }
        }
        .onAppear {
            Task {
                await viewModel.fecthData()
            }
        }
        .navigationTitle("Likes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            dtToolbarButton(placement: .topBarLeading, image: DtImage.backButton) {
                dismiss()
            }
            dtToolbarButton(placement: .topBarTrailing, image: DtImage.likeFilter) {
                showFilters.toggle()
            }
            dtToolbarButton(placement: .topBarTrailing,
                            image: displayMode == .carousel ? DtImage.likeGallery : DtImage.likeIcons) {
                if case .gallery = displayMode {
                    displayMode = .carousel
                } else {
                    displayMode = .gallery
                }
            }
        }
        .navigationBarBackButtonHidden()
    }

    private func chunkedArray(elements: Int) -> [[LikeModel]] {
        switch viewModel.categories {
        case .receivedLikes:
            return viewModel.receivedLikes.chunked(into: elements)
        case .mutualLikes:
            return viewModel.mutualLikes.chunked(into: elements)
        case .myLikes:
            return viewModel.myLikes.chunked(into: elements)
        }
    }

    private func getLikesAndSelectedItem() -> (likes: [LikeModel], selected: Binding<String?>) {
        switch viewModel.categories {
        case .receivedLikes:
            return (viewModel.receivedLikes, $viewModel.selectedReceivedLikesId)
        case .mutualLikes:
            return (viewModel.mutualLikes, $viewModel.selectedMutualLikesId)
        case .myLikes:
            return (viewModel.myLikes, $viewModel.selectedMyLikesId)
        }
    }

    @ViewBuilder
    private func categoriesFilter(size: CGSize) -> some View {
        VStack {
            DtSegmentedPicker(selectedItem: $viewModel.categories, items: LikeTage.allCases) {
                Text($0.title)
            }
        }
        .frame(width: size.width*0.92)
    }
}

#Preview {
    NavigationStack {
        LikesView(router: Router())
    }
}
