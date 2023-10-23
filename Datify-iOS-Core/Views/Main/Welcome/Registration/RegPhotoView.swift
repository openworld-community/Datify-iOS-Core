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
                ProgressView {
                    Text("Loading...")
                }
                .controlSize(.large)
                .padding()
                .background(
                    RoundedRectangle(
                        cornerRadius: AppConstants.Visual.cornerRadius,
                        style: .circular
                    )
                    .foregroundStyle(.ultraThinMaterial)
                )
            }
        }
        .padding(.bottom, 24)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                DtLogoView()
            }
        }
        .onAppear {
            viewModel.checkPhotoAuthStatus()
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
        .fullScreenCover(isPresented: $viewModel.showLimitedPicker) {
            DtLimitedPhotoPicker(
                isShowing: $viewModel.showLimitedPicker,
                uiImage: $viewModel.selectedImage,
                viewModel: viewModel)
            .onAppear {
                viewModel.showSpinner = false
            }
        }
        .fullScreenCover(isPresented: $viewModel.showCropView) {
            DtCropView(inputUIImage: viewModel.selectedImage) { croppedImage in
                if let croppedImage {
                    viewModel.selectedImages[viewModel.photoIndex] = Image(uiImage: croppedImage)
                }
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
                                                    ZStack {
                                                        image.resizableFill()
                                                        Button {
                                                            viewModel.selectedImages[index] = nil
                                                            viewModel.imageSelections[index] = nil
                                                        } label: {
                                                            ZStack {
                                                                Circle()
                                                                    .foregroundStyle(Color.backgroundPrimary)
                                                                    .frame(width: 32, height: 32)
                                                                Image(systemName: "xmark")
                                                                    .resizable()
                                                                    .frame(width: 10, height: 10)
                                                                    .foregroundStyle(Color.iconsSecondary)
                                                            }
                                                        }
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                                        .padding(8)
                                                    }
                                                } else {
                                                    photoPlaceholderView
                                                }
                                            }
                                        }
                                    } else {
                                        Group {
                                            if let image = viewModel.selectedImages[index] {
                                                ZStack {
                                                    image.resizableFill()
                                                    Button {
                                                        viewModel.selectedImages[index] = nil
                                                        viewModel.imageSelections[index] = nil
                                                    } label: {
                                                        ZStack {
                                                            Circle()
                                                                .foregroundStyle(Color.backgroundPrimary)
                                                                .frame(width: 32, height: 32)
                                                            Image(systemName: "xmark")
                                                                .resizable()
                                                                .frame(width: 10, height: 10)
                                                                .foregroundStyle(Color.iconsSecondary)
                                                        }
                                                    }
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                                    .padding(8)
                                                }
                                            } else {
                                                photoPlaceholderView
                                            }
                                        }
                                        .onTapGesture {
                                            Task {
                                                viewModel.showSpinner = true
                                            }
                                            if viewModel.photoAuthStatus == .limited {
                                                viewModel.photoIndex = index
                                                viewModel.showLimitedPicker = true
                                            } else {
                                                viewModel.isAlertShowing = true
                                            }
                                        }
                                    }
                                }
                                .onChange(of: viewModel.selectedImage) { _ in
                                    viewModel.showCropView = true
                                }
                                .aspectRatio(160/210, contentMode: .fit)
                                .frame(width: geo.size.width * 0.4)
                                .cornerRadius(AppConstants.Visual.cornerRadius)
                                .contentShape(Rectangle())
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
