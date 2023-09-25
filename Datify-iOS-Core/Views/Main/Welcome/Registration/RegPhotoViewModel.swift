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
    @Published var showPhotoPicker: Bool = false
    @Published var showAlert: Bool = false
    @Published var selectedImages: [Data] = .init()// Array(repeating: nil, count: 5)
    unowned let router: Router<AppRoute>
//    @Published var imageSelections: [PhotosPickerItem?] = Array(repeating: nil, count: 5) {
//        didSet {
//            let isChangedArray = zip(imageSelections, oldValue).map({ $0 != $1 })
//            guard let changedIndex = isChangedArray.firstIndex(where: { $0 }) else { return }
//            setImage(from: imageSelections[changedIndex], to: changedIndex)
//        }
//    }
    var photoLibraryAuthStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    var isButtonDisabled: Bool {
        selectedImages.compactMap({ $0 }).count < 2
    }

    init(router: Router<AppRoute>) {
        self.router = router
    }

//    func setImage(from selection: PhotosPickerItem?, to index: Int) {
//        Task {
//            if index < selectedImages.count,
//               let selection,
//               let data = try? await selection.loadTransferable(type: Data.self),
//               let uiImage = UIImage(data: data) {
//                selectedImages[index] = Image(uiImage: uiImage)
//            }
//        }
//    }
}
