//
//  DtLimitedPhotoPicker.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 27.09.2023.
//

import SwiftUI
import Photos

struct DtLimitedPhotoPicker: View {
    @Binding var isShowing: Bool
    @Binding var uiImage: UIImage?
    @State private var isShowingDialog: Bool = false
    let viewModel: RegPhotoViewModel

    public var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
                    ForEach(getImagesData(), id: \.self) { imageData in
                        GeometryReader { geo in
                            if let imageData {
                                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: geo.size.width)
                                    .onTapGesture {
                                        isShowing = false
                                        uiImage = UIImage(data: imageData)
                                    }
                            }
                        }
                        .clipped()
                        .contentShape(Rectangle())
                        .scaledToFit()
                    }
                }
            }
            .confirmationDialog(
                Text(""),
                isPresented: $isShowingDialog,
                actions: {
                    Button("Open app Settings") {
                        viewModel.goToAppSettings()
                        isShowing = false
                    }
                },
                message: {
                    Text("Go to Settings and select more photos or allow access to all photos")
                })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowing = false
                    } label: {
                        Text("Cancel")
                    }
                    .buttonStyle(DefaultButtonStyle())
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingDialog = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

private extension DtLimitedPhotoPicker {
    func getImagesData() -> [Data?] {
        let manager: PHImageManager = .default()
        let options: PHImageRequestOptions = .init()
        let phFetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: nil)
        var assets: [PHAsset] = .init()
        var imagesData: [Data?] = .init()
        options.isSynchronous = true

        phFetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }

        for asset in assets {
            manager.requestImageDataAndOrientation(
                for: asset,
                options: options) { data, _, _, _ in
                    imagesData.append(data)
                }
        }

        return imagesData
    }
}
