//
//  RegPhotoViewModel.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 14.09.2023.
//

import SwiftUI
import PhotosUI

final class RegPhotoViewModel: ObservableObject {
    unowned let router: Router<AppRoute>

    init(router: Router<AppRoute>) {
        self.router = router
    }
}

// MARK: - PhotoPickerViewModel

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    @Published private(set) var selectedImages: [Image?] = Array(repeating: nil, count: 3)
    @Published var imageSelections: [PhotosPickerItem?] = Array(repeating: nil, count: 3)

    var isSelectionEmpty: Bool {
        imageSelections.allSatisfy { selection in
            selection == nil
        }
    }

    func setImage(from selection: PhotosPickerItem?, to index: Int) {
        Task {
            if let selection,
               let data = try? await selection.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImages[index] = Image(uiImage: uiImage)
            }
        }
    }
}
