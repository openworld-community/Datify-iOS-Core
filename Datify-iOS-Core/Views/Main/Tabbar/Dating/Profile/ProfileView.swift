//
//  ProfileView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 26.12.2023.
//

import SwiftUI

struct ProfileView: View {
    @State private var currentIndex: Int = 0
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
                }, label: {
                    Image("ellipsis")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                })

            }
            .padding(.horizontal)
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
