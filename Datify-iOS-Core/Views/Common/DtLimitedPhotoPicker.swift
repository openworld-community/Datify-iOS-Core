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
    @Binding var image: Image?
    @State private var isShowingDialog: Bool = false
    let viewModel: RegPhotoViewModel

    public var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
                    ForEach(getImages(), id: \.self) { uiImage in
                        GeometryReader { geo in
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: geo.size.width)
                                .onTapGesture {
                                    image = Image(uiImage: uiImage)
                                    isShowing = false
                                }
                        }
                        .clipped()
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
    func getImages() -> [UIImage] {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        let phFetchResult = PHAsset.fetchAssets(with: nil)
        var assets = [PHAsset]()
        var images = [UIImage]()
        options.isSynchronous = true

        phFetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }

        for asset in assets {
            manager.requestImage(
                for: asset,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .aspectFit,
                options: options) { uiImage, _ in
                    if let image = uiImage {
                        images.append(image)
                    }
                }
        }

        return images
    }
}

struct DtLimitedPhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        DtLimitedPhotoPicker(
            isShowing: .constant(true),
            image: .constant(Image(uiImage: UIImage())),
            viewModel: RegPhotoViewModel(router: Router())
        )
    }
}
