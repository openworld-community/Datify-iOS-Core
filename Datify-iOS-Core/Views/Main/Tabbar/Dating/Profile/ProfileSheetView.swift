//
//  ProfileSheetView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 06.01.2024.
//

import SwiftUI

struct ProfileSheetView: View {
    @Binding var infoHeaderHeight: CGFloat

    let distance: Int
    let name: String
    let age: Int
    let bio: String
    let backAction: () -> Void
    let likeAction: () -> Void

    var body: some View {
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
}

private extension ProfileSheetView {
    var infoHeader: some View {
        HStack {
            DtBackButton(size: 48, padding: 12) {
                backAction()
            }

            Spacer()

            VStack(spacing: 0) {
                HStack(spacing: 4) {
                    Image("location")
                    Text("\(distance) m away from you")
                        .dtTypo(.p3Regular, color: .textPrimary)
                }

                Text("\(name), \(age)")
                    .dtTypo(.h3Medium, color: .textPrimary)
            }
            .padding(.horizontal, 24)

            Spacer()

            Button {
                likeAction()
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
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Voice message")
                    .dtTypo(.p2Medium, color: .textPrimary)

                // Here DtAudioPlayerView will be used
                // it's only a temporary solution.
                VoiceMessageView()
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("About myself")
                    .dtTypo(.p2Medium, color: .textPrimary)

                Text(bio)
                .dtTypo(.p2Regular, color: .textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    ProfileSheetView(
        infoHeaderHeight: .constant(100),
        distance: 100,
        name: "Alexandra",
        age: 55,
        bio: """
        Bla bla bla
        Bla bla bla Bla bla bla
        """,
        backAction: {},
        likeAction: {}
    )
}
