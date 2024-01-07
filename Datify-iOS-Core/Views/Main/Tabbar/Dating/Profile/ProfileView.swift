//
//  ProfileView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 26.12.2023.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel

    init(
        router: Router<AppRoute>,
        // temporarily values, so you don't have to deal with NavigationViewBuilder
        images: [Image] = [
            Image("AvatarPhoto"),
            Image("AvatarPhoto2"),
            Image("AvatarPhoto3"),
            Image("exampleImage")
        ],
        // temporarily values, so you don't have to deal with NavigationViewBuilder
        name: String = "Alexandra",
        // temporarily values, so you don't have to deal with NavigationViewBuilder
        age: Int = 24,
        // temporarily values, so you don't have to deal with NavigationViewBuilder
        distance: Int = 500,
        // temporarily, so you don't have to deal with NavigationViewBuilder
        // swiftlint: disable line_length
        bio: String = """
        I'm an artist. Tried my hand at graphic design and comics, but now I'm looking for something new in art and design. I have a husband Lev, he is a game designer, and yes we know we got married quite early, but we are actually very calm and friendly people)
        I'm in Belgrade, Serbia right now, I'm just looking for someone to have a coffee and gossip with
        """
    ) {
        _viewModel = StateObject(
            wrappedValue: ProfileViewModel(
                router: router,
                images: images,
                name: name,
                age: age,
                distance: distance,
                bio: bio
            )
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                imageSection(screenWidth: geo.size.width)
                progressAndButton(paddingTopSize: geo.safeAreaInsets.top)
            }
            .ignoresSafeArea()
            .scaleEffect(viewModel.isSheeted ? 1.2 : 1)
            .dtBottomSheet(
                isPresented: $viewModel.sheetIsPresented,
                isBackground: viewModel.isSheeted,
                presentationDetents: [viewModel.infoHeaderHeight, viewModel.infoTotalHeight]
            ) {
                ProfileSheetView(
                    infoHeaderHeight: $viewModel.infoHeaderHeight,
                    distance: viewModel.distance,
                    name: viewModel.name,
                    age: viewModel.age,
                    bio: viewModel.bio,
                    backAction: {
                        viewModel.back()
                    }, likeAction: {
                        // TODO: action
                    })
                .readSize(onChange: { size in
                    viewModel.infoTotalHeight = size.height
                })
            }
            .sheet(isPresented: $viewModel.dtConfDialogIsPresented) {
                DtConfirmationDialogView(isPresented: $viewModel.dtConfDialogIsPresented) {
                    viewModel.askToBlock()
                } onComplain: {
                    viewModel.complain()
                }
                .readSize { newSize in
                    viewModel.sheetHeight = newSize.height
                }
                .presentationDetents([.height(viewModel.sheetHeight)])
                .interactiveDismissDisabled()
                .presentationBackground(.clear)
            }
            .sheet(isPresented: $viewModel.complainSheetIsPresented) {
                ComplainView(
                    isPresented: $viewModel.complainSheetIsPresented,
                    onCompleted: {
                        viewModel.sendComplaint()
                    }
                )
                .readSize { newSize in
                    viewModel.sheetHeight = newSize.height
                }
                .presentationDetents([.height(viewModel.sheetHeight)])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
            }
            .sheet(isPresented: $viewModel.confirmationSheetIsPresented) {
                ConfirmationView(
                    confirmationType: viewModel.confirmationType) {
                        viewModel.finish()
                    }
                    .readSize { newSize in
                        viewModel.sheetHeight = newSize.height
                    }
                    .presentationDetents([.height(viewModel.sheetHeight)])
                    .interactiveDismissDisabled()
                    .presentationBackground(.clear)
            }
            .sheet(isPresented: $viewModel.blockingSheetIsPresented) {
                BlockView {
                    viewModel.confirmBlock()
                } onCancel: {
                    viewModel.cancelBlock()
                }
                .readSize { newSize in
                    viewModel.sheetHeight = newSize.height
                }
                .presentationDetents([.height(viewModel.sheetHeight)])
                .interactiveDismissDisabled()
                .presentationBackground(.clear)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

private extension ProfileView {
    func imageSection(screenWidth: CGFloat) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(viewModel.images.indices, id: \.self) { index in
                    if index < viewModel.images.count {
                        viewModel.images[index]
                            .resizableFill()
                            .frame(maxWidth: screenWidth)
                            .clipped()
                            .ignoresSafeArea()
                            .id(index)
                            .onTapGesture {}
                            .onLongPressGesture {
                                withAnimation {
                                    viewModel.dtConfDialogIsPresented = true
                                }
                            }
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $viewModel.currentIndex)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
    }

    func progressAndButton(paddingTopSize: CGFloat) -> some View {
        VStack(spacing: 16) {
            if viewModel.images.count > 1 {
                DtProgressBarView(
                    count: viewModel.images.count,
                    currentIndex: viewModel.currentIndex ?? 0
                )
            }

            Button {
                // TODO: action
            } label: {
                Image("ellipsis")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding([.horizontal, .bottom])
        .padding(.top, paddingTopSize)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .black.opacity(0.16), location: 0.00),
                    Gradient.Stop(color: .black.opacity(0), location: 1.00)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1))
        )
    }
}

#Preview {
    // example of getting and processing data
    let receivedData: [String] = [
        "AvatarPhoto",
        "AvatarPhoto2",
        "AvatarPhoto3",
        "exampleImage"
    ]

    var images: [Image] = .init()

    for item in receivedData {
        if let image = UIImage(named: item) { /*here will be 'data' type processing: UIImage(data: ... )*/
            images.append(Image(uiImage: image))
        }
    }

    return ProfileView(
        router: Router(),
        images: images,
        name: "Alexa",
        age: 22,
        distance: 500,
        bio: """
                     I'm an artist. Tried my hand at graphic design and comics, but now I'm looking for something new in art and design. I have a husband Lev, he is a game designer, and yes we know we got married quite early, but we are actually very calm and friendly people)
                     I'm in Belgrade, Serbia right now, I'm just looking for someone to have a coffee and gossip with
                     """
        // swiftlint: enable line_length
    )
}
