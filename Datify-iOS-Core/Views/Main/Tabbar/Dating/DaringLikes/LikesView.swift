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
        // TODO: delete NavigationStack
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    VStack {
                        if let currentUser = viewModel.currentUser {
                            categoriesFilter(size: geometry.size)
                            switch displayMode {
                            case .carousel: CarouselView(size: geometry.size,
                                                             currentUser: currentUser,
                                                             likes: getLikesAndSelectedItem().likes,
                                                             selectedItem: getLikesAndSelectedItem().selected,
                                                             showInformationView: $showInformationView,
                                                             blurRadius: $blurRadius)
                            case .gallery: GallaryView(size: geometry.size,
                                                           likes: chunkedArray(elements: 2),
                                                           currentUser: currentUser,
                                                           myLike: viewModel.myLikes)
                            }
                        }
                    }
                    .sheetFilter(isPresented: $showFilters, blurRadius: $blurRadius, title: "Filter") {
                        FilterView(sortOption: $viewModel.sortOption)
                    }
                    InformationView(showView: $showInformationView,
                                    width: geometry.size.width,
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
            return (viewModel.receivedLikes, $viewModel.selectedReceivedLikes)
        case .mutualLikes:
            return (viewModel.mutualLikes, $viewModel.selectedMutualLikes)
        case .myLikes:
            return (viewModel.myLikes, $viewModel.selectedMyLikes)
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

    private func isCrop(index: Int, indexNestedArray: Int, count: Int) -> Bool {
        if indexNestedArray == 1, index == 0 {
            return true
        }
        if indexNestedArray == 0, index == (count - 1), count != 1 {
            return true
        }
        return false
    }
}

private extension LikesView {
    var filterSheetView: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.backgroundPrimary.ignoresSafeArea()
                    VStack(spacing: 8) {
                        ForEach(LikeSortOption.allCases, id: \.self) { option in
                            DtSelectorButton(isSelected: viewModel.sortOption == option, title: option.title) {
                                viewModel.sortOption = option
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            DtXMarkButton()
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Text("Filters")
                                .dtTypo(.h3Medium, color: .textPrimary)
                        }
                    }
                }
                .onChange(of: geometry.frame(in: .global).minY) { minY in
                    withAnimation {
                        blurRadius = interpolatedValue(for: minY)
                    }
                }
            }
        }
        .presentationDetents([.height(350)])
        .presentationDragIndicator(.visible)
    }

    func interpolatedValue(for height: CGFloat) -> CGFloat {
        // TODO: Replace with View extension
        let screenHeight = UIScreen.main.bounds.height
        let startHeight = screenHeight
        let endHeight = screenHeight - 350
        let startValue: CGFloat = 0.0
        let endValue: CGFloat = 10.0

        if height >= startHeight || height <= 100 {
            return startValue
        } else if height <= endHeight {
            return endValue
        }

        let slope = (endValue - startValue) / (endHeight - startHeight)
        return startValue + slope * (height - startHeight)
    }
}

#Preview {
    NavigationStack {
        LikesView(router: Router())
    }
}
