//
//  RegPhotoViewModel.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 14.09.2023.
//

import SwiftUI
import PhotosUI

@MainActor
final class RegPhotoViewModel: ObservableObject {
    @Published private(set) var selectedImages: [Image?] = Array(repeating: nil, count: 3)
    @Published var imageSelections: [PhotosPickerItem?] = Array(repeating: nil, count: 3) {
        didSet {
            let isChangedArray = zip(imageSelections, oldValue).map({ $0 != $1 })
            guard let changedIndex = isChangedArray.firstIndex(where: { $0 }) else { return }
            setImage(from: imageSelections[changedIndex], to: changedIndex)
        }
    }
    unowned let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }

    var isButtonDisabled: Bool {
        imageSelections.compactMap({ $0 }).count < 2
    }

    func setImage(from selection: PhotosPickerItem?, to index: Int) {
        Task {
            if index < selectedImages.count,
               let selection,
               let data = try? await selection.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImages[index] = Image(uiImage: uiImage)
            }
        }
    }
}
