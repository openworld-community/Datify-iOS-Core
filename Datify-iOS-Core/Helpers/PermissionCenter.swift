//
//  PermissionCenter.swift
//  Datify-iOS-Core
//
//  Created by Алексей Баранов on 19.11.2023.
//

import Foundation
import AVFoundation

enum PermissionCenter {
    enum PermissionType {
        case microphone
    }

    enum AccessError: LocalizedError {
        case microphoneAccessDenied

        var errorDescription: String? {
            switch self {
            case .microphoneAccessDenied: return NSLocalizedString("No access to microphone", comment: "")
            }
        }
    }

    static func requestPermission(type: PermissionType) async -> Result<Bool, Error> {
        switch type {
        case .microphone: return await requestMicrophoneAccess()
        }
    }

    private static func requestMicrophoneAccess() async -> Result<Bool, Error> {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized: return .success(true)
        case .denied, .restricted: return .failure(AccessError.microphoneAccessDenied)
        case .notDetermined:
            let response = await AVCaptureDevice.requestAccess(for: .audio)
            switch response {
            case true: return .success(true)
            case false: return .failure(AccessError.microphoneAccessDenied)
            }
        @unknown default:
            return .failure(AccessError.microphoneAccessDenied)
        }
    }
}
