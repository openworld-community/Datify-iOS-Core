//
//  ProfileView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 26.12.2023.
//

import SwiftUI

struct ProfileView: View {
    @State private var currentIndex: Int = 0
    @State private var sheetIsPresented: Bool = true
    @State private var infoHeaderHeight: CGFloat = .zero
    @State private var infoTotalHeight: CGFloat = .zero
    @State private var dtConfDialogIsPresented: Bool = false
    let images: [Image]

    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    if index < images.count {
                        images[index]
                            .resizableFill()
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .clipped()
                            .ignoresSafeArea()
                            .tag(index)
                            .onTapGesture {}
                            .onLongPressGesture {
                                dtConfDialogIsPresented = true
                            }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            VStack(spacing: 16) {
                HStack(spacing: 4) {
                    ForEach(images.indices, id: \.self) { index in
                        if index < images.count {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(height: 4)
                                .foregroundStyle(index == currentIndex ? .white : .white.opacity(0.3))
                        }
                    }
                }

                Button(action: {
                    // TODO: action
                    sheetIsPresented.toggle()
                }, label: {
                    Image("ellipsis")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                })
            }
            .padding(.horizontal)
        }
        .dtBottomSheet(
            isPresented: $sheetIsPresented,
            concealable: true,
            presentationDetents: [infoHeaderHeight, infoTotalHeight]
        ) {
            infoView
                .readSize(onChange: { size in
                    infoTotalHeight = size.height
                })
        }

//        .sheet(isPresented: $sheetIsPresented) {
//            GeometryReader { geo in
//                let headerHeight = infoHeaderHeight - geo.safeAreaInsets.bottom
//
//                infoView
//                    .presentationDetents([.height(headerHeight), .height(infoTotalHeight)])
//                    .menuIndicator(.visible)
//                    .interactiveDismissDisabled()
//                    .presentationBackgroundInteraction(.enabled(upThrough: .height(headerHeight)))
//                    .readSize(onChange: { size in
//                        infoTotalHeight = size.height - geo.safeAreaInsets.bottom
//                    })
//            }
//        }
        .dtConfirmationDialog(isPresented: $dtConfDialogIsPresented) {
            DtConfirmationDialogView {

            } onComplain: {

            }
        }
    }
}

private extension ProfileView {
    var infoView: some View {
        VStack(spacing: 0) {
            infoHeader
                .readSize { size in
                    infoHeaderHeight = size.height
                }

            remainingInfo
        }
        .padding(.horizontal)
        .padding(.bottom, 40)
    }

    var infoHeader: some View {
        HStack {
            DtBackButton(size: 48, padding: 12) {
                // TODO: action
            }

            Spacer()

            VStack(spacing: 0) {
                HStack(spacing: 4) {
                    Image("location")
                    Text("500 m away from you")
                        .dtTypo(.p3Regular, color: .textPrimary)
                }

                Text("Aleksandra, 24")
                    .dtTypo(.h3Medium, color: .textPrimary)
            }
            .padding(.horizontal, 24)

            Spacer()

            Button {
                // TODO: action
            } label: {
                Image("heart")
                    .resizableFit()
                    .frame(width: 24, height: 24)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: AppConstants.Visual.cornerRadius)
                            .foregroundStyle(Color.backgroundSecondary)
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 22)
        .padding(.bottom, 24)
    }

    var remainingInfo: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Voice message")
                    .dtTypo(.p2Medium, color: .textPrimary)

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.backgroundSecondary)
                    .frame(height: 48)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("About myself")
                    .dtTypo(.p2Medium, color: .textPrimary)

                // swiftlint:disable line_length
                Text("""
                     I'm an artist. Tried my hand at graphic design and comics, but now I'm looking for something new in art and design. I have a husband Lev, he is a game designer, and yes we know we got married quite early, but we are actually very calm and friendly people)
                     I'm in Belgrade, Serbia right now, I'm just looking for someone to have a coffee and gossip with
                     """)
                .dtTypo(.p2Regular, color: .textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
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

    return ProfileView(images: images)
}
