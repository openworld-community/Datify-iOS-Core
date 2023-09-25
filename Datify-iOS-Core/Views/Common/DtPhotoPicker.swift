//
//  DtPhotoPicker.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 22.09.2023.
//

import SwiftUI
import Photos

@MainActor
struct DtPhotoPicker: View {
    @Binding var isPickerShown: Bool
    @Binding var selectedImages: [Data]
    var isButtonDisabled: Bool {
        selectedImages.isEmpty
    }

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
                        ForEach(getImageDatas(), id: \.self) { imageData in
                            let index: Int? = selectedImages.firstIndex(of: imageData)
                            GeometryReader { geo in
                                if let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: geo.size.width)
                                }
                            }
                            .clipped()
                            .scaledToFill()
                            .overlay(alignment: .topTrailing) {
                                Image(selectedImages.contains(imageData) ? "checkbox.fill" : "checkbox")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(6)
                                    .overlay {
                                        VStack {
                                            if index != nil {
                                                Text("\(index ?? 0)")
                                                    .dtTypo(.p3Regular, color: .textInverted)
                                            } else {
                                                Text("")
                                            }
                                        }
                                    }
                            }
                            .onTapGesture {
                                if selectedImages.contains(imageData), let index {
                                    selectedImages.remove(at: index)
                                } else {
                                    selectedImages.append(imageData)
                                }
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Choose your photos")
                                .dtTypo(.p1Medium, color: .textPrimary)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                isPickerShown = false
                            } label: {
                                Image("xmark")
                                    .resizableFit()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                }
            }
            buttonSection
        }
    }
}

struct DtPhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        DtPhotoPicker(isPickerShown: .constant(true), selectedImages: .constant([]))
    }
}

private extension DtPhotoPicker {
    var buttonSection: some View {
        VStack {
            Spacer()
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea(.all, edges: .bottom)
                DtButton(
                    title: "Choose your photos",
                    style: .main) {
                        isPickerShown = false
                        // TODO: action
                    }
                    .padding(12)
                    .disabled(isButtonDisabled)
            }
            .frame(maxHeight: .leastNormalMagnitude)
        }
        .padding(.bottom)
    }

    func getImageDatas() -> [Data] {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        let phFetchResult = PHAsset.fetchAssets(with: nil)
        var assets = [PHAsset]()
        var imageDatas = [Data]()
        options.isSynchronous = true

        phFetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }

        for asset in assets {
            manager.requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
                if let data {
                    imageDatas.append(data)
                }
            }
        }

        return imageDatas
    }
}
