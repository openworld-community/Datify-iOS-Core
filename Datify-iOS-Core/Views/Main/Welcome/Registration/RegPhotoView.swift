//
//  RegPhotoView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 14.09.2023.
//

import SwiftUI
import PhotosUI

struct RegPhotoView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel: RegPhotoViewModel

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: RegPhotoViewModel(router: router))
    }

    var body: some View {
        ZStack {
            VStack {
                mainSection
                buttonsSection
            }
            if viewModel.showSpinner {
                DtSpinnerView(size: 50)
            }
        }
        .padding(.bottom, 24)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.checkPhotoAuthStatus()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
        .alert(
            viewModel.photoAuthStatus == .denied ? "Access denied" : "Something wrong",
            isPresented: $viewModel.isAlertShowing
        ) {
            if viewModel.photoAuthStatus == .denied {
                Button("OK") {
                    viewModel.goToAppSettings()
                }
                Button("Cancel", role: .cancel, action: {})
            }
        } message: {
            if viewModel.photoAuthStatus == .denied {
                Text("Open Settings for editing?")
            } else {
                Text("Unable to show photo library")
            }
        }
        .sheet(isPresented: $viewModel.showLimitedPicker) {
            DtLimitedPhotoPicker(
                isShowing: $viewModel.showLimitedPicker,
                image: $viewModel.selectedImages[viewModel.photoIndex],
                viewModel: viewModel
            )
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
                        ForEach(0..<5) { index in
                            if index < viewModel.selectedImages.count {
                                Group {
                                    if viewModel.photoAuthStatus == .authorized {
                                        PhotosPicker(
                                            selection: $viewModel.imageSelections[index],
                                            matching: .images
                                        ) {
                                            Group {
                                                if let image = viewModel.selectedImages[index] {
                                                    image
                                                        .resizableFill()
                                                } else {
                                                    photoPlaceholderView
                                                }
                                            }
                                        }
                                    } else {
                                        Group {
                                            if let image = viewModel.selectedImages[index] {
                                                image
                                                    .resizableFill()
                                            } else {
                                                photoPlaceholderView
                                            }
                                        }
                                        .onTapGesture {
                                            if viewModel.photoAuthStatus == .limited {
                                                viewModel.photoIndex = index
                                                viewModel.showLimitedPicker = true
                                            } else {
                                                viewModel.isAlertShowing = true
                                            }
                                        }
                                    }
                                }
                                .aspectRatio(160/210, contentMode: .fit)
                                .frame(width: geo.size.width * 0.4)
                                .cornerRadius(AppConstants.Visual.cornerRadius)
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
