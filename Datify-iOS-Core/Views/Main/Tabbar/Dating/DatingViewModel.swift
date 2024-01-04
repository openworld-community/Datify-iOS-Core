//
//  DatingViewModel.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 09.10.2023.
//

import SwiftUI
import Combine

final class DatingViewModel: ObservableObject {
    unowned let router: Router<AppRoute>
    private var cancellables = Set<AnyCancellable>()
    var filterDataService = FilterDataService()
    @Published var userFilterModel: FilterModel?
    @Published var filterSheetIsPresented: Bool = false

    @Published var dtConfDialogIsPresented: Bool = false
    @Published var blockingSheetIsPresented: Bool = false
    @Published var confirmationSheetIsPresented: Bool = false
    @Published var complainSheetIsPresented: Bool = false
    @Published var confirmationType: ConfirmationView.ConfirmationType = .block

    @Published var sheetSize: CGSize = .zero

    init(
        router: Router<AppRoute>
    ) {
        self.router = router
        self.addSubscribers()
    }

    func addSubscribers() {
        filterDataService.$userFilterModel
            .sink { [weak self] fetchedFilterModel in
                self?.userFilterModel = fetchedFilterModel
            }
            .store(in: &cancellables)
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
}
