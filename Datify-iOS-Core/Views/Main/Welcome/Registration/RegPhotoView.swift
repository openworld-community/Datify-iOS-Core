//
//  RegPhotoView.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 14.09.2023.
//

import SwiftUI
import PhotosUI

struct RegPhotoView: View {
    @StateObject private var viewModel: RegPhotoViewModel
    @StateObject private var photoPickerViewModel: PhotoPickerViewModel = .init()

    init(router: Router<AppRoute>) {
        _viewModel = StateObject(wrappedValue: RegPhotoViewModel(router: router))
    }

    var body: some View {
        VStack {
            Spacer()
            MainSection(photoPickerViewModel: photoPickerViewModel)
            Spacer()
            ButtonsSection(
                photoPickerViewModel: photoPickerViewModel,
                viewModel: viewModel)
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

private struct MainSection: View {
    @ObservedObject var photoPickerViewModel: PhotoPickerViewModel

    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Select photos")
                    .dtTypo(.h3Medium, color: .textPrimary)
                Text("These photos will appear on your profile")
                    .dtTypo(.p2Regular, color: .textSecondary)
            }
            PhotoSection(photoPickerViewModel: photoPickerViewModel)
        }
    }
}

private struct PhotoSection: View {
    @ObservedObject var photoPickerViewModel: PhotoPickerViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.fixed(218))]) {
                ForEach(0..<3) { index in
                    PhotosPicker(
                        selection: $photoPickerViewModel.imageSelections[index],
                        matching: .images
                    ) {
                        VStack {
                            if let image = photoPickerViewModel.selectedImages[index] {
                                image
                                    .resizableFill()
                            } else {
                                DtPhotoPlaceholderView()
                            }
                        }
                        .frame(width: 157, height: 218)
                        .cornerRadius(AppConstants.Visual.cornerRadius)
                    }
                    .onChange(of: photoPickerViewModel.imageSelections[index]) { imageSelection in
                        photoPickerViewModel.setImage(
                            from: imageSelection,
                            to: index
                        )
                    }
                }
            }
            .padding()
        }
    }
}

private struct DtPhotoPlaceholderView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Color.backgroundSecondary
            Circle()
                .fill(
                    colorScheme == .light ?
                    Color.backgroundPrimary :
                    Color.backgroundSecondary
                )
                .frame(width: 40)
            // Should I download "plus" image from Figma?
            Image(systemName: "plus")
                .frame(width: 18, height: 18)
                .foregroundColor(.textPrimaryLink)
        }
    }
}

private struct ButtonsSection: View {
    @ObservedObject var photoPickerViewModel: PhotoPickerViewModel
    @ObservedObject var viewModel: RegPhotoViewModel

    var body: some View {
        HStack(spacing: 8) {
            DtBackButton {
                viewModel.router.pop()
            }
            DtButton(
                title: "Continue".localize(),
                style: .main) {
                    // TODO: viewModel func photo processing and sending
                }
                .disabled(photoPickerViewModel.isSelectionEmpty)
        }
        .padding(.horizontal)
    }
}
