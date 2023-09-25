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
        .fullScreenCover(
            isPresented: $viewModel.showPhotoPicker) {
                // TODO: action when dismiss
            } content: {
                DtPhotoPicker(isPickerShown: $viewModel.showPhotoPicker, selectedImages: $viewModel.selectedImages)
            }
        .alert(
            Text(
                viewModel.photoLibraryAuthStatus == .denied ?
                "Access to the photo library is denied." :
                "Something is wrong."),
            isPresented: $viewModel.showAlert) {
            if viewModel.photoLibraryAuthStatus == .denied {
                Button("OK") {
                    goToAppSettings()
                }
                Button("Cancel", role: .cancel, action: {})
            }
            } message: {
            Text(
                viewModel.photoLibraryAuthStatus == .denied ?
                "Open Settings for editing?" :
                "Unable to show photo library")
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
                            VStack {
                                if index < viewModel.selectedImages.count,
                                    let uiImage = UIImage(data: viewModel.selectedImages[index]) {
                                    Image(uiImage: uiImage)
                                        .resizableFill()
                                } else {
                                    photoPlaceholderView
                                }
                            }
//                                VStack {
//                                    if let uiImage = viewModel.selectedImages[index] {
//                                        Image(uiImage: uiImage)
//                                            .resizableFill()
//                                    } else {
//                                        photoPlaceholderView
//                                    }
//                                }
                                .aspectRatio(160/210, contentMode: .fit)
                                .frame(width: geo.size.width * 0.4)
                                .cornerRadius(AppConstants.Visual.cornerRadius)
                                .onTapGesture {
                                    PHPhotoLibrary.requestAuthorization(
                                        for: .readWrite) { status in
                                            switch status {
                                            case .authorized, .limited:
                                                Task {
                                                    viewModel.showPhotoPicker = true
                                                }
                                            case .restricted, .denied:
                                                Task {
                                                    viewModel.showAlert = true
                                                }
                                            default:
                                                break
                                            }
                                        }
                                }
//                        }
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

    func goToAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            // should this line be here?
            assertionFailure("Not able to open App privacy settings")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
