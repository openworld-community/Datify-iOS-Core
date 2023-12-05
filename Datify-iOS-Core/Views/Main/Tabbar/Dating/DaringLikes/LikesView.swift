//
//  LikesView.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 05.12.2023.
//

import SwiftUI

enum DisplayMode {
    case gallery, miniIcon
}

struct LikesView: View {
    @StateObject private var viewModel: LikesViewModel
    @State private var tag: LikeTage = .receivedLikes
    @State private var displayMode: DisplayMode = .gallery
    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: LikesViewModel(router: router))
    }

    var body: some View {
        // TODO: delete NavigationStack
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    categoriesFilter(size: geometry.size)

                    if case .gallery = displayMode, let currentUser = viewModel.currentUser {
                        galleryUserLikes(data: getLikesAndSelectedItem(),
                                         currentUser: currentUser, size: geometry.size)
                    } else {
                        ScrollView(showsIndicators: false) {
                            ForEach(chunkedArray(elements: 2), id: \.self) { likes in
                                HStack {
                                    if let currentUser = viewModel.currentUser {
                                        MediumUserCardView(like: likes[0], currentUser: currentUser)
                                        if likes.count > 1 {
                                            MediumUserCardView(like: likes[1], currentUser: currentUser)
                                                .offset(y: -50)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Likes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}, label: {
                        Image(DtImage.backButton)
                            .resizableFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.primary)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {
                            if case .allTime = viewModel.sortOption {
                                viewModel.sortOption = .lastMonth
                            } else {
                                viewModel.sortOption = .allTime
                            }
                        }, label: {
                            Image("likeFilter")
                                .resizableFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.primary)
                        })
                        Button(action: {
                            if case .gallery = displayMode {

                                displayMode = .miniIcon
                            } else {
                                displayMode = .gallery
                            }
                        }, label: {
                            Image(displayMode == .miniIcon ? "likeGallery" : "likeIcons")
                                .resizableFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.primary)
                        })
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

    private func galleryUserLikes(
        data: (likes: [LikeModel], selected: Binding<String?>),
        currentUser: UserModel,
        size: CGSize) -> some View {
        VStack {
            Spacer()
//            BigUserCardView(selectedItem: data.selected, size: size)
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    HStack {Text("")}
                        .frame(width: UIScreen.main.bounds.width / 2 - 27)
                    ForEach(data.likes) { like in
                        SmallUserCardView(like: like, selectedItem: data.selected, currentUser: currentUser, size: size)
                    }
                    HStack {Text("")}
                        .frame(width: UIScreen.main.bounds.width / 2 - 27)
                }
            }
            .padding(.bottom)
        }
    }

    @ViewBuilder
    func categoriesFilter(size: CGSize) -> some View {
        VStack {
            DtSegmentedPicker(selectedItem: $viewModel.categories, items: LikeTage.allCases) {
                Text($0.title)
            }
        }
        .frame(width: size.width*0.92)
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
