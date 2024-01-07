//
//  ProfileViewModel.swift
//  Datify-iOS-Core
//
//  Created by Reek i on 06.01.2024.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
    unowned private let router: Router<AppRoute>

    @Published var images: [Image]
    @Published var name: String
    @Published var age: Int
    @Published var distance: Int
    @Published var bio: String

    @Published var currentIndex: Int?
    @Published var sheetIsPresented: Bool = true
    @Published var infoHeaderHeight: CGFloat = .zero
    @Published var infoTotalHeight: CGFloat = .zero
    @Published var sheetHeight: CGFloat = .zero

    @Published var dtConfDialogIsPresented: Bool = false
    @Published var blockingSheetIsPresented: Bool = false
    @Published var confirmationSheetIsPresented: Bool = false
    @Published var complainSheetIsPresented: Bool = false
    @Published var confirmationType: ConfirmationView.ConfirmationType = .block

    var isSheeted: Bool {
        dtConfDialogIsPresented ||
        complainSheetIsPresented ||
        confirmationSheetIsPresented ||
        blockingSheetIsPresented
    }

    init(
        router: Router<AppRoute>,
        images: [Image],
        name: String,
        age: Int,
        distance: Int,
        bio: String
    ) {
        self.router = router
        self.images = images
        self.name = name
        self.age = age
        self.distance = distance
        self.bio = bio
    }

    func askToBlock() {
        withAnimation {
            dtConfDialogIsPresented = false
            blockingSheetIsPresented = true
        }
    }

    func confirmBlock() {
        confirmationType = .block
        blockingSheetIsPresented = false
        confirmationSheetIsPresented = true
    }

    func cancelBlock() {
        withAnimation {
            blockingSheetIsPresented = false
        }
    }

    func complain() {
        withAnimation {
            dtConfDialogIsPresented = false
        }

        Task { @MainActor in
            try await Task.sleep(nanoseconds: 100_000_000)
            withAnimation {
                complainSheetIsPresented = true
            }
        }
    }

    func sendComplaint() {
        confirmationType = .complain

        withAnimation {
            confirmationSheetIsPresented = true
        }
    }

    func finish() {
        withAnimation {
            confirmationSheetIsPresented = false
        }
    }

    func back() {
        router.pop()
    }
}
