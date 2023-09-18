//
//  RegPhotoView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 14.09.2023.
//

import SwiftUI
import PhotosUI

struct RegPhotoView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel: RegPhotoViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: RegPhotoViewModel(router: router))
    }

    var body: some View {
        VStack {
            mainSection
            buttonsSection
        }
        .padding(.bottom, 24)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
    }
}

struct RegPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        RegPhotoView(router: Router())
    }
}

private extension RegPhotoView {
    var mainSection: some View {
        GeometryReader { geo in
            VStack(spacing: 40) {
                VStack {
                    Text("Select photos")
                        .dtTypo(.h3Medium, color: .textPrimary)
                    Text("These photos will appear on your profile")
                        .dtTypo(.p2Regular, color: .textSecondary)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<3) { index in
                            if index < viewModel.selectedImages.count {
                                PhotosPicker(
                                    selection: $viewModel.imageSelections[index],
                                    matching: .images
                                ) {
                                    VStack {
                                        if let image = viewModel.selectedImages[index] {
                                            image
                                                .resizableFill()
                                        } else {
                                            photoPlaceholderView
                                        }
                                    }
                                    .frame(width: geo.size.width * 0.4, height: geo.size.width * 0.764)
                                    .cornerRadius(AppConstants.Visual.cornerRadius)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    var photoPlaceholderView: some View {
        ZStack {
            Color.backgroundSecondary
            Circle()
                .fill(
                    colorScheme == .light ?
                    Color.backgroundPrimary :
                        Color.backgroundSecondary
                )
                .frame(width: 40)
            Image("plus")
                .resizableFit()
                .frame(width: 18, height: 18)
                .foregroundColor(.textPrimaryLink)
        }
    }

    var buttonsSection: some View {
        HStack(spacing: 8) {
            DtBackButton {
                viewModel.router.pop()
            }
            DtButton(
                title: "Continue".localize(),
                style: .main) {
                    // TODO: viewModel func photo processing and sending
                }
                .disabled(viewModel.isButtonDisabled)
        }
        .padding(.horizontal)
    }
}
