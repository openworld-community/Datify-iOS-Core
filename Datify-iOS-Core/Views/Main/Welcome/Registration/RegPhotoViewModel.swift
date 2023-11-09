//
//  RegPhotoViewModel.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 14.09.2023.
//

import SwiftUI
import PhotosUI

final class RegPhotoViewModel: ObservableObject {
    @Published var selectedImages: [Image?] = Array(repeating: nil, count: 5)
    @Published var selectedImage: UIImage?
    @Published var imageSelections: [PhotosPickerItem?] = Array(repeating: nil, count: 5) {
        didSet {
            let isChangedArray = zip(imageSelections, oldValue).map({ $0 != $1 })
            guard let changedIndex = isChangedArray.firstIndex(where: { $0 }) else { return }
            photoIndex = changedIndex
            setImage(from: imageSelections[changedIndex])
        }
    }
    @Published var isAlertShowing: Bool = false
    @Published var showLimitedPicker: Bool = false
    @Published var showSpinner: Bool = false
    @Published var showCropView: Bool = false
    @Published var photoAuthStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    var photoIndex: Int = 0
    var isButtonDisabled: Bool {
        selectedImages.compactMap({ $0 }).count < 2
    }
    unowned let router: Router<AppRoute>
    private let application: UIApplication

    init(
        router: Router<AppRoute>,
        application: UIApplication = UIApplication.shared
    ) {
        self.router = router
        self.application = application
    }

    func setImage(from selection: PhotosPickerItem?) {
        Task { @MainActor in
            if let selection,
               let data = try? await selection.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data ) {
                selectedImage = uiImage
            }
        }
    }

    func goToAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              application.canOpenURL(url) else { return }
        application.open(url, options: [:], completionHandler: nil)
    }

    func checkPhotoAuthStatus() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .restricted, .denied:
                Task { @MainActor in
                    self.photoAuthStatus = status
                    self.isAlertShowing = true
                }
            case .limited, .authorized:
                Task { @MainActor in
                    self.photoAuthStatus = status
                }
            default:
                break
            }
        }
    }

    func back() {
        router.pop()
    }
}
