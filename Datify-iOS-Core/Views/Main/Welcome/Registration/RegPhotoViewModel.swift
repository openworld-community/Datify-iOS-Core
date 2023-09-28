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
    @Published var selectedImages: [Image?] = Array(repeating: nil, count: 5)
    @Published var imageSelections: [PhotosPickerItem?] = Array(repeating: nil, count: 5) {
        didSet {
            let isChangedArray = zip(imageSelections, oldValue).map({ $0 != $1 })
            guard let changedIndex = isChangedArray.firstIndex(where: { $0 }) else { return }
            setImage(from: imageSelections[changedIndex], to: changedIndex)
        }
    }
    @Published var isAlertShowing: Bool = false
    @Published var showLimitedPicker: Bool = false
    @Published var showSpinner: Bool = false
    @Published var photoAuthStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    var photoIndex: Int = 0
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

    func goToAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func checkPhotoAuthStatus() {
        showSpinner = true
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .restricted, .denied:
                Task {
                    self.isAlertShowing = true
                }
            case .limited:
                Task {
                    self.photoAuthStatus = status
                }
            case .authorized:
                Task {
                    self.photoAuthStatus = status
                }
            default:
                break
            }
            Task {
                self.showSpinner = false
            }
        }
    }
}
