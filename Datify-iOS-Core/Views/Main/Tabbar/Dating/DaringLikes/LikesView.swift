//
//  LikesView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

enum DisplayMode {
    case gallery, carousel
}

struct LikesView: View {
    @Environment (\.dismiss) private var dismiss
    @StateObject private var viewModel: LikesViewModel
    @State private var tag: LikeTage = .receivedLikes
    @State private var displayMode: DisplayMode = .carousel
    @State private var showFilters: Bool = false
    @State private var showInformationView: Bool = false
    @State private var blurRadius: CGFloat = 0
    @State private var spacingGalleryCard: CGFloat = 6

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
                    VStack(alignment: .center) {
                        categoriesFilter(size: geometry.size)
                        switch displayMode {
                        case .carousel: carouselUserLikes(size: geometry.size)
                        case .gallery: gallerylUserLikes(size: geometry.size)
                        }
                    }
                    .blur(radius: blurRadius)
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
            .sheet(isPresented: $showFilters) {
                FilterSheetView(blurRadius: $blurRadius) {
                    FilterView(sortOption: $viewModel.sortOption)
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
                // TODO: Replace with image from assets
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
    private func carouselUserLikes(size: CGSize) -> some View {
        VStack {
            Spacer()
            BigUserCardView(selectedItem: getLikesAndSelectedItem().selected,
                            size: size,
                            showInformationView: $showInformationView,
                            blurRadius: $blurRadius)
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    HStack {Text("")}
                        .frame(width: size.width / 2 - (size.width*0.07) / 2)
                    ForEach(getLikesAndSelectedItem().likes) { like in
                        if let currentUser = viewModel.currentUser {
                            SmallUserCardView(like: like,
                                              selectedItem: getLikesAndSelectedItem().selected,
                                              currentUser: currentUser,
                                              size: size)
                        }
                    }
                    HStack {Text("")}
                        .frame(width: size.width / 2 - (size.width*0.07) / 2)
                }
            }
            .padding(.bottom)
        }
    }

    @ViewBuilder
    private func gallerylUserLikes(size: CGSize) -> some View {
        VStack {
            if getLikesAndSelectedItem().likes.isNotEmpty {
                ScrollView(showsIndicators: false) {
                    ForEach(chunkedArray(elements: 2).indices, id: \.self) { index in
                        HStack(alignment: index == 0 ? .top  :  .bottom, spacing: spacingGalleryCard) {
                            if let currentUser = viewModel.currentUser {
                                MediumUserCardView(like: chunkedArray(elements: 2)[index][0],
                                                   currentUser: currentUser,
                                                   isCrop: isCrop(index: index,
                                                                  indexNestedArray: 0,
                                                                  count: chunkedArray(elements: 2).count),
                                                   myLikes: viewModel.myLikes,
                                                   size: size,
                                                   spacing: spacingGalleryCard)
                                .offset(y: isCrop(index: index,
                                                  indexNestedArray: 0,
                                                  count: chunkedArray(elements: 2).count) ? -size.height * 0.07 : 0)
                                if chunkedArray(elements: 2)[index].count > 1 {
                                    MediumUserCardView(like: chunkedArray(elements: 2)[index][1],
                                                       currentUser: currentUser,
                                                       isCrop: isCrop(index: index,
                                                                      indexNestedArray: 1,
                                                                      count: chunkedArray(elements: 2).count),
                                                       myLikes: viewModel.myLikes,
                                                       size: size,
                                                       spacing: spacingGalleryCard)
                                    .offset(y: isCrop(index: index,
                                                      indexNestedArray: 1,
                                                      count: chunkedArray(elements: 2).count) ? 0 : -size.height * 0.07)
                                } else {
                                    Rectangle()
                                        .frame(height: size.height * 0.4)
                                        .foregroundStyle(.clear)
                                    Spacer()
                                }
                            }
                        }
                        .frame(width: size.width*0.92)
                    }
                }

            } else {
                NoLikesYetView(width: size.width * 0.92, height: size.height * 0.85)
                DtButton(title: "Continue".localize(), style: .main) { }
                .frame(width: size.width * 0.92)
            }
        }
        .frame(width: size.width)
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

extension LikesView {
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

// TODO: перенести в extention
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    NavigationStack {
        LikesView(router: Router())
    }
}
